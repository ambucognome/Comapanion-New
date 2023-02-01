//
//  AppLockViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 31/01/23.
//

import UIKit

var isFacIdOn = true

class AppLockViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!
    
    
    var models = [Section]()


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "App Lock"
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
            models.append(Section(title: " ", options: [
                .switchCell(model: SettingsSwitchOption(title: "Require Face ID", icon: nil, iconBackgroundColor: .clear, handler: {
//                    isFacIdOn =
                    print("yes")
                }, isOn: isFacIdOn))
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
            cell.mySwitch.addTarget(self, action: #selector(self.switchValueDidChange(sender:)), for: .valueChanged)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @objc func switchValueDidChange(sender:UISwitch!)
    {
        isFacIdOn = sender.isOn
        if (sender.isOn == true){
            print("on")
        }
        else{
            print("off")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 55)
          
        if (section == models.count - 1){
            footer.backgroundColor = .clear
            let lbl = UILabel()
            lbl.frame = CGRect(x: 10, y: 0, width: self.view.frame.width - 10, height: 40)
            lbl.backgroundColor = .clear
            lbl.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            lbl.text = "When enabled, you'll need to use Face ID to unlock Companion"
            lbl.numberOfLines = 0
            footer.addSubview(lbl)
            self.tableView.tableFooterView = footer
        }
            return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == models.count - 1) {
            return 60.0
        } else {
            return 0.0
        }
    }
    
}
