//
//  GuestLoginViewController.swift
//  Companion
//
//  Created by ambu sangoli on 23/10/23.
//

import UIKit

class GuestLoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if self.emailTextField.text!.isEmpty {
            self.emailTextField.shake()
            return
        }
        if self.pinTextField.text!.isEmpty {
            self.pinTextField.shake()
            return
        }
        self.loginAPI()
    }
    
    func setRootViewController(vc: UIViewController) {
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func loginAPI(){
        ERProgressHud.shared.show()
        let parameters : [String: String] = [ "email" : self.emailTextField.text!,"pin": self.pinTextField.text! ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        BaseAPIManager.sharedInstance.makeRequestToGuestLogin( data: jsonData){ (success, response,statusCode)  in
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
                                          let jsonDataModels = try JSONDecoder().decode(GuestLoginModel.self, from: jsonData!)
                                          print(jsonDataModels)
                                          isFromLogin = false
                                          name = jsonDataModels.user.firstName
                                          ezid = jsonDataModels.user.userID
                                          SafeCheckUtils.setEZID(ezId: ezid)
                                          SafeCheckUtils.setName(name: name)
                                          SafeCheckUtils.setToken(token: jsonDataModels.user.userID)
                                          SafeCheckUtils.setGuestUserData(data: jsonDataModels)
                                          SafeCheckUtils.setIsGuest(isGuest: true)
                                          let username = "\(jsonDataModels.user.firstName) \(jsonDataModels.user.lastName)"
                                          self.uploadDeviceTokenAPI(emailID: jsonDataModels.user.emailID , username: username)
                                          let storyboard = UIStoryboard(name: "Companion", bundle: nil)
                                          let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                                          self.setRootViewController(vc: vc)
                                      } catch {
                                          print(error)
                                      }
                                  } catch {
                                      print(error)
                                  }
                        }
            } else {
                ERProgressHud.shared.hide()
                if statusCode == 401 {
                    APIManager.sharedInstance.showAlertWithMessage(message: "Invalid login credentials")
//                    APIManager.sharedInstance.showAlertWithMessage(message: APIManager.sharedInstance.choooseMessageForErrorCode(errorCode: statusCode))
                    return
                }
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            }
        }
    }
    
    func uploadDeviceTokenAPI(emailID: String, username: String){
        if SafeCheckUtils.getDeviceToken() != "" {
        let parameters : [String: String] = [
            "appId": Bundle.main.bundleIdentifier ?? "",
            "appToken": "",
            "fcmToken": SafeCheckUtils.getDeviceToken(),
            "userId": emailID,
            "appType" : "ios",
            "username" : username,
            "voipToken": SafeCheckUtils.getVoipDeviceToken()
           ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        BaseAPIManager.sharedInstance.makeRequestToUploadFCMToken( data: jsonData){ (success, response,statusCode)  in
            if (success) {
                print(response)
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
          }
         }
    }

}
