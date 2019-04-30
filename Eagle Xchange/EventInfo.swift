//
//  EventInfo.swift
//  Eagle Xchange
//
//  Created by Thomas Ronan on 4/20/19.
//  Copyright © 2019 Thomas Ronan. All rights reserved.
//

import Foundation
import Firebase

class EventInfo {
    var eventName:String
    var dateTimeString:String
    var dateTime:Date
    var dateRegistered:Date
    var location:String
    var categoryOfEvent:String
    var eventOrg:String
    var eventWebsite:String
    var price:Double
    var numTickets:Int
    var contactInfo:String
    var additionalInfo:String
    var postingUserID: String
    var documentID: String
    
    
    var dictionary: [String: Any] {
        return ["eventName": eventName, "dateTimeString": dateTimeString, "dateTime": dateTime, "dateRegistered": dateRegistered, "location": location, "categoryOfEvent": categoryOfEvent, "eventOrg": eventOrg, "eventWebsite": eventWebsite, "price": price, "numTickets": numTickets, "contactInfo": contactInfo, "additionalInfo": additionalInfo, "postingUserID": postingUserID ]
    }
    init(eventName: String, dateTimeString: String, dateTime: Date, dateRegistered: Date, location: String, categoryOfEvent: String, eventOrg: String, eventWebsite: String, price:Double, numTickets: Int, contactInfo: String, additionalInfo: String, postingUserID: String, documentID: String) {
        self.eventName = eventName
        self.dateTimeString = dateTimeString
        self.dateTime = dateTime
        self.dateRegistered = dateRegistered
        self.location = location
        self.categoryOfEvent = categoryOfEvent
        self.eventOrg = eventOrg
        self.eventWebsite = eventWebsite
        self.price = price
        self.numTickets = numTickets
        self.contactInfo = contactInfo
        self.additionalInfo = additionalInfo
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    convenience init() {
        self.init(eventName: "", dateTimeString: "", dateTime: Date(), dateRegistered: Date(), location: "", categoryOfEvent: "", eventOrg: "", eventWebsite: "", price: 0.0, numTickets: 0, contactInfo: "", additionalInfo: "", postingUserID: "", documentID: "")
    }

    convenience init(dictionary: [String: Any]) {
        let eventName = dictionary["eventName"]as! String? ?? ""
        let dateTimeString = dictionary["dateTimeString"]as! String? ?? ""
        let timestamp = dictionary["dateTime"] as? Timestamp
        let dateTime = timestamp!.dateValue()
        let timestampTwo = dictionary["dateRegistered"] as? Timestamp
        let dateRegistered = timestampTwo!.dateValue()
        let location = dictionary["location"] as! String? ?? ""
        let categoryOfEvent = dictionary["categoryOfEvent"] as! String? ?? ""
        let eventOrg = dictionary["eventOrg"] as! String? ?? ""
        let eventWebsite = dictionary["eventWebsite"] as! String? ?? ""
        let price = dictionary["price"] as! Double? ?? 0.0
        let numTickets = dictionary["numTickets"] as! Int? ?? 0
        let contactInfo = dictionary["contactInfo"] as! String? ?? ""
        let additionalInfo = dictionary["additionalInfo"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        self.init(eventName: eventName, dateTimeString: dateTimeString, dateTime: dateTime, dateRegistered: dateRegistered, location: location, categoryOfEvent: categoryOfEvent, eventOrg: eventOrg, eventWebsite: eventWebsite, price: price, numTickets: numTickets, contactInfo: contactInfo, additionalInfo: additionalInfo, postingUserID: postingUserID, documentID: documentID)
    }
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        //Grab user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            return completed(false)
        }
        self.postingUserID = postingUserID
        let dataToSave = self.dictionary
        if self.documentID != "" {
            let ref = db.collection("events").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection("events").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("*** ERROR: creating new document \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ new document created with ref ID \(ref?.documentID ?? "unknown")")
                    self.documentID = ref!.documentID
                    completed(true)
                }
            }
        }
    }
    
    func deleteData(event: EventInfo, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("events").document(documentID).delete() { error in
            if let error = error {
                print("***Error: deleting review documentID \(self.documentID) \(error.localizedDescription)")
                completed(false)
            } else {
                //something maybe?
            }
        }
    }
}

/*

func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
    let db = Firestore.firestore()
    let dataToSave = self.dictionary
    if self.documentID != "" {
        let ref = db.collection("spots").document(spot.documentID).collection("reviews").document(self.documentID)
        ref.setData(dataToSave) { (error) in
            if let error = error {
                print("*** Error: updating document \(self.documentID) in spot \(spot.documentID) \(error.localizedDescription)")
                completed(false)
            } else {
                print("^^ Document updated with ref ID \(ref.documentID)")
                spot.updateAverageRating {
                    completed(true)
                }
            }
        }
    } else {
        var ref: DocumentReference? = nil
        ref = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave) { error in
            if let error = error {
                print("*** Error: creating new document in spot \(spot.documentID) for new review DocumentID \(error.localizedDescription)")
                completed(false)
            } else {
                print("^^^ new document created with ref ID \(ref?.documentID ?? "unknown")")
                self.documentID = ref!.documentID
                spot.updateAverageRating {
                    completed(true)
                }
            }
        }
    }
}

func deleteData(spot: Spot, completed: @escaping (Bool) -> ()) {
    let db = Firestore.firestore()
    db.collection("spots").document(spot.documentID).collection("reviews").document(documentID).delete() { error in
        if let error = error {
            print("***Error: deleting review documentID \(self.documentID) \(error.localizedDescription)")
            completed(false)
        } else {
            spot.updateAverageRating {
                completed(true)
            }
        }
    }
}
*/


