//
//  EventDetailViewController.swift
//  Eagle Xchange
//
//  Created by Thomas Ronan on 4/22/19.
//  Copyright © 2019 Thomas Ronan. All rights reserved.
//

import UIKit
import SafariServices

class EventDetailViewController: UIViewController {

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventOrganization: UITextView!
    @IBOutlet weak var organizationImageView: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
   
    @IBOutlet weak var addInfoLabel: UILabel!
    @IBOutlet weak var additionalInfoTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var sellerInfoTextField: UITextField!
    
    @IBOutlet weak var webSiteButton: UIButton!
    
    @IBOutlet weak var postedOnTextField: UITextField!
    @IBOutlet weak var postedLabel: UILabel!
    
    var eventInfo = EventInfo()
    var addingEvent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInterface()
        
    }
    func dateStringFromDate(dateTime: Date) -> String {
        let finalDateFormatter: DateFormatter = {
            let result = DateFormatter()
            result.dateStyle = .medium
            result.timeStyle = .short
            return result
        }()
        return finalDateFormatter.string(from: dateTime)
    }
    
    func updateUserInterface() {
        //if viewing the event:
        //change add information to be "seller information:"
        //change title to be "Event Information"
        //add primary action function to price and add dollar sign in front if they didn't add it
        
        //if adding the event that isn't TicketMaster, leave the website textfield open so they can add one. Don't need one for ticketmaster because we already get website
        
      //  Setting up ticketmaster or BC logo
      //  additionalInfoTextView!.layer.borderWidth = 1
      //  let myColor : UIColor = UIColor.lightGray
      //  additionalInfoTextView!.layer.borderColor = myColor.cgColor
        if eventInfo.eventOrg == "ticketmaster" {
            eventOrganization.text = "Ticketmaster Event"
            eventNameTextField.isEnabled = false
            dateTextField.isEnabled = false
            locationTextField.isEnabled = false
            organizationImageView.image = UIImage(named: "ticketmaster")
        } else if eventInfo.eventOrg == "BC" {
            eventOrganization.text = "BC Event"
            organizationImageView.image = UIImage(named: "ticketmaster")
            //insert BC/other text here
        }
        
        eventNameTextField.text = eventInfo.eventName
        locationTextField.text = eventInfo.location
        
        if addingEvent == true{
            if eventInfo.dateTimeString == "" {
                dateTextField.text = "Please consult website for date of event"
            } else {
                dateTextField.text = dateStringFromDate(dateTime: eventInfo.dateTime)
            }
            navigationItem.title = "Event Information"
            addInfoLabel.text = "Seller Information"
            webSiteButton.isHidden = false
            additionalInfoTextView.isEditable = false
           // additionalInfoTextView.is
            priceTextField.isEnabled = false
            priceTextField.text = "$" + String(eventInfo.price) + "0"
            sellerInfoTextField.isEnabled = false
            postedLabel.isHidden = false
            postedOnTextField.isHidden = false
            postedOnTextField.isEnabled = false
          
        } else {
            additionalInfoTextView.backgroundColor = UIColor.white
        }
       
        
    }
    func showSafariVC(for url:String) {
        guard let url = URL(string: url) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    @IBAction func websiteButtonPressed(_ sender: UIButton) {
        showSafariVC(for: eventInfo.eventWebsite)
    }
    


}
