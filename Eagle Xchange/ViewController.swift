//
//  ViewController.swift
//  Eagle Xchange
//
//  Created by Thomas Ronan on 4/20/19.
//  Copyright © 2019 Thomas Ronan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var regionPickerView: UIPickerView!
    
    @IBOutlet weak var keyWordLabel: UILabel!
    @IBOutlet weak var keyWordTextField: UITextField!
    
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var basketballImageView: UIImageView!
    @IBOutlet weak var footballImageView: UIImageView!
    @IBOutlet weak var baseballImageView: UIImageView!
    @IBOutlet weak var hockeyImageView: UIImageView!
    
    var category = ""
    var market = ""
    var keyWordSearch = ""
    var sport = ""
    
    //Market Constants
    let greaterBostonArea = "11"
    
    
    let apiKey = "&apikey=WKsBVheH2lggazqKJrTtQvZKAiRZiCBS"
    let apiString = "https://app.ticketmaster.com/discovery/v2/events.json?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func basketBallPressed(_ sender: UITapGestureRecognizer) {
        sport = "&classificationName=NBA"
        print(sport)
    }
    
    @IBAction func footBallPressed(_ sender: UITapGestureRecognizer) {
        sport = "&classificationName=NFL"
        print(sport)
    }
    
    @IBAction func baseBallPressed(_ sender: UITapGestureRecognizer) {
        sport = "&classificationName=MLB"
        print(sport)
    }
    
    @IBAction func hockeyPressed(_ sender: UITapGestureRecognizer) {
        sport = "&classificationName=NFL"
    }
    
    
}
/*
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.pokeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row+1). \(pokemon.pokeArray[indexPath.row].name)"
        
        // should I get more data?
        print("indexPath.row = \(indexPath.row) pokeArray.count-1 = \(pokemon.pokeArray.count-1)")
        if indexPath.row == pokemon.pokeArray.count-1 && pokemon.apiURL.hasPrefix("http") {
            print("👊👊 Making a call to get more data! 👊👊")
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            pokemon.getPokemon {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.pokemon.pokeArray.count) of \(self.pokemon.totalPokemon) Pokemon"
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        
        return cell
    }
    
    
}

*/

