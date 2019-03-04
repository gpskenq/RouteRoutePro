//
//  User.swift
//  RouteRoutePro
//
//  Created by 安齋洸也 on 2018/12/02.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation
import YYModel

@objcMembers class User: NSObject {
    public var _id: String?;
    public var name: String?;
    public var userid: String?;
    public var password: String?;
    
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
