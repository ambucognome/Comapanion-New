//
//  EventsTableViewCell.swift
//  Companion
//
//  Created by Santosh Naidu on 13/03/23.
//

import UIKit

class EventsTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!

    var eventData = [Event]()

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
        return self.eventData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
            cell.eventName.text = self.eventData[indexPath.row].name
            cell.time.text = self.eventData[indexPath.row].time
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
