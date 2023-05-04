//
//  EventDetailVC.swift
//  Companion
//
//  Created by Ambu Sangoli on 31/03/23.
//

import UIKit

class EventDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var guestEmailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var videoCallImage: UIImageView!
    @IBOutlet weak var callImageView: UIImageView!


    var eventData : EventStruct?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = eventData {
            self.guestNameLabel.text = "\(data.guestname) | \(data.guestId) "
            self.guestEmailLabel.text = data.guestEmail
            self.nameLabel.text = data.name
            self.dateTimeLabel.text = "\(data.date) at \(data.time)"
            self.durationLabel.text = "\(data.duration) mins"
            self.descriptionLabel.text = data.description
            self.videoCallImage.layer.borderColor = DARK_BLUE_COLOR.cgColor
            self.videoCallImage.layer.borderWidth = 2

            
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.call))
        self.callImageView.isUserInteractionEnabled = true
        self.callImageView.addGestureRecognizer(tap)
        
    }
    
    @objc func call() {
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
        let dataDic = [
            "appId": Bundle.main.bundleIdentifier ?? "",
            "calleeEmailId": self.eventData?.guestEmail ?? "",
            "callerEmailId": retrievedCodableObject.user?.mail ?? "",
            "callerName": retrievedCodableObject.user?.firstname ?? ""
          ]
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
                vc.name = self.eventData?.guestname ?? ""
                self.present(vc, animated: true)
            
        } else {
            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            ERProgressHud.shared.hide()
        }
     }
        }

    }

    
    @IBAction func joinBtn(_ sender: Any) {
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {

        OnCallHelper.shared.removeOnCallView()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let vc = appDelegate.voiceCallVC {
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let storyBoard = UIStoryboard(name: "covidCheck", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "JitsiMeetViewController") as! JitsiMeetViewController
        vc.meetingName = self.eventData?.meetingId
            vc.userName = "\(retrievedCodableObject.user?.firstname ?? "") \(retrievedCodableObject.user?.lastname ?? "")"
        appDelegate.voiceCallVC = vc
//            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
