//
//  EventDetailTableViewController.swift
//  Eagle Xchange
//
//  Created by Thomas Ronan on 4/27/19.
//  Copyright © 2019 Thomas Ronan. All rights reserved.
//

import UIKit
import SafariServices
import Firebase
import FirebaseUI

class EventDetailTableViewController: UITableViewController {

    
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventOrganization: UITextView!
    @IBOutlet weak var organizationImageView: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var additionalInfoTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var numTicketsTextField: UITextField!
    @IBOutlet weak var sellerInfoTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var webSiteButton: UIButton!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var websiteTextField: UITextField!
    
    @IBOutlet weak var postedOnTextField: UITextField!
    @IBOutlet weak var postedLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var postSaveButton: UIBarButtonItem!
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    
    var eventInfo = EventInfo()
    var addingEvent = false
    var datePicked = Date()
    let categories = ["---", "Music", "Sports", "Comedy", "Art & Theatre", "Film", "Other"]
    var categoryChosen = ""
    
    override func viewDidLoad() {
        print(addingEvent)
        super.viewDidLoad()
        updateUserInterface()
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
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
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func updateOrgLogo() {
        if eventInfo.eventOrg == "ticketmaster" {
            eventOrganization.text = "Ticketmaster Event"
            organizationImageView.image = UIImage(named: "ticketmaster")
        } else if eventInfo.eventOrg == "BC" {
            eventOrganization.text = "BC Event"
            organizationImageView.image = UIImage(named: "bostonCollege")
            //insert BC/other text here
        } else if eventInfo.eventOrg == "Other" {
            eventOrganization.text = ""
            organizationImageView.isHidden = true
        }
    }
    
    func addEvent() {
        navigationItem.title = "Add Information"
        sellerInfoTextField.text = (Auth.auth().currentUser?.email)!
        if eventInfo.eventOrg == "ticketmaster" {
            categoryTextField.text = eventInfo.categoryOfEvent
            locationTextField.backgroundColor = UIColor.white
            eventNameTextField.backgroundColor = UIColor.white
            dateTextField.backgroundColor = UIColor.white
            if eventInfo.eventWebsite == "" {
                webSiteButton.isHidden = true
                websiteLabel.isHidden = false
                websiteTextField.isHidden = false
            } else {
                webSiteButton.isHidden = false
                websiteLabel.isHidden = true
                websiteTextField.isHidden = true
            }
            eventNameTextField.text = eventInfo.eventName
            locationTextField.text = eventInfo.location
            datePicker.isHidden = true
            datePickerView.isHidden = true
            dateTextField.isHidden = false
            categoryTextField.isHidden = false
            categoryPickerView.isHidden = true
            eventNameTextField.isEnabled = false
            if eventInfo.location == "" {
                locationTextField.isEnabled = true
            } else {
                locationTextField.isEnabled = false
            }
            if eventInfo.dateTimeString == "" {
                dateTextField.isEnabled = true
            } else {
                dateTextField.isEnabled = false
                dateTextField.text = dateStringFromDate(dateTime: eventInfo.dateTime)
            }
        }
        priceTextField.isEnabled = true
        numTicketsTextField.isEnabled = true
        sellerInfoTextField.isEnabled = true
        additionalInfoTextView.isEditable = true
        
    }
    
    func viewingEvent() {
        print(eventInfo.postingUserID)
        saveButton.isEnabled = false
        datePicker.isHidden = true
        datePickerView.isHidden = true
        categoryPickerView.isHidden = true
        if eventInfo.dateTimeString == "" {
            dateTextField.text = "No date given - contact seller"
        } else {
            dateTextField.text = dateStringFromDate(dateTime: eventInfo.dateTime)
        }
        navigationItem.title = "Event Information"
        if eventInfo.eventWebsite == "" {
            webSiteButton.isHidden = true
        } else {
            webSiteButton.isHidden = false
        }
        websiteLabel.isHidden = true
        websiteTextField.isHidden = true
        eventNameTextField.text = eventInfo.eventName
        locationTextField.text = eventInfo.location
        categoryTextField.text = eventInfo.categoryOfEvent
        eventNameTextField.isEnabled = false
        eventNameTextField.backgroundColor = UIColor.white
        var numTicketsExtension = " tickets available"
        if eventInfo.numTickets == 1 {
            numTicketsExtension = " ticket available"
        }
        numTicketsTextField.text = String(eventInfo.numTickets) + numTicketsExtension
        locationTextField.isEnabled = false
        locationTextField.backgroundColor = UIColor.white
        dateTextField.isHidden = false
        dateTextField.backgroundColor = UIColor.white
        if eventInfo.additionalInfo == "" {
            additionalInfoTextView.text = "No additional information provided by seller."
        } else {
            additionalInfoTextView.text = eventInfo.additionalInfo
        }
        additionalInfoTextView.isEditable = false
        additionalInfoTextView.backgroundColor = UIColor.white
        priceTextField.isEnabled = false
        priceTextField.backgroundColor = UIColor.white
        priceTextField.text = "$" + String(eventInfo.price) + "0"
        numTicketsTextField.isEnabled = false
        numTicketsTextField.backgroundColor = UIColor.white
        sellerInfoTextField.text = eventInfo.contactInfo //add in if clauses, etc
        sellerInfoTextField.isEnabled = false
        sellerInfoTextField.backgroundColor = UIColor.white
        postedOnTextField.isHidden = false
        postedOnTextField.backgroundColor = UIColor.white
        postedOnTextField.text = dateStringFromDate(dateTime: eventInfo.dateRegistered)
        categoryTextField.text = eventInfo.categoryOfEvent
        postedLabel.isHidden = false
        if eventInfo.postingUserID == Auth.auth().currentUser?.uid {
            deleteButton.isHidden = false
            postSaveButton.title = "Update"
            postSaveButton.isEnabled = true
            makeFieldsEditable()
            categoryPickerView.isHidden = false
            if eventInfo.eventOrg == "ticketmaster" {
                categoryPickerView.isHidden = true
            }
        }
    }
    func enableAndColor(textField: UITextField) {
        let color = UIColor.init(displayP3Red: 235/255, green: 235/255, blue: 234/255, alpha: 1)
        textField.backgroundColor = color
        textField.isEnabled = true
    }
    
    func makeFieldsEditable() {
        let color = UIColor.init(displayP3Red: 235/255, green: 235/255, blue: 234/255, alpha: 1)
        navigationItem.title = "Update Information"
        if eventInfo.eventOrg != "ticketmaster" {
            webSiteButton.isHidden = true
            enableAndColor(textField: eventNameTextField)
            enableAndColor(textField: locationTextField)
            websiteTextField.isHidden = false
            websiteLabel.isHidden = false
            enableAndColor(textField: websiteTextField)
            datePicker.isHidden = false
            datePickerView.isHidden = false
            dateTextField.isHidden = true
        }
        enableAndColor(textField: priceTextField)
        enableAndColor(textField: numTicketsTextField)
        numTicketsTextField.text = String(eventInfo.numTickets)
        enableAndColor(textField: sellerInfoTextField)
        additionalInfoTextView.backgroundColor = color
        additionalInfoTextView.isEditable = true
    }
    func notFilledOut(textField: UITextField) {
        textField.backgroundColor = UIColor.red
        print("TextShould be red now!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            textField.backgroundColor = UIColor.init(displayP3Red: 235/255, green: 235/255, blue: 234/255, alpha: 1)
        }
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updateUserInterface() {
        updateOrgLogo()
        if addingEvent == true {
            addEvent()
        } else {
            viewingEvent()
        }
    }
    func showSafariVC(for url:String) {
        guard let url = URL(string: url) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        var canSave = true
        var fields = 0
        var priceText = priceTextField.text!
        if priceTextField.text!.hasPrefix("$") {
            priceText.remove(at: priceText.startIndex)
        }
        if eventNameTextField.text == "" {
            notFilledOut(textField: eventNameTextField)
            canSave = false
            fields += 1
        }
        if locationTextField.text == "" {
            notFilledOut(textField: locationTextField)
            canSave = false
            fields += 1
        }
        if priceTextField.text == "" {
            notFilledOut(textField: priceTextField)
            canSave = false
            fields += 1
        }
        if numTicketsTextField.text == "" {
            notFilledOut(textField: numTicketsTextField)
            canSave = false
            fields += 1
        }
        if sellerInfoTextField.text == "" {
            notFilledOut(textField: sellerInfoTextField)
            canSave = false
            fields += 1
        }
        if categoryChosen == "" && eventInfo.categoryOfEvent == "" {
            categoryPickerView.backgroundColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.categoryPickerView.backgroundColor = UIColor.init(displayP3Red: 235/255, green: 235/255, blue: 234/255, alpha: 1)
            }
            fields += 1
        }
        if canSave == false {
            showAlert(title: "Enter All Required Fields", message: "There are still \(fields) remaining.")
            fields = 0
        }
        if canSave == true {
            if eventInfo.eventOrg != "ticketmaster" {
                eventInfo.categoryOfEvent = categoryChosen
                eventInfo.eventName = eventNameTextField.text!
                eventInfo.location = locationTextField.text!
                eventInfo.dateTime = datePicked
                eventInfo.dateTimeString = dateStringFromDate(dateTime: datePicked)
                if websiteTextField.text == "" {
                    eventInfo.eventWebsite = ""
                } else {
                    eventInfo.eventWebsite = websiteTextField.text!
                }
                
            }
            eventInfo.contactInfo = sellerInfoTextField.text!
            if additionalInfoTextView.text == "" {
                eventInfo.additionalInfo = ""
            } else {
                eventInfo.additionalInfo = additionalInfoTextView.text!
            }
            eventInfo.additionalInfo = additionalInfoTextView.text!
            eventInfo.numTickets = Int(numTicketsTextField.text!)!
            eventInfo.price = Double(priceText)!
            eventInfo.dateRegistered = Date()
            eventInfo.saveData { success in
                if success {
                    self.leaveViewController()
                } else {
                    print("*** ERROR - couldn't leave this view controller because data wasn't saved")
                }
            }
        }
    }
    
    @IBAction func websiteButtonPressed(_ sender: UIButton) {
        showSafariVC(for: eventInfo.eventWebsite)
    }
    @IBAction func deletePressed(_ sender: UIButton) {
        print("DeletePressed")
        eventInfo.deleteData(event: eventInfo) { (success) in
            if success {
                print("Success!")
            } else {
                print("*** Error: Delete unsuccessful")
            }
        }
        print("Success!")
        self.leaveViewController()
    }
    
    @IBAction func eventNameDone(_ sender: UITextField) {
        eventNameTextField.resignFirstResponder()
    }
    
    @IBAction func locationDone(_ sender: UITextField) {
        locationTextField.resignFirstResponder()
    }
    
    @IBAction func websiteDone(_ sender: UITextField) {
        websiteTextField.resignFirstResponder()
    }
    @IBAction func priceDone(_ sender: UITextField) {
        priceTextField.resignFirstResponder()
    }

    @IBAction func numTicketsDone(_ sender: UITextField) {
        numTicketsTextField.resignFirstResponder()
    }
    
    @IBAction func contactInfo(_ sender: UITextField) {
        sellerInfoTextField.resignFirstResponder()
        
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let inputDate = datePicker.date
        let inputDateString = dateStringFromDate(dateTime: inputDate)
        print(inputDateString)
        datePicked = inputDate
    }
    
}

extension EventDetailTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            categoryChosen = ""
            if eventInfo.categoryOfEvent != "" {
                categoryTextField.text = eventInfo.categoryOfEvent
            }
        }
        else {
            categoryChosen = categories[row]
        }
        if categoryChosen == "" {
            categoryTextField.text = eventInfo.categoryOfEvent
        } else {
           categoryTextField.text = categoryChosen
        }
        
            
        
        print(categoryChosen)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel //changing pickerView text size
        
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel!.font = UIFont(name: "Montserrat", size: 15)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        if component == 0 {
            pickerLabel?.text = categories[row]
        }
        return pickerLabel!
    }
}
