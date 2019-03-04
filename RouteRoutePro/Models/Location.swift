//
//  Location.swift
//  RouteRoutePro
//
//  Created by linkage on 2018/12/13.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation

import YYModel

@objcMembers class Location: NSObject {
    public var _id: String?
    public var eventid: String?
    public var userid: String?
    public var name: String?
    public var latitude: String?
    public var longitude: String?
    
    public var startTime: Int64 = 0
    public var historyDistance: Double = 0
    
    override var description: String{
        return yy_modelDescription()
    }
    
    /**
     * 初期化を行う
     */
    public override init() {
        super.init()
    }
    
    internal init(dict: [String: AnyObject]){
        super.init()
        setValuesForKeys(dict)
    }
    
    override public func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}



