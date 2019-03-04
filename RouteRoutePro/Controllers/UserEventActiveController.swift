//
//  UserEventActiveController.swift
//  RouteRoutePro
//
//  Created by 安齋洸也 on 2018/11/10.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import UIKit
import MapKit

class UserEventController: UIViewController, MKMapViewDelegate, LocationDelegate {

    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var minute: UILabel!
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var speed: UILabel!
    
    // map elements
    var userAnnotationImage: UIImage?
    var userAnnotation: UserAnnotation?
    var accuracyRangeCircle: MKCircle?
    var polyline: MKPolyline?
    var isZooming: Bool?
    var isBlockingAutoZoom: Bool?
    var zoomBlockingTimer: Timer?
    var didInitialZoom: Bool?
    
    // distance
    var distanceAll: Double = 0
    
    // eventtime
    var eventEndTime:Date?
    var eventStartTime:Date?
    
    // goal
    var annotationgoal:MKPointAnnotation = MKPointAnnotation()
    
    // data
    // var data:(id:String, name:String, detail:String, email:String, latitude:String, longitude:String, date:String, starttime:String, endtime:String)!
    
    var eventData: Event?
    
    var currLoc: CLLocation?
    
    private lazy var routeModel = RouteModel()
    var historyDistance: Double = 0
    var sysTime: Int64 = 0
    var startTime: Int64 = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lat:String = (eventData?.latitude)!
        let lon:String = (eventData?.longitude)!
        //目的地
        annotationgoal.coordinate = CLLocationCoordinate2DMake(Double(lat)!, Double(lon)!)
        annotationgoal.title = "目的地"
        mapView.addAnnotation(annotationgoal)

        // Do any additional setup after loading the view, typically from a nib.
        //title setting
        self.title = eventData!.name
        
        // settings
        self.mapView.delegate = self
        self.mapView.showsUserLocation = false
        
        self.userAnnotationImage = UIImage(named: "user_position_ball")!
        
        self.accuracyRangeCircle = MKCircle(center: CLLocationCoordinate2D.init(latitude: 41.887, longitude: -87.622), radius: 50)
        //self.mapView.addOverlay(self.accuracyRangeCircle!)
        
        
        self.didInitialZoom = false
        
        // 地址update
        NotificationCenter.default.addObserver(self, selector: #selector(UserEventController.updateMap(_:)), name: Notification.Name(rawValue:"didUpdateLocation"), object: nil)
        
        // 权限监听
        NotificationCenter.default.addObserver(self, selector: #selector(UserEventController.showTurnOnLocationServiceAlert(_:)), name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
        
        LocationService.sharedInstance.startUpdatingLocation()
        LocationService.sharedInstance.delegate = self;
        //LocationService.sharedInstance.useFilter = true
        
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm"
        eventStartTime = dateFormater.date(from: (eventData?.startDate)! + " " + (eventData?.startTime)!)
        eventEndTime = dateFormater.date(from: (eventData?.endDate)! + " " + (eventData?.endTime)!)
        let ho = eventEndTime?.hoursDiff(date: eventStartTime!)
        let mi = eventEndTime?.minutesDiff(date: eventStartTime!)
        minute.text = String(mi!%60)
        hour.text = String(ho!)
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { (timer) in
            //self.count値をコンソールへ出力
            print("Timer Refresh")
            self.loadHistoryLocation()
        })
        self.loadHistoryLocation()
    }
    
    @objc func showTurnOnLocationServiceAlert(_ notification: NSNotification){
        let alert = UIAlertController(title: "Turn on Location Service", message: "To use location tracking feature of the app, please turn on the location service from the Settings app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // 新しい経緯度
    @objc func updateMap(_ notification: NSNotification){
        if let userInfo = notification.userInfo{
            
            updatePolylines()
            
            if let newLocation = userInfo["location"] as? CLLocation{
                zoomTo(location: newLocation)
                
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                let loc = LocationRequest()
                loc.userid = appDelegate.userid!
                loc.eventid = eventData?._id
                loc.name = appDelegate.name
                loc.latitude = String(newLocation.coordinate.latitude)
                loc.longitude = String(newLocation.coordinate.longitude)
                loc.eventStartDate = eventData?.startDate
                loc.eventStartTime = eventData?.startTime
                loc.eventEndDate = eventData?.endDate
                loc.eventEndTime = eventData?.endTime
                loc.currentDistance = distanceAll
                loc.historyDistance = historyDistance
                // 経緯度を保存し、計算速度、時間取得
                routeModel.updateGuestLocation(location: loc) { (result: LocationListResult) in
                    if result.status == "200000"{
                        LocationService.sharedInstance.eventStart = true
                        LocationService.sharedInstance.locationDataArray.append(newLocation)
                        self.setSpeed(sysTime: result.sysTime, startTime: result.startTime)
                    }
                }
            }
        }
    }
    
    // 地図は円和線を描く
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay === self.accuracyRangeCircle{
            let circleRenderer = MKCircleRenderer(circle: overlay as! MKCircle)
            circleRenderer.fillColor = UIColor(white: 0.0, alpha: 0.25)
            circleRenderer.lineWidth = 0
            return circleRenderer
        }else{
            let polylineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            polylineRenderer.strokeColor = UIColor.red
            polylineRenderer.alpha = 0.5
            polylineRenderer.lineWidth = 5.0
            return polylineRenderer
        }
    }
    
    // 走行経路を更新する
    func updatePolylines(){
        var coordinateArray = [CLLocationCoordinate2D]()
        for loc in LocationService.sharedInstance.locationDataArray{
            coordinateArray.append(loc.coordinate)
        }
        self.clearPolyline()
        self.polyline = MKPolyline(coordinates: coordinateArray, count: coordinateArray.count)
        self.mapView.addOverlay((polyline)!)
        
    }
    
    func clearPolyline(){
        if self.polyline != nil{
            self.mapView.removeOverlay(self.polyline!)
            self.polyline = nil
        }
    }
    
    func zoomTo(location: CLLocation){
        self.currLoc = location
        if self.didInitialZoom == false{
            let coordinate = location.coordinate
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            self.mapView.setRegion(region, animated: false)
            self.didInitialZoom = true
        }
        
        if self.isBlockingAutoZoom == false{
            self.isZooming = true
            self.mapView.setCenter(location.coordinate, animated: true)
        }
        
        var accuracyRadius = 50.0
        if location.horizontalAccuracy > 0{
            if location.horizontalAccuracy > accuracyRadius{
                accuracyRadius = location.horizontalAccuracy
            }
        }
        
        self.mapView.removeOverlay(self.accuracyRangeCircle!)
        self.accuracyRangeCircle = MKCircle(center: location.coordinate, radius: accuracyRadius as CLLocationDistance)
        self.mapView.addOverlay(self.accuracyRangeCircle!)
        
        if self.userAnnotation != nil{
            self.mapView.removeAnnotation(self.userAnnotation!)
        }
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.userAnnotation = UserAnnotation(coordinate: location.coordinate, title: appDelegate.name!, subtitle: "")
        self.mapView.addAnnotation(self.userAnnotation!)
    }
    
    // カスタムピン
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation === self.annotationgoal {
            let identifier = "UserAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView != nil{
                annotationView!.annotation = annotation
            }else{
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            annotationView!.canShowCallout = true
            annotationView!.image = self.userAnnotationImage

            return annotationView
        }
        return nil
    }
    
