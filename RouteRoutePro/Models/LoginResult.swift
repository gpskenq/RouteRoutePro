//
//  LoginResult.swift
//  RouteRoutePro
//
//  Created by 安齋洸也 on 2018/11/09.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import UIKit

@objcMembers class LoginResult: NSObject {
    public var code: Int = 0
    public var message: String?
    public var content: User?
    
    override var description: String{
        return yy_modelDescription()
    }
    
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
