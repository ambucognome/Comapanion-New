//
//  CalendarViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 14/03/23.
//

import UIKit
import CalendarKit

class CalendarViewController: DayViewController {
    
    
    var generatedEvents = [EventDescriptor]()
    var alreadyGeneratedSet = Set<Date>()
    
    var colors = [DARK_BLUE_COLOR]

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
        if let eventData = descriptor.userInfo as? EventStruct {
        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "EventDetailVC") as! EventDetailVC
        controller.eventData = eventData
//        let nav = UINavigationController(rootViewController: controller)
        let sheetController = SheetViewController(
            controller: controller,
            sizes: [.intrinsic],options: options)
        sheetController.gripSize = CGSize(width: 50, height: 3)
        sheetController.gripColor = UIColor(white: 96.0 / 255.0, alpha: 1.0)
        self.present(sheetController, animated: true, completion: nil)
        }
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
      guard let descriptor = eventView.descriptor as? Event else {
        return
      }
      endEventEditing()
      print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
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
