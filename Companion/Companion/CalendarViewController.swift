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
            
            let duration = Int.random(in: 30...120)
            event.dateInterval = DateInterval(start: workingDate, duration: TimeInterval(duration * 60))
            event.text = "\(data.time) - \(data.name)"
            event.color = DARK_BLUE_COLOR
            event.isAllDay = false
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
