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

class ViewController: UIViewController {

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
    
    var category = ""
    var market = ""
    var keyWordSearch = ""
    var sport = ""
    
    //Market Constants
    let markets = ["Greater Boston Area", "Greater New York City Area","Greater Los Angeles Area", "Other"]
    let greaterBostonArea = "&marketId=11"
    let greaterNewYorkCity = "&marketId=35"
    let greaterLosAngeles = "&marketId=27"
    
    //Category Constants
    let categories = ["Sports", "Music", "Other"]
    let apiKey = "&apikey=WKsBVheH2lggazqKJrTtQvZKAiRZiCBS"
    let apiString = "https://app.ticketmaster.com/discovery/v2/events.json?"
    let pageString = "&page="//add numbers
    let sizeString = "&size=20" //add before API Key
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        updateUI()
        
    }
    
    func updateUI() {
        basketballSelectedView.backgroundColor = UIColor.lightGray
        footballSelectedView.backgroundColor = UIColor.lightGray
        baseballSelectedView.backgroundColor = UIColor.lightGray
        hockeySelectedView.backgroundColor = UIColor.lightGray
        self.view.sendSubviewToBack(basketballSelectedView)
        self.view.sendSubviewToBack(footballSelectedView)
        self.view.sendSubviewToBack(baseballSelectedView)
        self.view.sendSubviewToBack(hockeySelectedView)
    }
    func sportsPressed(sportsView: UIView, classificationName: String) {
        if sport == classificationName {
            sportsView.isHidden = true
        }
        else {
            sport = classificationName
            sportsView.isHidden = false
        }
        print(sport)
    }
    
    @IBAction func basketBallPressed(_ sender: UITapGestureRecognizer) {
        sportsPressed(sportsView: basketballSelectedView, classificationName: "&classificationName=NBA")
        footballSelectedView.isHidden = true
        baseballSelectedView.isHidden = true
        hockeySelectedView.isHidden = true
    }
    
    @IBAction func footBallPressed(_ sender: UITapGestureRecognizer) {
        sportsPressed(sportsView: footballSelectedView, classificationName: "&classificationName=NFL")
    }
    
    @IBAction func baseBallPressed(_ sender: UITapGestureRecognizer) {
        if sport == "&classificationName=MLB" {
            baseballSelectedView.isHidden = true
            sport = ""
        }
        else {
            sport = "&classificationName=MLB"
            baseballSelectedView.isHidden = false
        }
        print(sport)
    }
    
    @IBAction func hockeyPressed(_ sender: UITapGestureRecognizer) {
        if sport == "&classificationName=NFL" {
            hockeySelectedView.isHidden = true
            sport = ""
        }
        else {
          sport = "&classificationName=NFL"
             hockeySelectedView.isHidden = false
        }
        print(sport)
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
            categoryTextField.text = categories[row]
        }
        else {
            regionTextField.text = markets[row]
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
}
 


