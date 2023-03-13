//
//  CareTeamTableViewCell.swift
//  Companion
//
//  Created by Santosh Naidu on 13/03/23.
//

import UIKit

class CareTeamTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!

    var careTeamData = [CareTeam]()

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
        return self.careTeamData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.careTeamData[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CareTeamCell") as! CareTeamCell
        cell.nameLabel.text = "\(data.name) | \(data.specality) "
        cell.lastVisitLabel.text = data.lastVisitDate
        cell.imgView.image = UIImage(named: data.image)
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
