//
//  MeetingLogDetailVC.swift
//  Companion
//
//  Created by Ambu Sangoli on 07/11/23.
//

import UIKit

class MeetingLogDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var joinTimeLabel: UILabel!
    @IBOutlet weak var leaveLabel: UILabel!



    var logData : MeetingLogStruct?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = logData {
            self.nameLabel.text = data.title
            self.dateTimeLabel.text = "\(data.formattedEventDate) at \(data.formattedEventTime)"
            self.durationLabel.text = "\(data.duration) mins"
            self.descriptionLabel.text = data.description
            self.joinTimeLabel.text = data.formattedStartTime
            self.leaveLabel.text = data.formattedEndTime
            self.hostLabel.text = data.host
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func joinBtn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.voiceCallVC != nil {
            APIManager.sharedInstance.showAlertWithMessage(message: "Call in progress, can't join another call.")
            return
        }
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {

        OnCallHelper.shared.removeOnCallView()
        if let vc = appDelegate.voiceCallVC {
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
            self.dismiss(animated: false) {

        let storyBoard = UIStoryboard(name: "covidCheck", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "JitsiMeetViewController") as! JitsiMeetViewController
                vc.meetingName = self.logData?.meetingId
            vc.userName = "\(retrievedCodableObject.user?.firstname ?? "") \(retrievedCodableObject.user?.lastname ?? "")"
        appDelegate.voiceCallVC = vc
                vc.eventId = self.logData?.eventId ?? ""
            vc.modalPresentationStyle = .fullScreen
                if let navVC = UIApplication.getTopViewController() {
                    navVC.present(vc, animated: true)
                }
            }
        } else if let retrievedCodableObject = SafeCheckUtils.getGuestUserData() {

            OnCallHelper.shared.removeOnCallView()
            if let vc = appDelegate.voiceCallVC {
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
                self.dismiss(animated: false) {

            let storyBoard = UIStoryboard(name: "covidCheck", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "JitsiMeetViewController") as! JitsiMeetViewController
            vc.meetingName = self.logData?.meetingId
                    vc.userName = retrievedCodableObject.user.username
            appDelegate.voiceCallVC = vc
                    vc.eventId = self.logData?.eventId ?? ""
                vc.modalPresentationStyle = .fullScreen
                    if let navVC = UIApplication.getTopViewController() {
                        navVC.present(vc, animated: true)
                    }
                }
            }
    }
    
}

extension MeetingLogDetailVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.logData?.guest.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.logData?.guest[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestCell") as! GuestCell
        cell.guestNameLabel.text = "\(data?.guestname ?? "") "
        cell.guestEmailLabel.text = data?.guestEmail ?? ""

        cell.selectionStyle = .none
        return cell

    }
    
    
    
}
