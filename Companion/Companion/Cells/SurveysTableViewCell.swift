//
//  SurveyTableViewCell.swift
//  Companion
//
//  Created by Ambu Sangoli on 15/09/23.
//

import UIKit

protocol SurveysTableViewCellDelegate {
    func openForm(templateId: String,eventId: String, callStartSurvey: Bool,instrumentId: String?,isReadOnly: Bool)
}

class SurveysTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!

    var surveys = [SurveryData]()
    
    var nav : UINavigationController?
    var vc : HomeViewController?
    
    var delegate : SurveysTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        //Added shadow
        self.reloadLayers()
    }

    private func reloadLayers() {
        self.layer.cornerRadius = 4
        self.shadowView.dropShadoww()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.surveys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell") as! SurveyCell
        cell.nameLabel.text = self.surveys[indexPath.row].surverys[0].name
        cell.completedDateLabel.text = "SurveyId: \(self.surveys[indexPath.row].surverys[0].surveyId)"
        cell.tagView.layer.cornerRadius = 4
        cell.tagView.layer.borderWidth = 1

        if self.surveys[indexPath.row].surverys[0].concept == "SURVEY ASSIGNED" {
            cell.tagView.layer.borderColor = DARK_BLUE_COLOR.cgColor
            cell.typeLabel.textColor = DARK_BLUE_COLOR
            cell.typeLabel.text = "Assigned"
        } else if self.surveys[indexPath.row].surverys[0].concept == "SURVEY STARTED" {
            cell.tagView.layer.borderColor = UIColor(red: 246/255, green: 109/255, blue: 109/255, alpha: 1.0).cgColor
            cell.typeLabel.textColor = UIColor(red: 246/255, green: 109/255, blue: 109/255, alpha: 1.0)
            cell.typeLabel.text = "Pending"
        } else {
            cell.tagView.layer.borderColor = UIColor(red: 51/255, green: 102/255, blue: 0/255, alpha: 1.0).cgColor
            cell.typeLabel.textColor = UIColor(red: 51/255, green: 102/255, blue: 0/255, alpha: 1.0)
            cell.typeLabel.text = "Completed"
        }
        self.layoutSubviews()
            return cell
    }
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.openDDCForm(index: indexPath.row)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    func openDDCForm(index: Int) {
        let templatedId = self.surveys[index].surverys[0].templateId
        let surveyStatus = self.surveys[index].surverys[0].concept
        let eventId = self.surveys[index].surverys[0].eventId
        let instrumentId = self.surveys[index].surverys[0].instrumentId
        var shouldStartSurvey = false
        var isReadOnly = false
        if surveyStatus == "SURVEY ASSIGNED" {
            shouldStartSurvey = true
        } else if surveyStatus == "SURVEY SUBMITTED" {
            isReadOnly = true
        }
        self.delegate?.openForm(templateId: templatedId,eventId: eventId,callStartSurvey: shouldStartSurvey,instrumentId: instrumentId, isReadOnly: isReadOnly)
    }
}
