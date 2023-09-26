//
//  DashboardViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 22/12/22.
//

import UIKit
import SideMenu

let DARK_BLUE_COLOR = UIColor(red: 0.07, green: 0.22, blue: 0.40, alpha: 1.00)

//var appList = [AppStruct(name: "SafeCheck", image: nil, notificationCount: 0,isSelected: true),
//               AppStruct(name: "Registration", image: nil, notificationCount: 0, isSelected: false),
//               AppStruct(name: "Report", image: nil, notificationCount: 0,isSelected: false),
//               AppStruct(name: "Screening", image: nil, notificationCount: 0,isSelected: false),
//               AppStruct(name: "Basic", image: nil, notificationCount: 0,isSelected: false),
////               AppStruct(name: "Repeatable", image: nil, notificationCount: 0,isSelected: false),
//               AppStruct(name: "All component", image: nil, notificationCount: 0,isSelected: false)]

struct AppStruct {
    var name : String
    var image : UIImage?
    var notificationCount : Int?
    var isSelected : Bool
}

var selectedForm = false


var dashboardNav : UINavigationController?

class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!

    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
        case thirdChildTab = 2
        case fourthChildTab = 3
        case fifthChildTab = 4
        case sixthChildTab = 5
//        case seventhChildTab = 6
    }
    
//    var name = ""
//    var ezid = ""
    
    lazy var firstChildTabVC : UIViewController? = {
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
    
    lazy var secondChildTabVC: UIViewController? = {
        let secondChildTabVC = UIStoryboard(name: "covidCheck", bundle: nil).instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        secondChildTabVC.template_uri = "http://chdi.montefiore.org/newPatientRegistration"
        secondChildTabVC.isDemo = true
        secondChildTabVC.key = "102"
        let nav = UINavigationController.init(rootViewController: secondChildTabVC)
        return nav
    }()
    
    lazy var thirdChildTabVC: UIViewController? = {
        let vc = UIStoryboard(name: "covidCheck", bundle: nil).instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        vc.template_uri = "http://chdi.montefiore.org/newpatientreport"
        vc.isDemo = true
        vc.key = "102"
        let nav = UINavigationController.init(rootViewController: vc)
        return nav
    }()
    
    lazy var fourthChildTab: UIViewController? = {
        let fourthChildTab = UIStoryboard(name: "covidCheck", bundle: nil).instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        fourthChildTab.template_uri = "http://chdi.montefiore.org/screening"
        fourthChildTab.isDemo = true
        fourthChildTab.key = "102"
        let nav = UINavigationController.init(rootViewController: fourthChildTab)
        return nav
    }()
    
    lazy var fifthChildTab: UIViewController? = {
        let vc =  UIStoryboard(name: "covidCheck", bundle: nil).instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        vc.template_uri = "http://chdi.montefiore.org/basicComponents"
        vc.isDemo = true
        vc.key = "102"
        let nav = UINavigationController.init(rootViewController: vc)
        return nav
    }()
    
    lazy var sixthChildTab: UIViewController? = {
        let vc =  UIStoryboard(name: "covidCheck", bundle: nil).instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        vc.template_uri = "http://chdi.montefiore.org/allComponents" //"http://chdi.montefiore.org/blueprintWithRepeatable"
        vc.isDemo = true
        vc.key = "102"
        let nav = UINavigationController.init(rootViewController: vc)
        return nav
    }()
    
    lazy var seventhChildTab: UIViewController? = {
        let vc =  UIStoryboard(name: "covidCheck", bundle: nil).instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        vc.template_uri = "http://chdi.montefiore.org/allComponents"
        vc.isDemo = true
        vc.key = "102"
        let nav = UINavigationController.init(rootViewController: vc)
        return nav
    }()
    
    var currentViewController: UIViewController?
    var previousViewController: UIViewController?
    
    let LIGHT_BLUE_COLOR = UIColor.white
    
var formLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageLabel.text = message
        navigationItem.largeTitleDisplayMode = .never
        dashboardNav = self.navigationController
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        self.containerView.isHidden = true
        if selectedForm {
            DispatchQueue.main.asyncAfter(deadline: .now()  + .milliseconds(1), execute: {
                self.containerView.isHidden = false
            self.displayCurrentTab(0)
                self.formLoaded = true
            })
        }
        self.navigationItem.setHidesBackButton(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showHideReelSection(notification:)), name: Notification.Name("ReelSectionID"), object: nil)
        self.navigationItem.title = "SafeCheck"
