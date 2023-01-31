//
//  SettingsViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 31/01/23.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!
    
    
    var models = [Section]()


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
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
    
    func configure() {
        //MARK: SWİTCH
        models.append(Section(title: "Account", options: [
            .staticCell(model: SettingsOption(title: "Two-Step Verification", icon: UIImage(systemName: "hand.raised"), iconBackgroundColor: .systemBlue, handler: {
                //Switch action code is here
            }))
        ]))
        
        //MARK: SECTION ONE
        models.append(Section(title: "Privacy", options: [
            .staticCell(model: SettingsOption(title: "App Lock", icon: UIImage(systemName: "faceid"), iconBackgroundColor: .systemGreen, handler: {
                //Hücrenin yapacağı işlev buraya ...
            }))
        ]))
        
        models.append(Section(title: "Notifications", options: [
            .staticCell(model: SettingsOption(title: "Push Notifications", icon: UIImage(systemName: "bell.and.waveform"), iconBackgroundColor: .systemBlue, handler: {
                //Switch action code is here
            }))
        ]))

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(item: 0, section: 0) {
            let vc = UIStoryboard(name: "Companion", bundle: nil).instantiateViewController(withIdentifier: "TwoFactorAuthVC") as! TwoFactorAuthVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath == IndexPath(item: 0, section: 1) {
            let vc = UIStoryboard(name: "Companion", bundle: nil).instantiateViewController(withIdentifier: "AppLockViewController") as! AppLockViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath == IndexPath(item: 0, section: 2) {
            let vc = UIStoryboard(name: "Companion", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
            return 0.0
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
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }


}
