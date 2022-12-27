//
//  TouchIDVerification.swift
//  Cognome
//
//  Created by Ambu Sangoli
//  Copyright © 2022 Cognome. All rights reserved.
//

import UIKit
import SCLAlertView
import LocalAuthentication
import BiometricAuthentication
import SCLAlertView

class AuthenticationMethods: NSObject {

    static let shared = AuthenticationMethods()

// This Function verifies finger print of the user stored in the phone
    func Authenticate(completion: @escaping ((Bool) -> ())){
        //Create a context
        let authenticationContext = LAContext()
        var error:NSError?
        //Check if device have Biometric sensor
        let isValidSensor : Bool = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        
        if isValidSensor {
            //Device have BiometricSensor
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: "Authenticate To Continue",
                reply: { [unowned self] (success, error) -> Void in
                    
                    if(success) {
                        // Touch / Face ID recognized success here
                        completion(true)
                    } else {
                        //If not recognized then
                        if let error = error {
                            self.errorMessage(errorCode: error._code)
                            
                        }
                        completion(false)
                    }
            })
        } else {
            self.errorMessage(errorCode: (error?._code)!)
        }
    }
    
    func errorMessage(errorCode:Int){
        var strMessage = ""
        switch errorCode {
        case LAError.Code.userFallback.rawValue:
            strMessage = "UserFallback"
        case LAError.Code.userCancel.rawValue:
            DispatchQueue.main.async {
                UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
            }
        case LAError.Code.appCancel.rawValue:
            strMessage = "App Cancel"
        case LAError.Code.systemCancel.rawValue:
            strMessage = "System Cancel"
        case LAError.Code.passcodeNotSet.rawValue:
            strMessage = "Please go to the Settings & Turn On Passcode"
            self.showAlertWithTitle(title: "App Name", message: strMessage)
        case LAError.Code.biometryNotAvailable.rawValue:
            strMessage = "TouchID or FaceID Not Available"
        case LAError.Code.biometryLockout.rawValue:
            strMessage = "Too Many Attempts"
        case LAError.Code.biometryNotEnrolled.rawValue:
            strMessage = "TouchID or FaceID Not Enrolled"
        case LAError.Code.invalidContext.rawValue:
            strMessage = "Invalid Context"
        default:
            break
        }
    }
    
    //MARK: Show Alert
    func showAlertWithTitle( title:String, message:String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        var topController = UIApplication.shared.keyWindow!.rootViewController
        
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController!;
        }
        topController?.present(alert, animated: true, completion: nil)
    }

}
