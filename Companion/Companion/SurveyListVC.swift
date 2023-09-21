//
//  SurveyListVC.swift
//  Companion
//
//  Created by Ambu Sangoli on 21/09/23.
//

import UIKit

class SurveyListVC: UIViewController {
    
    var titles = [String]()
    var completedDate = [String]()
    var tags = [String]()

    
    @IBOutlet weak var tableView: UITableView!
    
    var eventsData : [DateData] = []
    var vc : HomeViewController?


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Surveys"
        var dateRange = [
            "fromDate": "2023-01-10 00:00:00",
            "toDate": "2023-10-10 20:00:00"]
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
            dateRange["meiID"] = retrievedCodableObject.user?.mail
            self.getEvents(data: dateRange)
        }
    }
    

    func getEvents(data: [String: Any]) {
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        eventsData.removeAll()

        ERProgressHud.shared.show()
                    BaseAPIManager.sharedInstance.makeRequestToGetEvent(data: jsonData){ (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            print(response)
                            for i in 0..<response.count {
                                if let eventDic = response[i] as? NSDictionary {
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
//                                        let guestStr = guestString.replacingOccurrences(of: "[Guest(", with: "").replacingOccurrences(of: ")]", with: "")
//                                        let components = guestStr.components(separatedBy: ", ")
//                                        var guestDic: [String : String] = [:]
//
//                                        for component in components{
//                                          let pair = component.components(separatedBy: "=")
//                                            guestDic[pair[0]] = pair[1]
//                                        }
//                                        print(guestDic)
//                                        let guestName = guestDic["name"] ?? ""
//                                        let email = guestDic["email"] ?? ""
//                                        let guestId = guestDic["guestId"] ?? ""
                                        
                                        let contextString = metaDataDic["context"] as? String ?? ""
                                        if let cont = contextString.convertToDictionary() {
                                            print(cont)
                                        
//                                        let contextStr = contextString.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
//                                        let contextComponents = contextStr.components(separatedBy: ",")
//                                        var contextDic: [String : String] = [:]
//
//                                        for component in contextComponents{
//                                          let pair = component.components(separatedBy: ":")
//                                            contextDic[pair[0]] = pair[1]
//                                        }
                                        
                                        
                                            let data = DateData(date: dateString, events: [EventStruct(name: title, time: timeString,duration: eventDuration, parentId: parentId, description: description, date: dateString, guestData: guestDat,meetingId: meetingId, context: cont, eventId: eventID)], careTeam: [CareTeam(image: "profile1", name: "guestName", specality: "guestId", lastVisitDate: "email")])
                                            self.eventsData.append(data)
                                            self.tableView.reloadData()

                                        }
                                        
                                    }

                                }
                            }
                            self.titles = ["Covid Check","Sample Survey","Completed Survey"]
                            self.completedDate = ["Assigned on 28 August","Pending","Completed on 31 August"]
                            self.tags = ["Assigned","Pending","Completed"]

                            self.tableView.reloadData()
                    
                        } else {
                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                            ERProgressHud.shared.hide()
                        }
                    }
    }


}

extension SurveyListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titles.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell") as! SurveyCell
        cell.nameLabel.text = self.titles[indexPath.section]
        cell.completedDateLabel.text = self.completedDate[indexPath.section]
        cell.tagView.layer.cornerRadius = 4
        cell.tagView.layer.borderWidth = 1
        cell.typeLabel.text = self.tags[indexPath.section]
        if indexPath.section == 0 {
            cell.tagView.layer.borderColor = DARK_BLUE_COLOR.cgColor
        } else if indexPath.section == 1 {
            cell.tagView.layer.borderColor = UIColor.red.cgColor
        } else if indexPath.section == 2 {
            cell.tagView.layer.borderColor = UIColor.systemGreen.cgColor
        }
            return cell
    }
    

    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
