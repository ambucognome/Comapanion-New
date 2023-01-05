//
//  MenuViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 22/12/22.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var cellNames = ["My Profile", "Settings","Register","Request App", "Log out"]

    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameLabel.text = username
        tableView.layer.cornerRadius = 25
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.layer.masksToBounds = false
        tableView.layer.shadowRadius = 5
        tableView.layer.shadowOpacity = 1
        tableView.layer.shadowOffset = CGSize(width: -5, height: -5)
        tableView.layer.shadowColor = UIColor.white.cgColor
        
    }
    
    //TabelViewDelegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  cellNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = cellNames[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        cell.textLabel?.textColor = DARK_BLUE_COLOR
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            LogoutHelper.shared.logout()
        }
    }

}
