//
//  APIManager.swift
//  Cognome
//
//  Created by ambu sangoli.
//

import Foundation
import UIKit
import Alamofire

class APIManager : NSObject {
    
    // Shared Instance
    static let sharedInstance = APIManager()
    
    // MARK: URLRequestConvertible
    enum Router: URLRequestConvertible {
        
        // Api Base Url fron Constant
        static let baseURLString = BASEURL

        //User
        case loginUser([String : AnyObject])
        case getTemplate(String)
        case updateEntityValue(Data)
        case saveInstrument(Data)
        case addRepeatableGroup(Data)
        case deleteRepeatableGroup(Data)
        case getInstrument(String)
        case resetInstrument(Data)

        // Api Methods
        var method: HTTPMethod {
            switch self {
            case .loginUser:
                return .post
            case .getTemplate:
                return .get
            case .updateEntityValue:
                return .post
            case .saveInstrument:
                return .post
            case .addRepeatableGroup:
                return .post
            case .deleteRepeatableGroup:
                return .post
            case .getInstrument:
                return .get
            case .resetInstrument:
                return .post
            }
        }
            
        // Get the URL path
        var path: String {
            switch self {
            case .loginUser:
                return API_END_LOGIN
            case .getTemplate:
                return API_END_GET_TEMPLATE
            case .updateEntityValue:
                return API_END_UPDATE_ENTITY_VALUE
            case .saveInstrument:
                return API_END_SAVE_INSTRUMENT
            case .addRepeatableGroup:
                return API_END_ADD_REPEATABLE_GROUP
            case .deleteRepeatableGroup:
                return API_END_DELETE_REPEATABLE_GROUP
            case .getInstrument:
                return API_END_GET_INSTRUMENT
            case .resetInstrument:
                return API_END_RESET_INSTRUMENT
            }
        }
        
        //Generates a URL request object with the token embeded in the header.
        func asURLRequest() throws -> URLRequest {
            var url = try Router.baseURLString.asURL().appendingPathComponent(path)
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            urlRequest.addValue(TEMP_TOKEN_VALUE, forHTTPHeaderField: TEMP_TOKEN_KEY)
            
            switch self {
            case .loginUser(let parameters):
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
                return urlRequest
            case .getTemplate(let templateId):
                url.appendQueryItem(name: "templateId", value: templateId)
                let urlRequest = APIManager.sharedInstance.createURLRequest(url: url, method: method)
                return urlRequest
            case .updateEntityValue(let data):
                urlRequest.httpBody = data
                return urlRequest
            case .saveInstrument(let data):
                urlRequest.httpBody = data
                return urlRequest
            case .addRepeatableGroup(let data):
                urlRequest.httpBody = data
                return urlRequest
            case .deleteRepeatableGroup(let data):
                urlRequest.httpBody = data
                return urlRequest
            case .getInstrument(let instrumentId):
                url.appendQueryItem(name: "instrumentId", value: instrumentId)
                let urlRequest = APIManager.sharedInstance.createURLRequest(url: url, method: method)
                return urlRequest
            case .resetInstrument(let data):
                urlRequest.httpBody = data
                return urlRequest
            }
        }
    }
    
    func createURLRequest(url:URL, method: HTTPMethod) -> URLRequest {
        var newUrlRequest = URLRequest(url: url)
        newUrlRequest.httpMethod = method.rawValue
        newUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        newUrlRequest.addValue(TEMP_TOKEN_VALUE, forHTTPHeaderField: TEMP_TOKEN_KEY)
        return newUrlRequest
    }
    
        
    // Completion Handlers
    typealias completionHandlerWithSuccess = (_ success:Bool) -> Void
    typealias completionHandlerWithSuccessAndErrorMessage = (_ success:Bool, _ errorMessage: String) -> Void
    typealias completionHandlerWithSuccessAndMessage = (_ success:Bool,_ message: NSDictionary) -> Void
    typealias completionHandlerWithResponse = (HTTPURLResponse) -> Void
    typealias completionHandlerWithResponseAndError = (HTTPURLResponse?, NSError?) -> Void
    typealias completionHandlerWithSuccessAndResultArray = (_ success:Bool, _ message: NSArray,_ statusCode: Int) -> Void
    typealias completionHandlerWithSuccessAndResultsArray = (_ success:Bool, _ result_1: NSArray,_ statusCode: Int) -> Void
    typealias completionHandlerWithStatusCode = (_ success:Bool,_ message: NSDictionary,_ statusCode: Int) -> Void
        
        
        
