//
//  LogoutView.swift
//  Compan
//
//  Created by Ambu Sangoli on 08/09/22.
//

import UIKit
import FirebaseMessaging

class LogoutView: UIView {

    
    @IBAction func logoutBtn(sender : UIButton) {
        print("logout")
        LogoutHelper.shared.logout()
    }

}

class LogoutHelper : NSObject {
    
    static let shared = LogoutHelper()
    
    func showLogoutView(){
        let window = UIApplication.shared.windows.last!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let logoutView = appDelegate.logoutView {
            window.addSubview(logoutView)
        }
    }
    
    func removeLogoutView(){
        let window = UIApplication.shared.windows.last!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        for view in window.subviews {
            if view.tag == 111 {
                view.removeFromSuperview()
            }
        }
        appDelegate.logoutView?.removeFromSuperview()
    }
    
    func logout() {
        let deviceToken = SafeCheckUtils.getDeviceToken()
        self.removeLogoutView()
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "CompanionLoginViewController") as! CompanionLoginViewController
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationCapturesStatusBarAppearance = true
        nav.modalPresentationStyle = .custom
        SafeCheckUtils.setDeviceToken(deviceToken: deviceToken)
        Messaging.messaging().deleteData { error in
            
        }
        UIApplication.getTopViewController()?.present(nav, animated: true, completion: nil)
    }
    
    
}

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
