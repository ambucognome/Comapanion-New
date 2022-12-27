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
        case getTemplate([String : Any])
        case updateEntityValue(Data)
        case addRepeatableEntityGroup(Data)
        case deleteRepeatableEntityGroup(Data)
        case excuteDDCScript(Data)
        case saveTemplate(Data)
        case resetTemplate(Data)
        case revokeBaseEntity(Data)

        // Api Methods
        var method: HTTPMethod {
            switch self {
            case .loginUser:
                return .post
            case .getTemplate:
                return .post
            case .updateEntityValue:
                return .post
            case .addRepeatableEntityGroup:
                return .post
            case .deleteRepeatableEntityGroup:
                return .delete
            case .excuteDDCScript:
                return .post
            case .saveTemplate:
                return .post
            case .resetTemplate:
                return .delete
            case .revokeBaseEntity:
                return .delete
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
            case .addRepeatableEntityGroup:
                return API_END_ADD_REPEATABLE_ENTITY_GROUP
            case .deleteRepeatableEntityGroup:
                return API_END_DELETE_REPEATABLE_ENTITY_GROUP
            case .excuteDDCScript(_):
                return API_END_EXCUTE_DDC_SCRIPT
            case .saveTemplate:
                return API_END_SAVE_TEMPLATE_INSTANCE
            case .resetTemplate:
                return API_END_RESET_TEMPLATE_INSTANCE
            case .revokeBaseEntity:
                return API_END_REVOKE_BASE_ENTITY
            }
        }
        
        //Generates a URL request object with the token embeded in the header.
        func asURLRequest() throws -> URLRequest {
            let url = try Router.baseURLString.asURL().appendingPathComponent(path)
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            urlRequest.addValue(TEMP_TOKEN_VALUE, forHTTPHeaderField: TEMP_TOKEN_KEY)
//            urlRequest.setValue("Bearer \(Utilities.getToken())", forHTTPHeaderField: "Authorization")

            switch self {
            case .loginUser(let parameters):
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
                return urlRequest
            case .getTemplate(let parameters):
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
                return urlRequest
            case .updateEntityValue(let data):
                urlRequest.httpBody = data
                return urlRequest
            case .addRepeatableEntityGroup(let data):
                urlRequest.httpBody = data
                return urlRequest
            case .deleteRepeatableEntityGroup(let data):
                urlRequest.httpBody = data
                return urlRequest
            case .excuteDDCScript(let data):
                urlRequest.httpBody = data
                return urlRequest
            case .saveTemplate(let data):
                urlRequest.httpBody = data
                return urlRequest
            case .resetTemplate(let data):
                urlRequest.httpBody = data
                return urlRequest
            case .revokeBaseEntity(let data):
                urlRequest.httpBody = data
                return urlRequest
            }
        }
    }
    
        
    // Completion Handlers
    typealias completionHandlerWithSuccess = (_ success:Bool) -> Void
    typealias completionHandlerWithSuccessAndErrorMessage = (_ success:Bool, _ errorMessage: String) -> Void
    typealias completionHandlerWithSuccessAndMessage = (_ success:Bool,_ message: NSDictionary) -> Void
    typealias completionHandlerWithResponse = (HTTPURLResponse) -> Void
    typealias completionHandlerWithResponseAndError = (HTTPURLResponse?, NSError?) -> Void
    typealias completionHandlerWithSuccessAndResultArray = (_ success:Bool, _ results: NSArray) -> Void
    typealias completionHandlerWithSuccessAndResultsArray = (_ success:Bool, _ result_1: NSArray, _ result_2: NSArray) -> Void
    typealias completionHandlerWithStatusCode = (_ success:Bool,_ message: NSDictionary,_ statusCode: Int) -> Void
    typealias completionHandlerWithBoolAndStatusCode = (_ success:Bool,_ message: Bool,_ statusCode: Int) -> Void

        
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
    func makeRequestToGetTemplate(params:[String:Any],completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.getTemplate(params)).responseJSON { response in
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
    func makeRequestToUpdateEntityValue(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.updateEntityValue(data)).responseJSON { response in
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
    
    // Add Repeatable Entity Group
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToAddRepeatableEntityGroup(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.addRepeatableEntityGroup(data)).responseJSON { response in
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
    
    // Delete Repeatable Entity Group
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToDeleteRepeatableEntityGroup(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.deleteRepeatableEntityGroup(data)).responseJSON { response in
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
                completion(true,[:],0)
            }
        }
    }
    
    // Execute ddc script
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToExecuteDDCScript(jsonString: String,data:Data,completion: @escaping completionHandlerWithBoolAndStatusCode) {
        let json = jsonString
        Alamofire.request(Router.excuteDDCScript(data)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? Bool else {
                    print(json)
//                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                } else {
//                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,false,0)
            }
        }
    }
    
    // Execute calculative ddc script
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToExecuteCalculativeDDCScript(jsonString: String,data:Data,completion: @escaping completionHandlerWithBoolAndStatusCode) {
        let json = jsonString
        Alamofire.request(Router.excuteDDCScript(data)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? Bool else {
                    print(json)
               //     APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,false,0)
            }
        }
    }

    // Save template instance
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToSaveTemplateInstance(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.saveTemplate(data)).responseJSON { response in
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
                completion(true,[:],0)
            }
        }
    }
    
    // Reset template instance
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToResetTemplateInstance(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.resetTemplate(data)).responseJSON { response in
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
                completion(true,[:],0)
            }
        }
    }
    
    // revoke base entity
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToRevokeBaseEntity(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.revokeBaseEntity(data)).responseJSON { response in
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
                completion(true,[:],0)
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

