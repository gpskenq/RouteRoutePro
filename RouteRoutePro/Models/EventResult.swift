//
//  EventResult.swift
//  RouteRoutePro
//
//  Created by linkage on 2018/12/11.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation
import YYModel

@objcMembers class EventResult: NSObject {
    public var status: String?;
    
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
