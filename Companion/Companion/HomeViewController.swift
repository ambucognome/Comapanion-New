//
//  HomeViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 11/03/23.
//

import UIKit
import NotificationBannerSwift

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

struct DateData {
    var date : String
    var events : [EventStruct]
    var careTeam : [CareTeam]
}

struct SurveryData {
    var date : String
    var surverys : [SurveyStruct]
}



struct SurveyStruct {
    var concept : String
    var eventId : String
    var time : String
    var date : String = ""
    var templateId : String
    var surveyId : String
    var name : String
    var sourceUri : String?
    var instrumentId : String?
}

struct EventStruct {
    var name : String
    var time : String
    var duration : String = "30"
    var parentId : String?
    var description : String = ""
    var date: String = ""
    var guestData : [GuestStruct]
    var meetingId : String = ""
    var context : [String:Any] = [:]
    var eventId : String = ""
    var templateId : String = ""
    var instrumentId : String = ""

}

struct GuestStruct {
    var guestname : String = ""
    var guestId : String = ""
    var guestEmail  : String = ""
}

struct CareTeam {
    var image : String
    var name : String
    var specality : String
    var lastVisitDate : String
    var experience : String = ""
    var patients : String = ""
    var review : String = ""
    var bio : String = ""
    var email: String = ""
}


//MARK: Add message text here
let message = "App not selected"

//MARK: Add reels data here
let appList = [AppStruct(name: "Events", image: UIImage(named: "calen"), notificationCount: 0,isSelected: false),
//               AppStruct(name: "Careteam", image: UIImage(named: "careteam"), notificationCount: 1, isSelected: false),
               AppStruct(name: "SafeCheck", image: UIImage(named: "form"), notificationCount: 0, isSelected: false)]


//MARK: Add events data here
var eventsData : [DateData] = []

var surveyData : [SurveryData] = []

var careteamData = [CareTeam(image: "profile1", name: "Hugo Franco", specality: "Cardiologist", lastVisitDate: "Last visit : May 20 2022"),
                    CareTeam(image: "profile2", name: "Cora Barber", specality: "Dentist", lastVisitDate: "Last visit : April 23 2022")]

var newEventIdStartSurvey: String = ""
var instrumentIdFromSaveInstrument: String = ""

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, CalendarViewControllerDelegate, SurveysTableViewCellDelegate, DynamicTemplateViewControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var containerView: UIView!

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    var selectedDate = Date()
    let btnLeftMenu: UIButton = UIButton()
    
    var dateRange = [
        "fromDate": "2023-01-10 00:00:00",
        "toDate": "2025-01-10 20:00:00" ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        
//        self.calendar.select(Date())
//        self.selectedDate = Date()
//        calendar.select(calendar.today)
        self.calendar.select(calendar.today, scrollToDate: false)

        //Call after select method.
        self.calendar(self.calendar, didSelect: calendar.today!, at: .current)

        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        self.navigationItem.title = "Home"
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
//        btnLeftMenu.setImage(UIImage(named:  "calendar_tab"), for: .normal)
        btnLeftMenu.addTarget(self, action: #selector (menu), for: .touchUpInside)
        btnLeftMenu.setTitle("Refresh", for: .normal)
        btnLeftMenu.setTitleColor(.blue, for: .normal)
//        btnLeftMenu.frame.size = CGSize(width:25, height: 25)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.rightBarButtonItem = barButton
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
//        self.selectedDate = self.getDateFromString(dateString: "14/03/2023")
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        navigationController?.navigationBar.isTranslucent = false
        self.tableView.reloadData()
        self.addObservers()

    }
    deinit {
        removeObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
            self.dateRange["meiID"] = retrievedCodableObject.user?.mail
            self.getEvents(data: dateRange)
        }
    }
    
    

    func addObservers(){
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(getTemplate),
//            name: NSNotification.Name(rawValue: "ReloadAPI") ,
//            object: nil
//        )
    }

    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:"ReloadAPI"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    @objc func menu() {
//        if self.calendar.scope == .month {
//            self.calendar.setScope(.week, animated: true)
//            btnLeftMenu.setImage(UIImage(named:  "calendar_tab"), for: .normal)
//        } else {
//            self.calendar.setScope(.month, animated: true)
//            btnLeftMenu.setImage(UIImage(named:  "vertical"), for: .normal)
//        }
        self.getEvents(data: dateRange)
    }

    var context = [
        "key": "test12345",
        "app":"Companion_iOS"    ]
    
    let CREATE_EVENT_TEMPLATE = "ddc:template_08060374-0022-4d30-9ddd-6896ef7b6fc5"
    
    @IBAction func addBtn(_ sender: Any) {
//        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
//            context["userid"] = retrievedCodableObject.user?.mail ?? ""
//            context["key"] = "Companion_\(self.random(digits: 5))"
//            self.getTemplate()
//        }
        self.getTemplateForEvent(templateId: self.CREATE_EVENT_TEMPLATE)
        
        
    }
    
    @objc func getTemplate() {
//        self.getTempleWith(uri: template_uri, context: self.context)
    }
    
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    
    
    func didSubmitEventForm(response: NSArray) {
        print("Did submit event form")
        self.createEventWithV2(response: response)
    }
    
    func didSubmitSurveyForm(response: NSArray, eventId: String) {
        print("Did Submit survey form")
        self.submitSurvey(ddcResponse: response, eventId: eventId)
    }

    var template_uri = "http://chdi.montefiore.org/calendarEvent"
    
    func didSubmitSurvey(params: [String : Any]) {
        print("survey completed")
        self.createEvent(data: params)
    }
    
