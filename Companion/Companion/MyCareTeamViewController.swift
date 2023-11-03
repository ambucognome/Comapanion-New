//
//  MyCareTeamViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 13/03/23.
//

import UIKit


class MyCareTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

//MARK: caretaker data
    var careteamData : [CareTeam] = []
    
    struct Section {
        let letter : String
        let data : [CareTeam]
    }

    var sections = [Section]()
    var searchSections = [Section]()

    var images = ["1","2","3","4","5","6"]
    var isSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .onDrag
        self.searchBar.delegate = self
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

        self.tableView.rowHeight = UITableView.automaticDimension
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        self.navigationItem.title = "Caretakers"
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()  + 0.0) {
            self.tableView.reloadData()
        }
        self.getCareteam()
    }
    
    func getCareteam() {
        let params : [String:String] = ["meiId":SafeCheckUtils.getUserData()?.user?.mail ?? SafeCheckUtils.getGuestUserData()?.user.emailID ?? ""]
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        self.careteamData.removeAll()

        ERProgressHud.shared.show()
        BaseAPIManager.sharedInstance.makeRequestToGetCareteam(data: jsonData){ [self] (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            for i in 0..<response.count {
                                if let data = response[i] as? NSDictionary {
                                    print(data)
                                    let username = data["username"] as? String ?? ""
                                    let email = data["user_id"] as? String ?? ""
                                    let careteam = CareTeam(image: self.images.randomElement() ?? "", name: username, specality: "Radiology", lastVisitDate: "", experience: "1.06k+", patients: "2 years", review: "600",bio: "I'm a radiologist. I use medical imaging to diagnose and treat diseases. I work with patients and their families to provide the best possible care.", email: email)
                                    self.careteamData.append(careteam)
                                }
                            }
                            self.careteamData.sort(by: {$0.name < $1.name})
                            // group the array to ["N": ["Nancy"], "S": ["Sue", "Sam"], "J": ["John", "James", "Jenna"], "E": ["Eric"]]
                            let groupedDictionary = Dictionary(grouping: self.careteamData, by: {String($0.name.prefix(1))})
                            // get the keys and sort them
                            let keys = groupedDictionary.keys.sorted()
                            // map the sorted keys to a struct
                            self.sections = keys.map{Section(letter: $0, data: groupedDictionary[$0]!.sorted(by: {$0.name < $1.name}))}
                            self.searchSections = [Section(letter: "Top Name Matches", data: self.careteamData)]

                            self.tableView.reloadData()
                            DispatchQueue.main.asyncAfter(deadline: .now()  + 0.0) {
                                self.tableView.reloadData()
                            }
                            
                        } else {
                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                            ERProgressHud.shared.hide()
                        }
                    }
    }
    
    
    //MARK: Filter users based on searched text
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        print(textSearched)
        if textSearched == "" {
            self.isSearched = false
            tableView.reloadData()
        } else {
            self.isSearched = true
            self.searchSections = [Section(letter: "Top Name Matches", data: self.careteamData)]
            let filtered = self.searchSections[0].data.filter{($0.name.localizedCaseInsensitiveContains(textSearched)) }
            print(filtered)
            self.searchSections = [Section(letter: "Top Name Matches", data: filtered)]
            tableView.reloadData()
        }
    }
    
    // MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isSearched {
            return self.searchSections.count
        } else {
            return self.sections.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearched {
            return self.searchSections[section].data.count
        } else {
            return self.sections[section].data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var data : CareTeam?
        if self.isSearched {
            data = self.searchSections[indexPath.section].data[indexPath.row]
        } else {
             data = self.sections[indexPath.section].data[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorTableViewCell") as! DoctorTableViewCell
        cell.nameLabel.text = data?.name
        cell.specialityLabel.text = data?.specality
        cell.expLabel.text = data?.experience
        cell.patientsLabel.text = data?.patients
//        cell.imgView.image = UIImage(named: data.image)
        cell.imgView.setImageForName(data?.name ?? "", backgroundColor: nil, circular: false, textAttributes: nil)
        cell.layoutSubviews()
        cell.shadowView.dropShadoww()
        return cell
    }
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "DoctorProfileViewController") as! DoctorProfileViewController
            controller.data = self.sections[indexPath.section].data[indexPath.row]
//        let nav = UINavigationController(rootViewController: controller)
        let sheetController = SheetViewController(
            controller: controller,
            sizes: [.intrinsic],options: options)
        sheetController.gripSize = CGSize(width: 50, height: 3)
        sheetController.gripColor = UIColor(white: 96.0 / 255.0, alpha: 1.0)
        self.present(sheetController, animated: true, completion: nil)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.isSearched == false {
            return self.sections[section].letter
        }
        return self.searchSections[section].letter
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.isSearched == false {
            return self.sections.map{$0.letter}
        }
        return nil
    }

}

let options = SheetOptions(
    // Shrinks the presenting view controller, similar to the native modal
    shrinkPresentingViewController: false,
    // Adds a padding on the left and right of the sheet with this amount. Defaults to zero (no padding)
    horizontalPadding: 0
)


extension MyCareTeamViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCollectionViewCell", for: indexPath) as! AppCollectionViewCell
        let data = appList[indexPath.item]
        cell.imgView.image = data.image
        cell.imgView.layer.cornerRadius = 25
        cell.mainView.layer.borderWidth = 2
        cell.badgeLabel.isHidden = true
        if indexPath.item == 0 {
            cell.mainView.layer.borderColor = UIColor(red: 0.78, green: 0.44, blue: 0.14, alpha: 1.00).cgColor
        } else {
            cell.mainView.layer.borderColor = DARK_BLUE_COLOR.cgColor
        }
//        cell.badgeLabel.text = data.notificationCount?.description
//        if indexPath.item == 0 || indexPath.item == 1{
//            cell.badgeLabel.isHidden = false
//        }
        cell.badgeLabel.layer.cornerRadius = 7.5
        cell.badgeLabel.layer.masksToBounds = true
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 1 {
            selectedForm = true
            self.tabBarController?.selectedIndex = 2
        } else {
//            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
//            let controller = storyboard.instantiateViewController(identifier: "NotificationVC")
//            controller.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(controller, animated: true)
            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "NotificationVC") as! NotificationVC
//            controller.vc = self
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 58, height: 58)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
    
}

