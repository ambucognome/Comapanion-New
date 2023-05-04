//
//  CallingViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 03/05/23.
//

import UIKit
import NotificationBannerSwift

class CallingViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var timer : Timer?
    var second = 0
    
    var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameLabel.text = "Calling \(name)"
        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.timerfunction), userInfo: nil, repeats: false)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    

    @objc func timerfunction() {
        self.dismiss(animated: true) {
            let banner = NotificationBanner(title: "Call was not answered", subtitle: nil, leftView: nil, rightView: nil, style: .warning, colors: nil)
            banner.haptic = .heavy
            banner.show()
        }
    }



@IBAction func rejectBtn(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
}

}
