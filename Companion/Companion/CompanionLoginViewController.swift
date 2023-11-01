//
//  CompanionLoginViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 22/12/22.
//

import UIKit
import GoogleSignIn


class CompanionLoginViewController: UIViewController {

    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ezIdTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SafeCheckUtils.setIsGuest(isGuest: false)
        selectedForm = false
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if self.ezIdTextField.text!.isEmpty {
            self.ezIdTextField.shake()
            return
        }
        if self.lastNameTextField.text!.isEmpty {
            self.lastNameTextField.shake()
            return
        }
        self.loginAPI()
    }
    
    @IBAction func googleSignInBtn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
           guard error == nil else { return }
            print(signInResult)
           // If sign in succeeded, display the app's main content View.
            guard let signInResult = signInResult else { return }

                let user = signInResult.user

                let emailAddress = user.profile?.email

                let fullName = user.profile?.name
                let givenName = user.profile?.givenName
                let familyName = user.profile?.familyName

                let profilePicUrl = user.profile?.imageURL(withDimension: 320)
         }
    }
    
    //MARK: Guest Login
    
    @IBAction func guestSignInBtn(_ sender: Any) {

            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "GuestLoginViewController")
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func setRootViewController(vc: UIViewController) {
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func loginAPI(){
        ERProgressHud.shared.show()
        let parameters : [String: String] = [ "eid" : self.ezIdTextField.text!,"lastname": self.lastNameTextField.text!,"loginType": "EZ-ID" ]
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
                                          isFromLogin = false
                                          name = self.lastNameTextField.text!
                                          ezid = self.ezIdTextField.text!
                                          SafeCheckUtils.setEZID(ezId: ezid)
                                          SafeCheckUtils.setName(name: name)
                                          SafeCheckUtils.setToken(token: jsonDataModels.user?.jwtToken ?? "")
                                          SafeCheckUtils.setUserData(data: jsonDataModels)
                                          let username = "\(jsonDataModels.user?.firstname ?? "") \(jsonDataModels.user?.lastname ?? "")"
                                          self.uploadDeviceTokenAPI(emailID: jsonDataModels.user?.mail ?? "", username: username)
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
                    APIManager.sharedInstance.showAlertWithMessage(message: APIManager.sharedInstance.choooseMessageForErrorCode(errorCode: statusCode))
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
//        }
//      }
    }
   
}

