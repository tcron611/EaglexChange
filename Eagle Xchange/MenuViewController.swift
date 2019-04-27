//
//  MenuViewController.swift
//  Eagle Xchange
//
//  Created by Thomas Ronan on 4/27/19.
//  Copyright © 2019 Thomas Ronan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var eventOrg = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEventDetail" {
            let destination = segue.destination as! EventDetailViewController
            if self.eventOrg == "BC" {
                destination.eventInfo.eventOrg = "BC"
            }
            else {
              destination.eventInfo.eventOrg = "Other"
            }
            destination.addingEvent = true
        }
    }
    
    @IBAction func ticketmasterTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "ShowTicketmasterSearch", sender: nil)
    }
    
    @IBAction func bostonCollegePressed(_ sender: UITapGestureRecognizer) {
        eventOrg = "BC"
        performSegue(withIdentifier: "AddEventDetail", sender: nil)
    }
    @IBAction func otherPressed(_ sender: Any) {
        eventOrg = "Other"
        performSegue(withIdentifier: "AddEventDetail", sender: nil)
    }
    
}
