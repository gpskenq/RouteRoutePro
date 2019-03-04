//
//  RouteModel.swift
//  RouteRoutePro
//
//  Created by linkage on 2018/12/10.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation

class RouteModel{
    
    func makeEvent(event: Event, completion: @escaping (_ result: EventResult)->()){
        let urlString = "makeEvent"
        
        HttpUtil.shareInstance.request(methodType: HttpUtil.HTTPMethod.POST, urlString: urlString, parameters: HttpUtil.shareInstance.convertStringToDictionary(text: event.yy_modelToJSONString()!), resultBlock: {(json, err) in
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
                let r = EventResult()
                r.yy_modelSet(with: json as! [String : AnyObject])
                if r.status == "201002" {
                    CBToast.showToastAction(message: "メールアドレス検索結果なし")
                    return
                }else if r.status == "201005" {
                    CBToast.showToastAction(message: "イベント日が過去日付")
                    return
                }
                completion(r)
            }
        })
    }
    
    func eventList(completion: @escaping (_ result: EventListResult) -> ()){
        let urlString = "eventList"
        
        let result = EventListResult.init()
        HttpUtil.shareInstance.request(methodType: HttpUtil.HTTPMethod.GET, urlString: urlString, parameters: HttpUtil.shareInstance.convertStringToDictionary(text: result.yy_modelToJSONString()!), resultBlock: {(json, err) in
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
                let r = EventListResult()
                r.yy_modelSet(with: json as! [String : AnyObject])
                if r.status == "201004" {
                    CBToast.showToastAction(message: "イペントなし")
                    return
                }
                completion(r)
            }
        })
    }
    
    func updateGuestLocation(location: LocationRequest, completion: @escaping (_ result: LocationListResult)->()){
        let urlString = "updateGuestLocation"
        
        HttpUtil.shareInstance.request(methodType: HttpUtil.HTTPMethod.POST, urlString: urlString, parameters: HttpUtil.shareInstance.convertStringToDictionary(text: location.yy_modelToJSONString()!), resultBlock: {(json, err) in
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
                let r = LocationListResult()
                r.yy_modelSet(with: json as! [String : AnyObject])
                completion(r)
            }
        })
    }
    
    func guestLocations(location: Location, completion: @escaping (_ result: LocationListResult)->()){
        let urlString = "guestLocations"
        
        HttpUtil.shareInstance.request(methodType: HttpUtil.HTTPMethod.POST, urlString: urlString, parameters: HttpUtil.shareInstance.convertStringToDictionary(text: location.yy_modelToJSONString()!), resultBlock: {(json, err) in
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
                let r = LocationListResult()
                r.yy_modelSet(with: json as! [String : AnyObject])
                if r.status == "201006" {
                    CBToast.showToastAction(message: "イベント検索結果なし")
                    return
                }
                completion(r)
            }
        })
    }
    
    
    func guestHistoryLocation(location: LocationRequest, completion: @escaping (_ result: LocationListResult)->()){
        let urlString = "guestHistoryLocation"
        
        HttpUtil.shareInstance.request(methodType: HttpUtil.HTTPMethod.POST, urlString: urlString, parameters: HttpUtil.shareInstance.convertStringToDictionary(text: location.yy_modelToJSONString()!), resultBlock: {(json, err) in
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
                let r = LocationListResult()
                r.yy_modelSet(with: json as! [String : AnyObject])
                if r.status == "200000" {
                    completion(r)
                }
            }
        })
    }
    
}

