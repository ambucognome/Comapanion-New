//
//  CallLogViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 30/10/23.
//

import UIKit

var logData : CallLogModel?

class CallLogViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var vc : HomeViewController?
    var nav: UINavigationController?
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
        case thirdChildTab = 2
        case fourthChildTab = 3
    }
    
    let historyBtn = UIButton()
    
    var currentViewController: UIViewController?
    var previousViewController: UIViewController?
    
    lazy var firstChildTabVC : UIViewController? = {
        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
        let firstChildTabVC = storyboard.instantiateViewController(withIdentifier: "IncomingListVC") as! IncomingListVC
        return firstChildTabVC
    }()
    lazy var secondChildTabVC: UIViewController? = {
        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
        let secondChildTabVC = storyboard.instantiateViewController(withIdentifier: "OutgoingListVC") as! OutgoingListVC
        return secondChildTabVC
    }()
    lazy var thirdChildTabVC : UIViewController? = {
        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
        let firstChildTabVC = storyboard.instantiateViewController(withIdentifier: "MissedListVC") as! MissedListVC
        return firstChildTabVC
    }()
    lazy var fourthChildTabVC: UIViewController? = {
        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
        let secondChildTabVC = storyboard.instantiateViewController(withIdentifier: "RejectedListVC") as! RejectedListVC
        return secondChildTabVC
    }()
    
    var fetchLogDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchLogDate = SafeCheckUtils.addOrSubtractMonth(month: -1)
        self.getCallLogs()
        self.title = "Call Logs"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: DARK_BLUE_COLOR]
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)


        DispatchQueue.main.asyncAfter(deadline: .now()  + .milliseconds(1), execute: {
            self.displayCurrentTab(0)
        })
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("loadmore"), object: nil)

    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
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
    
    func getCallLogs(){
        
        ERProgressHud.shared.show()
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd'T'hh:mm:ss.SSS"
        let dateString = formatter.string(from: self.fetchLogDate.zeroTime!)
        
        var parameters : [String: String] = [
            "endDate": dateString]
        
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
            parameters["meiID"] = retrievedCodableObject.user?.mail
        }
        
        if let retrievedCodableObject = SafeCheckUtils.getGuestUserData() {
            parameters["meiID"] = retrievedCodableObject.user.emailID
        }
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        BaseAPIManager.sharedInstance.makeRequestToGetCallLogs(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
                if let responseData = response as? Dictionary<String, Any> {
                  var jsonData: Data? = nil
                  do {
                      jsonData = try JSONSerialization.data(
                          withJSONObject: responseData as Any,
                          options: .prettyPrinted)
                      do{
                          let jsonDataModels = try JSONDecoder().decode(CallLogModel.self, from: jsonData!)
                          print(jsonDataModels)
                          logData = jsonDataModels
                          NotificationCenter.default.post(name: Notification.Name("reloadLogs"), object: nil)

                      } catch {
                          print(error)
                      }
                  } catch {
                      print(error)
                  }
        }
                               
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            }
        }
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
        case TabIndex.thirdChildTab.rawValue :
            vc = thirdChildTabVC
        case TabIndex.fourthChildTab.rawValue :
            vc = fourthChildTabVC
        default:
            return nil
        }
        return vc
    }

    
}

extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = style
    return formatter.string(from: self) ?? ""
  }
}
