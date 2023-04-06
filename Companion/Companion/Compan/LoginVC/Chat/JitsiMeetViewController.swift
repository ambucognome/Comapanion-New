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
        let options = JitsiMeetConferenceOptions.fromBuilder { builder in
            builder.room = name
            builder.userInfo = JitsiMeetUserInfo(displayName: self.userName, andEmail: self.email, andAvatar: nil)

            builder.setAudioMuted(true)
            builder.setVideoMuted(true)
//            let url = URL(string: "https://www.companion.today")
//            builder.serverURL = url
            builder.setFeatureFlag("chat.enabled", withBoolean: false)
            builder.setFeatureFlag("ios.screensharing.enabled", withBoolean: true)
            builder.setFeatureFlag("pip.enabled", withBoolean: true)
        }

        meetView.join(options)
    }
}

extension JitsiMeetViewController: JitsiMeetViewDelegate {
    
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.voiceCallVC = nil
        OnCallHelper.shared.removeOnCallView()
//        callTimer.invalidate()
//        self.callTimer = nil
        self.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    
    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        print(data)
    }
    
    func participantJoined(_ data: [AnyHashable : Any]!) {
//        OnCallHelper.shared.updateSnapshot(image: self.meetView.takeScreenshot())
    }
    
    func participantLeft(_ data: [AnyHashable : Any]!) {
//        OnCallHelper.shared.updateSnapshot(image: self.meetView.takeScreenshot())
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
