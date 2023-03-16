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
    var events : [EventStruct]
    var careTeam : [CareTeam]
}

struct EventStruct {
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



//MARK: Add events data here
let eventsData : [DateData] = [
    DateData(date: "14/03/2023", events: [EventStruct(name: "Daily check", time: "10:30 AM")], careTeam: [CareTeam(image: "profile1", name: "Dr.Randy Wigham", specality: "Dentist", lastVisitDate: "Last visit : April 20 2022")]),
    
    DateData(date: "15/03/2023", events: [
        EventStruct(name: "Respiratory therapy home visit", time: "10:45 AM"),
        EventStruct(name: "Daily Check", time: "1:00 PM"),
        EventStruct(name: "Telehealth cardiology appointment", time: "5:00 PM")
    ], careTeam: [CareTeam(image: "profile1", name: "Hugo Franco", specality: "Cardiologist", lastVisitDate: "Last visit : May 20 2022"),
                  CareTeam(image: "profile2", name: "Cora Barber", specality: "Dentist", lastVisitDate: "Last visit : April 23 2022")]),
    
    DateData(date: "25/03/2023", events: [EventStruct(name: "Daily check", time: "10:45 AM")], careTeam: [CareTeam(image: "profile1", name: "Jazmin Chang", specality: "Orthopedic", lastVisitDate: "Last visit : June 20 2022")])]

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
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
    
    let appList = [AppStruct(name: "", image: UIImage(named: "calen"), notificationCount: 3,isSelected: false),
                   AppStruct(name: "", image: UIImage(named: "careteam"), notificationCount: 1, isSelected: false),
                   AppStruct(name: "Safecheck", image: UIImage(named: "form"), notificationCount: 0, isSelected: false)]

    
    var selectedDate = Date()
    let btnLeftMenu: UIButton = UIButton()

    
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
        btnLeftMenu.setImage(UIImage(named:  "calendar_tab"), for: .normal)
        btnLeftMenu.addTarget(self, action: #selector (menu), for: .touchUpInside)
        btnLeftMenu.frame.size = CGSize(width:25, height: 25)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.rightBarButtonItem = barButton
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        self.selectedDate = self.getDateFromString(dateString: "14/03/2023")
        self.tableView.reloadData()
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        navigationController?.navigationBar.isTranslucent = false
        self.containerView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func menu() {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
            btnLeftMenu.setImage(UIImage(named:  "calendar_tab"), for: .normal)
        } else {
            self.calendar.setScope(.month, animated: true)
            btnLeftMenu.setImage(UIImage(named:  "vertical"), for: .normal)
        }
    }
    
    deinit {
        print("\(#function)")
    }
    
    lazy var safeCheckVC : UIViewController? = {
        if isFromLogin {
            let firstChildTabVC = UIStoryboard(name: "covidCheck", bundle: nil).instantiateViewController(withIdentifier: "EZLoginViewController") as! EZLoginViewController
            firstChildTabVC.ezId = ezid
            firstChildTabVC.name = name
            let nav = UINavigationController.init(rootViewController: firstChildTabVC)
            return nav
        }
        let storyboard = UIStoryboard(name: "covidCheck", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        let nav = UINavigationController.init(rootViewController: vc)
        return nav
    }()
    
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
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CareTeamTableViewCell") as! CareTeamTableViewCell
            cell.careTeamData = data.careTeam
            cell.tableView.reloadData()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data = eventsData[indexPath.section]
        for dataa in eventsData {
            if self.selectedDate == self.getDateFromString(dateString: dataa.date) {
                data = dataa
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let dayViewController = CalendarViewController()
            dayViewController.hidesBottomBarWhenPushed = true
            dayViewController.selectedDate = data.date
            self.navigationController?.pushViewController(dayViewController, animated: true)
        }
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
        let data = self.appList[indexPath.item]
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
        if indexPath.item == 2 {
            if let vc = self.safeCheckVC {
                self.addChild(vc)
                vc.didMove(toParent: self)
                vc.view.frame = self.containerView.bounds
                self.containerView.isHidden = false
                self.containerView.subviews.forEach({ $0.removeFromSuperview() })
                self.containerView.addSubview(vc.view)
            }
        } else {
            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "NotificationVC")
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

