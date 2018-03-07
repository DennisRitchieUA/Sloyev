//
//  SloyevAPIManager.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/6/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DPLocalization
import ObjectMapper
import MagicalRecord


class ResponseObject {
    var error:NSError? = nil
    var response = Array<Any>()
    var originalResponse:SwiftyJSON.JSON?
    var message:String?
    let userData:AnyObject? = nil
}

typealias ResultHandler = (_ object: ResponseObject) -> Void
class SloyevAPIManager: NSObject {
    
    
    static var realmQueue: DispatchQueue {
        let queue = DispatchQueue(label: "PigCareOwner", attributes: [])
        return queue
    }
    
    fileprivate static let baseURL = "https://chat2help.com/test/"
    
    class func registrationAction(_ params: [String:Any], avatar: UIImage, handler: @escaping (ResultHandler)) {
        realmQueue.async {
            
            let url = "\(baseURL)register"
            NetworkManager.requestWith(url, reqMethod: .post , dataToSend: params, uploadImage: avatar, handler: { (object) in
                if object.originalResponse != nil && object.error == nil {
                    
                    let status = object.originalResponse?["status"].boolValue
                    if (status == true) {
                        object.message = object.originalResponse?["message"].string
                        handler(object)
                    } else {
                        object.error = ErrorManager.createError(object.originalResponse?["message"].string ?? "", code: object.originalResponse?["code"].intValue ?? 0)
                        handler(object)
                    }
                } else {
                    if (object.error != nil) {
                        handler(object)
                    } else {
                        object.error = ErrorManager.createError(DPAutolocalizedString("error_no_data", nil), code: object.error?.code ?? 000)
                    }
                }
            })
        }
    }
    
    class func loginAction(_ params: [String:Any], handler: @escaping (ResultHandler)) {
        realmQueue.async {
            
            let url = "\(baseURL)auth"
            NetworkManager.requestWith(url, reqMethod: .post , dataToSend: params, handler: { (object) in
                if object.originalResponse != nil && object.error == nil {
                    
                    let status = object.originalResponse?["status"].boolValue
                    if (status == true) {
                        object.message = object.originalResponse?["message"].string
                        let originalResponse = object.originalResponse
                        let context = NSManagedObjectContext.mr_default()
                        let user = UserProfile.mr_createEntity(in: context)
                        user?.avatar = originalResponse?["avatar"].url
                        user?.password = (params["password"] as? String) ?? ""
                        user?.birthDate = DateFormatter.dateOfBirth(date: (originalResponse?["birthday"].string)!) as NSDate
                        user?.login = originalResponse?["email"].string
                        user?.firstName = originalResponse?["firstname"].string
                        user?.lastName = originalResponse?["lastname"].string
                        user?.gender = originalResponse?["gender"].string
                        user?.growth = originalResponse?["growth"].number
                        user?.weight = originalResponse?["weight"].number
                        context.mr_saveToPersistentStore(completion: { (finished, error) in
                             handler(object)
                        })
                    } else {
                        object.error = ErrorManager.createError(object.originalResponse?["message"].string ?? "", code: object.originalResponse?["code"].intValue ?? 0)
                        handler(object)
                    }
                } else {
                    if (object.error != nil) {
                        handler(object)
                    } else {
                        object.error = ErrorManager.createError(DPAutolocalizedString("error_no_data", nil), code: object.error?.code ?? 000)
                    }
                }
            })
        }
    }
    
    
    
}

private class NetworkManager {
    
    class func requestWith(_ url: String,
                           reqMethod: HTTPMethod,
                           dataToSend: [String : Any]?,
                           uploadImage: UIImage? = nil,
                           handler: @escaping (ResponseObject) -> Void) {
        
        var header: [String:String] = [:]
        header["Accept-Language"] = dp_get_current_language()
        
        myPrint("headers - \(header)")
        myPrint("parameters:\n \(String(describing: dataToSend))")
        
        let object = ResponseObject()
        
        if let image = uploadImage {
            
            let imageData = UIImageJPEGRepresentation(image, 0.6)
            header["content-type"] = "multipart/form-data"
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            Alamofire.upload(multipartFormData: { mpfData in
                mpfData.append(imageData!, withName: "avatar", fileName: "avatar.jpg", mimeType: "image/jpg")

                for (key, value) in dataToSend! {
                    if ((value as? String) != nil) {
                        mpfData.append((value as! String).data(using: .utf8)!, withName: key)
                    } else {
                        mpfData.append("\(value)".data(using: .utf8)!, withName: key)
                    }
                }
                
            }, usingThreshold: UInt64.init(),
               to: url,
               method: .post,
               headers: header,
               encodingCompletion: { encodingResult in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON {JSON in
                        let jsonS = SwiftyJSON.JSON(JSON.result.value ?? "")
                        object.originalResponse = jsonS
                        handler(object)
                    }
                case .failure(let error):
                    object.error = error as NSError
                    handler(object)
                }
            })
            
        } else {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            Alamofire.request(url, method: reqMethod,
                              parameters: dataToSend,
                              encoding: URLEncoding(),
                              headers: header).responseJSON { response in
                                DispatchQueue.main.async {
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                }
                                myPrint(response.request)
                                myPrint(response.request?.httpMethod)
                                myPrint(response.response)
                                myPrint(response.result)
                                myPrint(response.result.value)
                                myPrint(response.error)
                                
                                switch response.result {
                                case .success(let JSON):
                                    let jsonS = SwiftyJSON.JSON(JSON)
                                    object.originalResponse = jsonS
                                    handler(object)
                                case .failure(let error):
                                    object.error = error as NSError
                                    handler(object)
                                }
            }
        }
    }
}

func myPrint(_ value: Any?, file: String = #file, lineNumber: Int = #line) {
    #if DEBUG
        let fName = fileName(from: file)
        
        let printValue: Any = value ?? "value is nil"
        print("\n~~ [\(fName): \(lineNumber)]  \(printValue)")
    #endif
}

func fileName(from path: String) -> String {
    let components = path.components(separatedBy: "/")
    guard let last = components.last else {
        return ""
    }
    
    return last
}

