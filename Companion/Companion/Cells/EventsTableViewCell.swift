//
//  EventsTableViewCell.swift
//  Companion
//
//  Created by Ambu Sangoli on 13/03/23.
//

import UIKit

class EventsTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!

    var eventData = [EventStruct]()
    var dateEvents = [DateData]()
    

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
        return self.dateEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.dateEvents[indexPath.row].events[0]
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
            cell.eventName.text = data.name
            cell.time.text = data.time
            cell.selectionStyle = .none
        cell.durationLabel.text = "Duration: \(data.duration) mins"
        if data.parentId == nil {
            cell.hostLabel.text = "You are the host for this event."
        } else {
            cell.hostLabel.text = ""
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
