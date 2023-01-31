//
//  NotificationsViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 31/01/23.
//

import UIKit

var allNotification = true

class NotificationsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!
    
    
    var models = [Section]()


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notifications"
        self.configure()
        tableView.register(SettingTableViewCell.self,
                       forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.register(SwitchTableViewCell.self,
                       forCellReuseIdentifier: SwitchTableViewCell.identifier)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always

    }
    
    var appList = [AppStruct(name: "SafeCheck", image: nil, notificationCount: 0,isSelected: false),AppStruct(name: "Basic", image: nil, notificationCount: 0, isSelected: false),AppStruct(name: "Repeatable", image: nil, notificationCount: 0,isSelected: false),AppStruct(name: "Repeatable 2", image: nil, notificationCount: 0,isSelected: false),AppStruct(name: "App Four", image: nil, notificationCount: 0,isSelected: false),AppStruct(name: "App Five", image: nil, notificationCount: 0,isSelected: false)]

    struct AppStruct {
        var name : String
        var image : UIImage?
        var notificationCount : Int?
        var isSelected : Bool
    }
    
    func configure() {
        //MARK: SWİTCH
        models.append(Section(title: "When disabled, you'll not receive any notifications from cognome", options: [
            .switchCell(model: SettingsSwitchOption(title: "All Notifications", icon: nil, iconBackgroundColor: .clear, handler: {

            }, isOn: allNotification))
        ]))
        
        var options = [SettingsOptionType]()
        for app in appList {
            let option =  SettingsOptionType.switchCell(model: SettingsSwitchOption(title: app.name, icon: nil, iconBackgroundColor: .clear, handler: {
                
            }, isOn: true))
            options.append(option)

        }

            models.append(Section(title: "You can enable/disable App Based specific notification", options:options))
        

    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let data = models[section]
        let label = EdgeInsetLabel()
        label.numberOfLines = 0
        label.text = data.title
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            label.textInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return UITableView.automaticDimension
      }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if allNotification {
            return models.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTableViewCell.identifier,
                for: indexPath
            ) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            if indexPath.section == 0 {
            cell.mySwitch.addTarget(self, action: #selector(self.switchValueDidChange(sender:)), for: .valueChanged)
            } else {
                cell.mySwitch.removeTarget(self, action: #selector(self.switchValueDidChange(sender:)), for: .valueChanged)
            }
            return cell
        }
    }
    
    @objc func switchValueDidChange(sender:UISwitch!)
    {
        allNotification = sender.isOn
        let data = Section(title: "When disabled, you'll not receive any notifications from cognome", options: [
            .switchCell(model: SettingsSwitchOption(title: "All Notifications", icon: nil, iconBackgroundColor: .clear, handler: {

            }, isOn: allNotification))
        ])
        self.models[0] = data
        
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = EdgeInsetLabel()

        if (section == 0){
            if models.count > 1 {
            label.numberOfLines = 0
            label.text = "You can enable/disable App Based specific notification"
            label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            label.textInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if (section == 0) {
//            return 60.0
//        } else {
            return 0.0
//        }
    }

}
