//
//  MeetingLogViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 07/11/23.
//

import UIKit

struct MeetingLogStruct {
    var title = ""
    var description = ""
    var status = ""
    var startTime = ""
    var endTime = ""
    var host = ""
    var guest = [GuestStruct]()
    var eventTime = ""
    var formattedEventTime = ""
    var formattedStartTime = ""
    var duration = ""
    var formattedEventDate = ""
    var formattedEndTime = ""
    var eventId = ""
    var meetingId = ""
}

class MeetingLogViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var meetingLogData : [MeetingLogStruct] = []
    var fetchLogDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Meeting Logs"
        self.fetchLogDate = SafeCheckUtils.addOrSubtractMonth(month: -1)
        self.getMeetingLogs()
    }
    
    func getMeetingLogs(){
        ERProgressHud.shared.show()
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd'T'hh:mm:ss.SSS"
        let dateString = formatter.string(from: self.fetchLogDate.zeroTime!)
        
        var parameters : [String: String] = [
            "endDate": dateString]
        
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
            parameters["meiID"] = retrievedCodableObject.user?.mail
        }
        
        if let retrievedCodableObject = SafeCheckUtils.getGuestUserData() {
            parameters["meiID"] = retrievedCodableObject.user.emailID
        }
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        
        BaseAPIManager.sharedInstance.makeRequestToGetMeetingLogs(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
                for i in 0..<response.count {
                    if let dataDic = response[i] as? NSDictionary {
                        let startTime = dataDic["startTime"] as? String ?? ""
                        let endTime = dataDic["endTime"] as? String ?? ""
                        let eventTime = dataDic["eventTime"] as? String ?? ""
                        let status = dataDic["status"] as? String ?? ""
                        let eventId = dataDic["eventId"] as? String ?? ""
                        
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        var date = Date()
                        if let newDate = dateFormatter.date(from: eventTime) {
                            date = newDate
                        }
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                        if let newDate = dateFormatter.date(from: eventTime) {
                            date = newDate
                        }
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
                        if let newDate = dateFormatter.date(from: eventTime) {
                            date = newDate
                        }
                        
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MM/yyyy"
                        let formattedEventDate = formatter.string(from: date)
                        
                        formatter.dateFormat = "h:mm a"
                        let formattedEventTime = formatter.string(from: date)

                        
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                        let time = timeFormatter.date(from: startTime)
                        
                        let newformatter = DateFormatter()
                        newformatter.dateFormat = "h:mm a"
                        let formattedStartTime = newformatter.string(from: time! as Date)
                        
                        let timeFormatter1 = DateFormatter()
                        timeFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                        let time1 = timeFormatter1.date(from: endTime)
                        
                        var formattedEndTime = ""
                        let newformatter1 = DateFormatter()
                        newformatter1.dateFormat = "h:mm a"
                        if let time = time1 {
                            formattedEndTime = newformatter.string(from: time as Date)
                        }
                        
                        

                        let metaDataString = dataDic["metadata"] as? String ?? ""
                        if let metaDataDic = metaDataString.convertToDictionary() {
                            print(metaDataDic)
                            let title = metaDataDic["title"] as? String ?? ""
                            let eventDuration = metaDataDic["eventDuration"] as? String ?? ""
                            let hostUserId = metaDataDic["hostUserId"] as? String ?? ""
                            let description = metaDataDic["description"] as? String ?? ""
                            let meetingId = metaDataDic["meetingId"] as? String ?? ""
                            var guestDat = [GuestStruct]()
                            if let guestArray = (metaDataDic["guests"] as? String ?? "").convertToNSDictionary() {
//                                if let guestArray = metaDataDic["guests"] as? NSArray {
                                    for i in 0..<guestArray.count {
                                        if let guestDic = guestArray[i] as? NSDictionary {
                                            if let guestData = guestDic["guest"] as? NSDictionary {
                                                let guestName = guestData["name"] as? String ?? ""
                                                let email = guestData["email"] as? String ?? ""
                                                let guestId = guestData["guestId"] as? String ?? ""
                                                guestDat.append(GuestStruct(guestname: guestName, guestId: guestId, guestEmail: email))
                                                
                                            }
//                                        }
                                    }
                                }
                            }
                            let data = MeetingLogStruct(title: title,description: description,status: status, startTime: startTime, endTime: endTime,host: hostUserId, guest: guestDat, eventTime: eventTime,formattedEventTime: formattedEventTime,formattedStartTime: formattedStartTime,duration: eventDuration,formattedEventDate: formattedEventDate, formattedEndTime: formattedEndTime,eventId: eventId,meetingId: meetingId)
                            self.meetingLogData.append(data)
                        }
                    }
                }
                self.meetingLogData.sort(by: {$0.eventTime > $1.eventTime})
                self.tableView.reloadData()

                
                
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            }
        }
    }
    
        
}

extension MeetingLogViewController : UITableViewDataSource, UITableViewDelegate {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
}

func numberOfSections(in tableView: UITableView) -> Int {
    return self.meetingLogData.count
}

func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let data = self.meetingLogData[section]
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyy"
    let newDate = dateFormatter.date(from: data.formattedEventDate)

    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d, yyyy"
    let dateString = formatter.string(from: newDate! as Date)
            return dateString
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let data = self.meetingLogData[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        cell.eventName.text = data.title
        cell.time.text = data.formattedEventTime
        cell.selectionStyle = .none
    cell.durationLabel.text = "Duration: \(data.duration) mins"
    cell.hostLabel.text = "Status: \(data.status)"
        cell.callBtn.tag = indexPath.section
        return cell
}


// MARK:- UITableViewDelegate
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let storyboard = UIStoryboard(name: "Companion", bundle: nil)
    let controller = storyboard.instantiateViewController(identifier: "MeetingLogDetailVC") as! MeetingLogDetailVC
    controller.logData = self.meetingLogData[indexPath.section]
    let sheetController = SheetViewController(
        controller: controller,
        sizes: [.marginFromTop(40)],options: options)
    sheetController.gripSize = CGSize(width: 50, height: 3)
    sheetController.gripColor = UIColor(white: 96.0 / 255.0, alpha: 1.0)
    self.present(sheetController, animated: true, completion: nil)
}

func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 20
}
    
}
