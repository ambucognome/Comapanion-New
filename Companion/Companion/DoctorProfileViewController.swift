//
//  DoctorProfileViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 13/03/23.
//

import UIKit

class DoctorProfileViewController: UIViewController {
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var specialityLabel : UILabel!
    @IBOutlet weak var patientsLabel : UILabel!
    @IBOutlet weak var experienceLabel : UILabel!
    @IBOutlet weak var reviewLabel : UILabel!
    @IBOutlet weak var bioTextView : UITextView!
    @IBOutlet weak var videoCallImage : UIImageView!


    var data : CareTeam?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = data {
            self.nameLabel.text = data.name
            self.specialityLabel.text = data.email
            self.patientsLabel.text = data.patients
            self.experienceLabel.text = data.experience
            self.reviewLabel.text = data.review
            self.bioTextView.text = data.bio
//            self.imgView.image = UIImage(named: data.image)
            self.imgView.setImageForName(data.name, backgroundColor: nil, circular: false, textAttributes: nil)
            self.videoCallImage.layer.borderColor = DARK_BLUE_COLOR.cgColor
            self.videoCallImage.layer.borderWidth = 2

        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.call))
        self.videoCallImage.isUserInteractionEnabled = true
        self.videoCallImage.addGestureRecognizer(tap)
        
    }
    
    @objc func call() {
        var dataDic = [String:Any]()
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
             dataDic = [
                "callerEmailId": retrievedCodableObject.user?.mail ?? "",
                "callerName": retrievedCodableObject.user?.firstname ?? "",
                "appId": Bundle.main.bundleIdentifier ?? ""
            ]
        } else if let retrievedCodableObject = SafeCheckUtils.getGuestUserData() {
             dataDic = [
                "callerEmailId": retrievedCodableObject.user.emailID,
                "callerName": retrievedCodableObject.user.username,
                "appId": Bundle.main.bundleIdentifier ?? ""
            ]
        }
        dataDic["calleeEmailId"] = self.data?.email ?? ""
        let jsonData = try! JSONSerialization.data(withJSONObject: dataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
        BaseAPIManager.sharedInstance.makeRequestToStartCall(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
                let roomId = response["roomId"] as? String ?? ""
        self.dismiss(animated: false) {
            let storyBoard = UIStoryboard(name: "Companion", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "CallingViewController") as! CallingViewController
            vc.name = self.data?.name ?? ""
            vc.roomId = roomId
            vc.opponentEmailId = self.data?.email ?? ""
            vc.modalPresentationStyle = .fullScreen
        if let navVC = UIApplication.getTopViewController() {
            navVC.present(vc, animated: true)
        }
        }
        } else {
            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            ERProgressHud.shared.hide()
        }
     }
    }


}
