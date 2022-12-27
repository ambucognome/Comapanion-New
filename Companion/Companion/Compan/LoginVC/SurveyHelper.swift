//
//  SurveyHelper.swift
//  Compan
//
//  Created by Ambu Sangoli on 8/9/22.
//

import Foundation
import UIKit

class SurveyHelper : NSObject {
    
    static let shared = SurveyHelper()
    

    func completeSurvey(surveyDetails: [String: Any]) {
//        let jsonData = try! JSONSerialization.data(withJSONObject: surveyDetails, options: JSONSerialization.WritingOptions.prettyPrinted)
//        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//
//        ERProgressHud.shared.show()
//                    BaseAPIManager.sharedInstance.makeRequestToCompleteSurvey( data: jsonData){ (success, response,statusCode)  in
//                        if (success) {
//                            ERProgressHud.shared.hide()
//                            print(response)
//                            let surveyDay = response["day_of_survey"] as? String ?? ""
//                            let surveyDate = response["survey_date"] as? String ?? ""
//                            let surveyExpirationTime = response["survey_expiration"] as? String ?? ""
//
//                            
//                            let surveyPassStatus = response["survey_pass_status"] as? Bool ?? false
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            if surveyPassStatus {
//                                let vc = storyboard.instantiateViewController(withIdentifier: "PassScreenViewController") as! PassScreenViewController
//                                vc.surveyDay = surveyDay
//                                vc.surveyDate = surveyDate
//                                vc.surveyExpirationTime = surveyExpirationTime
//                                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
//
//                            } else {
//                                let vc = storyboard.instantiateViewController(withIdentifier: "FailScreenViewController") as! FailScreenViewController
//                                vc.surveyDay = surveyDay
//                                vc.surveyDate = surveyDate
////                                self.navigationController?.pushViewController(vc, animated: true)
//                                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
//
//                            }
//                        } else {
//                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
//                            ERProgressHud.shared.hide()
//                        }
//                    }
        
    }
    


}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}


extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
}
