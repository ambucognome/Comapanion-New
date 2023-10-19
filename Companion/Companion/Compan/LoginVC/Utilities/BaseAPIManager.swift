//
//  BaseAPIManager.swift
//  Compan
//
//  Created by Ambu Sangoli on 7/29/22.
//

import Foundation
import UIKit
import Alamofire

class BaseAPIManager : NSObject {
    
    // Shared Instance
    static let sharedInstance = BaseAPIManager()
    
    // MARK: URLRequestConvertible
    enum Router: URLRequestConvertible {
        
        // Api Base Url fron Constant
        static let baseURLString = FLOW_BASE_URL

        //User
        case loginUser(Data)
        case startSurvey(Data,String)
        case completeSurvey(Data)
        case uploadToken(Data)
        case createEvent(Data)
        case getEvents(Data)
        case deleteEvents(Data)
        
        case startCall(Data)
        case acceptCall(Data)
        case rejectCall(Data)
        case endCall(Data)
        case logout(Data)
        case getCareTeam(Data)
        case joinEvent(Data)
        case leaveEvent(Data)
        case getEventDetails(Data)
        case userBusy(Data)
        case startSurveyNew(String)
        case submitSurvey(Data)

        // saving it to backend
        case saveInstrumentID(Data)


        // Api Methods
        var method: HTTPMethod {
            switch self {
            case .loginUser:
                return .post
            case .startSurvey:
                return .post
            case .completeSurvey:
                return .post
            case .uploadToken:
                return .post
            case .createEvent:
                return .post
            case .getEvents:
                return .post
            case .deleteEvents:
                return .delete
            case .startCall:
                return .post
            case .acceptCall:
                return .post
            case .rejectCall:
                return .post
            case .endCall:
                return .post
            case .logout:
                return .post
            case .getCareTeam:
                return .post
            case .joinEvent:
                return .post
            case .leaveEvent:
                return .post
            case .getEventDetails:
                return .post
            case .userBusy:
                return .post
            case .startSurveyNew:
                return .get
            case .submitSurvey:
                return .post
                
            case .saveInstrumentID:
                return .post
            }
        }
            
        // Get the URL path
        var path: String {
            switch self {
            case .loginUser:
                return API_END_LOGIN
            case .startSurvey:
                return API_END_START_SURVEY
            case .completeSurvey:
                return API_END_COMPLETE_SURVEY
            case .uploadToken:
                return API_END_ADD_DEVICE_TOKEN
            case .createEvent:
                return API_END_CREATE_EVENT
            case .getEvents:
                return API_END_GET_EVENTS
            case .deleteEvents:
                return API_END_DELETE_EVENT
            case .startCall:
                return API_END_START_CALL
            case .acceptCall:
                return API_END_ACCEPT_CALL
            case .rejectCall:
                return API_END_REJECT_CALL
            case .endCall(_):
                return API_END_END_CALL
            case .logout(_):
                return API_END_LOGOUT
            case .getCareTeam:
                return API_END_GET_CARETEAM
            case .joinEvent(_):
                return API_END_JOIN_EVENT
            case .leaveEvent(_):
                return API_END_LEAVE_EVENT
            case .getEventDetails:
                return API_END_GET_EVENT_DETAILS
            case .userBusy:
                return API_END_USER_BUSY
            case .startSurveyNew:
                return API_END_START_SURVEY_NEW
            case .submitSurvey:
                return API_END_SUBMIT_SURVEY
            case .saveInstrumentID:
                return API_END_SAVE_INSTRUMENTID
            }
        }
        
