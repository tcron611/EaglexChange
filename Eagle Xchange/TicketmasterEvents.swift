//
//  TicketmasterEvents.swift
//  Eagle Xchange
//
//  Created by Thomas Ronan on 4/20/19.
//  Copyright © 2019 Thomas Ronan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TicketmasterEvents {
    
    var eventArray:[EventInfo] = []
    var apiCriteria:ApiCriteria
    
    init(apiCriteria: ApiCriteria) {
        self.apiCriteria = apiCriteria
    }
    convenience init() {
        self.init(apiCriteria: ApiCriteria(category: "", market: "", keyWordSearch: "", sport: ""))
    }
    
    let apiKey = "&apikey=WKsBVheH2lggazqKJrTtQvZKAiRZiCBS"
    let apiString = "https://app.ticketmaster.com/discovery/v2/events.json?&includeSpellcheck=yes&sort=name,asc"
    let pageString = "&page="//add numbers, before size
    let sizeString = "&size=20" //add before API Key
    var apiUrl = ""
    var pageNumber = 0
    var suggestion = false
    var keyWordSearch = ""
    
    func constructApiURL() -> String {
        var category = ""
        if apiCriteria.category == "Sports" {
            if apiCriteria.sport == "" {
                category = "Sports"
            }
            else {
                category = apiCriteria.sport
            }
        }
        else {
            category = "&classificationName=" + apiCriteria.category
        }
        let marketId = apiCriteria.market
        if suggestion == true {
            suggestion = false
        }
        else {
            keyWordSearch = "&keyword=" + apiCriteria.keyWordSearch
        }
        if pageNumber == 0 {
            apiUrl = apiString + category + marketId + keyWordSearch + apiKey
        }
        else {
            apiUrl = apiString + category + marketId + keyWordSearch + pageString + String(pageNumber) + sizeString + apiKey
        }
        print(apiUrl)
        return apiUrl
    }
    
    func getEvents(completed: @escaping () -> ()) {
        apiUrl = constructApiURL()
        Alamofire.request(apiUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
             //   print("****************")
               // print(json)
                print("json[embedded]:****************")
                print(json["_embedded"]["events"])
                print("NEW COUNT:")
                print(json["_embedded"]["events"].count)
                //if there are no results on current/next page:
                if json["_embedded"]["events"].count == 0 {
                    print(json["spellcheck"]["suggestions"][0]["suggestion"])
                        //["suggestions"][1]["suggestions"].stringValue)
                    //if there are suggestions:
                    if json["spellcheck"]["suggestions"][0]["suggestion"].stringValue != "" {
                        // keyWordSearch
                        print("Spellcheck here")
                        self.keyWordSearch = "&keyword=" + json["spellcheck"]["suggestions"][0]["suggestion"].stringValue
                        print(self.keyWordSearch)
                        self.suggestion = true
                        self.apiUrl = self.constructApiURL()
                        Alamofire.request(self.apiUrl).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                print("Did it get here?")
                                let json = JSON(value)
                                //   print(json)
                                if json["_embedded"]["events"].count == 0 {
                                    self.apiUrl = ""
                                } else {
                                    let numberOfEvents = json["_embedded"]["events"].count
                                    self.pageNumber += 1
                                    for index in 0...numberOfEvents - 1 {
                                        print(index)
                                        //print(json["_embedded"]["events"][index]["name"])
                                        let eventName = json["_embedded"]["events"][index]["name"].stringValue
                                        print(eventName)
                                        let dateOfEvent = json["_embedded"]["events"][index]["dates"]["start"]["localDate"].stringValue
                                        print(dateOfEvent)
                                        //add the rest of the pieces
                                        let dateTime = json["_embedded"]["events"][index]["dates"]["start"]["dateTime"].stringValue
                                        let dateRegistered = ""
                                        let time = json["_embedded"]["events"][index]["dates"]["start"]["localTime"].stringValue
                                        let location = ""
                                        let ticketMasterEvent = false
                                        let eventWebsite = ""
                                        let price = 0.0
                                        let contactInfo = ""
                                        self.eventArray.append(EventInfo(eventName: eventName, dateTime: dateTime, dateOfEvent: dateOfEvent, dateRegistered: "", time: "", location: "", ticketMasterEvent: true, eventWebsite: "", price: 0.0, contactInfo: ""))
                                    }
                                }
                            case .failure(let error):
                                print("Error: \(error.localizedDescription) failed to get data from url \(self.apiUrl)")
                            }
                            completed()
                        }
                        // end of there is a suggestion and no data section
                    }
                    else {
                        self.apiUrl = ""
                        print("No search results/next page!")
                    }
                } else {
                    let numberOfEvents = json["_embedded"]["events"].count
                    self.pageNumber += 1
                    print("# of events: " + String(numberOfEvents))
                    for index in 0...numberOfEvents - 1 {
                        print(index)
                        //print(json["_embedded"]["events"][index]["name"])
                        let eventName = json["_embedded"]["events"][index]["name"].stringValue
                          print(eventName)
                        let dateOfEvent = json["_embedded"]["events"][index]["dates"]["start"]["localDate"].stringValue
                        print(dateOfEvent)
                        //add the rest of the pieces
                        let dateTime = json["_embedded"]["events"][index]["dates"]["start"]["dateTime"].stringValue
                        let dateRegistered = ""
                        let time = json["_embedded"]["events"][index]["dates"]["start"]["localTime"].stringValue
                        let location = ""
                        let ticketMasterEvent = false
                        let eventWebsite = ""
                        let price = 0.0
                        let contactInfo = ""
                        self.eventArray.append(EventInfo(eventName: eventName, dateTime: dateTime, dateOfEvent: dateOfEvent, dateRegistered: "", time: "", location: "", ticketMasterEvent: true, eventWebsite: "", price: 0.0, contactInfo: ""))
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription) failed to get data from url \(self.apiUrl)")
                //ends up here is there are no results for your search - can append a single element to the table view with the title that there is no results. (Event not Found)
                //
            }
            completed()
        }
    }
}

