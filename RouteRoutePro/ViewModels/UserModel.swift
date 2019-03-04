//
//  UserModel.swift
//  RouteRoutePro
//
//  Created by linkage on 2018/12/7.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation

class UserModel{
    
    func signup(user: User, completion: @escaping (_ result: UserResult)->()){
        let urlString = "signup"
        
        HttpUtil.shareInstance.request(methodType: HttpUtil.HTTPMethod.POST, urlString: urlString, parameters: HttpUtil.shareInstance.convertStringToDictionary(text: user.yy_modelToJSONString()!), resultBlock: {(json, err) in
            if err != nil{
                if json != nil{
                    let code:Int = json as! Int
                    if code >= 400 && code < 500 {
                        CBToast.showToastAction(message: "リクエスト不正")
                    }
                    if code == 500 {
                        CBToast.showToastAction(message: "システムエラー")
                    }
                }
            }else{
                let r = UserResult()
                r.yy_modelSet(with: json as! [String : AnyObject])
                if r.status == "201001" {
                    CBToast.showToastAction(message: "ID重複")
                    return
                }
                completion(r)
            }
        })
    }
    
    func login(user: User, completion: @escaping (_ result: UserResult) -> ()){
        let urlString = "login"
        
        HttpUtil.shareInstance.request(methodType: HttpUtil.HTTPMethod.POST, urlString: urlString, parameters: HttpUtil.shareInstance.convertStringToDictionary(text: user.yy_modelToJSONString()!), resultBlock: {(json, err) in
            if err != nil{
                if json != nil{
                    let code:Int = json as! Int
                    if code >= 400 && code < 500 {
                        CBToast.showToastAction(message: "リクエスト不正")
                    }
                    if code == 500 {
                        CBToast.showToastAction(message: "システムエラー")
                    }
                }
            }else{
                print(json as Any)
                let r = UserResult()
                r.yy_modelSet(with: json as! [String : AnyObject])
                if r.status == "201002" {
                    CBToast.showToastAction(message: "Userd 検索結果なし")
                }else if r.status == "201003" {
                    CBToast.showToastAction(message: "パスワード間違い")
                }else {
                    completion(r)
                }
            }
        })
    }
    
}
