//
//  RingingViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 03/05/23.
//

import UIKit
import AVFoundation

class RingingViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var player: AVAudioPlayer?

    
    var callTitle = ""
    var roomId = ""
    var callerEmailId = ""
    var opponentEmailId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = callTitle
        self.playSound()
    }
    

    @IBAction func acceptBtn(_ sender: Any) {
        self.player?.stop()
        var dataDic = [String:Any]()
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
             dataDic = [
                "actionBy": retrievedCodableObject.user?.firstname ?? "",
                "callerEmailId": callerEmailId,
                "roomId": self.roomId,
                "appId": Bundle.main.bundleIdentifier ?? "",
                "opponentEmailId": self.opponentEmailId
                
            ]
        } else if let retrievedCodableObject = SafeCheckUtils.getGuestUserData() {
             dataDic = [
                "actionBy": retrievedCodableObject.user.username,
                "callerEmailId": callerEmailId,
                "roomId": self.roomId,
                "appId": Bundle.main.bundleIdentifier ?? "",
                "opponentEmailId": self.opponentEmailId
                
            ]
        }
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
                    vc.isFromDialing = true
                    vc.callerEmailId = self.callerEmailId
                    vc.opponentEmailId = self.opponentEmailId
                    vc.modalPresentationStyle = .fullScreen
                    vc.userName = SafeCheckUtils.getUserData()?.user?.mail ?? SafeCheckUtils.getGuestUserData()?.user.emailID ?? ""
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
    
    @IBAction func rejectBtn(_ sender: Any) {
        self.player?.stop()
            var dataDic = [String:Any]()
            if let retrievedCodableObject = SafeCheckUtils.getUserData() {
                 dataDic = [
                    "actionBy": retrievedCodableObject.user?.firstname ?? "",
                    "callerEmailId": callerEmailId,
                    "roomId": self.roomId,
                    "appId": Bundle.main.bundleIdentifier ?? "",
                    "opponentEmailId": self.opponentEmailId
                    
                ]
            } else if let retrievedCodableObject = SafeCheckUtils.getGuestUserData() {
                 dataDic = [
                    "actionBy": retrievedCodableObject.user.username,
                    "callerEmailId": callerEmailId,
                    "roomId": self.roomId,
                    "appId": Bundle.main.bundleIdentifier ?? "",
                    "opponentEmailId": self.opponentEmailId
                    
                ]
            }
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
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "callertune", withExtension: "caf") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }

}
