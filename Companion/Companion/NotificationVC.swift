//
//  NotificationVC.swift
//  Companion
//
//  Created by Ambu Sangoli on 21/09/23.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var vc : HomeViewController?
    var nav: UINavigationController?
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }
    
    let historyBtn = UIButton()
    
    var currentViewController: UIViewController?
    var previousViewController: UIViewController?
    
    lazy var firstChildTabVC : UIViewController? = {
        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
        let firstChildTabVC = storyboard.instantiateViewController(withIdentifier: "EventListVC") as! EventListVC
        firstChildTabVC.vc = self.vc
        return firstChildTabVC
    }()
    lazy var secondChildTabVC: UIViewController? = {
        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
        let secondChildTabVC = storyboard.instantiateViewController(withIdentifier: "SurveyListVC") as! SurveyListVC
        secondChildTabVC.nav = self.nav
        return secondChildTabVC
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notifications"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: DARK_BLUE_COLOR]
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)


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

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    //Select and display view According to index of collectionView
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedTab(tabIndex) {
            self.addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = self.contentView.bounds
            self.contentView.subviews.forEach({ $0.removeFromSuperview() })
            self.contentView.addSubview(vc.view)
        }
    }
    
    func viewControllerForSelectedTab(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.firstChildTab.rawValue :
            vc = firstChildTabVC
        case TabIndex.secondChildTab.rawValue :
            vc = secondChildTabVC
        default:
            return nil
        }
        return vc
    }

    
}
