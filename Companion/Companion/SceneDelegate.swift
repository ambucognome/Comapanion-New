//
//  SceneDelegate.swift
//  Companion
//
//  Created by Ambu Sangoli on 22/12/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
            if let url = connectionOptions.urlContexts.first?.url {
                // handle
                if url.absoluteString.contains("companion://eventId"){
                    let component = url.absoluteString.components(separatedBy: "=") // 2
                               if component.count > 1, let eventId = component.last { // 3
                                   self.getEventDetails(eventId: eventId)
                               }
                }
                
            }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        UIApplication.shared.applicationIconBadgeNumber = 0

    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    


}

extension SceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first?.url else {
            return
        }

        print(firstUrl.absoluteString)
        if firstUrl.absoluteString.contains("companion://eventId"){
            let component = firstUrl.absoluteString.components(separatedBy: "=") // 2
                       if component.count > 1, let eventId = component.last { // 3
                           self.getEventDetails(eventId: eventId)
                       }
        }
    }
    
    func getEventDetails(eventId:String) {
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
            let data: [String: Any] = ["eventId": eventId,"meiId":retrievedCodableObject.user?.mail ?? ""]
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)


        ERProgressHud.shared.show()
                    BaseAPIManager.sharedInstance.makeRequestToGetEventDetails(data: jsonData){ (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            print(response)
                                 let eventDic = response
                                    let eventID = eventDic["eventId"] as? String ?? ""
                                    let metaDataString = eventDic["metadata"] as? String ?? ""
                                    if let metaDataDic = metaDataString.convertToDictionary() {
                                        print(metaDataDic)
                                        let parentId = eventDic["parentId"] as? String
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
                                        
                                        
//                                            let eventData = DateData(date: dateString, events: [EventStruct(name: title, time: timeString,duration: eventDuration, parentId: parentId, description: description, date: dateString, guestData: guestDat,meetingId: meetingId, context: cont, eventId: eventID)], careTeam: [CareTeam(image: "profile1", name: "guestName", specality: "guestId", lastVisitDate: "email")])
                                            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
                                            let controller = storyboard.instantiateViewController(identifier: "EventDetailVC") as! EventDetailVC
                                            controller.eventData = EventStruct(name: title, time: timeString,duration: eventDuration, parentId: parentId, description: description, date: dateString, guestData: guestDat,meetingId: meetingId, context: cont, eventId: eventID)
                                    //        let nav = UINavigationController(rootViewController: controller)
                                            let sheetController = SheetViewController(
                                                controller: controller,
                                                sizes: [.intrinsic],options: options)
                                            sheetController.gripSize = CGSize(width: 50, height: 3)
                                            sheetController.gripColor = UIColor(white: 96.0 / 255.0, alpha: 1.0)
                                            UIApplication.getTopViewController()?.present(sheetController, animated: true, completion: nil)
                                            
                                        }
                                    }
                        } else {
                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                            ERProgressHud.shared.hide()
                        }
                    }
        }
    }

    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
