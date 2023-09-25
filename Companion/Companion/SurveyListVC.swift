//
//  SurveyListVC.swift
//  Companion
//
//  Created by Ambu Sangoli on 21/09/23.
//

import UIKit

class SurveyListVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var vc : HomeViewController?


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Surveys"
        self.tableView.reloadData()
    }
    

}

extension SurveyListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return surveyData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let data = surveyData[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyy"
        let newDate = dateFormatter.date(from: data.date)

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let dateString = formatter.string(from: newDate! as Date)
                return dateString
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell") as! SurveyCell
        cell.nameLabel.text = surveyData[indexPath.section].surverys[0].name
        cell.completedDateLabel.text = "SurveyId: \(surveyData[indexPath.section].surverys[0].surveyId)"
        cell.tagView.layer.cornerRadius = 4
        cell.tagView.layer.borderWidth = 1

        if surveyData[indexPath.section].surverys[0].concept == "SURVEY ASSIGNED" {
            cell.tagView.layer.borderColor = DARK_BLUE_COLOR.cgColor
            cell.typeLabel.textColor = DARK_BLUE_COLOR
            cell.typeLabel.text = "Assigned"
        } else if surveyData[indexPath.section].surverys[0].concept == "SURVEY STARTED" {
            cell.tagView.layer.borderColor = UIColor(red: 246/255, green: 109/255, blue: 109/255, alpha: 1.0).cgColor
            cell.typeLabel.textColor = UIColor(red: 246/255, green: 109/255, blue: 109/255, alpha: 1.0)
            cell.typeLabel.text = "Pending"
        } else if surveyData[indexPath.section].surverys[0].concept == "SURVEY SUBMITTED" {
            cell.tagView.layer.borderColor = UIColor(red: 51/255, green: 102/255, blue: 0/255, alpha: 1.0).cgColor
            cell.typeLabel.textColor = UIColor(red: 51/255, green: 102/255, blue: 0/255, alpha: 1.0)
            cell.typeLabel.text = "Completed"
        }
        return cell
    }
    

    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
