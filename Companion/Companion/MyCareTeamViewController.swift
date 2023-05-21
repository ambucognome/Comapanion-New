//
//  MyCareTeamViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 13/03/23.
//

import UIKit


class MyCareTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    
//MARK: Add caretaker data here
    let careteamData : [CareTeam] = [
        CareTeam(image: "6", name: "Alexina Nechis", specality: "Internal Medicine", lastVisitDate: "", experience: "400+", patients: "2 years", review: "200",bio: "I am a physician specializing in internal medicine. I provide comprehensive care for adults, focusing on the prevention and treatment of adult diseases. I have a special interest in chronic disease management and women's health.",email: "anechis@montefiore.org"),
        CareTeam(image: "2", name: "Aston Merrill", specality: "Dermatology", lastVisitDate: "", experience: "3.06k+", patients: "6 years", review: "u",bio: "I'm a dermatologist specializing in the treatment of skin diseases and disorders. I'm passionate about helping my patients achieve and maintain healthy skin."),
        CareTeam(image: "3", name: "Francis Fuentes", specality: "Radiology", lastVisitDate: "", experience: "1.06k+", patients: "2 years", review: "600",bio: "I'm a radiologist. I use medical imaging to diagnose and treat diseases. I work with patients and their families to provide the best possible care."),
        CareTeam(image: "4", name: "Nathanael Cox", specality: "Orthopedic", lastVisitDate: "", experience: "6k+", patients: "9 years", review: "3.3k",bio: "Orthopedic Surgeon specializing in minimally invasive surgery and sports medicine. Dedicated to helping patients return to an active, pain-free lifestyle."),
        CareTeam(image: "5", name: "Joanna Coffey", specality: "Ophthalmology", lastVisitDate: "", experience: "1k+", patients: "3 years", review: "100",bio: "I am a practicing ophthalmologist. I specialize in the diagnosis and treatment of conditions of the eye. I have a passion for helping my patients improve their vision and reach their full potential."),
        CareTeam(image: "6", name: "Veronica Pugh", specality: "Pediatrics", lastVisitDate: "", experience: "8.11k+", patients: "8 years", review: "3.2k",bio: "I am a pediatrician. I have been providing care for children for over 15 years. I have a passion for helping children stay healthy and thrive.")]


    override func viewDidLoad() {
        super.viewDidLoad()
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
        let params : [String:String] = ["meiId":SafeCheckUtils.getUserData()?.user?.mail ?? ""]
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        eventsData.removeAll()

        ERProgressHud.shared.show()
                    BaseAPIManager.sharedInstance.makeRequestToGetCareteam(data: jsonData){ (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            print(response)
//                            for i in 0..<response.count {
//                                if let eventDic = response[i] as? NSDictionary {
//                                    let eventID = eventDic["eventId"] as? String ?? ""
//                                    let metaDataString = eventDic["metadata"] as? String ?? ""
//                                    if let metaDataDic = metaDataString.convertToDictionary() {
//                                        print(metaDataDic)
//                                        let parentId = metaDataDic["parentId"] as? String
//                                        let eventDate = metaDataDic["date"] as? String ?? ""
//
//                                        let dateFormatter = DateFormatter()
//                                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//                                        let newDate = dateFormatter.date(from: eventDate)
//
//                                        let formatter = DateFormatter()
//                                        formatter.dateFormat = "dd/MM/yyyy"
//                                        let dateString = formatter.string(from: newDate! as Date)
//
//                                        let startTime = metaDataDic["startTime"] as? String ?? ""
//                                        let timeFormatter = DateFormatter()
//                                        timeFormatter.dateFormat = "hh:mm:ss a"
//                                        let time = timeFormatter.date(from: startTime)
//
//                                        let newformatter = DateFormatter()
//                                        newformatter.dateFormat = "h:mm a"
//                                        let timeString = newformatter.string(from: time! as Date)
//
//
//                                        let title = metaDataDic["title"] as? String ?? ""
//                                        let eventDuration = metaDataDic["eventDuration"] as? String ?? ""
//                                        let description = metaDataDic["description"] as? String ?? ""
//                                        let guestString = metaDataDic["guests"] as? String ?? ""
//                                        let meetingId = metaDataDic["meetingId"] as? String ?? ""
//
//                                        var guestDat = [GuestStruct]()
//                                        if let array = guestString.convertToNSDictionary() {
//                                            for guest in array {
//                                            if let guestDic = guest as? NSDictionary {
//                                                if let guestData = guestDic["guest"] as? NSDictionary {
//                                                let guestName = guestData["name"] as? String ?? ""
//                                                 let email = guestData["email"] as? String ?? ""
//                                                 let guestId = guestData["guestId"] as? String ?? ""
//                                                    guestDat.append(GuestStruct(guestname: guestName, guestId: guestId, guestEmail: email))
//                                                }
//                                            }
//                                            }
//                                        }
////                                        let guestStr = guestString.replacingOccurrences(of: "[Guest(", with: "").replacingOccurrences(of: ")]", with: "")
////                                        let components = guestStr.components(separatedBy: ", ")
////                                        var guestDic: [String : String] = [:]
////
////                                        for component in components{
////                                          let pair = component.components(separatedBy: "=")
////                                            guestDic[pair[0]] = pair[1]
////                                        }
////                                        print(guestDic)
////                                        let guestName = guestDic["name"] ?? ""
////                                        let email = guestDic["email"] ?? ""
////                                        let guestId = guestDic["guestId"] ?? ""
//
//                                        let contextString = metaDataDic["context"] as? String ?? ""
//                                        if let cont = contextString.convertToDictionary() {
//                                            print(cont)
//
////                                        let contextStr = contextString.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
////                                        let contextComponents = contextStr.components(separatedBy: ",")
////                                        var contextDic: [String : String] = [:]
////
////                                        for component in contextComponents{
////                                          let pair = component.components(separatedBy: ":")
////                                            contextDic[pair[0]] = pair[1]
////                                        }
//
//
//                                            let data = DateData(date: dateString, events: [EventStruct(name: title, time: timeString,duration: eventDuration, parentId: parentId, description: description, date: dateString, guestData: guestDat,meetingId: meetingId, context: cont, eventId: eventID)], careTeam: [CareTeam(image: "profile1", name: "guestName", specality: "guestId", lastVisitDate: "email")])
//                                            eventsData.append(data)
//                                            self.tableView.reloadData()
//
//                                        }
//
//                                    }
//
//                                }
//                            }
//                            self.tableView.reloadData()
//                            self.calendar.reloadData()
//                            DispatchQueue.main.asyncAfter(deadline: .now()  + 0.1) {
//                                self.tableView.reloadData()
//                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now()  + 0.2) {
//                                self.tableView.reloadData()
//                            }
                        } else {
                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                            ERProgressHud.shared.hide()
                        }
                    }
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.careteamData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = careteamData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorTableViewCell") as! DoctorTableViewCell
        cell.nameLabel.text = data.name
        cell.specialityLabel.text = data.specality
        cell.expLabel.text = data.experience
        cell.patientsLabel.text = data.patients
        cell.imgView.image = UIImage(named: data.image)
        cell.layoutSubviews()
        cell.shadowView.dropShadoww()
        return cell
    }
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Companion", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "DoctorProfileViewController") as! DoctorProfileViewController
            controller.data = careteamData[indexPath.row]
//        let nav = UINavigationController(rootViewController: controller)
        let sheetController = SheetViewController(
            controller: controller,
            sizes: [.intrinsic],options: options)
        sheetController.gripSize = CGSize(width: 50, height: 3)
        sheetController.gripColor = UIColor(white: 96.0 / 255.0, alpha: 1.0)
        self.present(sheetController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        cell.badgeLabel.text = data.notificationCount?.description
        if indexPath.item == 0 || indexPath.item == 1{
            cell.badgeLabel.isHidden = false
        }
        cell.badgeLabel.layer.cornerRadius = 7.5
        cell.badgeLabel.layer.masksToBounds = true
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 2 {
            selectedForm = true
            self.tabBarController?.selectedIndex = 2
        } else {
            let storyboard = UIStoryboard(name: "Companion", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "NotificationVC")
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
