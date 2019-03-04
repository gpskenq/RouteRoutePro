//
//  LocationListResult.swift
//  RouteRoutePro
//
//  Created by linkage on 2018/12/13.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation

@objcMembers class LocationListResult: NSObject {
    public var status: String?
    public var sysTime: Int64 = 0
    public var startTime: Int64 = 0
    public var locations: Array<Location>?
    
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
    
    static func modelContainerPropertyGenericClass() -> [String: AnyObject]?{
        return ["locations":Location.self]
    }
}



