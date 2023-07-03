//
//  JitsiMeetViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 27/09/22.
//

import UIKit
import JitsiMeetSDK

class JitsiMeetViewController: UIViewController {
    
    var meetingName: String!
    var email: String = ""
    var userName = ""
    var isFromDialing = false
    var callerEmailId = ""
    var opponentEmailId = ""
    var eventId = ""
//    var callTimer: Timer?
    
    @IBOutlet private var meetView: JitsiMeetView!
    @IBOutlet private var meetViewHeight: NSLayoutConstraint!
    @IBOutlet private var meetViewWidth: NSLayoutConstraint!

    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        joinMeeting(name: meetingName)
        meetView.delegate = self
        let downButton: UIButton = UIButton()
        let image = UIImage(named: "down");
        downButton.setImage(image, for: .normal)
        downButton.frame =  CGRect(x:0, y:0, width: 35, height:35)
        downButton.addTarget(self, action: #selector (downButtonAction(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: downButton)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       super.traitCollectionDidChange(previousTraitCollection)
                self.meetViewWidth.constant = self.view.frame.size.width
                self.meetViewHeight.constant = self.view.frame.size.height
        self.meetView.frame = CGRect(origin: .zero, size: view.bounds.size)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.meetViewWidth.constant = self.view.frame.size.width
        self.meetViewHeight.constant = self.view.frame.size.height
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
            self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func downButtonAction(sender: UIButton) {
        print("down button")
    }
    
    private func joinMeeting(name: String) {
        CALL_COMPLETED = false
        let options = JitsiMeetConferenceOptions.fromBuilder { builder in
            builder.room = name
            builder.userInfo = JitsiMeetUserInfo(displayName: self.userName, andEmail: self.email, andAvatar: nil)

            builder.setAudioMuted(true)
            builder.setVideoMuted(true)
            let url = URL(string: "https://chdiaz.montefiore.org")
//            let url = URL(string: "https://meet.jit.si")
            builder.serverURL = url
            builder.setFeatureFlag("chat.enabled", withBoolean: false)
            builder.setFeatureFlag("ios.screensharing.enabled", withBoolean: true)
            builder.setFeatureFlag("add-people.enabled", withBoolean: false)
            builder.setFeatureFlag("invite.enabled", withBoolean: false)
            builder.setFeatureFlag("meeting-name.enabled", withBoolean: false)
            builder.setFeatureFlag("server-url-change.enabled", withBoolean:false)
            builder.setFeatureFlag("meeting-password.enabled", withBoolean:false)
            builder.setFeatureFlag("live-streaming.enabled", withBoolean:false)
            builder.setFeatureFlag("ios.recording.enabled", withBoolean:false)
            builder.setFeatureFlag("calendar.enabled", withBoolean:false)
            builder.setFeatureFlag("close-captions.enabled", withBoolean:false)
            builder.setFeatureFlag("video-share.enabled", withBoolean:false)
            builder.setFeatureFlag("security-options.enabled", withBoolean:false)
            builder.setFeatureFlag("reactions.enabled", withBoolean:false)
            builder.setFeatureFlag("speakerstats.enabled", withBoolean:false)
            builder.setFeatureFlag("call-integration.enabled", withBoolean:true) // CallKit integration
            builder.setFeatureFlag("raise-hand.enabled", withBoolean:true)
            builder.setFeatureFlag("close-captions.enabled", withBoolean:true)
            if self.isFromDialing {
                builder.setFeatureFlag("pip.enabled", withBoolean:true)
            }
        }

        meetView.join(options)
    }
    
    func joinEvent() {
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
        let dataDic = ["meiId" : retrievedCodableObject.user?.mail ?? "",
                       "eventId": self.eventId ]
        let jsonData = try! JSONSerialization.data(withJSONObject: dataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
        BaseAPIManager.sharedInstance.makeRequestToJoinEvent(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
        } else {
            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            ERProgressHud.shared.hide()
        }
     }
        }
    }
    
    func leaveEvent() {
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
            let dataDic = ["meiId" : retrievedCodableObject.user?.mail ?? "",
                           "eventId": self.eventId ]
        let jsonData = try! JSONSerialization.data(withJSONObject: dataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
        BaseAPIManager.sharedInstance.makeRequestToLeaveEvent(data: jsonData){ (success, response,statusCode)  in
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

extension JitsiMeetViewController: JitsiMeetViewDelegate {
    
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.voiceCallVC = nil
        OnCallHelper.shared.removeOnCallView()
//        callTimer.invalidate()
//        self.callTimer = nil
        if self.isFromDialing {
        self.dismiss(animated: true) {
                CALL_COMPLETED = true
                self.endCall()
        }
        } else {
            self.leaveEvent()
        }
//        self.navigationController?.popViewController(animated: true)
    }
    
    func endCall() {
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
        let dataDic = [
              "actionBy": retrievedCodableObject.user?.mail ?? "",
              "callerEmailId": self.callerEmailId,
              "roomId": self.meetingName,
            "appId": Bundle.main.bundleIdentifier ?? "",
              "opponentEmailId": self.opponentEmailId
          ]
        let jsonData = try! JSONSerialization.data(withJSONObject: dataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
        BaseAPIManager.sharedInstance.makeRequestToEndCall(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
        } else {
            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            ERProgressHud.shared.hide()
        }
     }
        }
    }
    
    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        print(data)
        if self.isFromDialing == false {
            self.joinEvent()
        }
    }
    
    func participantJoined(_ data: [AnyHashable : Any]!) {
        OnCallHelper.shared.updateSnapshot(image: self.meetView.takeScreenshot())
    }
    
    func participantLeft(_ data: [AnyHashable : Any]!) {
        OnCallHelper.shared.updateSnapshot(image: self.meetView.takeScreenshot())
    }
    
    
    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        self.minimize()
    }
    
    func minimize() {
        self.meetViewWidth.constant = 120
        self.meetViewHeight.constant = 140
        OnCallHelper.shared.showOnCallView(image: self.meetView.takeScreenshot())
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            OnCallHelper.shared.updateSnapshot(image: self.meetView.takeScreenshot())
            self.meetViewWidth.constant = self.view.frame.size.width
            self.meetViewHeight.constant = self.view.frame.size.height
        }
    }
    
    
}