        //Generates a URL request object with the token embeded in the header.
        func asURLRequest() throws -> URLRequest {
            let url = try Router.baseURLString.asURL().appendingPathComponent(path)
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var urlTokenRequest = URLRequest(url: url)
            urlTokenRequest.httpMethod = method.rawValue
            urlTokenRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlTokenRequest.setValue("Bearer \(SafeCheckUtils.getToken())", forHTTPHeaderField: "Authorization")
            
            switch self {
            case .loginUser(let data):
                urlRequest.httpBody = data
                return urlRequest
            case .startSurvey(let data,let isForced):
                let postUrl = try Router.baseURLString.asURL().appendingPathComponent(path)
                var url = URLComponents(string: postUrl.absoluteString)!
                if isForced == "true" {
                let isForced = URLQueryItem(name: "isForced", value: isForced)
                url.queryItems = [isForced]
                }
                urlRequest = URLRequest(url: url.url!)
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("Bearer \(SafeCheckUtils.getToken())", forHTTPHeaderField: "Authorization")
                urlRequest.httpMethod = method.rawValue
                urlRequest.httpBody = data
                return urlRequest
                
            case .completeSurvey(let data):
                urlTokenRequest.httpBody = data
                return urlTokenRequest
            case .uploadToken(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .createEvent(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .getEvents(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .deleteEvents(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .startCall(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .acceptCall(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .rejectCall(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .endCall(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .logout(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .getCareTeam(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .joinEvent(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .leaveEvent(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .getEventDetails(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .userBusy(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .startSurveyNew(let eventId):
                let urlWithEventId = EVENT_BASE_URL + path + eventId
                let url = try urlWithEventId.asURL()
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                return urlRequest
            case .submitSurvey(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = data
                return urlRequest
            case .saveInstrumentID(let data):
                let url = try EVENT_BASE_URL.asURL().appendingPathComponent(path)
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
    typealias completionHandlerWithSuccessAndResultArray = (_ success:Bool, _ message: NSArray,_ statusCode: Int) -> Void
    typealias completionHandlerWithSuccessAndResultsArray = (_ success:Bool, _ result_1: NSArray, _ result_2: NSArray) -> Void
    typealias completionHandlerWithStatusCode = (_ success:Bool,_ message: NSDictionary,_ statusCode: Int) -> Void
    typealias completionHandlerWithBoolAndStatusCode = (_ success:Bool,_ message: Bool,_ statusCode: Int) -> Void

        
    // Login User
    // completion : Completion object to return parameters to the calling functions
    // Returns User details
    func makeRequestToLoginUser(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.loginUser(data)).responseJSON { response in
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
                    if statusCode == 401 {
                        completion(false,[:],statusCode!)
                    } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                    completion(false,[:],statusCode!)
                    }
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    // Start survey
    // completion : Completion object to return parameters to the calling functions
    // Returns User details
    func makeRequestToStartSurvey(data:Data,isForced:String,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.startSurvey(data,isForced)).responseJSON { response in
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
                }  else if statusCode == ERROR_CODE_401 || statusCode == 403 {
                    self.loginAPI(urlRequest: Router.startSurvey(data,isForced), completion: completion)
                } else {
                    LogoutHelper.shared.logout()
                    APIManager.sharedInstance.showAlertWithMessage(message: "Session Expired. Login to continue.")
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    // Complete survey
    // completion : Completion object to return parameters to the calling functions
    // Returns User details
    func makeRequestToCompleteSurvey(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.completeSurvey(data)).responseJSON { response in
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
                }  else if statusCode == ERROR_CODE_401 || statusCode == 403 {
                    self.loginAPI(urlRequest: Router.completeSurvey(data), completion: completion)
                } else {
                    LogoutHelper.shared.logout()
                    APIManager.sharedInstance.showAlertWithMessage(message: "Session Expired. Login to continue.")
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    func loginAPI(urlRequest: URLRequestConvertible, completion: @escaping completionHandlerWithStatusCode){
        if let data = SafeCheckUtils.getUserData() {

        ERProgressHud.shared.show()
            let parameters : [String: String] = [ "eid" : data.user?.eid ?? "","lastname": data.user?.lastname ?? "","loginType": "EZ-ID" ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        BaseAPIManager.sharedInstance.makeRequestToLoginUser( data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
                                if let responseData = response as? Dictionary<String, Any> {
                                  var jsonData: Data? = nil
                                  do {
                                      jsonData = try JSONSerialization.data(
                                          withJSONObject: responseData as Any,
                                          options: .prettyPrinted)
                                      do{
                                          let jsonDataModels = try JSONDecoder().decode(LoginModel.self, from: jsonData!)
                                          print(jsonDataModels)
                                          SafeCheckUtils.setEZID(ezId: ezid)
                                          SafeCheckUtils.setName(name: name)
                                          SafeCheckUtils.setToken(token: jsonDataModels.user?.jwtToken ?? "")
                                          SafeCheckUtils.setUserData(data: jsonDataModels)
                                          
                                          
                                      } catch {
                                          print(error)
                                      }
                                  } catch {
                                      print(error)
                                  }
                        }
            } else {
                ERProgressHud.shared.hide()
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            }
        }
        }
    }
    
    func buildRequest(urlRequest: URLRequestConvertible, completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(urlRequest).responseJSON { response in
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
                    LogoutHelper.shared.logout()
                    APIManager.sharedInstance.showAlertWithMessage(message: "Session Expired. Login to continue.")
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    // Upload fcm Token
    // completion : Completion object to return parameters to the calling functions
    // Returns User details
    func makeRequestToUploadFCMToken(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.uploadToken(data)).responseJSON { response in
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
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    //  Create Event
    // completion : Completion object to return parameters to the calling functions
    // Returns Event
    func makeRequestToCreateEvent(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.createEvent(data)).responseJSON { response in
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
                    APIManager.sharedInstance.showAlertWithCode(code: response.response?.statusCode ?? 0)
//                    LogoutHelper.shared.logout()
//                    APIManager.sharedInstance.showAlertWithMessage(message: "Session Expired. Login to continue.")
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
 
    
    //  Get Event
    // completion : Completion object to return parameters to the calling functions
    // Returns Events
    func makeRequestToGetEvent(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.getEvents(data)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSDictionary else {
//                    completion(true, [], statusCode!)
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                }   else {
                    APIManager.sharedInstance.showAlertWithCode(code: response.response?.statusCode ?? 0)
//                    LogoutHelper.shared.logout()
//                    APIManager.sharedInstance.showAlertWithMessage(message: "Session Expired. Login to continue.")
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    

    
    //  Delete Event
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToDeleteEvent(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.deleteEvents(data)).response { response in
            print(response)
            ERProgressHud.shared.hide()
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                completion(true,[:],200)
            } else {
                completion(false,[:],0)
            }
        }
    }
    
    //  Start Call
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToStartCall(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.startCall(data)).responseJSON { response in
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
                    APIManager.sharedInstance.showAlertWithCode(code: response.response?.statusCode ?? 0)
//                    LogoutHelper.shared.logout()
//                    APIManager.sharedInstance.showAlertWithMessage(message: "Session Expired. Login to continue.")
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    //  Accept Call
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToAcceptCall(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.acceptCall(data)).response { response in
            print(response)
            ERProgressHud.shared.hide()
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                completion(true,[:],200)
            } else {
                completion(false,[:],0)
            }
        }
    }
    
    //  Reject Call
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToRejectCall(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.rejectCall(data)).response { response in
            print(response)
            ERProgressHud.shared.hide()
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                completion(true,[:],200)
            } else {
                completion(false,[:],0)
            }
        }
    }
    
    //  End Call
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToEndCall(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.endCall(data)).response { response in
            print(response)
            ERProgressHud.shared.hide()
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                completion(true,[:],200)
            } else {
                completion(false,[:],0)
            }
        }
    }
    
    //  Join Event
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToJoinEvent(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.joinEvent(data)).response { response in
            print(response)
            ERProgressHud.shared.hide()
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                completion(true,[:],200)
            } else {
                completion(false,[:],0)
            }
        }
    }
    
    //  Leave Event
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToLeaveEvent(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.leaveEvent(data)).response { response in
            print(response)
            ERProgressHud.shared.hide()
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                completion(true,[:],200)
            } else {
                completion(false,[:],0)
            }
        }
    }
    
    // Logout
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToLogout(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.logout(data)).response { response in
            print(response)
            ERProgressHud.shared.hide()
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                completion(true,[:],200)
            } else {
                completion(false,[:],0)
            }
        }
    }
    
    // Get careTeam
    // completion : Completion object to return parameters to the calling functions
    // Returns careteam
    func makeRequestToGetCareteam(data:Data,completion: @escaping completionHandlerWithSuccessAndResultArray) {
        Alamofire.request(Router.getCareTeam(data)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSArray else {
//                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                }
            case .failure( _):
                completion(false,[],0)
            }
        }
    }
    
    // Get Event Details
    // completion : Completion object to return parameters to the calling functions
    // Returns event details
    func makeRequestToGetEventDetails(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.getEventDetails(data)).responseJSON { response in
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
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    //  User Busy
    // completion : Completion object to return parameters to the calling functions
    // Returns
    func makeRequestToUserBusy(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.userBusy(data)).response { response in
            print(response)
            ERProgressHud.shared.hide()
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                completion(true,[:],200)
            } else {
                completion(false,[:],0)
            }
        }
    }
    
    // Start survey new
    // completion : Completion object to return parameters to the calling functions
    // Returns User details
    func makeRequestToStartSurveyNew(eventId:String,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.startSurveyNew(eventId)).responseJSON { response in
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
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    //  Submit Survey
    // completion : Completion object to return parameters to the calling functions
    // Returns Event
    func makeRequestToSubmitSurvey(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.submitSurvey(data)).response { response in
            print(response)
            ERProgressHud.shared.hide()
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                completion(true,[:],200)
            } else {
                completion(false,[:],0)
            }
        }
    }
    
    // Update Entity Value
    // completion : Completion object to return parameters to the calling functions
    // Returns Dynamic Form Components in Json format
    func makeRequestToSaveIntrumentID(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.saveInstrumentID(data)).responseJSON { response in
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



