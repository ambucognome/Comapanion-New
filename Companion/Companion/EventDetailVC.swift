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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
