//
//  GridViewController.swift
//  Companion
//
//  Created by Santosh Naidu on 09/01/23.
//

import UIKit

class GridViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    let DARK_BLUE_COLOR = UIColor(red: 0.07, green: 0.22, blue: 0.40, alpha: 1.00)
    let LIGHT_BLUE_COLOR = UIColor.white
    
    var appList = [AppStruct(name: "SafeCheck", image: nil, notificationCount: 0,isSelected: false),AppStruct(name: "Basic", image: nil, notificationCount: 0, isSelected: false),AppStruct(name: "Repeatable", image: nil, notificationCount: 0,isSelected: false),AppStruct(name: "Repeatable 2", image: nil, notificationCount: 0,isSelected: false),AppStruct(name: "App Four", image: nil, notificationCount: 0,isSelected: false),AppStruct(name: "App Five", image: nil, notificationCount: 0,isSelected: false)]
    
    struct AppStruct {
        var name : String
        var image : UIImage?
        var notificationCount : Int?
        var isSelected : Bool
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SocketHelper.shared.connectSocket { success in
            print(success)
            SocketHelper.Events.server_initiated_event.listen { (result) in
                if let dataArray = result as? NSArray {
                    if let string = dataArray[0] as? String {
                        if let data = string.convertToDictionary() as? NSDictionary {
                        let success = data["success"] as? Bool ?? false
                        if let type = data["type"] as? String {
                            if type == "login" {
                                if success  {
                                    let storyBoard = UIStoryboard(name: "covidCheck", bundle: nil)
                                    let messageVC = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
                                    messageVC.viewModel = MessageViewModel(bubbleStyle: .facebook )
                                    var configuration = ChatViewConfiguration.default
                                    configuration.chatBarStyle = .default
                                    configuration.imagePickerType = .actionSheet
                                    messageVC.configuration = configuration

                                    self.navigationController?.pushViewController(messageVC, animated: true)
                                }
                            }
                        }
                    }
                  }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        SocketHelper.Events.server_initiated_event.off()
    }

}

extension GridViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCollectionViewCell", for: indexPath) as! AppCollectionViewCell
        let data = self.appList[indexPath.item]
        cell.nameLabel.text = data.name
//        if data.isSelected {
            cell.nameLabel.textColor = DARK_BLUE_COLOR
            cell.contentView.backgroundColor = LIGHT_BLUE_COLOR
            cell.contentView.layer.borderWidth = 5
            cell.contentView.layer.borderColor = DARK_BLUE_COLOR.cgColor
//        } else {
//            cell.nameLabel.textColor = .white
//            cell.contentView.backgroundColor = DARK_BLUE_COLOR
//            cell.contentView.layer.borderWidth = 0
//            cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var eid = ""
        if let retrievedCodableObject =  SafeCheckUtils.getUserData() {
            userName = (retrievedCodableObject.user?.firstname ?? "") + " " + (retrievedCodableObject.user?.lastname ?? "")
            eid = retrievedCodableObject.user?.eid ?? ""
        }
        let json2String = "{\"ezid\":\"\(eid)\",\"username\":\"\(userName)\",\"userType\":\"SAFECHECK\",\"type\":\"login\"}"
        SocketHelper.Events.event.emit(params: json2String)
        
        let jsonString = "{\"ezid\":\"\(eid)\",\"username\":\"\(userName)\",\"userType\":\"SAFECHECK\",\"type\":\"login-webrtc\"}"
        SocketHelper.Events.event.emit(params: jsonString)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.width - 80) / 3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    
    
}