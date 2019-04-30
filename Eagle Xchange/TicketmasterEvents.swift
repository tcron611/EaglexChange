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
    
    func removeAnySpaces(string: String) -> String {
        var newString = string
        while newString.contains(" "){
            print(newString.contains(" "))
            print("Inside while loop")
            let index = newString.firstIndex(of: " ")
            newString.insert("0", at: index!)
            newString.insert("2", at: index!)
            newString.insert("%", at: index!)
            newString.remove(at: newString.firstIndex(of: " ")!)
            print(newString)
        }
        return newString
    }
    
    func constructApiURL() -> String {
        var category = ""
        if apiCriteria.category == "Sports" {
            if apiCriteria.sport == "" {
                category = "&classificationName=Sports"
            } else {
                category = apiCriteria.sport
            }
        } else {
            category = "&classificationName=" + apiCriteria.category
        }
        let marketId = apiCriteria.market
        if suggestion == true {
            suggestion = false
        } else {
            keyWordSearch = "&keyword=" + apiCriteria.keyWordSearch
        }
        if pageNumber == 0 {
            apiUrl = apiString + category + marketId + keyWordSearch + apiKey
        } else {
            apiUrl = apiString + category + marketId + keyWordSearch + pageString + String(pageNumber) + sizeString + apiKey
        }
        if apiUrl.contains(" ") {
            apiUrl = removeAnySpaces(string: apiUrl)
        }
        print(apiUrl)
        return apiUrl
    }
    func getDate(dateTimeString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let calendar = Calendar.current
        let date = dateFormatter.date(from:dateTimeString)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date!)
        let finalDate = calendar.date(from:components)!
        return finalDate
    }
    
    func getEvents(completed: @escaping () -> ()) {
        print("Entered getEvents") //testing
        apiUrl = constructApiURL()
        print("constructedApiUrl") //testing
        Alamofire.request(apiUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                //if there are no results on current/next page:
                if json["_embedded"]["events"].count == 0 {
                    //if there are suggestions:
                    if json["spellcheck"]["suggestions"][0]["suggestion"].stringValue != "" {
                        // keyWordSearch
                        print("Spellcheck here")
                        self.keyWordSearch = "&keyword=" + json["spellcheck"]["suggestions"][0]["suggestion"].stringValue
                        print(self.keyWordSearch)
                        self.suggestion = true
                        self.apiUrl = self.constructApiURL()
                        print(self.suggestion)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { //adding a delay because of API spike arrest limit
                            Alamofire.request(self.apiUrl).responseJSON { response in
                                switch response.result {
                                case .success(let value):
                                    let json = JSON(value)
                                    if json["_embedded"]["events"].count == 0 {
                                        self.apiUrl = ""
                                    } else {
                                        let numberOfEvents = json["_embedded"]["events"].count
                                        self.pageNumber += 1
                                        for index in 0...numberOfEvents - 1 {
                                            print(index)
                                            let eventName = json["_embedded"]["events"][index]["name"].stringValue
                                            //add the rest of the pieces
                                            let dateTimeString = json["_embedded"]["events"][index]["dates"]["start"]["dateTime"].stringValue
                                            var dateTime: Date
                                            if dateTimeString == "" {
                                                dateTime = Date()
                                            } else {
                                                dateTime = self.getDate(dateTimeString: dateTimeString)
                                            }
                                            let dateRegistered = Date() // make it an actual date
                                            let location = json["_embedded"]["events"][index]["_embedded"]["venues"][0]["name"].stringValue + ", " + json["_embedded"]["events"][index]["_embedded"]["venues"][0]["city"]["name"].stringValue
                                            let categoryOfEvent = self.apiCriteria.category
                                            let eventOrg = "ticketmaster"
                                            let eventWebsite = json["_embedded"]["events"][index]["url"].stringValue
                                            let price = 0.0
                                            let numTickets = 0
                                            let contactInfo = ""
                                            let additionalInfo = ""
                                            self.eventArray.append(EventInfo(eventName: eventName, dateTimeString: dateTimeString, dateTime: dateTime, dateRegistered: dateRegistered, location: location, categoryOfEvent: categoryOfEvent, eventOrg: eventOrg, eventWebsite: eventWebsite, price: price, numTickets:numTickets, contactInfo: contactInfo, additionalInfo: additionalInfo, postingUserID: "", documentID: ""))
                                            print(self.eventArray)
                                        }
                                        
//                                        var eventName = ""
//                                        var dateTime = ""
//                                        var dateRegistered = ""
//                                        var location = ""
//                                        var categoryOfEvent = ""
//                                        var eventOrg = ""
//                                        var eventWebsite = ""
//                                        var price = 0.0
//                                        var contactInfo = ""
//                                        var additionalInfo = ""
                                    }
                                case .failure(let error):
                                    print("Error: \(error.localizedDescription) failed to get data from url \(self.apiUrl)")
                                }
                                completed()
                            }
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
                        //add the rest of the pieces
                        let dateTimeString = json["_embedded"]["events"][index]["dates"]["start"]["dateTime"].stringValue
                        var dateTime: Date
                        if dateTimeString == "" {
                            dateTime = Date()
                        } else {
                             dateTime = self.getDate(dateTimeString: dateTimeString)
                        }
                        let dateRegistered = Date() // make it an actual date
                        let location = json["_embedded"]["events"][index]["_embedded"]["venues"][0]["name"].stringValue + ", " + json["_embedded"]["events"][index]["_embedded"]["venues"][0]["city"]["name"].stringValue
                        let categoryOfEvent = self.apiCriteria.category
                        let eventOrg = "ticketmaster"
                        let eventWebsite = json["_embedded"]["events"][index]["url"].stringValue
                        let price = 0.0
                        let numTickets = 0
                        let contactInfo = ""
                        let additionalInfo = ""
                        self.eventArray.append(EventInfo(eventName: eventName, dateTimeString: dateTimeString, dateTime: dateTime, dateRegistered: dateRegistered, location: location, categoryOfEvent: categoryOfEvent, eventOrg: eventOrg, eventWebsite: eventWebsite, price: price, numTickets: numTickets, contactInfo: contactInfo, additionalInfo: additionalInfo, postingUserID: "", documentID: ""))
                        print(self.eventArray)
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

