//
//  MyCareTeamViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 13/03/23.
//

import UIKit


class MyCareTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
//MARK: Add caretaker data here
    let careteamData : [CareTeam] = [
        CareTeam(image: "1", name: "Phillip Frost", specality: "Internal Medicine", lastVisitDate: "", experience: "400+", patients: "2 years", review: "200",bio: "I am a physician specializing in internal medicine. I provide comprehensive care for adults, focusing on the prevention and treatment of adult diseases. I have a special interest in chronic disease management and women's health."),
        CareTeam(image: "2", name: "Aston Merrill", specality: "Dermatology", lastVisitDate: "", experience: "3.06k+", patients: "6 years", review: "u",bio: "I'm a dermatologist specializing in the treatment of skin diseases and disorders. I'm passionate about helping my patients achieve and maintain healthy skin."),
        CareTeam(image: "3", name: "Francis Fuentes", specality: "Radiology", lastVisitDate: "", experience: "1.06k+", patients: "2 years", review: "600",bio: "I'm a radiologist. I use medical imaging to diagnose and treat diseases. I work with patients and their families to provide the best possible care."),
        CareTeam(image: "4", name: "Nathanael Cox", specality: "Orthopedic", lastVisitDate: "", experience: "6k+", patients: "9 years", review: "3.3k",bio: "Orthopedic Surgeon specializing in minimally invasive surgery and sports medicine. Dedicated to helping patients return to an active, pain-free lifestyle."),
        CareTeam(image: "5", name: "Joanna Coffey", specality: "Ophthalmology", lastVisitDate: "", experience: "1k+", patients: "3 years", review: "100",bio: "I am a practicing ophthalmologist. I specialize in the diagnosis and treatment of conditions of the eye. I have a passion for helping my patients improve their vision and reach their full potential."),
        CareTeam(image: "6", name: "Veronica Pugh", specality: "Pediatrics", lastVisitDate: "", experience: "8.11k+", patients: "8 years", review: "3.2k",bio: "I am a pediatrician. I have been providing care for children for over 15 years. I have a passion for helping children stay healthy and thrive.")]


    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        self.navigationItem.title = "Caretakers"
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()  + 0.0) {
            self.tableView.reloadData()
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
