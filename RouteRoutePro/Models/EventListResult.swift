//
//  EventListResult.swift
//  RouteRoutePro
//
//  Created by linkage on 2018/12/11.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation

@objcMembers class EventListResult: NSObject {
    public var status: String?;
    public var sysTime: Int64 = 0;
    public var eventList: Array<Event>?
    
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
        return ["eventList":Event.self]
    }
}



