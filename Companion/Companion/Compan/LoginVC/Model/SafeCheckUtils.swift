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
    
    // Save the voip token
    // Params :
    // device token : It is the string which is to be saved
    class func setVoipDeviceToken(deviceToken : String){
        UserDefaults.standard.set(deviceToken, forKey: "voiptoken")
    }
    
    // Fetch the device token
    class func getVoipDeviceToken() -> String {
        let defaults = UserDefaults.standard
        guard let deviceVoipToken =  defaults.value(forKey: "voiptoken") as? String else {
            //APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            return ""
        }
        return deviceVoipToken
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
    
    // Save the user email
    // Params :
    // email : It is the string which is to be saved
    class func setEmail(email : String){
        UserDefaults.standard.set(email, forKey: "email")
    }
    
    // Fetch the email
    class func getEmail() -> String {
        let defaults = UserDefaults.standard
        guard let email =  defaults.value(forKey: "email") as? String else {
            //APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            return ""
        }
        return email
    }

    // Save the user mobile
    // Params :
    // email : It is the string which is to be saved
    class func setMobile(mobile : String){
        UserDefaults.standard.set(mobile, forKey: "mobile")
    }
    
    // Fetch the email
    class func getMobile() -> String {
        let defaults = UserDefaults.standard
        guard let mobile =  defaults.value(forKey: "mobile") as? String else {
            //APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            return ""
        }
        return mobile
    }
    
    // Save the user Id
    // Params :
    // email : It is the string which is to be saved
    class func setEZID(ezId : String){
        UserDefaults.standard.set(ezId, forKey: "ezid")
    }
    
    // Fetch the email
    class func getEZID() -> String {
        let defaults = UserDefaults.standard
        guard let ezId =  defaults.value(forKey: "ezid") as? String else {
            //APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            return ""
        }
        return ezId
    }
    
    // Save the user Id
    // Params :
    // email : It is the string which is to be saved
    class func setName(name : String){
        UserDefaults.standard.set(name, forKey: "name")
    }
    
    // Fetch the email
    class func getName() -> String {
        let defaults = UserDefaults.standard
        guard let name =  defaults.value(forKey: "name") as? String else {
            //APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            return ""
        }
        return name
    }
    
    // Save if user is guest
    // Params :
    // token : It is the string which is to be saved
    class func setIsGuest(isGuest : Bool){
        UserDefaults.standard.set(isGuest, forKey: "isGuest")
    }

    // Fetch if user is guest
    class func getIsGuest() -> Bool {
        let defaults = UserDefaults.standard
        guard let isGuest =  defaults.value(forKey: "isGuest") as? Bool else {
            return false
        }
        return isGuest
    }

    // Save the token
    // Params :
    // token : It is the string which is to be saved
    class func setGuestUserData(data : GuestLoginModel){
        UserDefaults.standard.setCodableObject(data, forKey: "guestloginData")
    }

    // Fetch the token
    class func getGuestUserData() -> GuestLoginModel? {
        guard let data = UserDefaults.standard.codableObject(dataType: GuestLoginModel.self, key: "guestloginData") else {
            return nil
        }
        return data
    }
}
