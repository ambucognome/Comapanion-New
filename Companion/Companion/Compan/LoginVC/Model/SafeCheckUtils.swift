//
//  SafeCheckUtils.swift
//  Compan
//
//  Created by Ambu Sangoli on 08/09/22.
//

import Foundation

class SafeCheckUtils: NSObject {

    static let shared = SafeCheckUtils()


// Save the token
// Params :
// token : It is the string which is to be saved
class func setToken(token : String){
    UserDefaults.standard.set(token, forKey: "token")
}

// Fetch the token
class func getToken() -> String {
    let defaults = UserDefaults.standard
    guard let userToken =  defaults.value(forKey: "token") as? String else {
        //APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
        return ""
    }
    return userToken
}
    
    // Save the token
    // Params :
    // token : It is the string which is to be saved
    class func setUserData(data : LoginModel){
        UserDefaults.standard.setCodableObject(data, forKey: "loginData")
    }

    // Fetch the token
    class func getUserData() -> LoginModel? {
        guard let data = UserDefaults.standard.codableObject(dataType: LoginModel.self, key: "loginData") else {
            return nil
        }
        return data
    }

    // Save the device token
    // Params :
    // device token : It is the string which is to be saved
    class func setDeviceToken(deviceToken : String){
        UserDefaults.standard.set(deviceToken, forKey: "devicetoken")
    }
    
    // Fetch the device token
    class func getDeviceToken() -> String {
        let defaults = UserDefaults.standard
        guard let deviceToken =  defaults.value(forKey: "devicetoken") as? String else {
            //APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            return ""
        }
        return deviceToken
    }
    
    // Save the FCM token
    // Params :
    // fcmToken : It is the string which is to be saved
    class func setFCMToken(fcmToken : String){
        UserDefaults.standard.set(fcmToken, forKey: "fcmtoken")
    }
    
    // Fetch the token
    class func getFCMToken() -> String {
        let defaults = UserDefaults.standard
        guard let fcmToken =  defaults.value(forKey: "fcmtoken") as? String else {
            //APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            return ""
        }
        return fcmToken
    }
    
    // Save Biometrics enabled
    // Params :
    // isEnabled : It is the Bool which is to be saved
    class func setBiometricsEnabled(isEnabled : Bool){
        UserDefaults.standard.set(isEnabled, forKey: "isEnabled")
    }
    
    // Fetch the Biometrics enabled
    class func getBiometricsEnabled() -> Bool {
        let defaults = UserDefaults.standard
        guard let isEnabled =  defaults.value(forKey: "isEnabled") as? Bool else {
            //APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            return false
        }
        return isEnabled
    }

}
