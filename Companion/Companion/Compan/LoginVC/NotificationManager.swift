//
//  NotificationManager.swift
//  Compan
//
//  Created by Ambu Sangoli on 16/12/22.
//

import Foundation
import UIKit
import NotificationBannerSwift

var LAUNCHED_FROM_NOTIFICATION = false
var notificationData : [AnyHashable : Any] = [:]

class NotificationManager : NSObject {
    
    static let shared = NotificationManager()
    
    
    func processNotification(dict : [AnyHashable : Any] ){
//        print(dict as! [String:Any])
        if (SafeCheckUtils.getToken() != "") {
//        guard let notificationTypeString = dict["type"] as? String else {
//            return
//        }
        
       if UIApplication.shared.applicationState == .active {
           UIApplication.shared.applicationIconBadgeNumber = 0
           parsePayload( data: dict)
       }
       if UIApplication.shared.applicationState == .inactive ||  UIApplication.shared.applicationState == .background {
           UIApplication.shared.applicationIconBadgeNumber = 0
           if LAUNCHED_FROM_KILLED_STATE {
               LAUNCHED_FROM_NOTIFICATION = true
               notificationData = dict
               return

//               DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
//                self.parsePayload( data: dict)
//               }
           } else {
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.parsePayload(data: dict)
               }
           }
       }
     }
    }
    
    func parsePayload(data: [AnyHashable : Any] ){
                    guard let type = data["type"] as? String else { return }
                    guard let value = data["value"] as? String else { return }
                    if type == "image" {
                        print(value)
                        if let navVC = UIApplication.getTopViewController()  {
                            let storyboard = UIStoryboard(name: "covidCheck", bundle: nil)
                             let vc = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
                            vc.imageURL = value
                            navVC.present(vc, animated: true)
                        }
                    } else if type == "pdf" || type == "website"  {
                        if let navVC = UIApplication.getTopViewController() {
                            let storyboard = UIStoryboard(name: "covidCheck", bundle: nil)
                             let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                            vc.url = value
                            navVC.present(vc, animated: true)
                        }
                    }
    }
    
    func showNotificationBanner(dict : [AnyHashable : Any]) {
        //        print(dict as! [String:Any])
                if (SafeCheckUtils.getToken() != "") {
        //        guard let notificationTypeString = dict["type"] as? String else {
        //            return
        //        }

               if UIApplication.shared.applicationState == .active {
                   UIApplication.shared.applicationIconBadgeNumber = 0
                   self.parseBannerPayload( data: dict)
               }
               if UIApplication.shared.applicationState == .inactive ||  UIApplication.shared.applicationState == .background {
                   UIApplication.shared.applicationIconBadgeNumber = 0
                   if LAUNCHED_FROM_KILLED_STATE {
                       LAUNCHED_FROM_NOTIFICATION = true
                       notificationData = dict
                       return
//                       DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
//                        self.parseBannerPayload( data: dict)
//                       }
                       
                   } else {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.parseBannerPayload(data: dict)
                       }
                   }
               }
             }
    }
    
    func parseBannerPayload(data: [AnyHashable : Any] ){
        guard let apsDict = data["aps"] as? [String:Any] else { return }
        guard let title = apsDict["alert"] as? String else { return }
        let leftView = UIImageView(image: UIImage(named: "bell")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
        leftView.contentMode = .scaleAspectFit
        leftView.tintColor = UIColor.white
        let banner = NotificationBanner(title: title, subtitle: "Tap to View",leftView: leftView, style: .success)
        banner.haptic = .heavy
        banner.duration = 6
        banner.show()
        banner.onTap = {
                        guard let type = data["type"] as? String else { return }
                        guard let value = data["value"] as? String else { return }
                        if type == "image" {
                            print(value)
                            if let navVC = UIApplication.getTopViewController()  {
                                let storyboard = UIStoryboard(name: "covidCheck", bundle: nil)
                                 let vc = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
                                vc.imageURL = value
                                navVC.present(vc, animated: true)
                            }
                        } else if type == "pdf" || type == "website"  {
                            if let navVC = UIApplication.getTopViewController() {
                                let storyboard = UIStoryboard(name: "covidCheck", bundle: nil)
                                 let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                                vc.url = value
                                navVC.present(vc, animated: true)
                            }
                        }
        }

    }
}

