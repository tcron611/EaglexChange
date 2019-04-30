//
//  EventCell.swift
//  Eagle Xchange
//
//  Created by Thomas Ronan on 4/28/19.
//  Copyright © 2019 Thomas Ronan. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
   
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var organizationLabel: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numTicketsLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    var event:EventInfo!
    
    func configureCell(event: EventInfo) {
        eventNameLabel.text = event.eventName
        priceLabel.text = "$" + String(Int(event.price))
        if event.eventOrg == "ticketmaster" {
            organizationLabel.image = UIImage(named: "ticketmaster")
        }
        if event.eventOrg == "BC" {
            organizationLabel.image = UIImage(named: "bostonCollege")
        }
        if event.eventOrg == "Other" {
            organizationLabel.isHidden = true
        }
        let finalDateFormatter: DateFormatter = {
            let result = DateFormatter()
            result.dateStyle = .medium
            return result
        }()
        let dateString = finalDateFormatter.string(from: event.dateTime)
        dateLabel.text = dateString
        var numTicketsExtension = " tickets available"
        if event.numTickets == 1 {
           numTicketsExtension = " ticket available"
        }
        numTicketsLabel.text = String(event.numTickets) + numTicketsExtension
    }
    
}
