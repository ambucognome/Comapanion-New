//
//  AppDelegate.swift
//  Companion
//
//  Created by Ambu Sangoli on 22/12/22.
//

import UIKit
import Firebase
import FirebaseMessaging

var LAUNCHED_FROM_KILLED_STATE : Bool = true


@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate,UNUserNotificationCenterDelegate {
    
    var logoutView : LogoutView?
    var callView : OnCallView?
    var voiceCallVC : JitsiMeetViewController?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if self.logoutView == nil {
            self.logoutView = Bundle.main.loadNibNamed("LogoutView", owner:
            self, options: nil)?.first as? LogoutView
            self.logoutView?.tag = 111
            self.logoutView?.frame = CGRect(x: UIScreen.main.bounds.maxX - 90, y: 40, width: 80, height: 40)
            self.logoutView?.layer.cornerRadius = 20
            self.logoutView?.isUserInteractionEnabled = true
        }
        if self.callView == nil {
            self.callView = Bundle.main.loadNibNamed("OnCallView", owner:
            self, options: nil)?.first as? OnCallView
            self.callView?.tag = 100
            self.callView?.frame = CGRect(x: UIScreen.main.bounds.maxX - 140, y: UIScreen.main.bounds.midY, width: 120, height: 160)
            self.callView?.layer.cornerRadius = 20
            self.callView?.imageView.layer.cornerRadius = 20
            let origImage = UIImage(named: "icCallFilled")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            self.callView?.callBtn.setImage(tintedImage, for: .normal)
            self.callView?.callBtn.tintColor = .white
            var panGesture       = UIPanGestureRecognizer()
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
            self.callView?.isUserInteractionEnabled = true
            self.callView?.addGestureRecognizer(panGesture)
        }
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        Messaging.messaging().delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        let windoww = UIApplication.shared.windows.last!
        let location = sender.location(in: windoww)
                let draggedView = sender.view
                draggedView?.center = location
                if sender.state == .ended {
                    if draggedView!.frame.minY < windoww.layer.frame.minY + 80 {
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                            draggedView!.center.y = 100
                        }, completion: nil)
                    } else if draggedView!.frame.maxY > windoww.layer.frame.maxY - 80 {
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                            draggedView!.center.y = windoww.layer.frame.height - 100
                        }, completion: nil)
                    }
                    
                    if draggedView!.frame.midX >= windoww.layer.frame.width / 2 {
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                            draggedView!.center.x = windoww.layer.frame.width - 80
                        }, completion: nil)
                    }else{
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                            draggedView!.center.x = 80
                        }, completion: nil)
                    }
                }
    }
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) {
          [weak self] granted, error in
            
          print("Permission granted: \(granted)")
            
          guard granted else { return }
            UNUserNotificationCenter.current().delegate = self
          self?.getNotificationSettings()
    }
    }

    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        Messaging.messaging().delegate = self
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        SafeCheckUtils.setFCMToken(fcmToken: fcmToken ?? "")
    }
    
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        SafeCheckUtils.setDeviceToken(deviceToken: token)
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
              SafeCheckUtils.setFCMToken(fcmToken: token)
          }
        }
    }

    func application( _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let dict = notification.request.content.userInfo
        print(dict)

//        if ((dict["data"] as? String)) != nil {
//            NotificationManager.shared.processNotification(dict: dict)
//        } else {
   
//        completionHandler([.sound])
        NotificationManager.shared.showNotificationBanner(dict: dict)
//        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let dict = response.notification.request.content.userInfo
//        print(dict)
        NotificationManager.shared.processNotification(dict: dict)
        completionHandler()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

