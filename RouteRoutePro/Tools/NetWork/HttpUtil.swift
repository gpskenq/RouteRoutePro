//
//  HttpUtil.swift
//  RouteRoutePro
//
//  Created by 安齋洸也 on 2018/11/21.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation
import AFNetworking

class HttpUtil: AFHTTPSessionManager {
    
    let baseUrl = "http://54.214.116.94:8888/"
    //let baseUrl = "http://192.168.61.32:8888/"
    
    enum HTTPMethod {
        case GET
        case POST
    }
    
    static let shareInstance:HttpUtil = {
        let manager = HttpUtil()
        manager.requestSerializer = AFJSONRequestSerializer()
        let setArr = NSSet(objects: "text/html", "application/json", "text/json")
        manager.responseSerializer.acceptableContentTypes = setArr as? Set
        // add HttpHeader
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField:"Accept")
        manager.requestSerializer.willChangeValue(forKey:"timeoutInterval")
        manager.requestSerializer.timeoutInterval = 30.0
        manager.requestSerializer.didChangeValue(forKey:"timeoutInterval")
        return manager
    }()
    
    func request(methodType:HTTPMethod, urlString:String, parameters: [String:AnyObject]?, resultBlock:@escaping(Any?,Error?)->()) {
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let token = appDelegate.token
        if token != nil{
            HttpUtil.shareInstance.requestSerializer.setValue(token, forHTTPHeaderField:"token")
        }
        
        let url = baseUrl + urlString;
        // If the request succeeds, then the error is nil.
        let successBlock = { (task:URLSessionDataTask, responseObj:Any?)in
            resultBlock(responseObj,nil)
        }
        // If the request succeeds, then the error is nil.
        let failureBlock = { (task:URLSessionDataTask?, error:Error)in
            resultBlock((task?.response as? HTTPURLResponse)?.statusCode, error)
        }
        // request type
        if methodType == HTTPMethod.GET{
            get(url, parameters: parameters, progress:nil, success: successBlock, failure: failureBlock)
        }else{
            post(url, parameters: parameters, progress:nil, success: successBlock, failure: failureBlock)
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}

