//
//  ViewController.swift
//  Eagle Xchange
//
//  Created by Thomas Ronan on 4/20/19.
//  Copyright © 2019 Thomas Ronan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class TicketSearchViewController: UIViewController {

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var keyWordLabel: UILabel!
    @IBOutlet weak var keyWordTextField: UITextField!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var basketballImageView: UIImageView!
    @IBOutlet weak var footballImageView: UIImageView!
    @IBOutlet weak var baseballImageView: UIImageView!
    @IBOutlet weak var hockeyImageView: UIImageView!
    @IBOutlet weak var basketballSelectedView: UIView!
    @IBOutlet weak var footballSelectedView: UIView!
    @IBOutlet weak var baseballSelectedView: UIView!
    @IBOutlet weak var hockeySelectedView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var noEventLabel: UILabel!
    @IBOutlet weak var addManuallyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var activityIndicator = UIActivityIndicatorView()
    var apiCriteria = ApiCriteria(category: "", market: "", keyWordSearch: "", sport: "")
    var events = TicketmasterEvents()
   // var category = ""
  //  var market = ""
  //  var keyWordSearch = ""
  //  var sport = ""
    
    //Market Constants
    let markets = ["--", "Boston Area", "New York City Area","Los Angeles Area", "Other"]
    let greaterBostonArea = "&marketId=11"
    let greaterNewYorkCity = "&marketId=35"
    let greaterLosAngeles = "&marketId=27"
    
    //Category Constants
    let categories = ["--", "Sports", "Music", "Comedy", "Art & Theatre", "Film", "Other"]
    //make sure to remove comedy from arts and theater when doing the search function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPActivityIndicator()
        pickerView.delegate = self
        pickerView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        self.view.sendSubviewToBack(basketballSelectedView)
        self.view.sendSubviewToBack(footballSelectedView)
        self.view.sendSubviewToBack(baseballSelectedView)
        self.view.sendSubviewToBack(hockeySelectedView)
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTicketmasterEvent" {
            let destination = segue.destination as! EventDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.eventInfo = events.eventArray[selectedIndexPath.row]
            destination.addingEvent = true
        }
        if segue.identifier == "AddManualEvent" {
           let destination = segue.destination as! EventDetailTableViewController
            destination.eventInfo.eventOrg = "Other"
            destination.addingEvent = true
        }
    }
    
    func setUPActivityIndicator() {
        activityIndicator.center = self.tableView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.color = UIColor.red
        view.addSubview(activityIndicator)
    }
    
    func sportsPressed(sportsView: UIView, classificationName: String) {
        if apiCriteria.sport == classificationName {
            if footballSelectedView.isHidden == true && baseballSelectedView.isHidden == true &&
                hockeySelectedView.isHidden == true &&
                basketballSelectedView.isHidden == true {
                sportsView.isHidden = false
            }
            else {
                sportsView.isHidden = true
                apiCriteria.sport = ""
            }
        }
        else {
            apiCriteria.sport = classificationName
            sportsView.isHidden = false
        }
        print(apiCriteria.sport)
    }
    
    func unhideUIElements() {
        if categoryTextField.text == "Sports" {
           // keyWordLabel.font = keyWordLabel.font.withSize(10)
            keyWordLabel.text = "Enter Team(s):"
          //  keyWordTextField.text = "Ex: Patriots Giants"
            sportLabel.isHidden = false
            baseballImageView.isHidden = false
            basketballImageView.isHidden = false
            footballImageView.isHidden = false
            hockeyImageView.isHidden = false
        }
        else {
            keyWordLabel.text = "Enter Artist or Group:"
            if categoryTextField.text == "Film" {
                keyWordLabel.text = "Enter Film Title:"
            }
            apiCriteria.sport = ""
            sportLabel.isHidden = true
            baseballImageView.isHidden = true
            basketballImageView.isHidden = true
            footballImageView.isHidden = true
            hockeyImageView.isHidden = true
            footballSelectedView.isHidden = true
            baseballSelectedView.isHidden = true
            hockeySelectedView.isHidden = true
            basketballSelectedView.isHidden = true
        }
        keyWordLabel.isHidden = false
        keyWordTextField.isHidden = false
    }
    func categoryChanged() {
        print("Category Changed!")
        keyWordTextField.text = ""
        if regionTextField.text != "" {
            unhideUIElements()
        }
    }
    
    func regionChanged() {
        print("Region Changed!")
        if categoryTextField.text != "" {
            unhideUIElements()
        }
    }
    
    @IBAction func keyWordDonePressed(_ sender: Any) {
        keyWordTextField.resignFirstResponder()
        searchButton.isHidden = false
        searchButton.isEnabled = true
    }
    
    @IBAction func basketBallPressed(_ sender: UITapGestureRecognizer) {
        sportsPressed(sportsView: basketballSelectedView, classificationName: "&classificationName=NBA")
        footballSelectedView.isHidden = true
        baseballSelectedView.isHidden = true
        hockeySelectedView.isHidden = true
    }
    
    @IBAction func footBallPressed(_ sender: UITapGestureRecognizer) {
        sportsPressed(sportsView: footballSelectedView, classificationName: "&classificationName=NFL")
        basketballSelectedView.isHidden = true
        baseballSelectedView.isHidden = true
        hockeySelectedView.isHidden = true
    }
    
    @IBAction func baseBallPressed(_ sender: UITapGestureRecognizer) {
        sportsPressed(sportsView: baseballSelectedView, classificationName: "&classificationName=MLB")
        basketballSelectedView.isHidden = true
        footballSelectedView.isHidden = true
        hockeySelectedView.isHidden = true
    }
    
    @IBAction func hockeyPressed(_ sender: UITapGestureRecognizer) {
        sportsPressed(sportsView: hockeySelectedView, classificationName: "&classificationName=NHL")
        basketballSelectedView.isHidden = true
        baseballSelectedView.isHidden = true
        footballSelectedView.isHidden = true
    }
    
    @IBAction func SearchButtonPressed(_ sender: UIButton) {
        keyWordTextField.resignFirstResponder()
        searchButton.isEnabled = false
        noEventLabel.isHidden = false
        addManuallyButton.isHidden = false
        //setting up api call elements
        if categoryTextField.text == "Other" {
            apiCriteria.category = ""
        }
        else {
            apiCriteria.category = categoryTextField.text!
        }
        //category done
        //sport done
        apiCriteria.keyWordSearch = keyWordTextField.text!
        //keyWord done
        if regionTextField.text == "Other" {
            apiCriteria.market = ""
        }
        if regionTextField.text == "Boston Area" {
            apiCriteria.market = greaterBostonArea
        }
        if regionTextField.text == "Los Angeles Area" {
            apiCriteria.market = greaterLosAngeles
        }
        if regionTextField.text == "New York City Area" {
            apiCriteria.market = greaterNewYorkCity
        }
        //market done
        events = TicketmasterEvents(apiCriteria: apiCriteria)
        print(apiCriteria)
        activityIndicator.startAnimating()
        events.getEvents {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
        keyWordTextField.text = ""
    }
    
    @IBAction func addManuallyPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "AddManualEvent", sender: nil)
        
    }
    
}
extension TicketSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = events.eventArray[indexPath.row].eventName
        if events.eventArray[indexPath.row].dateTimeString == "" {
            cell.detailTextLabel?.text = events.eventArray[indexPath.row].dateTimeString
        }
        else {
            let finalDateFormatter: DateFormatter = {
                let result = DateFormatter()
                result.dateStyle = .medium
                result.timeStyle = .short //may want to add back the medium and then remove the last 3 letters, because now is not including minutes correctly
                return result
            }()
            let dateString = finalDateFormatter.string(from: events.eventArray[indexPath.row].dateTime)
            cell.detailTextLabel?.text = dateString
        }
        if indexPath.row == events.eventArray.count - 1 && events.apiUrl != "" {
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            events.getEvents {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        return cell
    }
}


extension TicketSearchViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return categories.count
        }
        else {
            return markets.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if row == 0 {
                categoryTextField.text = ""
            }
            else {
                categoryTextField.text = categories[row]
                categoryChanged()
            }
        }
        else {
            if row == 0 {
                regionTextField.text = ""
            }
            else {
                regionTextField.text = markets[row]
                regionChanged()
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return categories[row]
        }
        else {
            return markets[row]
        }
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
        else {
            pickerLabel?.text = markets[row]
        }
        return pickerLabel!
    }
 
}
 


