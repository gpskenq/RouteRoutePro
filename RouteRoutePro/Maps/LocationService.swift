//
//  LocationManager.swift
//  RouteRoutePro
//
//  Created by 安齋洸也 on 2018/11/21.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationDelegate:class {
    // delegate関数
    func mapinfodelegate(mapspeed:CLLocationSpeed, mapdistance:CLLocationDistance)
}

public class LocationService: NSObject, CLLocationManagerDelegate{
    
    weak var delegate : LocationDelegate? = nil
    
    public static var sharedInstance = LocationService()
    let locationManager: CLLocationManager
    var locationDataArray: [CLLocation]
    var useFilter: Bool
    var currLocal: CLLocation?
    var eventStart: Bool = false
    
    
    override init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // 現在値からどれだけ離れたら位置情報取得するか。
        locationManager.distanceFilter = 15
        
        // automotiveNavigation 自動車ナビゲーション用
//        locationManager.activityType = .fitness
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationDataArray = [CLLocation]()
        
        useFilter = true
        
        super.init()
        
        locationManager.delegate = self
    }
    
    
    func startUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }else{
            //tell view controllers to show an alert
            showTurnOnLocationServiceAlert()
        }
    }
    
    func stopUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled(){
            eventStart = false
            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingHeading()
            locationDataArray.removeAll()
            self.currLocal = nil
        }
    }
    
    
    //MARK: CLLocationManagerDelegate protocol methods
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]){
        
        if let newLocation = locations.last{
            print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
            
            var locationAdded: Bool
            if useFilter{
                locationAdded = filterAndAddLocation(newLocation)
            }else{
                if eventStart {
                    locationDataArray.append(newLocation)
                }
                locationAdded = true
            }
            
            if !locationAdded && self.currLocal == nil && eventStart {
                locationDataArray.append(newLocation)
            }
            
            if locationAdded || self.currLocal == nil {
                self.currLocal = newLocation
                notifiyDidUpdateLocation(newLocation: newLocation)
            }
            
        }
    }
    
    func filterAndAddLocation(_ location: CLLocation) -> Bool{
        let age = -location.timestamp.timeIntervalSinceNow
        
        if age > 10{
            print("Locaiton is old.")
            return false
        }
        
        if location.horizontalAccuracy < 0{
            print("Latitidue and longitude values are invalid.")
            return false
        }
        
        if location.horizontalAccuracy > 100{
            print("Accuracy is too low.")
            return false
        }
        
        
        
        print("Location quality is good enough.")
        if eventStart {
            locationDataArray.append(location)
        }
        //location処理

        //km/s
        let speed:CLLocationSpeed = location.speed * 3.6
        print(speed)
        let distance:CLLocationDistance
        if locationDataArray.count > 1 {
            distance = location.distance(from: locationDataArray[locationDataArray.endIndex - 2])
        }else{
            distance = 0
        }
        print(distance)
        
        self.delegate?.mapinfodelegate(mapspeed: speed,mapdistance: distance)

        return true
        
    }
    
    
    public func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error){
        if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue{
            //User denied your app access to location information.
            showTurnOnLocationServiceAlert()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse{
            //You can resume logging by calling startUpdatingLocation here
        }
    }
    
    func showTurnOnLocationServiceAlert(){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    }
    
    func notifiyDidUpdateLocation(newLocation:CLLocation){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didUpdateLocation"), object: nil, userInfo: ["location" : newLocation])
    }
}
