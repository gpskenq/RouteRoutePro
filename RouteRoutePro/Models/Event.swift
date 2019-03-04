//
//  Event.swift
//  RouteRoutePro
//
//  Created by linkage on 2018/12/10.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation
import YYModel

@objcMembers class Event: NSObject {
    public var _id: String?
    public var name: String?
    public var userid: String?
    public var detail: String?
    public var latitude: String?
    public var longitude: String?
    public var startDate: String?
    public var endDate: String?
    public var startTime: String?
    public var endTime: String?
    
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
