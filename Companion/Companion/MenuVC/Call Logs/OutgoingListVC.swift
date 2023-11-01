//
//  OutgoingListVC.swift
//  Companion
//
//  Created by Ambu Sangoli on 30/10/23.
//

import UIKit

class OutgoingListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("reloadLogs"), object: nil)
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.tableView.reloadData()
    }


}

extension OutgoingListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return logData?.outgoing.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let data = logData?.outgoing[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let newDate = dateFormatter.date(from: data?.startTime ?? "")

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let dateString = formatter.string(from: newDate! as Date)
                return dateString
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = logData?.outgoing[indexPath.section]
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        cell.eventName.text = data?.callee
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let newDate = dateFormatter.date(from: data?.startTime ?? "")

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let dateString = formatter.string(from: newDate! as Date)
        cell.time.text = dateString
        cell.selectionStyle = .none
        cell.durationLabel.text = "Duration: \(data!.duration) mins"
        cell.hostLabel.text = ""
        cell.selectionStyle = .none
        return cell
    }
    

    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