    // Login User
    // completion : Completion object to return parameters to the calling functions
    // Returns User details
    func makeRequestToLoginUser(params:[String:AnyObject],completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.loginUser(params)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSDictionary else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                }   else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    // Get Template
    // completion : Completion object to return parameters to the calling functions
    // Returns Dynamic Form Components in Json format
    func makeRequestToGetTemplate(templateId: String,completion: @escaping completionHandlerWithStatusCode) {
        
        Alamofire.request(Router.getTemplate(templateId)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSDictionary else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    // Update Entity Value
    // completion : Completion object to return parameters to the calling functions
    // Returns Dynamic Form Components in Json format
    func makeRequestToUpdateEntityValue(data:Data,completion: @escaping completionHandlerWithSuccessAndResultArray) {
        Alamofire.request(Router.updateEntityValue(data)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSArray else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,[],0)
            }
        }
    }
    
    // Save Instrument
    // completion : Completion object to return parameters to the calling functions
    func makeRequestToSaveInstrument(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.saveInstrument(data)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSDictionary else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    // Add Repeatable Group
    // completion : Completion object to return parameters to the calling functions
    func makeRequestToAddRepeatableGroup(data:Data,completion: @escaping completionHandlerWithSuccessAndResultArray) {
        Alamofire.request(Router.addRepeatableGroup(data)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSArray else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,[],0)
            }
        }
    }
    
    // Delete Repeatable Group
    // completion : Completion object to return parameters to the calling functions
    // Returns Dynamic Form Components in Json format
    func makeRequestToDeleteRepeatableGroup(data:Data,completion: @escaping completionHandlerWithSuccessAndResultArray) {
        Alamofire.request(Router.deleteRepeatableGroup(data)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSArray else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,[],0)
            }
        }
    }
    
    // Get Instrument
    // completion : Completion object to return parameters to the calling functions
    // Returns instruments
    func makeRequestToGetInstrument(instrumentId: String,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.getInstrument(instrumentId)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSDictionary else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    // Reset Instrument
    // completion : Completion object to return parameters to the calling functions
    // Returns Dynamic Form Components in Json format
    func makeRequestToResetInstrument(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.resetInstrument(data)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSDictionary else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }

    
    // Shows alert view according to the code sent
    // Params:
    // code:code is the response code sent from the server.
    func showAlertWithCode(code:Int)  {
        let alertView = UIAlertController(title: "Alert",message: self.choooseMessageForErrorCode(errorCode: code) as String, preferredStyle:.alert)
        alertView.setTint(color: PURPLE)
        alertView.setBackgroundColor(color: .white)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(okAction)
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        var vc = window.rootViewController;
        while (vc!.presentedViewController != nil){
            vc = vc!.presentedViewController;
        }
        vc?.present(alertView, animated: true, completion: nil)
    }
    
    // Shows alert view with the message sent
    // Params:
    // message is the text to shown in the alert view.
    func showAlertWithMessage(message:String)  {
        var alertView = UIAlertController(title: nil,
                                          message: message, preferredStyle:.alert)
        alertView.setTint(color: PURPLE)
        alertView.setBackgroundColor(color: .white)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(okAction)
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        var vc = window.rootViewController;
        while (vc!.presentedViewController != nil){
            vc = vc!.presentedViewController;
        }
        vc?.present(alertView, animated: true, completion: nil)
    }
    
    // Method for Error Code with Proper Appropriate String
    // Params:
    // errorCode:errorCode is the response code sent from the server.
    // Returns a String according to the error code.
    func choooseMessageForErrorCode(errorCode: Int) -> String {
        var message: String = ""
        switch errorCode {
        case SUCCESS_CODE_200:
            message = SUCCESS_MESSAGE_FOR_200
        case ERROR_CODE_400:
            message = ERROR_MESSAGE_FOR_400
            break
        case ERROR_CODE_401:
            message = ERROR_MESSAGE_FOR_401
        case ERROR_CODE_500:
            message = ERROR_MESSAGE_FOR_500
        case ERROR_CODE_503:
            message = ERROR_MESSAGE_FOR_503
        default:
            message = ERROR_MESSAGE_DEFAULT
        }
        return message;
    }
}
