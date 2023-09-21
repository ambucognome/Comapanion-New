//
//  SurveyTableViewCell.swift
//  Companion
//
//  Created by Ambu Sangoli on 15/09/23.
//

import UIKit

class SurveysTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!

    var titles = ["Covid Check","Sample Survey","Completed Survey"]
    var completedDate = ["Assigned on 28 August","Pending","Completed on 31 August"]
    var tags = ["Assigned","Pending","Completed"]

//    var dateEvents = [DateData]()

    
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
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell") as! SurveyCell
        cell.nameLabel.text = self.titles[indexPath.row]
        cell.completedDateLabel.text = self.completedDate[indexPath.row]
        cell.tagView.layer.cornerRadius = 4
        cell.tagView.layer.borderWidth = 1
        cell.typeLabel.text = self.tags[indexPath.row]
        if indexPath.row == 0 {
            cell.tagView.layer.borderColor = DARK_BLUE_COLOR.cgColor
        } else if indexPath.row == 1 {
            cell.tagView.layer.borderColor = UIColor.red.cgColor
        } else if indexPath.row == 2 {
            cell.tagView.layer.borderColor = UIColor.systemGreen.cgColor
        }
        self.layoutSubviews()
            return cell
    }
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
