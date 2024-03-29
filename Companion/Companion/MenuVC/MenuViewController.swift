//
//  MenuViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 22/12/22.
//

import UIKit
var username = ""

class MenuViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var cellNames = ["Connect", "My Profile", "Settings","Register","Request App", "Log out"]

    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var tableView : UITableView!
    
    
    var models = [Section]()


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        self.configure()
        //KARNA
        self.nameLabel.text = username
        tableView.layer.cornerRadius = 25
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.layer.masksToBounds = false
        tableView.layer.shadowRadius = 5
        tableView.layer.shadowOpacity = 1
        tableView.layer.shadowOffset = CGSize(width: -5, height: -5)
        tableView.layer.shadowColor = UIColor.white.cgColor
        tableView.register(SettingTableViewCell.self,
                       forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.register(SwitchTableViewCell.self,
                       forCellReuseIdentifier: SwitchTableViewCell.identifier)

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = UIStoryboard(name: "Companion", bundle: nil).instantiateViewController(withIdentifier: "GridViewController") as! GridViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 1 {
            let vc = UIStoryboard(name: "Companion", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 2 {
            let vc = UIStoryboard(name: "Companion", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            self.navigationController?.pushViewController(vc, animated: true)

        }
        if indexPath.row == 5 {
            LogoutHelper.shared.logout()
        }
    }
    
    func configure() {

        
        //MARK: SECTION ONE
        models.append(Section(title: "", options: [
            .staticCell(model: SettingsOption(title: "Connect", icon: UIImage(named:  "connect"), iconBackgroundColor: .clear, handler: {
                //Switch action code is here
            })),
            .staticCell(model: SettingsOption(title: "My Profile", icon: UIImage(named: "profile"), iconBackgroundColor: .clear, handler: {
            })),
            .staticCell(model: SettingsOption(title: "Settings", icon: UIImage(named: "settings"), iconBackgroundColor: .clear, handler: {
//                let nav = UINavigationController(rootViewController: vc)
                
            })),
            .staticCell(model: SettingsOption(title: "Register", icon: UIImage(named: "register"), iconBackgroundColor: .clear, handler: {
                //Hücrenin yapacağı işlev buraya ...
            })),
            .staticCell(model: SettingsOption(title: "Request App", icon: UIImage(named: "request"), iconBackgroundColor: .clear, handler: {
                //Hücrenin yapacağı işlev buraya ...
            })),
            .staticCell(model: SettingsOption(title: "Logout", icon: UIImage(named: "logout"), iconBackgroundColor: .clear, handler: {
                //Hücrenin yapacağı işlev buraya ...
            }, disclosureRequired : false))
        ]))

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
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
            cell.selectionStyle = .none
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            cell.selectionStyle = .none
            return cell
        }
    }


}
