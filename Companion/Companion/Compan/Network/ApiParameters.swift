//
//  ApiParameters.swift
//  Cognome
//
//  Created by Ambu Sangoli
//  Copyright © 2022 Cognome. All rights reserved.
//

import UIKit

class ApiParameters: NSObject {

    static let shared = ApiParameters()

    //Creates Parameters for login api
    func getLoginParameters(userName:String,password:String,firstCharacter:String,secondCharacter:String,firstCharacterIndex:String,secondCharacterIndex:String) -> [String:String] {
        let parameter = ["UserName" : userName, "Password" :password,"FirstCharacter" :firstCharacter,"SecondCharacter" :secondCharacter,"FirstCharacterIndex" :firstCharacterIndex,"SecondCharacterIndex" :secondCharacterIndex]
        return parameter
    }
  
    //Creates Parameters for submiting Email or Mobile number based on the reponse of login
    func getEmailOrMobileParameters(userName:String,UserId:String,mobileNo:String,emailId:String,flag:String) -> [String:String] {
        let parameter = ["UserName" : userName, "UserId" :UserId,"MobileNo" :mobileNo,"EmailID" :emailId,"Flag" :flag, "Uuid":UIDevice.current.identifierForVendor?.uuidString]
        return parameter as! [String : String]
    }
    
    //Creates Parameters for Otp verify api call
    func getVerifyOtpParameters(userName:String,UserId:String,otp:String) -> [String:String] {
        let parameter = ["UserName" : userName, "UserId" :UserId,"OtpCode" :otp,"Uuid":UIDevice.current.identifierForVendor?.uuidString]
        return parameter as! [String : String]
    }
    
    //Creates Parameters for activating User
    func getActivationParameters(userName:String,activationKey:String,uuid:String) -> [String:String] {
        let parameter = ["UserName" : userName, "ActivationKey" :activationKey,"UUID" :UIDevice.current.identifierForVendor?.uuidString]
        return parameter as! [String : String]
    }
}
