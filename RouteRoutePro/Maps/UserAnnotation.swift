//
//  UserAnotation.swift
//  RouteRoutePro
//
//  Created by 安齋洸也 on 2018/11/21.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation
import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    
    convenience override init() {
        self.init(coordinate:CLLocationCoordinate2DMake(41.887, -87.622), title:"", subtitle:"")
    }
    
    required init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
}
