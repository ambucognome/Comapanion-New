//
//  RingingViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 03/05/23.
//

import UIKit

class RingingViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var callTitle = ""
    var roomId = ""
    var callerEmailId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = callTitle
    }
    

    @IBAction func acceptBtn(_ sender: Any) {
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
        let dataDic = [
              "actionBy": retrievedCodableObject.user?.firstname ?? "",
              "callerEmailId": callerEmailId,
              "roomId": self.roomId,
            "appId": Bundle.main.bundleIdentifier ?? ""
            
          ]
        let jsonData = try! JSONSerialization.data(withJSONObject: dataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
        BaseAPIManager.sharedInstance.makeRequestToAcceptCall(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                self.dismiss(animated: false) {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let storyBoard = UIStoryboard(name: "covidCheck", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "JitsiMeetViewController") as! JitsiMeetViewController
                    vc.meetingName = self.roomId
                        vc.userName = "\(retrievedCodableObject.user?.firstname ?? "") \(retrievedCodableObject.user?.lastname ?? "")"
                    appDelegate.voiceCallVC = vc
                    if let navVC = UIApplication.getTopViewController()  {
                        navVC.present(vc, animated: false, completion: nil)
                    }
                }
            
        } else {
            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            ERProgressHud.shared.hide()
        }
     }
        }
    }
    
    @IBAction func rejectBtn(_ sender: Any) {
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
        let dataDic = [
              "actionBy": retrievedCodableObject.user?.firstname ?? "",
              "callerEmailId": callerEmailId,
              "roomId": self.roomId,
            "appId": Bundle.main.bundleIdentifier ?? ""
            
          ]
        let jsonData = try! JSONSerialization.data(withJSONObject: dataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
        BaseAPIManager.sharedInstance.makeRequestToRejectCall(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
                self.dismiss(animated: true)
            
        } else {
            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            ERProgressHud.shared.hide()
        }
     }
        }
    }

}
