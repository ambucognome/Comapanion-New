//
//  HomeViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 11/03/23.
//

import UIKit

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
    var events : [Event]
    var careTeam : [CareTeam]
}

struct Event {
    var name : String
    var time : String
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
}

let eventsData : [DateData] = [
    DateData(date: "14/03/2023", events: [Event(name: "Daily check", time: "10:45 AM")], careTeam: [CareTeam(image: "profile1", name: "Dr.Randy Wigham", specality: "Dentist", lastVisitDate: "Last visit : April 20 2022")]),
    DateData(date: "15/03/2023", events: [
        Event(name: "Respiratory therapy home visit", time: "10:45 AM"),
        Event(name: "Daily Check", time: "11:45 AM"),
        Event(name: "Telehealth cardiology appointment", time: "4:00 PM")
    ], careTeam: [CareTeam(image: "profile1", name: "Hugo Franco", specality: "Cardiologist", lastVisitDate: "Last visit : May 20 2022"),
                  CareTeam(image: "profile2", name: "Cora Barber", specality: "Dentist", lastVisitDate: "Last visit : April 23 2022")]),
    DateData(date: "25/03/2023", events: [Event(name: "Daily check", time: "10:45 AM")], careTeam: [CareTeam(image: "", name: "Jazmin Chang", specality: "Orthopedic", lastVisitDate: "Last visit : June 20 2022")])]

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        self.navigationItem.title = "Home"
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setTitle("Toggle", for: .normal)
        btnLeftMenu.setTitleColor(.blue, for: .normal)
        btnLeftMenu.addTarget(self, action: #selector (menu), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.rightBarButtonItem = barButton
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
    }
    
    @objc func menu() {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        } else {
            self.calendar.setScope(.month, animated: true)
        }
    }
    
    deinit {
        print("\(#function)")
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
//        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
//        print("selected dates is \(selectedDates)")
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
        for data in eventsData {
            if self.getDateFromString(dateString: data.date) == date {
                return data.events.count
            }
        }
        return 0
    }
    
    func getDateFromString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from:dateString)!
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        for data in eventsData {
            if self.selectedDate == self.getDateFromString(dateString: data.date) {
                return 2
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var data = eventsData[indexPath.section]
        for dataa in eventsData {
            if self.selectedDate == self.getDateFromString(dateString: dataa.date) {
                data = dataa
            }
        }
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell") as! EventsTableViewCell
            cell.eventData = data.events
            cell.tableView.reloadData()
            cell.layoutSubviews()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CareTeamTableViewCell") as! CareTeamTableViewCell
            cell.careTeamData = data.careTeam
            cell.tableView.reloadData()
            return cell
        }
    }
    
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
