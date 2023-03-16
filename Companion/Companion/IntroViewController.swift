//
//  IntroViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 03/02/23.
//

import UIKit
import LocalAuthentication

var isFromLogin = false
var name = ""
var ezid = ""

class IntroViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
//        self.appBecomeActive()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SafeCheckUtils.getBiometricsEnabled()  {
            self.authenticateDeviceOwner()
        } else {
            self.checkForUserType()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self, name:UIApplication.willResignActiveNotification, object: nil)
            notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
           print("App moved to background!")
    }
    
    @objc func appBecomeActive() {
//        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "TabBarController") as! UITabBarController
////            let nav = UINavigationController(rootViewController: vc)
//            self.setRootViewController(vc: vc)

    }
    

    func checkForUserType() {
        if (SafeCheckUtils.getToken() != "") {
            //User type not selected but logged in
            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            let vc = storyboard.instantiateViewController(identifier: "TabBarController") as! UITabBarController
//            vc.isFromLogin = false
            isFromLogin = false
//            let nav = UINavigationController(rootViewController: vc)
            self.setRootViewController(vc: vc)
            if LAUNCHED_FROM_NOTIFICATION {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                NotificationManager.shared.parsePayload( data: notificationData)
            }
            }
        } else if (SafeCheckUtils.getToken() == "") {
            // not logged in
            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "CompanionLoginViewController") as! CompanionLoginViewController
                let nav = UINavigationController(rootViewController: vc)
                self.setRootViewController(vc: nav)
        }
    }
    
    func authenticateDeviceOwner(){
        if (SafeCheckUtils.getToken() == "") {
            self.checkForUserType()
            return
        }
        // start authentication
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "Verify yourself") { (result) in

            switch result {
            case .success( _):
                self.checkForUserType()

                return

            case .failure(let error):

                switch error {

                // device does not support biometric (face id or touch id) authentication
                case .biometryNotAvailable:
                    self.checkForUserType()

                // No biometry enrolled in this device, ask user to register fingerprint or face
                case .biometryNotEnrolled:
                    self.checkForUserType()
//                    APIManager.sharedInstance.showAlertWithMessage(message:  error.message())

                // show alternatives on fallback button clicked
                case .fallback:
//                    self.showPasscodeAuthentication(message: error.message())
                    // Biometry is locked out now, because there were too many failed attempts.
                    LogoutHelper.shared.logout()
                    // Need to enter device passcode to unlock.
                case .biometryLockedout:
//                    self.showPasscodeAuthentication(message: error.message())
                    LogoutHelper.shared.logout()
                // do nothing on canceled by system
                case .canceledBySystem:
                    break

                 case .canceledByUser:
                    LogoutHelper.shared.logout()
//                        self.showAuthenticateAlert()
                default:
                    APIManager.sharedInstance.showAlertWithMessage(message:  error.message())
                }
            }
        }
    }

    // show passcode authentication
    func showPasscodeAuthentication(message: String) {
        BioMetricAuthenticator.authenticateWithPasscode(reason: message) {(result) in
            switch result {
            case .success( _):
                self.checkForUserType()
            case .failure(let error):
                print(error.message())
            }
        }
    }

    func showAuthenticateAlert(){
        let alertView = UIAlertController(title: nil,
                                          message: "You can only use SafeCheck App when its unlocked.", preferredStyle:.alert)
        let okAction = UIAlertAction(title: "Unlock", style: .default) { _ in
            self.authenticateDeviceOwner()
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    func setRootViewController(vc: UIViewController) {
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
   

}
