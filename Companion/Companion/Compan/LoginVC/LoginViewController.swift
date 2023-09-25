//
//  LoginViewController.swift
//  Compan
//
//  Created by Ambu Sangoli on 7/28/22.
//

import UIKit
//import FirebaseMessaging

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var ezLoginBtn: UIButton!
    
    var surveyStartTime = ""
    var surveyID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func loginBtn(_ sender: Any) {
        if self.usernameTextField.text!.isEmpty {
            self.usernameTextField.shake()
            return
        }
        if self.passwordTextField.text!.isEmpty {
            self.passwordTextField.shake()
            return
        }
        self.loginAPI()

    }
    
    @IBAction func ezloginBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "covidCheck", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EZLoginViewController") as! EZLoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginAPI(){
        ERProgressHud.shared.show()
        let parameters : [String: String] = [ "username" : self.usernameTextField.text!,"password": self.passwordTextField.text!,"loginType": "LDAP" ]
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
                                          SafeCheckUtils.setToken(token: jsonDataModels.user?.jwtToken ?? "")
                                          SafeCheckUtils.setUserData(data: jsonDataModels)
                                          self.uploadFCMTokenAPI(eid: jsonDataModels.user?.eid ?? "")
                                         let storyboard = UIStoryboard(name: "covidCheck", bundle: nil)
                                          let vc = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
                                          self.navigationController?.pushViewController(vc, animated: true)
                                          
                                      } catch {
                                          print(error)
                                      }
                                  } catch {
                                      print(error)
                                  }
                        }
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    func uploadFCMTokenAPI(eid:String){
        if SafeCheckUtils.getDeviceToken() != "" {
//            Messaging.messaging().token { token, error in
//              if let error = error {
//                print("Error fetching FCM registration token: \(error)")
//              } else if let token = token {
//                print("FCM registration token: \(token)")
//                  SafeCheckUtils.setFCMToken(fcmToken: token)
        ERProgressHud.shared.show()
        let parameters : [String: String] = [
            "appId": Bundle.main.bundleIdentifier ?? "",
            "appToken": "",
            "fcmToken": SafeCheckUtils.getFCMToken(),
            "userId": eid,
            "username": SafeCheckUtils.getUserData()?.user?.firstname ?? "",
            "voipToken": SafeCheckUtils.getVoipDeviceToken()

           ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        BaseAPIManager.sharedInstance.makeRequestToUploadFCMToken( data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
//              }
//            }
    }
    }
}