    // 地図のスケーリング
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if self.isZooming == true{
            self.isZooming = false
            self.isBlockingAutoZoom = false
        }else{
            self.isBlockingAutoZoom = true
            if let timer = self.zoomBlockingTimer{
                if timer.isValid{
                    timer.invalidate()
                }
            }
            self.zoomBlockingTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { (Timer) in
                self.zoomBlockingTimer = nil
                self.isBlockingAutoZoom = false;
            })
        }
    }
    
    // 地図が戻る距離
    func mapinfodelegate(mapspeed: CLLocationSpeed, mapdistance: CLLocationDistance) {
        distanceAll = distanceAll + (round(mapdistance / 1000 * 10) / 10)
        distance.text = String(format:"%.1f", distanceAll + historyDistance)
    }
    
    // tap quit
    @IBAction func tapQuit(_ sender: UIBarButtonItem) {
        let title = "イベントの終了"
        let message = "イベントを終了します。よろしいでしょうか？"
        
        let mapAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        mapAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        mapAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(mapAlert, animated: true, completion: nil)

    }
    
    @IBAction func showLocal(_ sender: UIButton) {
        if currLoc == nil {
            LocationService.sharedInstance.startUpdatingLocation()
            return
        }
        let region = MKCoordinateRegion(center: currLoc!.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
        self.mapView.setRegion(region, animated: false)
    }
    
    @IBAction func showTarget(_ sender: UIButton) {
        let lat:String = (eventData?.latitude)!
        let lon:String = (eventData?.longitude)!
        let center:CLLocation = CLLocation(latitude: Double(lat)!, longitude: Double(lon)!)
        let region = MKCoordinateRegion(center: center.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
        self.mapView.setRegion(region, animated: false)
    }
    
    // 位置を停止し、タイマーを停止する
    override func viewDidDisappear(_ animated: Bool) {
        LocationService.sharedInstance.stopUpdatingLocation()
        timer.invalidate()
    }
    
    // 歴史の位置をロードする
    func loadHistoryLocation(){
        if self.startTime == Int64(0) {
            let loc = LocationRequest()
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            loc.userid = appDelegate.userid!
            loc.eventid = eventData?._id
            loc.eventStartDate = eventData?.startDate
            loc.eventStartTime = eventData?.startTime
            loc.eventEndDate = eventData?.endDate
            loc.eventEndTime = eventData?.endTime
            routeModel.guestHistoryLocation(location: loc) { (locationListResult: LocationListResult) in
                if locationListResult.status == "200000"{
                    self.sysTime = locationListResult.sysTime
                    let location = locationListResult.locations?.first
                    self.startTime = (location?.startTime)!
                    self.historyDistance = (location?.historyDistance)!
                    self.setRemainingTime()
                }
            }
        } else {
            setRemainingTime()
        }
    }
    
    // 残り時間を設定する
    func setRemainingTime(){
        if self.startTime != Int64(0) && self.sysTime != Int64(0) {
            self.sysTime = self.sysTime + 1000 * 60
            let ho = eventEndTime?.hoursDiff(time: self.sysTime)
            let mi = eventEndTime?.minutesDiff(time: self.sysTime)
            minute.text = String((mi!%60) > 0 ? (mi!%60) : 0)
            hour.text = String(ho! > 0 ? ho! : 0)
            setSpeed(sysTime: self.sysTime, startTime: self.startTime)
        }
    }
    
    // 速度を計算する
    func setSpeed(sysTime: Int64, startTime: Int64){
        let distance = self.distanceAll + self.historyDistance
        if distance > 0{
            let speed = distance / (Double((sysTime - startTime)) / 1000.0 / 60.0 / 60.0)
            self.speed.text = String(format:"%.1f", round(speed * 10) / 10)
            self.distance.text = String(format:"%.1f", distanceAll + historyDistance)
        }
    }
}
