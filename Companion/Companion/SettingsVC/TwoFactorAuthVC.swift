//
//  TwoFactorAuthVC.swift
//  Companion
//
//  Created by Ambu Sangoli on 31/01/23.
//

import UIKit

var isEmailOn = false
var isSMSOn = false

class TwoFactorAuthVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!
    
    var models = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Two-Step Verification"
        self.configure()
        tableView.register(SettingTableViewCell.self,
                       forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.register(SwitchTableViewCell.self,
                       forCellReuseIdentifier: SwitchTableViewCell.identifier)
        self.tableView.sectionHeaderHeight =  UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 25;

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always

    }
    
    func configure() {
            models.append(Section(title: "When enabled, you'll need to verify through sms verification before accessing account", options: [
                .switchCell(model: SettingsSwitchOption(title: "SMS Verification", icon: nil, iconBackgroundColor: .clear, handler: {

                }, isOn: isSMSOn))
            ]))
        
        models.append(Section(title: "When enabled, you'll need to verify through email ID verification before accessing account", options: [
            .switchCell(model: SettingsSwitchOption(title: "Email Verification", icon: nil, iconBackgroundColor: .clear, handler: {
            
            }, isOn: isEmailOn))
        ]))
     }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = models[section]
        let label = EdgeInsetLabel()
        label.numberOfLines = 0
        label.text = section.title
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        label.textInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return UITableView.automaticDimension
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
            cell.mySwitch.tag = indexPath.section
            cell.mySwitch.addTarget(self, action: #selector(self.switchValueDidChange(sender:)), for: .valueChanged)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @objc func switchValueDidChange(sender:UISwitch!)
    {
        if sender.tag == 0 {
            isSMSOn = sender.isOn
        } else {
            isEmailOn = sender.isOn
        }
        
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footer = UIView()
//        footer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 55)
//
//        if (section == models.count - 1){
//            footer.backgroundColor = .clear
//            let lbl = UILabel()
//            lbl.frame = CGRect(x: 10, y: 0, width: self.view.frame.width - 10, height: 40)
//            lbl.backgroundColor = .clear
//            lbl.font = UIFont(name: "HelveticaNeue-Light", size: 14)
//            lbl.text = "When enabled, you'll need to use Face ID to unlock Companion"
//            lbl.numberOfLines = 0
//            footer.addSubview(lbl)
//            self.tableView.tableFooterView = footer
//        }
//            return footer
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if (section == models.count - 1) {
//            return 60.0
//        } else {
            return 0.0
//        }
    }
    
}

class EdgeInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}