//    func didUpdateEvent(eventData: [String : Any],eventId: String) {
//        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
//            context["userid"] = retrievedCodableObject.user?.mail ?? ""
//            context["key"] = "Companion_\(self.random(digits: 5))"
//            self.getTemplate()
//        }
//        self.deleteEvent(eventId: eventId, data: eventData)
//    }
    
    func didDeleteEvent(eventId: String) {
        self.deleteEvent(eventId: eventId, isDeleteSelected: true)
    }
    
    func didUpdateEvent(eventData: NSArray, eventId: String) {
        print("updatedEvent")
        self.deleteEvent(eventId: eventId)
    }
    
    func openForm(templateId: String, eventId: String, callStartSurvey: Bool,instrumentId: String?,isReadOnly: Bool) {
        if callStartSurvey {
            
            if ((instrumentId) != nil || instrumentId != "") {
                
                // Loading Assigned or Pending form
                self.startSurvey(eventId: eventId, templateId: templateId, instrumentId: instrumentId ?? "")

                
            } else {
                
                self.startSurvey(eventId: eventId, templateId: templateId, instrumentId: "")
                
            }
            
        } else {
        
            // loading completed form
            self.getTemplate(templateId: templateId, eventId: eventId, instrumentId: instrumentId,isReadOly: isReadOnly)
            
        }
    }
    
    func createEventWithV2(response: NSArray,isEdit: Bool = false) {

        var dataDic : [String: Any] = [:]
        dataDic["appId"] = Bundle.main.bundleIdentifier ?? ""
        var ddcContext : [String: Any] = ["key": "test12345","app":"Companion_iOS"]
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
            ddcContext["userid"] = retrievedCodableObject.user?.mail
        }
        dataDic["ddc_context"] = ddcContext
        dataDic["template_uri"] = self.CREATE_EVENT_TEMPLATE
        dataDic["id"] = instruments?.id
        var filteredEntities = [Entityy]()
        var groupEntities = [Entityy]()
        if let instrumentsData = instruments?.entities {
            for data in instrumentsData {
                if data.entityType == "ENTITY_INSTRUMENT" && data.parentEntityInstrumentID != nil {
                    groupEntities.append(data)
                }
                if data.entityType == "ENTITY_INSTRUMENT" && data.parentEntityInstrumentID == nil {
                    filteredEntities.append(data)
                }
            }
        }
        
        let orderedEntitiesInstrument = filteredEntities.sorted { $0.order! < $1.order!  }
        dataDic["title"] = orderedEntitiesInstrument[0].value
        dataDic["description"] = orderedEntitiesInstrument[1].value
        dataDic["start_time"] = orderedEntitiesInstrument[3].value
        
        dataDic["event_duration"] = (orderedEntitiesInstrument[4].value! as NSString).integerValue
        
        
        
        
        let orderedGuestEntitle = groupEntities.sorted { $0.order! < $1.order!  }

        var guest : [String: Any] = [:]
        guest["name"] = orderedGuestEntitle[0].value
        guest["email"] = orderedGuestEntitle[1].value
        guest["guest_id"] = orderedGuestEntitle[1].value
        
        dataDic["guests"] = [["guest":guest]]

        let date = orderedEntitiesInstrument[2].value
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newDate = dateFormatter.date(from: date!)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateString = formatter.string(from: newDate! as Date)
        dataDic["date"] = dateString

        let jsonData = try! JSONSerialization.data(withJSONObject: dataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        
        ERProgressHud.shared.show()
                    BaseAPIManager.sharedInstance.makeRequestToCreateEvent( data: jsonData){ (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            print(response)
                            if statusCode == 200 {
                                if isEdit {
                                    let banner = NotificationBanner(title: "Success", subtitle: "Event updated successfully.", style: .success)
                                    banner.show()
                                } else {
                                    let banner = NotificationBanner(title: "Success", subtitle: "Event created successfully.", style: .success)
                                    banner.show()
                                }
//                                self.getEvents(data: self.dateRange)
                            }
                        } else {
                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                            ERProgressHud.shared.hide()
                        }
                    }
        
    }
    
    func createEvent(data: [String: Any],isEdit: Bool = false) {
        
        let date = data["date"] as? String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newDate = dateFormatter.date(from: date!)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateString = formatter.string(from: newDate! as Date)

        
        var dataDic = data
        dataDic["ddc_context"] = context
        dataDic["template_uri"] = self.template_uri
        dataDic["date"] = dateString
        dataDic["appId"] = Bundle.main.bundleIdentifier ?? ""
        let jsonData = try! JSONSerialization.data(withJSONObject: dataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        
        ERProgressHud.shared.show()
                    BaseAPIManager.sharedInstance.makeRequestToCreateEvent( data: jsonData){ (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            print(response)
                            if statusCode == 200 {
                                if isEdit {
                                    let banner = NotificationBanner(title: "Success", subtitle: "Event updated successfully.", style: .success)
                                    banner.show()
                                } else {
                                    let banner = NotificationBanner(title: "Success", subtitle: "Event created successfully.", style: .success)
                                    banner.show()
                                }
                                self.getEvents(data: self.dateRange)
                            }
                        } else {
                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                            ERProgressHud.shared.hide()
                        }
                    }
    }
    
    func deleteEvent(eventId: String, data: [String: Any] = [:],isDeleteSelected:Bool = false) {
        let dataDic = ["eventId":eventId]
        let jsonData = try! JSONSerialization.data(withJSONObject: dataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        
        ERProgressHud.shared.show()
                    BaseAPIManager.sharedInstance.makeRequestToDeleteEvent( data: jsonData){ (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            if statusCode == 200 {
                                if isDeleteSelected {
                                    let banner = NotificationBanner(title: "Success", subtitle: "Event deleted successfully.", style: .success)
                                    banner.show()
//                                    self.getEvents(data: self.dateRange)
                                    return
                                }
//                                self.createEvent(data: data,isEdit: true)
                                self.createEventWithV2(response: [],isEdit: true)
                            }
                        } else {
                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                            ERProgressHud.shared.hide()
                        }
                    }
    }

    
    func getEvents(data: [String: Any]) {
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        eventsData.removeAll()
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
                                            let instrumentId =  metaDataDic["instanceId"] as? String ?? ""
                                            let templateId = eventDic["sourceUri"] as? String ?? ""
                                            
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
                                                
                                                let data = DateData(date: dateString, events: [EventStruct(name: title, time: timeString,duration: eventDuration, parentId: parentId, description: description, date: dateString, guestData: guestDat,meetingId: meetingId, context: cont, eventId: eventID, templateId: templateId, instrumentId: instrumentId)], careTeam: [CareTeam(image: "profile1", name: "guestName", specality: "guestId", lastVisitDate: "email")])
                                                eventsData.append(data)
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
                                            
                                            let eventDate = cont["startDate"] as? String ?? ""
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
                            self.calendar.reloadData()
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
    
    //Get Template Api Call
    func getTemplateForEvent(templateId: String){
            ERProgressHud.shared.show()
            APIManager.sharedInstance.makeRequestToGetTemplate(templateId: templateId){ (success, response,statusCode)  in
                if (success) {
                    print(response)
                    if let responseData = response as? Dictionary<String, Any> {
                                      var jsonData: Data? = nil
                                      do {
                                          jsonData = try JSONSerialization.data(
                                              withJSONObject: responseData as Any,
                                              options: .prettyPrinted)
                                          do{
                                              let jsonDataModels = try JSONDecoder().decode(DDCFormModell.self, from: jsonData!)
                                              print(jsonDataModels)
                                              let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                              let vc = storyboard.instantiateViewController(withIdentifier: "dynamic") as! DynamiccTemplateViewController
                                              ddcModel = jsonDataModels
                                              vc.delegate = self
                                              vc.isEventTemplate = true
                                              vc.hideIndexField = true
                                              self.saveInstrument(templateId: jsonDataModels.id!,isEventTemplate: true)
                                              vc.hidesBottomBarWhenPushed = true
                                              self.navigationController?.pushViewController(vc, animated: true)

                                          }catch {
                                              print(error)
                                          }
                                      } catch {
                                          print(error)
                                      }
                            }
                } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    ERProgressHud.shared.hide()
                }
            }
        }

    //Get Template Api Call
    func getTemplate(templateId: String,eventId: String, shouldUpdateIndex: Bool = false, newEventId: String = "",instrumentId:String?,isReadOly: Bool = false){
            ERProgressHud.shared.show()
            APIManager.sharedInstance.makeRequestToGetTemplate(templateId: templateId){ (success, response,statusCode)  in
                if (success) {
                    print(response)
                    if let responseData = response as? Dictionary<String, Any> {
                                      var jsonData: Data? = nil
                                      do {
                                          jsonData = try JSONSerialization.data(
                                              withJSONObject: responseData as Any,
                                              options: .prettyPrinted)
                                          do{
                                              let jsonDataModels = try JSONDecoder().decode(DDCFormModell.self, from: jsonData!)
                                              print(jsonDataModels)
                                              let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                              let vc = storyboard.instantiateViewController(withIdentifier: "dynamic") as! DynamiccTemplateViewController
                                              ddcModel = jsonDataModels
                                              vc.delegate = self
                                              vc.eventId = eventId
                                              vc.hideIndexField = true
                                              isReadOnly = false
                                              if let id = instrumentId {
                                                  isReadOnly = isReadOly
                                                  self.getInstrument(instrumentId: id)
                                              } else {
                                                  self.saveInstrument(templateId: jsonDataModels.id!,shouldUpdateIndex: shouldUpdateIndex, newEventId: newEventId, oldEventId: eventId)
                                              }
                                              vc.hidesBottomBarWhenPushed = true
                                              self.navigationController?.pushViewController(vc, animated: true)

                                          }catch {
                                              print(error)
                                          }
                                      } catch {
                                          print(error)
                                      }
                            }
                } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    ERProgressHud.shared.hide()
                }
            }
        }
        
        
    func saveInstrument(templateId: String,shouldUpdateIndex: Bool = false, newEventId: String = "", oldEventId: String = "",isEventTemplate : Bool = false){
            let parameter : [String:Any] = ["templateId": templateId, "predefinedFields": [:] ]
            let jsonData = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)

            APIManager.sharedInstance.makeRequestToSaveInstrument(data: jsonData){ (success, response,statusCode)  in
                if (success) {
                    print(response)
                    if let responseData = response as? Dictionary<String, Any> {
                                      var jsonData: Data? = nil
                                      do {
                                          jsonData = try JSONSerialization.data(
                                              withJSONObject: responseData as Any,
                                              options: .prettyPrinted)
                                          do{
                                              let jsonDataModels = try JSONDecoder().decode(Instruments.self, from: jsonData!)
                                              print(jsonDataModels)

                                              instruments = jsonDataModels
                                              instrumentIdFromSaveInstrument = instruments?.id ?? ""
                                              
                                              self.saveInstrumentID(eventId: newEventIdStartSurvey, instrumenId: instrumentIdFromSaveInstrument)
                                              
                                              if !isEventTemplate {
//                                                  if shouldUpdateIndex {
//                                                      NewRequestHelper.shared.updateIndexField(eventId: newEventId)
//                                                  } else {
                                                  NewRequestHelper.shared.updateIndexField(eventId: instruments?.id ?? "")
//                                                  }
                                              } else {
                                                  NewRequestHelper.shared.updateIndexField(eventId: self.random(digits: 8))
                                              }
                                              NewScriptHelper.shared.checkIsVisibleEntity(ddcModel: ddcModel)
                                              if (self.navigationController?.topViewController as? DynamiccTemplateViewController) != nil {
                                                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                                  return
                                              }
                                          } catch {
                                              print(error)
                                          }
                                      } catch {
                                          print(error)
                                      }
                            }            } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    ERProgressHud.shared.hide()
                }
            }
        }
        
    
    // save instrument ID to server
    
    func saveInstrumentID (eventId:String, instrumenId:String) {
        
        let saveInstrumentData = [
            "eventId": eventId,
            "instrumentId": instrumenId
          ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: saveInstrumentData, options: JSONSerialization.WritingOptions.prettyPrinted)

        
        BaseAPIManager.sharedInstance.makeRequestToSaveIntrumentID(data:jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)

            } else {
                ERProgressHud.shared.hide()
               
            }
        }
        
    }
    
    
        func getInstrument(instrumentId: String){
            APIManager.sharedInstance.makeRequestToGetInstrument(instrumentId: instrumentId){ (success, response,statusCode)  in
                if (success) {
                    print(response)
                    if let responseData = response as? Dictionary<String, Any> {
                                      var jsonData: Data? = nil
                                      do {
                                          jsonData = try JSONSerialization.data(
                                              withJSONObject: responseData as Any,
                                              options: .prettyPrinted)
                                          do{
                                              let jsonDataModels = try JSONDecoder().decode(Instruments.self, from: jsonData!)
                                              instruments = jsonDataModels
                                              NewScriptHelper.shared.checkIsVisibleEntity(ddcModel: ddcModel)

                                              if (self.navigationController?.topViewController as? DynamiccTemplateViewController) != nil {
                                                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                                  return
                                              }
                                              
                                          } catch {
                                              print(error)
                                          }
                                      } catch {
                                          print(error)
                                      }
                            }            } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    ERProgressHud.shared.hide()
                }
            }
        }
    
    func startSurvey(eventId: String, templateId: String, instrumentId:String) {
        BaseAPIManager.sharedInstance.makeRequestToStartSurveyNew(eventId: eventId){ (success, response,statusCode)  in
            if (success) {
                let newEventId = response["eventId"] as? String ?? ""

                newEventIdStartSurvey = newEventId
                
                if (instrumentId == "") {
                    self.getTemplate(templateId: templateId,eventId: eventId, shouldUpdateIndex: true,newEventId: newEventId, instrumentId: nil)
                } else {
                    print("eventId ", eventId)
                    print("instrumentId ", instrumentId)

                    self.getTemplate(templateId: templateId,eventId: eventId, shouldUpdateIndex: true,newEventId: newEventId, instrumentId: instrumentId)
                }
                
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    func submitSurvey(ddcResponse: NSArray, eventId: String) {
        let observationKey : [String:Any] = ["observations":ddcResponse]
        
        print("newEventId ", newEventIdStartSurvey)

        var parameter : [String:Any] = ["ddcResponse": observationKey, "eventId": newEventIdStartSurvey]
        
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
            parameter["mei"] = retrievedCodableObject.user?.mail
        }
            let jsonData = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)

            BaseAPIManager.sharedInstance.makeRequestToSubmitSurvey(data: jsonData){ (success, response,statusCode)  in
                if (success) {
                    print(response)

                    let banner = NotificationBanner(title: "Success", subtitle: "Survey Submitted successfully.", style: .success)
                    banner.show()
                } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    ERProgressHud.shared.hide()
                }
            }
    }
    
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        self.selectedDate = date
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        for data in eventsData {
            if self.getDateFromString(dateString: data.date) == date {
                print("Has Events on this date")
                print(data)
            }
        }
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()  + 0.1) {
            self.tableView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()  + 0.2) {
            self.tableView.reloadData()
        }
        
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var eventCount = 0
        for data in eventsData {
            if self.getDateFromString(dateString: data.date) == date {
                eventCount += 1
            }
        }
        for data in surveyData {
            if self.getDateFromString(dateString: data.date) == date {
                eventCount += 1
            }
        }
        return eventCount
    }
    
    func getDateFromString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from:dateString)!
    }
    
    // MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        for data in eventsData {
            if self.selectedDate == self.getDateFromString(dateString: data.date) {
                self.tableView.restore()
                count = 1
            }
        }
        for data in surveyData {
            if self.selectedDate == self.getDateFromString(dateString: data.date) {
                self.tableView.restore()
                count += 1
                return count
            }
        }
        if count == 0 {
            self.tableView.setEmptyMessage("No Events for this date.")
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var surveys = [SurveryData]()
        for dataa in surveyData {
            if self.selectedDate == self.getDateFromString(dateString: dataa.date) {
                surveys.append(dataa)
            }
        }
        var events = [DateData]()
        for dataa in eventsData {
            if self.selectedDate == self.getDateFromString(dateString: dataa.date) {
                events.append(dataa)
            }
        }
        
        if surveys.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as! EventsTableViewCell
            cell.dateEvents = events
            cell.layoutSubviews()
            cell.selectionStyle = .none
            cell.nav = self.navigationController
            cell.vc = self
            cell.tableView.reloadData()
            return cell
        } else if events.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveysTableViewCell") as! SurveysTableViewCell
            cell.selectionStyle = .none
            cell.surveys = surveys
            cell.nav = self.navigationController
            cell.vc = self
            cell.delegate = self
            cell.tableView.reloadData()
            return cell
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SurveysTableViewCell") as! SurveysTableViewCell
                cell.selectionStyle = .none
                cell.surveys = surveys
                cell.nav = self.navigationController
                cell.vc = self
                cell.delegate = self
                cell.tableView.reloadData()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as! EventsTableViewCell
                cell.dateEvents = events
                cell.layoutSubviews()
                cell.selectionStyle = .none
                cell.nav = self.navigationController
                cell.vc = self
                cell.tableView.reloadData()
                return cell
            }
        }

    }
    
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var data = eventsData[indexPath.section]
//        for dataa in eventsData {
//            if self.selectedDate == self.getDateFromString(dateString: dataa.date) {
//                data = dataa
//            }
//        }
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.section == 0 {
//            let dayViewController = CalendarViewController()
//            dayViewController.calendarDelegate = self
//            dayViewController.hidesBottomBarWhenPushed = true
//            dayViewController.selectedDate = data.date
//            self.navigationController?.pushViewController(dayViewController, animated: true)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension UIView {

    func dropShadoww(color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25), opacity: Float = 1, offSet: CGSize = CGSize(width: 0, height: 1), radius: CGFloat = 4, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCollectionViewCell", for: indexPath) as! AppCollectionViewCell
        let data = appList[indexPath.item]
        cell.imgView.image = data.image
        cell.imgView.layer.cornerRadius = 25
        cell.mainView.layer.borderWidth = 2
        cell.badgeLabel.isHidden = true
        if indexPath.item == 0 {
            cell.mainView.layer.borderColor = UIColor(red: 0.78, green: 0.44, blue: 0.14, alpha: 1.00).cgColor
        } else {
            cell.mainView.layer.borderColor = DARK_BLUE_COLOR.cgColor
        }
//        cell.badgeLabel.text = data.notificationCount?.description
//        if indexPath.item == 0 || indexPath.item == 1{
//            cell.badgeLabel.isHidden = false
//        }
        cell.badgeLabel.layer.cornerRadius = 7.5
        cell.badgeLabel.layer.masksToBounds = true
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 1 {
            selectedForm = true
            self.tabBarController?.selectedIndex = 2
        } else {
//            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
//            let controller = storyboard.instantiateViewController(identifier: "NotificationVC")
//            controller.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(controller, animated: true)
            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "NotificationVC") as! NotificationVC
            controller.vc = self
            controller.nav = self.navigationController
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 58, height: 58)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
    
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
    }
}
