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
            self.specialityLabel.text = data.specality
            self.patientsLabel.text = data.patients
            self.experienceLabel.text = data.experience
            self.reviewLabel.text = data.review
            self.bioTextView.text = data.bio
            self.imgView.image = UIImage(named: data.image)
            self.videoCallImage.layer.borderColor = DARK_BLUE_COLOR.cgColor
            self.videoCallImage.layer.borderWidth = 2

        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.call))
        self.videoCallImage.isUserInteractionEnabled = true
        self.videoCallImage.addGestureRecognizer(tap)
        
    }
    
    @objc func call() {
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
        var dataDic = ["appId": Bundle.main.bundleIdentifier ?? "",
            "callerEmailId": retrievedCodableObject.user?.mail ?? "",
            "callerName": retrievedCodableObject.user?.firstname ?? ""
          ]
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
                let storyBoard = UIStoryboard(name: "Companion", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "CallingViewController") as! CallingViewController
                vc.name = self.data?.name ?? ""
                self.present(vc, animated: true)
            
        } else {
            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            ERProgressHud.shared.hide()
        }
     }
        }

    }


}
