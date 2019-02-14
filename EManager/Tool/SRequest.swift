//
//  SRequest.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/1.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

import UIKit
import Alamofire
import SwiftyJSON
// typealias:用来为已存在的类型重新定义名称的.
class SRequest: NSObject {
    static let shared = SRequest()
    private var session:Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return Alamofire.SessionManager(configuration: configuration)
    }();
    typealias Success = (NSDictionary,SwiftyJSON.JSON)
    typealias Fail = (AFError)->Void
    typealias Progress = (Double)->Void
}

extension SRequest {
    func get(url:String,param:Parameters?,success: Success, fail:@escaping Fail) {
        let header:HTTPHeaders =  ["Content-Type":"application/json;charset=utf-8"]
        self.session.request(url, method: HTTPMethod.post, parameters: param, encoding: URLEncoding.httpBody, headers: header).validate().responseJSON { (response) in
            self.response(response: response, success: success, fail: fail)
        }
    }
    
    func post(url:String,param:Parameters?,success: Success, fail:@escaping Fail) {
        let header:HTTPHeaders =  ["Content-Type":"application/json;charset=utf-8"]
        self.session.request(url, method: HTTPMethod.get, parameters: param, encoding: URLEncoding.httpBody, headers: header).validate().responseJSON { (response) in
            self.response(response: response, success: success, fail: fail)
        }
    }
    
    private func response(response:DataResponse<Any>,success:Success, fail:Fail) {
        if let error = response.result.error {
            self.handleRequestError(error: error as NSError, fail: fail)
        }else if let value = response.result.value {
            if (value as? NSDictionary) == nil {
                self.handleRequestSuccessWithFaliedBlock(fail:fail)
            }else{
                self.handleRequestSuccess(value: value, success: success, fail: fail)
            }
        }
    }
    
    private func handleRequestError(error:NSError,fail:Fail) {
        
    }
    
    private func handleRequestSuccess(value:Any,success:Success,fail:Fail) {
        
    }
    
    private func handleRequestSuccessWithFaliedBlock(fail:Fail) {
        
    }
    
    struct ErrorInfo {
        var code = 0
        var message = ""
        var error = NSError()
    }
}

extension Data {
    
    /** Unarchive data into an object. It will be returned as type `Any` but you can cast it into the correct type. */
    func convert() -> Any {
        return NSKeyedUnarchiver.unarchiveObject(with: self)!
    }
    
    /** Converts an object into Data using the NSKeyedArchiver */
    static func toData(object: Any) -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: object)
    }
    
}
