//
//  SignupResult.swift
//  RouteRoutePro
//
//  Created by linkage on 2018/12/7.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation
import YYModel

@objcMembers class UserResult: NSObject {
    public var objid: String?
    public var status: String?
    public var name: String?
    public var token: String?
    
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
