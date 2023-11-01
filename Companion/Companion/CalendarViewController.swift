//
//  CalendarViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 14/03/23.
//

import UIKit
import CalendarKit

protocol  CalendarViewControllerDelegate {
    func didUpdateEvent(eventData: NSArray, eventId: String)
    func didDeleteEvent(eventId: String)
}
//KARNA
class CalendarViewController: DayViewController, DynamicTemplateViewControllerDelegate {
    
    var template_uri = "http://chdi.montefiore.org/calendarEvent"

    
    var generatedEvents = [EventDescriptor]()
    var alreadyGeneratedSet = Set<Date>()
    
    var colors = [DARK_BLUE_COLOR]
    
    var calendarDelegate: CalendarViewControllerDelegate?

    private lazy var dateIntervalFormatter: DateIntervalFormatter = {
      let dateIntervalFormatter = DateIntervalFormatter()
      dateIntervalFormatter.dateStyle = .none
      dateIntervalFormatter.timeStyle = .short

      return dateIntervalFormatter
    }()

    override func loadView() {
      dayView = DayView(calendar: calendar)
      view = dayView
    }
    
    var selectedDate = ""
    
    override func viewDidLoad() {
      super.viewDidLoad()
        self.navigationItem.title = "Events"
        dayView.autoScrollToFirstEvent = true
        self.view.backgroundColor = .white
        self.dayView.move(to: self.getDateFromString(dateString: selectedDate))
      reloadData()
    }
    
    // MARK: EventDataSource
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
      if !alreadyGeneratedSet.contains(date) {
        alreadyGeneratedSet.insert(date)
          for data in eventsData {
              if date == self.getDateFromString(dateString: data.date) {
                  print("for this data event are there")
                  self.generatedEvents.append(contentsOf: self.generateEvent(date: date, eventData: data.events, dateString: data.date))
              }
          }
      }
        
      return self.generatedEvents
    }
    var selectedEventId = ""
    
    func didSubmitSurvey(params: [String : Any]) {
        print("survey completed")
//        self.navigationController?.popViewController(completion: {
//            self.calendarDelegate?.didUpdateEvent(eventData: params,eventId: self.selectedEventId)
//        })
        
    }
    
    func didSubmitSurveyForm(response: NSArray, eventId: String) {
        print("didSubmitSurveyForm")
    }
    
    func didSubmitEventForm(response: NSArray) {
        print("didSubmitEventForm")
        self.calendarDelegate?.didUpdateEvent(eventData: response, eventId: self.selectedEventId)
        self.navigationController?.popViewController(animated: true)
    }
    
    func getDateFromString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from:dateString)!
    }
    
    func generateEvent(date: Date, eventData: [EventStruct],dateString:String) -> [EventDescriptor] {
        var events = [Event]()
        for data in eventData {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
            let eventDate = dateFormatter.date(from: "\(dateString) \(data.time)")!
            
            let hour = Calendar.current.component(.hour, from: eventDate)
            let minutes = Calendar.current.component(.minute, from: eventDate)

            
            let event = Event()
            var workingDate = Calendar.current.date(byAdding: .hour, value: hour, to: date)!
            workingDate = Calendar.current.date(byAdding: .minute, value: minutes, to: workingDate)!
            
            let duration = Int(data.duration) ?? 30
            event.dateInterval = DateInterval(start: workingDate, duration: TimeInterval(duration * 60))
            event.text = "\(data.time) - \(data.name) : \(data.description)"
            event.color = DARK_BLUE_COLOR
            event.isAllDay = false
            event.userInfo = data
            events.append(event)
        }
        return events
    }
    

    
    // MARK: DayViewDelegate
    
    
    private var createdEvent: EventDescriptor?
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
      guard let descriptor = eventView.descriptor as? Event else {
        return
      }
      print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
        if let data = descriptor.userInfo as? EventStruct {
            if data.parentId != nil {
                let storyboard = UIStoryboard(name: "Companion", bundle: nil)
                let controller = storyboard.instantiateViewController(identifier: "EventDetailVC") as! EventDetailVC
                controller.eventData = data
        //        let nav = UINavigationController(rootViewController: controller)
                let sheetController = SheetViewController(
                    controller: controller,
                    sizes: [.marginFromTop(40)],options: options)
                sheetController.gripSize = CGSize(width: 50, height: 3)
                sheetController.gripColor = UIColor(white: 96.0 / 255.0, alpha: 1.0)
                self.present(sheetController, animated: true, completion: nil)
                return
            }
        }

        let alert = UIAlertController(title: nil, message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "View", style: .default , handler:{ (UIAlertAction)in
            if let eventData = descriptor.userInfo as? EventStruct {
            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "EventDetailVC") as! EventDetailVC
            controller.eventData = eventData
    //        let nav = UINavigationController(rootViewController: controller)
            let sheetController = SheetViewController(
                controller: controller,
                sizes: [.marginFromTop(40)],options: options)
            sheetController.gripSize = CGSize(width: 50, height: 3)
            sheetController.gripColor = UIColor(white: 96.0 / 255.0, alpha: 1.0)
            self.present(sheetController, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
            if let data = descriptor.userInfo as? EventStruct {
                self.selectedEventId = data.eventId
                self.getTempleWith(templateId: data.templateId, instrumentId: data.instrumentId)
            }
        }))
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            if let data = descriptor.userInfo as? EventStruct {
                self.calendarDelegate?.didDeleteEvent(eventId: data.eventId)
                self.navigationController?.popViewController(animated: true)
            }

        })
        alert.addAction(deleteAction)

        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
      guard let descriptor = eventView.descriptor as? Event else {
        return
      }
      endEventEditing()
      print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    func getTempleWith(templateId: String, instrumentId: String) {
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
                                          self.getInstrument(instrumentId: instrumentId)
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
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
      endEventEditing()
      print("Did Tap at date: \(date)")
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
      endEventEditing()
      print("DayView did begin dragging")
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
      print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
      print("DayView = \(dayView) did move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
      print("Did long press timeline at date \(date)")
      endEventEditing()
    }
    
 
    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
      print("did finish editing \(event)")
      print("new startDate: \(event.dateInterval.start) new endDate: \(event.dateInterval.end)")
      
    }
  }

extension CalendarViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        cell.badgeLabel.text = data.notificationCount?.description
        if indexPath.item == 0 || indexPath.item == 1{
            cell.badgeLabel.isHidden = false
        }
        cell.badgeLabel.layer.cornerRadius = 7.5
        cell.badgeLabel.layer.masksToBounds = true
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.item == 2 {
//            if let vc = self.safeCheckVC {
//                self.addChild(vc)
//                vc.didMove(toParent: self)
//                vc.view.frame = self.containerView.bounds
//                self.containerView.isHidden = false
//                self.containerView.subviews.forEach({ $0.removeFromSuperview() })
//                self.containerView.addSubview(vc.view)
//            }
//        } else {
//            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
//            let controller = storyboard.instantiateViewController(identifier: "NotificationVC")
//            controller.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
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
