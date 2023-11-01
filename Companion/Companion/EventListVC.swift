//
//  EventListVC.swift
//  Companion
//
//  Created by Ambu Sangoli on 26/05/23.
//

import UIKit

class EventListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var eventsData : [DateData] = []
    var vc : HomeViewController?


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Events"
        var dateRange = [
            "fromDate": "2023-01-10 00:00:00",
            "toDate": "2024-10-10 20:00:00"]
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
            dateRange["meiID"] = retrievedCodableObject.user?.mail
            self.getEvents(data: dateRange)
        } else if let retrievedCodableObject = SafeCheckUtils.getGuestUserData() {
            dateRange["meiID"] = retrievedCodableObject.user.emailID
            self.getEvents(data: dateRange)
        }
    }
    
    
    func getEvents(data: [String: Any]) {
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        self.eventsData.removeAll()
        surveyData.removeAll()

        ERProgressHud.shared.show()
                    BaseAPIManager.sharedInstance.makeRequestToGetEvent(data: jsonData){ (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            print(response)
                            if let appointmentArray = response["appointments"] as? NSArray {
                                for i in 0..<appointmentArray.count {
                                    if let eventDic = appointmentArray[i] as? NSDictionary {
                                        let eventID = eventDic["eventId"] as? String ?? ""
                                        let metaDataString = eventDic["metadata"] as? String ?? ""
                                        if let metaDataDic = metaDataString.convertToDictionary() {
                                            print(metaDataDic)
                                            let parentId = eventDic["parentId"] as? String
                                            let eventDate = metaDataDic["date"] as? String ?? ""
                                            
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                            let newDate = dateFormatter.date(from: eventDate)
                                            
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "dd/MM/yyyy"
                                            let dateString = formatter.string(from: newDate! as Date)
                                            
                                            let startTime = metaDataDic["startTime"] as? String ?? ""
                                            let timeFormatter = DateFormatter()
                                            timeFormatter.dateFormat = "hh:mm:ss a"
                                            let time = timeFormatter.date(from: startTime)
                                            
                                            let newformatter = DateFormatter()
                                            newformatter.dateFormat = "h:mm a"
                                            let timeString = newformatter.string(from: time! as Date)
                                            
                                            
                                            let title = metaDataDic["title"] as? String ?? ""
                                            let eventDuration = metaDataDic["eventDuration"] as? String ?? ""
                                            let description = metaDataDic["description"] as? String ?? ""
                                            let guestString = metaDataDic["guests"] as? String ?? ""
                                            let meetingId = metaDataDic["meetingId"] as? String ?? ""
                                            
                                            var guestDat = [GuestStruct]()
                                            if let array = guestString.convertToNSDictionary() {
                                                for guest in array {
                                                    if let guestDic = guest as? NSDictionary {
                                                        if let guestData = guestDic["guest"] as? NSDictionary {
                                                            let guestName = guestData["name"] as? String ?? ""
                                                            let email = guestData["email"] as? String ?? ""
                                                            let guestId = guestData["guestId"] as? String ?? ""
                                                            guestDat.append(GuestStruct(guestname: guestName, guestId: guestId, guestEmail: email))
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            let contextString = metaDataDic["context"] as? String ?? ""
                                            if let cont = contextString.convertToDictionary() {
                                                print(cont)
                                                
                                                let data = DateData(date: dateString, events: [EventStruct(name: title, time: timeString,duration: eventDuration, parentId: parentId, description: description, date: dateString, guestData: guestDat,meetingId: meetingId, context: cont, eventId: eventID)], careTeam: [CareTeam(image: "profile1", name: "guestName", specality: "guestId", lastVisitDate: "email")])
                                                self.eventsData.append(data)
                                                self.tableView.reloadData()
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                }
                            }
                            if let surveys = response["surveys"] as? NSArray {
                                for i in 0..<surveys.count {
                                    if let surveyDic = surveys[i] as? NSDictionary {
                                        let concept = surveyDic["concept"] as? String ?? ""
                                        let eventId = surveyDic["eventId"] as? String ?? ""
                                        var eventTime = surveyDic["eventTime"] as? String ?? ""
                                        
                                        
                                        let contextString = surveyDic["metadata"] as? String ?? ""
                                        if let cont = contextString.convertToDictionary() {
                                            print(cont)
                                            let name = cont["surveyTitle"] as? String ?? ""
                                            let templateId = cont["templateId"] as? String ?? ""
                                            let surveyId = cont["surveyId"] as? String ?? ""
                                            let instrumentId = cont["instrumentId"] as? String

                                            let dateFormatter = DateFormatter()
                                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                            dateFormatter.dateFormat = "yyyy-MM-dd"
                                            dateFormatter.timeZone = TimeZone(identifier: "UTC")
                                            
                                            if let dotRange = eventTime.range(of: "T") {
                                                eventTime.removeSubrange(dotRange.lowerBound..<eventTime.endIndex)
                                            }
                                            let newDate = dateFormatter.date(from: eventTime)
                                            
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "dd/MM/yyyy"
                                            let dateString = formatter.string(from: newDate! as Date)
                                            
                                            
                                            let data = SurveryData(date: dateString, surverys: [SurveyStruct(concept: concept, eventId: eventId, time: eventTime, templateId: templateId, surveyId: surveyId, name: name,instrumentId: instrumentId)])
                                            surveyData.append(data)
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                            }
                                
                            
                            self.tableView.reloadData()
                            DispatchQueue.main.asyncAfter(deadline: .now()  + 0.1) {
                                self.tableView.reloadData()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()  + 0.2) {
                                self.tableView.reloadData()
                            }
                        } else {
                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                            ERProgressHud.shared.hide()
                        }
                    }
    }



}

extension EventListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.eventsData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let data = self.eventsData[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyy"
        let newDate = dateFormatter.date(from: data.date)

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let dateString = formatter.string(from: newDate! as Date)
                return dateString
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.eventsData[indexPath.section].events[0]
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
        cell.callBtn.tag = indexPath.section
        cell.callBtn.addTarget(self, action: #selector(self.callAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func callAction(_ sender: UIButton) {
        print(sender.tag)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.voiceCallVC != nil {
            APIManager.sharedInstance.showAlertWithMessage(message: "Call in progress, can't join another call.")
            return
        }
        let data = self.eventsData[sender.tag].events[0]
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
            } else if let retrievedCodableObject = SafeCheckUtils.getGuestUserData() {
                
                OnCallHelper.shared.removeOnCallView()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate

                let storyBoard = UIStoryboard(name: "covidCheck", bundle: nil)
                let jitsi = storyBoard.instantiateViewController(withIdentifier: "JitsiMeetViewController") as! JitsiMeetViewController
                    jitsi.meetingName = data.meetingId
                jitsi.userName = retrievedCodableObject.user.username
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
        let data =  self.eventsData[indexPath.section].events[0]
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let dayViewController = CalendarViewController()
            dayViewController.calendarDelegate = vc
            dayViewController.hidesBottomBarWhenPushed = true
            dayViewController.selectedDate = data.date
            self.navigationController?.pushViewController(dayViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
