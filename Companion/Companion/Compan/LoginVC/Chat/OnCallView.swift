//
//  OnCallView.swift
//  Companion
//
//  Created by Ambu Sangoli on 11/21/22.
//

import Foundation
import UIKit
import JitsiMeetSDK

class OnCallView: UIView {
    
    @IBOutlet weak var callBtn: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!

    
    @IBAction func actionBtn(sender : UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print("return to call")
        if let controller = appDelegate.voiceCallVC {
            OnCallHelper.shared.removeOnCallView()
            if let nav = UIApplication.getTopViewControllerNav() as? UINavigationController {
                nav.pushViewController(controller, animated: true)
            } else {
                UIApplication.getTopViewController()?.present(controller, animated: true, completion: nil)
            }
        }

    }
    
}

class OnCallHelper : NSObject {
    
    static let shared = OnCallHelper()
    
    func updateCallTimer(time: String) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if let callView = appDelegate.callView {
//            callView.callLabel.text = time
//        }
    }
    
    func updateSnapshot(image: UIImage) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let callView = appDelegate.callView {
            callView.imageView.image = image
        }
    }
    
    func showOnCallView(image: UIImage){
        let window = UIApplication.shared.windows.last!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let callView = appDelegate.callView {
            callView.imageView.image = image
            window.addSubview(callView)
        }
    }
    
    func removeOnCallView(){
//        let window = UIApplication.shared.windows.last!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.callView?.removeFromSuperview()
    }
    
    
}

extension UIApplication {

    class func getTopViewControllerNav(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return nav

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension UIView {

    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func convertToNSDictionary() -> [[String: Any]]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
        
    }
}
