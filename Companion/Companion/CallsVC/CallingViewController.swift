//
//  CallingViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 03/05/23.
//

import UIKit
import NotificationBannerSwift
import AVFoundation

class CallingViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var timer : Timer?
    var second = 0
    
    var name = ""
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.playSound()
        self.nameLabel.text = "Calling \(name)"
        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.timerfunction), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
        player?.stop()
    }

    @objc func timerfunction() {
        player?.stop()
        self.dismiss(animated: true) {
            let banner = NotificationBanner(title: "Call was not answered", subtitle: nil, leftView: nil, rightView: nil, style: .warning, colors: nil)
            banner.haptic = .heavy
            banner.show()
        }
    }

    @IBAction func rejectBtn(_ sender: Any) {
        player?.stop()
        self.dismiss(animated: false, completion: nil)
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "phoneringing", withExtension: "caf") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
