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

var CALL_COMPLETED = false

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
    
    //MARK: Event notification handling
    
    func processEventNotification(dict : [AnyHashable : Any] ){
        if (SafeCheckUtils.getToken() != "") {
        
       if UIApplication.shared.applicationState == .active {
           UIApplication.shared.applicationIconBadgeNumber = 0
           parseEventPayload(data: dict)
       }
       if UIApplication.shared.applicationState == .inactive ||  UIApplication.shared.applicationState == .background {
           UIApplication.shared.applicationIconBadgeNumber = 0
           if LAUNCHED_FROM_KILLED_STATE {
               LAUNCHED_FROM_NOTIFICATION = true
//               notificationData = dict
//               return

               DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                self.parseEventPayload(data: dict)
               }
           } else {
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.parseEventPayload(data: dict)
               }
           }
       }
     }
    }
    
    
    func parseEventPayload(data : [AnyHashable : Any] ) {
        if let eventDic = data["eventdatajson"] as? [String:Any] {
        print(eventDic)
        let eventType = eventDic["eventType"] as? NSNumber ?? 0
        if eventType == 1 {
        let eventID = eventDic["eventId"] as? String ?? ""
        let metaDataString = eventDic["metadata"] as? [String:Any]
        if let metaDataDic = metaDataString {
            print(metaDataDic)
            let parentId = metaDataDic["parentId"] as? String
            let eventDate = metaDataDic["date"] as? String ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let newDate = dateFormatter.date(from: eventDate)

            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let dateString = formatter.string(from: newDate! as Date)
            
            let startTime = metaDataDic["startTime"] as? String ?? ""
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm:ss a"
            let time = timeFormatter.date(from: startTime)

            let newformatter = DateFormatter()
            newformatter.dateFormat = "h:mm a"
            let timeString = newformatter.string(from: time! as Date)
            
            
            let title = metaDataDic["title"] as? String ?? ""
            let eventDuration = metaDataDic["eventDuration"] as? String ?? ""
            let description = metaDataDic["description"] as? String ?? ""
            let guestString = metaDataDic["guests"] as? String ?? ""
            let meetingId = metaDataDic["meetingId"] as? String ?? ""


            var guestDat = [GuestStruct]()
            if let array = guestString.convertToNSDictionary() {
                for guest in array {
                if let guestDic = guest as? NSDictionary {
                    if let guestData = guestDic["guest"] as? NSDictionary {
                    let guestName = guestData["name"] as? String ?? ""
                     let email = guestData["email"] as? String ?? ""
                     let guestId = guestData["guestId"] as? String ?? ""
                        guestDat.append(GuestStruct(guestname: guestName, guestId: guestId, guestEmail: email))
                    }
                }
                }
            }
            
            let contextString = metaDataDic["context"] as? String ?? ""
            if let cont = contextString.convertToDictionary() {
                print(cont)

            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "EventDetailVC") as! EventDetailVC
            controller.eventData = EventStruct(name: title, time: timeString,duration: eventDuration, parentId: parentId, description: description, date: dateString, guestData: guestDat,meetingId: meetingId, context: cont, eventId: eventID)

    //        let nav = UINavigationController(rootViewController: controller)
            let sheetController = SheetViewController(
                controller: controller,
                sizes: [.intrinsic],options: options)
            sheetController.gripSize = CGSize(width: 50, height: 3)
            sheetController.gripColor = UIColor(white: 96.0 / 255.0, alpha: 1.0)
            if let navVC = UIApplication.getTopViewController()  {
                if let vc = navVC as? HomeViewController {
                    vc.getEvents(data: [
                        "fromDate": "2023-01-10 00:00:00",
                        "toDate": "2023-10-10 20:00:00" ,
                        "meiID" : SafeCheckUtils.getUserData()?.user?.mail ?? ""
                        ])
                }
                navVC.present(sheetController, animated: true, completion: nil)
            }
        }
        }
        }
        } else if let dataString = data["eventdatajson"] as? String {
            var callTitle = ""
            if let apsDict = data["aps"] as? [String:Any] {
            if let alert = apsDict["alert"] as? [String:Any] {
                callTitle = alert["body"] as? String ?? ""

            }
        }

            if let eventDic = dataString.convertToDictionary() {
                let eventType = eventDic["eventType"] as? NSNumber ?? 0
                if eventType == 1 {
                    let eventID = eventDic["eventId"] as? String ?? ""
                    let metaDataString = eventDic["metadata"] as? [String:Any]
                    if let metaDataDic = metaDataString {
                        print(metaDataDic)
                        let parentId = metaDataDic["parentId"] as? String
                        let eventDate = metaDataDic["date"] as? String ?? ""
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let newDate = dateFormatter.date(from: eventDate)

                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MM/yyyy"
                        let dateString = formatter.string(from: newDate! as Date)
                        
                        let startTime = metaDataDic["startTime"] as? String ?? ""
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "hh:mm:ss a"
                        let time = timeFormatter.date(from: startTime)

                        let newformatter = DateFormatter()
                        newformatter.dateFormat = "h:mm a"
                        let timeString = newformatter.string(from: time! as Date)
                        
                        
                        let title = metaDataDic["title"] as? String ?? ""
                        let eventDuration = metaDataDic["eventDuration"] as? String ?? ""
                        let description = metaDataDic["description"] as? String ?? ""
                        let guestString = metaDataDic["guests"] as? String ?? ""
                        let meetingId = metaDataDic["meetingId"] as? String ?? ""

                        var guestDat = [GuestStruct]()
                        if let array = guestString.convertToNSDictionary() {
                            for guest in array {
                            if let guestDic = guest as? NSDictionary {
                                if let guestData = guestDic["guest"] as? NSDictionary {
                                let guestName = guestData["name"] as? String ?? ""
                                 let email = guestData["email"] as? String ?? ""
                                 let guestId = guestData["guestId"] as? String ?? ""
                                    guestDat.append(GuestStruct(guestname: guestName, guestId: guestId, guestEmail: email))
                                }
                            }
                            }
                        }
                        
                        let contextString = metaDataDic["context"] as? String ?? ""
                        if let cont = contextString.convertToDictionary() {
                            print(cont)

                        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
                        let controller = storyboard.instantiateViewController(identifier: "EventDetailVC") as! EventDetailVC
                        controller.eventData = EventStruct(name: title, time: timeString,duration: eventDuration, parentId: parentId, description: description, date: dateString, guestData: guestDat,meetingId: meetingId, context: cont, eventId: eventID)

                //        let nav = UINavigationController(rootViewController: controller)
                        let sheetController = SheetViewController(
                            controller: controller,
                            sizes: [.intrinsic],options: options)
                        sheetController.gripSize = CGSize(width: 50, height: 3)
                        sheetController.gripColor = UIColor(white: 96.0 / 255.0, alpha: 1.0)
                        if let navVC = UIApplication.getTopViewController()  {
                            if let vc = navVC as? HomeViewController {
                                vc.getEvents(data: [
                                    "fromDate": "2023-01-10 00:00:00",
                                    "toDate": "2023-10-10 20:00:00" ,
                                    "meiID" : SafeCheckUtils.getUserData()?.user?.mail ?? ""
                                    ])
                            }
                            navVC.present(sheetController, animated: true, completion: nil)
                        }
                    }
                    }
                    }
            }
            
            if let dataDic = dataString.convertToDictionary() {
                let eventType = dataDic["eventType"] as? NSNumber ?? 0
                if eventType == 2 {
                    let roomId = dataDic["roomId"] as? String ?? ""
                    let callerEmailId = dataDic["callerEmailId"] as? String ?? ""
                    let opponentEmailId = dataDic["opponentEmailId"] as? String ?? ""
                    let storyboard = UIStoryboard(name: "Companion", bundle: nil)
                    let controller = storyboard.instantiateViewController(identifier: "RingingViewController") as! RingingViewController
                    controller.callTitle = callTitle
                    controller.modalPresentationStyle = .fullScreen
                    controller.roomId = roomId
                    controller.callerEmailId = callerEmailId
                    controller.opponentEmailId = opponentEmailId
                    if let retrievedCodableObject = SafeCheckUtils.getUserData() {
                        controller.opponentEmailId = retrievedCodableObject.user?.mail ?? ""
                    }
                    if let navVC = UIApplication.getTopViewController()  {
                        if (navVC as? JitsiMeetViewController != nil) || (navVC as? RingingViewController != nil){
                            self.userBusyAPICall(callerEmailId: callerEmailId, roomId: roomId, opponentEmailId: opponentEmailId)
                            return
                        } else {
                            navVC.present(controller, animated: true, completion: nil)
                        }
                    }
                    
                } else if eventType == 3 {
                    let roomId = dataDic["roomId"] as? String ?? ""
                    let actionBy = dataDic["actionBy"] as? String ?? ""
                    let callerEmailId = dataDic["callerEmailId"] as? String ?? ""
                    let opponentEmailId = dataDic["opponentEmailId"] as? String ?? ""
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let storyBoard = UIStoryboard(name: "covidCheck", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "JitsiMeetViewController") as! JitsiMeetViewController
                    vc.meetingName = roomId
                        vc.userName = actionBy
                    appDelegate.voiceCallVC = vc
                    vc.isFromDialing = true
                    vc.callerEmailId = callerEmailId
                    vc.opponentEmailId = opponentEmailId
                    if let navVC = UIApplication.getTopViewController()  {
                        if navVC as? CallingViewController != nil {
                            navVC.dismiss(animated: false) {
                                if let topVC = UIApplication.getTopViewController()  {
                                    topVC.present(vc, animated: false, completion: nil)
                                    return
                                }
                            }
                        }
                        navVC.present(vc, animated: false, completion: nil)
                    }
                } else if eventType == 4 {
                    let roomId = dataDic["roomId"] as? String ?? ""
                    let actionBy = dataDic["actionBy"] as? String ?? ""
                    if let navVC = UIApplication.getTopViewController()  {
                        if navVC as? CallingViewController != nil {
                            navVC.dismiss(animated: false) {
                                CALL_COMPLETED = true
                                let banner = NotificationBanner(title: "Call rejected", subtitle: nil, leftView: nil, rightView: nil, style: .danger, colors: nil)
                                banner.haptic = .heavy
                                banner.show()

                            }
                        }
//                        let banner = NotificationBanner(title: "Call was rejected", subtitle: nil, leftView: nil, rightView: nil, style: .danger, colors: nil)
//                        banner.haptic = .heavy
//                        banner.show()
                    }
                }  else if eventType == 5 {
                    let roomId = dataDic["roomId"] as? String ?? ""
                    let actionBy = dataDic["actionBy"] as? String ?? ""
                    if let navVC = UIApplication.getTopViewController()  {
                        if navVC as? JitsiMeetViewController != nil {
                            navVC.dismiss(animated: false) {
                                CALL_COMPLETED = true
                                let banner = NotificationBanner(title: "Call ended", subtitle: nil, leftView: nil, rightView: nil, style: .success, colors: nil)
                                banner.haptic = .heavy
                                banner.show()
                                return
                            }
                        } else {
                            if CALL_COMPLETED {
                                return
                            }
                            let banner = NotificationBanner(title: "Call ended", subtitle: nil, leftView: nil, rightView: nil, style: .success, colors: nil)
                            banner.haptic = .heavy
                            banner.show()
                        }
                    }
                } else if eventType == 10 {
                    if let navVC = UIApplication.getTopViewController()  {
                        if navVC as? CallingViewController != nil {
                            navVC.dismiss(animated: true) {
                                let banner = NotificationBanner(title: "User is busy", subtitle: nil, leftView: nil, rightView: nil, style: .warning, colors: nil)
                                banner.haptic = .heavy
                                banner.show()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func processNotification(data : [AnyHashable : Any] ) {
        if (SafeCheckUtils.getToken() != "") {
        
       if UIApplication.shared.applicationState == .active {
           UIApplication.shared.applicationIconBadgeNumber = 0
           handleNotificationWhenActive(data: data)
       }
       if UIApplication.shared.applicationState == .inactive ||  UIApplication.shared.applicationState == .background {
           UIApplication.shared.applicationIconBadgeNumber = 0
           if LAUNCHED_FROM_KILLED_STATE {
               LAUNCHED_FROM_NOTIFICATION = true
//               notificationData = dict
//               return

//               DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
//                self.handleNotificationWhenActive(data: data)
//               }
           } else {
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.handleNotificationWhenActive(data: data)
               }
           }
       }
        }
    }
    
    func handleNotificationWhenActive(data : [AnyHashable : Any] ) {
  if let dataString = data["eventdatajson"] as? String {
            var callTitle = ""
            if let apsDict = data["aps"] as? [String:Any] {
            if let alert = apsDict["alert"] as? [String:Any] {
                callTitle = alert["body"] as? String ?? ""

            }
        }

            if let dataDic = dataString.convertToDictionary() {
                let eventType = dataDic["eventType"] as? NSNumber ?? 0
                if eventType == 2 {
                    let roomId = dataDic["roomId"] as? String ?? ""
                    let callerEmailId = dataDic["callerEmailId"] as? String ?? ""
                    let opponentEmailId = dataDic["opponentEmailId"] as? String ?? ""
                    let storyboard = UIStoryboard(name: "Companion", bundle: nil)
                    let controller = storyboard.instantiateViewController(identifier: "RingingViewController") as! RingingViewController
                    controller.callTitle = callTitle
                    controller.modalPresentationStyle = .fullScreen
                    controller.roomId = roomId
                    controller.callerEmailId = callerEmailId
                    controller.opponentEmailId = opponentEmailId
                    if let retrievedCodableObject = SafeCheckUtils.getUserData() {
                        controller.opponentEmailId = retrievedCodableObject.user?.mail ?? ""
                    }
                    if let navVC = UIApplication.getTopViewController()  {
                        if (navVC as? JitsiMeetViewController != nil) || (navVC as? RingingViewController != nil){
                            self.userBusyAPICall(callerEmailId: callerEmailId, roomId: roomId, opponentEmailId: opponentEmailId)
                            return
                        } else {
                            navVC.present(controller, animated: true, completion: nil)
                        }
                    }
                    
                } else if eventType == 3 {
                    let roomId = dataDic["roomId"] as? String ?? ""
                    let actionBy = dataDic["actionBy"] as? String ?? ""
                    let callerEmailId = dataDic["callerEmailId"] as? String ?? ""
                    let opponentEmailId = dataDic["opponentEmailId"] as? String ?? ""
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let storyBoard = UIStoryboard(name: "covidCheck", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "JitsiMeetViewController") as! JitsiMeetViewController
                    vc.meetingName = roomId
                    vc.modalPresentationStyle = .fullScreen
                    if let retrievedCodableObject = SafeCheckUtils.getUserData() {
                        vc.userName = retrievedCodableObject.user?.firstname ?? ""
                    }
                    vc.isFromDialing = true
                    vc.callerEmailId = callerEmailId //email
                    vc.opponentEmailId = opponentEmailId
                    appDelegate.voiceCallVC = vc
                    if let navVC = UIApplication.getTopViewController()  {
                        if navVC as? CallingViewController != nil {
                            navVC.dismiss(animated: false) {
                                if let eventVC = UIApplication.getTopViewController() as? DoctorProfileViewController  {
                                    eventVC.dismiss(animated: false) {
                                        if let topVC = UIApplication.getTopViewController()  {
                                            topVC.present(vc, animated: false, completion: nil)
                                            return
                                        }
                                    }
                                } else {
                                    UIApplication.getTopViewController()?.present(vc, animated: false, completion: nil)
                                }
                            }
                        } else {
                            navVC.present(vc, animated: false, completion: nil)
                        }
                    }
                } else if eventType == 4 {
                    let roomId = dataDic["roomId"] as? String ?? ""
                    let actionBy = dataDic["actionBy"] as? String ?? ""
                    if let navVC = UIApplication.getTopViewController()  {
                        if navVC as? CallingViewController != nil {
                            navVC.dismiss(animated: false) {
                                CALL_COMPLETED = true
                                let banner = NotificationBanner(title: "Call rejected", subtitle: nil, leftView: nil, rightView: nil, style: .danger, colors: nil)
                                banner.haptic = .heavy
                                banner.show()
                                return
                            }
                        } else {
//                        let banner = NotificationBanner(title: "Call was rejected", subtitle: nil, leftView: nil, rightView: nil, style: .danger, colors: nil)
//                            banner.haptic = .heavy
//                            banner.show()
                        }
                    }
                } else if eventType == 5 {
                    let roomId = dataDic["roomId"] as? String ?? ""
                    let actionBy = dataDic["actionBy"] as? String ?? ""
                    if let navVC = UIApplication.getTopViewController()  {
                        if navVC as? JitsiMeetViewController != nil {
                            navVC.dismiss(animated: false) {
                                CALL_COMPLETED = true
                                let banner = NotificationBanner(title: "Call ended", subtitle: nil, leftView: nil, rightView: nil, style: .success, colors: nil)
                                banner.haptic = .heavy
                                banner.show()
                                return
                            }
                        } else {
                            if CALL_COMPLETED {
                                return
                            }
                            let banner = NotificationBanner(title: "Call ended", subtitle: nil, leftView: nil, rightView: nil, style: .success, colors: nil)
                            banner.haptic = .heavy
                            banner.show()
                        }
                    }
                }
                else if eventType == 10 {
                    if let navVC = UIApplication.getTopViewController()  {
                        if navVC as? CallingViewController != nil {
                            navVC.dismiss(animated: true) {
                                let banner = NotificationBanner(title: "User is busy", subtitle: nil, leftView: nil, rightView: nil, style: .warning, colors: nil)
                                banner.haptic = .heavy
                                banner.show()
                            }
                        }
                    }
                }
            }
  } else if let eventDic = data["eventdatajson"] as? [String:Any] {
      let eventType = eventDic["eventType"] as? NSNumber ?? 0
    if eventType == 10 {
          if let navVC = UIApplication.getTopViewController()  {
              if navVC as? CallingViewController != nil {
                  navVC.dismiss(animated: true) {
                      let banner = NotificationBanner(title: "User is busy", subtitle: nil, leftView: nil, rightView: nil, style: .warning, colors: nil)
                      banner.haptic = .heavy
                      banner.show()
                  }
              }
          }
      }
  }

        
    }
    
    
    func userBusyAPICall(callerEmailId:String, roomId:String, opponentEmailId: String){
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
        let dataDic = [
              "actionBy": retrievedCodableObject.user?.firstname ?? "",
              "callerEmailId": callerEmailId,
              "roomId": roomId,
              "appId": Bundle.main.bundleIdentifier ?? "",
              "opponentEmailId": opponentEmailId
          ]
        let jsonData = try! JSONSerialization.data(withJSONObject: dataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
        BaseAPIManager.sharedInstance.makeRequestToUserBusy(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
            
        } else {
            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            ERProgressHud.shared.hide()
        }
     }
        }
    }
}

