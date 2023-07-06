//
//  AppDelegate.swift
//  Companion
//
//  Created by Ambu Sangoli on 22/12/22.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import PushKit
import CallKit
import NotificationBannerSwift

var LAUNCHED_FROM_KILLED_STATE : Bool = true


@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var logoutView : LogoutView?
    var callView : OnCallView?
    var voiceCallVC : JitsiMeetViewController?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        if self.logoutView == nil {
//            self.logoutView = Bundle.main.loadNibNamed("LogoutView", owner:
//            self, options: nil)?.first as? LogoutView
//            self.logoutView?.tag = 111
//            self.logoutView?.frame = CGRect(x: UIScreen.main.bounds.maxX - 90, y: 40, width: 80, height: 40)
//            self.logoutView?.layer.cornerRadius = 20
//            self.logoutView?.isUserInteractionEnabled = true
//        }
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
//        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
//        Messaging.messaging().delegate = self
//        UIApplication.shared.applicationIconBadgeNumber = 0
        IQKeyboardManager.shared.enable = true
        // Set `backgroundImage` to be able to use `shadowImage`
        
        let tabBarAppearance = UITabBar.appearance()
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.shadowImage = UIImage.colorForNavBar(color: UIColor(hexString: "#E0DDDD"))
            tabBarAppearance.standardAppearance = appearance
            tabBarAppearance.scrollEdgeAppearance = appearance
            tabBarAppearance.backgroundImage = UIImage()
        } else {
            UITabBar.appearance().shadowImage = UIImage.colorForNavBar(color: UIColor(hexString: "#E0DDDD"))
            UITabBar.appearance().backgroundImage = UIImage()
        }
        UINavigationBar.appearance().barTintColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        self.voipRegistration()
        return true
    }
    
    // Register for VoIP notifications
        func voipRegistration() {
            // Create a push registry object
            let mainQueue = DispatchQueue.main
            let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
            voipRegistry.delegate = self
            voipRegistry.desiredPushTypes = [PKPushType.voIP]
        }
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }
      return false
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
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    

    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        SafeCheckUtils.setDeviceToken(deviceToken: token)
        
    }

    func application( _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let dict = notification.request.content.userInfo
        print(dict)
        if  let eventData = (dict["eventdatajson"] as? String) {
            if let eventDataDic = eventData.convertToDictionary() {
                if let eventType = eventDataDic["eventType"] as? NSNumber {
                    if eventType == 1 {
                        completionHandler([.banner, .sound])
                    }
                }
            }
        } else if let eventData = (dict["eventdatajson"] as? NSDictionary) {
                if let eventType = eventData["eventType"] as? NSNumber {
                    if eventType == 1 {
                        completionHandler([.banner, .sound])
                    }
                }
            }
        


//        if ((dict["data"] as? String)) != nil {
//            NotificationManager.shared.processNotification(dict: dict)
//        } else {
   
        NotificationManager.shared.processNotification(data: dict)
        
//        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let dict = response.notification.request.content.userInfo
        print(dict)
        NotificationManager.shared.processEventNotification(dict: dict)
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

extension UIImage {
class func colorForNavBar(color: UIColor) -> UIImage {
    //let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)

    let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 1.0, height: 1.0))

    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()

    context!.setFillColor(color.cgColor)
    context!.fill(rect)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()


     return image!
    }
}

//MARK: - PKPushRegistryDelegate
extension AppDelegate : PKPushRegistryDelegate, CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("provider did reset")
    }
    
    
    // Handle updated push credentials
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print("pushRegistry -> deviceToken :\(deviceToken)")
        SafeCheckUtils.setVoipDeviceToken(deviceToken: deviceToken)
    }
        
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("pushRegistry:didInvalidatePushTokenForType:")
    }
    
    
    // Handle incoming pushes
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
         print("Voip notification",payload.dictionaryPayload)
        self.showCallView(callerName: "test")
        
    }
    
    func showCallView(callerName:String){
        // 1: Create an incoming call update object. This object stores different types of information about the caller. You can use it in setting whether the call has a video.
        let update = CXCallUpdate()
        // Specify the type of information to display about the caller during an incoming call. The different types of information available include `.generic`. For example, you could use the caller&#039;s name for the generic type. During an incoming call, the name displays to the other user. Other available information types are emails and phone numbers.
        update.remoteHandle = CXHandle(type: .generic, value: callerName)
        //update.remoteHandle = CXHandle(type: .emailAddress, value: "amosgyamfi@gmail.com")
        //update.remoteHandle = CXHandle(type: .phoneNumber, value: "a+35846599990")

        // 2: Create and set configurations about how the calling application should behave
        let config = CallKit.CXProviderConfiguration()
        let imageView = UIImageView()
        imageView.setImageForName(callerName, circular: true, textAttributes: nil)
        config.iconTemplateImageData = imageView.image!.pngData()
        config.includesCallsInRecents = true;
        config.supportsVideo = true;
        update.hasVideo = true

        // Provide a custom ringtone
//        config.ringtoneSound = "ES_CellRingtone23.mp3";

        // 3: Create a CXProvider instance and set its delegate
        let provider = CXProvider(configuration: config)
        provider.setDelegate(self, queue: nil)

        // 4. Post local notification to the user that there is an incoming call. When using CallKit, you do not need to rely on only displaying incoming calls using the local notification API because it helps to show incoming calls to users using the native full-screen incoming call UI on iOS. Add the helper method below `reportIncomingCall` to show the full-screen UI. It must contain `UUID()` that helps to identify the caller using a random identifier. You should also provide the `CXCallUpdate` that comprises metadata information about the incoming call. You can also check for errors to see if everything works fine.
        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
    }
    
    // What happens when the user accepts the call by pressing the incoming call button? You should implement the method below and call the fulfill method if the call is successful.
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("call answered")
        let banner = NotificationBanner(title: "Call Accepted", subtitle: nil, leftView: nil, rightView: nil, style: .success, colors: nil)
        banner.haptic = .heavy
        banner.show()
        action.fulfill()
        return
    }

    // What happens when the user taps the reject button? Call the fail method if the call is unsuccessful. It checks the call based on the UUID. It uses the network to connect to the end call method you provide.
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("call rejected")
        let banner = NotificationBanner(title: "Call Rejected/ Ended", subtitle: nil, leftView: nil, rightView: nil, style: .success, colors: nil)
        banner.haptic = .heavy
        banner.show()
        action.fail()
        return
    }
}
