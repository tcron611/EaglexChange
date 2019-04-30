//
//  EventListTableViewController.swift
//  Eagle Xchange
//
//  Created by Thomas Ronan on 4/27/19.
//  Copyright © 2019 Thomas Ronan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class EventListViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bcViewBorder: UIView!
    @IBOutlet weak var bcImageView: UIImageView!
   
    
    var events:Events!
    var originalEvents:Events!
    var categories = ["Unsorted", "Music", "Sports", "Comedy", "Art & Theatre", "Film"]
    var categorySort = ""
    var bcSort = false
    var favoriteSort = false
    
    override func viewDidLoad() {
        pickerView.delegate = self
        pickerView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        events = Events()
        self.view.sendSubviewToBack(bcViewBorder)
        bcViewBorder.isHidden = true
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        events.loadData {
            self.tableView.reloadData()
        }
        originalEvents = events
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEventDetails" {
            let destination = segue.destination as! EventDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.eventInfo = events.eventsArray[selectedIndexPath.row]
            destination.addingEvent = false
        }
    }
    
    @IBAction func bcPressed(_ sender: UITapGestureRecognizer) {
        if bcViewBorder.isHidden == true {
            bcViewBorder.isHidden = false
            bcSort = true
        } else {
            bcViewBorder.isHidden = true
            bcSort = false
        }
        print("BC Sort:" + String(bcSort))
    }
    
    @IBAction func sortPressed(_ sender: UIButton) {
        var sortedEventList = Events()
        print(categorySort)
        if categorySort == "" {
            for event in originalEvents.eventsArray {
                sortedEventList.eventsArray.append(event)
            }
        } else {
            for event in originalEvents.eventsArray {
                if event.categoryOfEvent == categorySort {
                    sortedEventList.eventsArray.append(event)
                }
            }
        }
        let tempSortedList = Events()
        if bcSort == true {
            for event in sortedEventList.eventsArray {
                if event.eventOrg == "BC" {
                    tempSortedList.eventsArray.append(event)
                }
            }
            sortedEventList = tempSortedList
        }
        events = sortedEventList
        tableView.reloadData()
    }
}
extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventCell
        cell.configureCell(event: events.eventsArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    
}


extension EventListViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            categorySort = ""
        }
        else {
            categorySort = categories[row]
        }
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
