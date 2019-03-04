//
//  RouteEventController.swift
//  RouteRoutePro
//
//  Created by 安齋洸也 on 2018/11/09.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class RouteEventController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate,UITextFieldDelegate,UIToolbarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var startdate: UITextField!
    @IBOutlet weak var enddate: UITextField!
    @IBOutlet weak var eventname: UITextField!
    @IBOutlet weak var eventDetail: UITextField!
    
    @IBOutlet weak var starttime: UITextField!
    @IBOutlet weak var endtime: UITextField!
    
    private lazy var routeModel = RouteModel()
    
    var goallat:Double!
    var goallog:Double!
    
    // map
    var locationManager = CLLocationManager()
    var accuracyRangeCircle: MKCircle?
    
    // date
    let nowDate = NSDate()
    let dateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    
    let timeFormat = DateFormatter()
    let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.eventname.delegate = self
        self.eventDetail.delegate = self
        self.locationManager.delegate = self
        
        // ロケーションの精度を設定する
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        // 更新距離（メートル）
        locationManager.distanceFilter = 5
        
        self.mapView.showsUserLocation = false
        
        self.accuracyRangeCircle = MKCircle(center: CLLocationCoordinate2D.init(latitude: 41.887, longitude: -87.622), radius: 50)
        self.mapView.addOverlay(self.accuracyRangeCircle!)
        
        //date setting
        //日付フィールドの設定
        dateFormat.dateFormat = "yyyy/MM/dd"
        startdate.text = dateFormat.string(from: nowDate as Date)
        self.startdate.delegate = self
        
        
        // DatePickerの設定(日付用)
        inputDatePicker.datePickerMode = UIDatePicker.Mode.date
        startdate.inputView = inputDatePicker
        startdate.inputAccessoryView = getPickerToolBar(tag: 1)
        
        enddate.inputView = inputDatePicker
        enddate.inputAccessoryView = getPickerToolBar(tag: 2)
        
        timeFormat.dateFormat = "HH:mm"
        timePicker.datePickerMode = UIDatePicker.Mode.time
        starttime.inputView = timePicker
        starttime.inputAccessoryView = getPickerToolBar(tag: 3)
        
        endtime.inputView = timePicker
        endtime.inputAccessoryView = getPickerToolBar(tag: 4)

    }
    
    func getPickerToolBar(tag: Int) -> UIToolbar{
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        pickerToolBar.barStyle = .blackTranslucent
        pickerToolBar.tintColor = UIColor.white
        pickerToolBar.backgroundColor = UIColor.black
        
        //完了ボタンを設定
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(toolBarBtnPush))
        toolBarBtn.tag = tag
        
        //ツールバーにボタンを表示
        pickerToolBar.items = [toolBarBtn]
        return pickerToolBar
    }
    
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnPush(sender: UIBarButtonItem){
        switch sender.tag {
        case 1:
            let pickerDate = inputDatePicker.date
            startdate.text = dateFormat.string(from: pickerDate)
        case 2:
            let pickerDate = inputDatePicker.date
            enddate.text = dateFormat.string(from: pickerDate)
        case 3:
            let pickerDate = timePicker.date
            starttime.text = timeFormat.string(from: pickerDate)
        case 4:
            let pickerDate = timePicker.date
            endtime.text = timeFormat.string(from: pickerDate)
        default: break
            
        }
        
        
        self.view.endEditing(true)
    }
    
    // 位置情報利用許可のステータスが変わった
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .authorizedAlways, .authorizedWhenInUse:
            // 利用可に変更された
            locationManager.startUpdatingLocation()
        case .notDetermined:
            // 位置情報取得確認のメッセージを表示。必須。
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
        default:
            locationManager.stopUpdatingLocation()
        }
    }
    
    // 位置を移動した
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationData = locations.last
        
        // 取得した位置情報の緯度経度
        let latitude = locationData?.coordinate.latitude
        let longitude = locationData?.coordinate.longitude
        let location = CLLocationCoordinate2DMake(latitude!,longitude!)
        
        print("(\(String(describing: latitude)), \(String(describing: longitude)))");
        
        // 表示するマップの中心を、取得した位置情報のポイントに指定
        mapView.setCenter(location, animated: true)
        
        // 表示する領域を設定する
        var region: MKCoordinateRegion = mapView.region
        // 領域設定の中心
        region.center = location
        // 表示する領域の拡大・縮小の係数
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        // 決定した表示設定をMapViewに適用
        mapView.setRegion(region, animated: true)
        
        // 地図の形式。Standardがデフォルトの地図。Satteliteが航空地図。
        mapView.mapType = MKMapType.standard
        // 位置情報は既に取得したので、これ以降取得を行わないように位置情報取得を停止
        locationManager.stopUpdatingLocation()
        
    }
    
    // 位置情報取得が失敗した際に呼ばれる。
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("map failed..")
    }
    
    //long press map
    @IBAction func pressMap(_ sender: UILongPressGestureRecognizer) {
        print("long")
        
        //マップビュー内のタップした位置を取得する。
        let location:CGPoint = sender.location(in: mapView)
        
        if (sender.state == UIGestureRecognizer.State.ended){
            
            //タップした位置を緯度、経度の座標に変換する。
            let mapPoint:CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
            
            //ピンを作成してマップビューに登録する。
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude)
            annotation.title = "目的地"
            annotation.subtitle = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
            
            let title = "目的値の設定"
            let message = "指定個所を目的地に設定します。よろしいでしょうか？"
            
            let mapAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            mapAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.mapView.addAnnotation(annotation)
                self.goallat = annotation.coordinate.latitude
                self.goallog = annotation.coordinate.longitude
            }))
            
            mapAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(mapAlert, animated: true, completion: nil)
            
        }
    }
    
    //complete keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    //event登録ボタン押下
    @IBAction func touchRouteEvent(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let event = Event()
        event.userid = appDelegate.userid!
        event.name = eventname.text
        event.detail = eventDetail.text
        event.startDate = startdate.text
        event.endDate = enddate.text
        event.startTime = starttime.text
        event.endTime = endtime.text
        if goallat == nil || goallog == nil {
            CBToast.showToastAction(message: "ターゲット値を設定していません")
            return
        }
        event.longitude = String(goallog)
        event.latitude = String(goallat)
        routeModel.makeEvent(event: event) { (EventResult) in
            let NotifMycation = NSNotification.Name(rawValue:"MyNSNotification")
            NotificationCenter.default.post(name: NotifMycation, object: "MyNSNotification")
            self.presentingViewController!.dismiss(animated: true, completion: nil)
        }
    }
    
    //hide keyborad
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
