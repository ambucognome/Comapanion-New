//
//  CompanionLoginViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 22/12/22.
//

import UIKit



class CompanionLoginViewController: UIViewController {

    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ezIdTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        selectedForm = false
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if self.ezIdTextField.text!.isEmpty {
            self.ezIdTextField.shake()
            return
        }
        if self.lastNameTextField.text!.isEmpty {
            self.lastNameTextField.shake()
            return
        }
        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
//         let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
//        vc.isFromLogin = true
        isFromLogin = true
        name = self.lastNameTextField.text!
        ezid = self.ezIdTextField.text!
//        vc.name = self.lastNameTextField.text!
//        vc.ezid = self.ezIdTextField.text!
//         self.navigationController?.pushViewController(vc, animated: true)
        self.setRootViewController(vc: vc)
    }
    
    func setRootViewController(vc: UIViewController) {
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
   
}