//        let btnLeftMenu: UIButton = UIButton()
//        let image = UIImage(named: "menu");
//        btnLeftMenu.setImage(image, for: .normal)
//        btnLeftMenu.frame =  CGRect(x:0, y:0, width: 25, height:25)
//        btnLeftMenu.addTarget(self, action: #selector (menu), for: .touchUpInside)
//        btnLeftMenu.imageEdgeInsets = UIEdgeInsets(top: 10 , left: 10, bottom: 10, right: 10)
//        let barButton = UIBarButtonItem(customView: btnLeftMenu)
//        self.navigationItem.rightBarButtonItem = barButton
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selectedForm && (formLoaded == false){
            DispatchQueue.main.asyncAfter(deadline: .now()  + .milliseconds(1), execute: {
                self.containerView.isHidden = false
            self.displayCurrentTab(0)
                self.formLoaded = true
            })
        }
    }
    
    @objc func menu() {
        let vc = UIStoryboard(name: "Companion", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController")
        let menu = SideMenuNavigationController(rootViewController: vc)
        present(menu, animated: true, completion: nil)
    }
    
    @objc func showHideReelSection(notification: Notification) {
//        let userInfo = notification.userInfo
//        if let isHide = userInfo!["hide"] as? Bool {
//            if isHide {
//                self.collectionViewHeight.constant = 0
//                UIView.animate(withDuration: 0.2, animations: {
//                     self.view.layoutIfNeeded()
//                })
//            } else {
//                self.collectionViewHeight.constant = 90
//                UIView.animate(withDuration: 0.2, animations: {
//                     self.view.layoutIfNeeded()
//                })
//            }
//        }
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedTab(tabIndex) {
            self.addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = self.containerView.bounds
            self.containerView.subviews.forEach({ $0.removeFromSuperview() })
            self.containerView.addSubview(vc.view)
        }
    }

    func viewControllerForSelectedTab(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.firstChildTab.rawValue :
            vc = firstChildTabVC
        case TabIndex.secondChildTab.rawValue :
            vc = secondChildTabVC
        case TabIndex.thirdChildTab.rawValue :
            vc = thirdChildTabVC
        case TabIndex.fourthChildTab.rawValue :
            vc = fourthChildTab
        case TabIndex.fifthChildTab.rawValue :
            vc = fifthChildTab
        case TabIndex.sixthChildTab.rawValue :
            vc = sixthChildTab
//        case TabIndex.seventhChildTab.rawValue :
//            vc = seventhChildTab
        default:
            return nil
        }
        return vc
    }

}

extension DashboardViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        cell.badgeLabel.text = data.notificationCount?.description
        cell.badgeLabel.layer.cornerRadius = 7.5
        cell.badgeLabel.layer.masksToBounds = true
//        cell.mainView.bringSubviewToFront(cell.badgeLabel)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 1 {
            selectedForm = true
            self.containerView.isHidden = false
            self.displayCurrentTab(0)
        } else {
//            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
//            let controller = storyboard.instantiateViewController(identifier: "NotificationVC")
//            controller.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(controller, animated: true)
            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "NotificationVC") as! NotificationVC
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
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCollectionViewCell", for: indexPath) as! AppCollectionViewCell
//        let data = appList[indexPath.item]
//        cell.nameLabel.text = data.name
//        if data.isSelected {
//            cell.nameLabel.textColor = DARK_BLUE_COLOR
//            cell.contentView.backgroundColor = LIGHT_BLUE_COLOR
//            cell.contentView.layer.borderWidth = 5
//            cell.contentView.layer.borderColor = DARK_BLUE_COLOR.cgColor
//        } else {
//            cell.nameLabel.textColor = .white
//            cell.contentView.backgroundColor = DARK_BLUE_COLOR
//            cell.contentView.layer.borderWidth = 0
//            cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        }
//        return cell
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        for i in 0..<appList.count {
//            appList[i].isSelected = false
//        }
//        appList[indexPath.item].isSelected = true
//        self.collectionView.reloadData()
//        print("selected at", indexPath.item)
//        displayCurrentTab(indexPath.item)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return appList.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 80, height: 80)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
    
    
    
    
}
