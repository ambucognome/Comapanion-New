//
//  RejectedListVC.swift
//  Companion
//
//  Created by Ambu Sangoli on 30/10/23.
//

import UIKit

class RejectedListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("reloadLogs"), object: nil)
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.tableView.reloadData()
    }


}

extension RejectedListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return logData?.rejected.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let data = logData?.rejected[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let newDate = dateFormatter.date(from: data?.startTime ?? "")

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let dateString = formatter.string(from: newDate! as Date)
                return dateString
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = logData?.rejected[indexPath.section]
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        cell.eventName.text = data?.caller
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let newDate = dateFormatter.date(from: data?.startTime ?? "")

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let dateString = formatter.string(from: newDate! as Date)
        cell.time.text = dateString
        cell.selectionStyle = .none
        return cell
    }
    

    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = logData?.missed[indexPath.section]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Call \(data?.caller ?? "")", style: .default , handler:{ (UIAlertAction)in
            self.call(email: (data?.callerEmail ?? ""), name: data?.caller ?? "")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @objc func call(email: String, name: String) {
        var dataDic = [String:Any]()
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
             dataDic = [
                "callerEmailId": retrievedCodableObject.user?.mail ?? "",
                "callerName": retrievedCodableObject.user?.firstname ?? "",
                "appId": Bundle.main.bundleIdentifier ?? ""
            ]
        } else if let retrievedCodableObject = SafeCheckUtils.getGuestUserData() {
             dataDic = [
                "callerEmailId": retrievedCodableObject.user.emailID,
                "callerName": retrievedCodableObject.user.username,
                "appId": Bundle.main.bundleIdentifier ?? ""
            ]
        }
        dataDic["calleeEmailId"] = email
        let jsonData = try! JSONSerialization.data(withJSONObject: dataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
        BaseAPIManager.sharedInstance.makeRequestToStartCall(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
                let roomId = response["roomId"] as? String ?? ""
        self.dismiss(animated: false) {
            let storyBoard = UIStoryboard(name: "Companion", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "CallingViewController") as! CallingViewController
            vc.name = name
            vc.roomId = roomId
            vc.opponentEmailId = email
            vc.modalPresentationStyle = .fullScreen
        if let navVC = UIApplication.getTopViewController() {
            navVC.present(vc, animated: true)
        }
        }
        } else {
            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            ERProgressHud.shared.hide()
        }
     }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
