//
//  CallingViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 03/05/23.
//

import UIKit
import NotificationBannerSwift
import AVFoundation

class CallingViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var timer : Timer?
    var second = 0
    
    var name = ""
    var player: AVAudioPlayer?
    
    var roomId = ""
    var opponentEmailId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.playSound()
        self.nameLabel.text = "Calling \(name)"
        timer = Timer.scheduledTimer(timeInterval: 40.0, target: self, selector: #selector(self.timerfunction), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
        player?.stop()
    }

    @objc func timerfunction() {
        player?.stop()
        self.dismiss(animated: true) {
            let banner = NotificationBanner(title: "Call not answered", subtitle: nil, leftView: nil, rightView: nil, style: .warning, colors: nil)
            banner.haptic = .heavy
            banner.show()
        }
    }

    @IBAction func rejectBtn(_ sender: Any) {
        player?.stop()
        var dataDic = [String:Any]()
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
            dataDic = [
                "actionBy": retrievedCodableObject.user?.firstname ?? "",
                "callerEmailId": retrievedCodableObject.user?.mail ?? "",
                "roomId": self.roomId,
                "appId": Bundle.main.bundleIdentifier ?? "",
                "opponentEmailId": self.opponentEmailId
            ]
        } else if let retrievedCodableObject = SafeCheckUtils.getGuestUserData() {
            dataDic = [
                "actionBy": retrievedCodableObject.user.username,
                "callerEmailId": retrievedCodableObject.user.emailID,
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
        guard let url = Bundle.main.url(forResource: "phoneringing", withExtension: "caf") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
