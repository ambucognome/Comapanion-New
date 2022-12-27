//
//  DashboardViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 22/12/22.
//

import UIKit

var dashboardNav : UINavigationController?

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
        case thirdChildTab = 2
        case fourthChildTab = 3
        case fifthChildTab = 4
    }
    
    var name = ""
    var ezid = ""
    
    lazy var firstChildTabVC : UIViewController? = {
        let firstChildTabVC = UIStoryboard(name: "covidCheck", bundle: nil).instantiateViewController(withIdentifier: "EZLoginViewController") as! EZLoginViewController
        firstChildTabVC.ezId = ezid
        firstChildTabVC.name = name
        let nav = UINavigationController.init(rootViewController: firstChildTabVC)
        return nav
    }()
    
    lazy var secondChildTabVC: UIViewController? = {
        let secondChildTabVC = UIStoryboard(name: "Companion", bundle: nil).instantiateViewController(withIdentifier: "AppOneVC")
        return secondChildTabVC
    }()
    
    lazy var thirdChildTabVC: UIViewController? = {
        let vc = UIStoryboard(name: "Companion", bundle: nil).instantiateViewController(withIdentifier: "AppTwoVC")
        return vc
    }()
    
    lazy var fourthChildTab: UIViewController? = {
        let fourthChildTab = UIStoryboard(name: "Companion", bundle: nil).instantiateViewController(withIdentifier: "AppThreeVC")
        return fourthChildTab
    }()
    
    lazy var fifthChildTab: UIViewController? = {
        let vc = UIStoryboard(name: "Companion", bundle: nil).instantiateViewController(withIdentifier: "AppFourVC")
        return vc
    }()
    
    lazy var sixthChildTab: UIViewController? = {
        let vc = UIStoryboard(name: "Companion", bundle: nil).instantiateViewController(withIdentifier: "AppFiveVC")
        return vc
    }()
    
    var currentViewController: UIViewController?
    var previousViewController: UIViewController?
    
    let DARK_BLUE_COLOR = UIColor(red: 0.07, green: 0.22, blue: 0.40, alpha: 1.00)
    let LIGHT_BLUE_COLOR = UIColor.white
    
    var appList = [AppStruct(name: "SafeCheck", image: nil, notificationCount: 0,isSelected: true),AppStruct(name: "App One", image: nil, notificationCount: 0, isSelected: false),AppStruct(name: "App Two", image: nil, notificationCount: 0,isSelected: false),AppStruct(name: "App Three", image: nil, notificationCount: 0,isSelected: false),AppStruct(name: "App Four", image: nil, notificationCount: 0,isSelected: false),AppStruct(name: "App Five", image: nil, notificationCount: 0,isSelected: false)]
    
    struct AppStruct {
        var name : String
        var image : UIImage?
        var notificationCount : Int?
        var isSelected : Bool
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardNav = self.navigationController
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        DispatchQueue.main.asyncAfter(deadline: .now()  + .milliseconds(1), execute: {
            self.displayCurrentTab(0)
        })
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
        default:
            return nil
        }
        return vc
    }

}

extension DashboardViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCollectionViewCell", for: indexPath) as! AppCollectionViewCell
        let data = self.appList[indexPath.item]
        cell.nameLabel.text = data.name
        if data.isSelected {
            cell.nameLabel.textColor = DARK_BLUE_COLOR
            cell.contentView.backgroundColor = LIGHT_BLUE_COLOR
            cell.contentView.layer.borderWidth = 5
            cell.contentView.layer.borderColor = DARK_BLUE_COLOR.cgColor
        } else {
            cell.nameLabel.textColor = .white
            cell.contentView.backgroundColor = DARK_BLUE_COLOR
            cell.contentView.layer.borderWidth = 0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<self.appList.count {
            self.appList[i].isSelected = false
        }
        self.appList[indexPath.item].isSelected = true
        self.collectionView.reloadData()
        print("selected at", indexPath.item)
        displayCurrentTab(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
    
}
