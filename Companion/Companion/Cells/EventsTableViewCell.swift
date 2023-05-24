//
//  EventsTableViewCell.swift
//  Companion
//
//  Created by Ambu Sangoli on 13/03/23.
//

import UIKit

class EventsTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!

//    var eventData = [EventStruct]()
    var dateEvents = [DateData]()
    var nav : UINavigationController?
    var vc : HomeViewController?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        //Added shadow
        self.reloadLayers()
    }

    private func reloadLayers() {
        self.layer.cornerRadius = 4
        self.shadowView.dropShadoww()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dateEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.dateEvents[indexPath.row].events[0]
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
            cell.eventName.text = data.name
            cell.time.text = data.time
            cell.selectionStyle = .none
        cell.durationLabel.text = "Duration: \(data.duration) mins"
        if data.parentId == nil {
            cell.hostLabel.text = "You are the host for this event."
        } else {
            cell.hostLabel.text = ""
        }
        cell.callBtn.tag = indexPath.row
        cell.callBtn.addTarget(self, action: #selector(self.callAction(_:)), for: .touchUpInside)
        
        self.layoutSubviews()
            return cell
    }
    
    @objc func callAction(_ sender: UIButton) {
        print(sender.tag)
        let data = self.dateEvents[sender.tag].events[0]
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {

        OnCallHelper.shared.removeOnCallView()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let storyBoard = UIStoryboard(name: "covidCheck", bundle: nil)
        let jitsi = storyBoard.instantiateViewController(withIdentifier: "JitsiMeetViewController") as! JitsiMeetViewController
            jitsi.meetingName = data.meetingId
            jitsi.userName = "\(retrievedCodableObject.user?.firstname ?? "") \(retrievedCodableObject.user?.lastname ?? "")"
        appDelegate.voiceCallVC = jitsi
            jitsi.modalPresentationStyle = .fullScreen
                if let navVC = UIApplication.getTopViewController() {
                    navVC.present(jitsi, animated: true)
                }
            }
//            self.present(vc, animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data =  self.dateEvents[indexPath.row].events[0]
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let dayViewController = CalendarViewController()
            dayViewController.calendarDelegate = vc
            dayViewController.hidesBottomBarWhenPushed = true
            dayViewController.selectedDate = data.date
            self.nav?.pushViewController(dayViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}
