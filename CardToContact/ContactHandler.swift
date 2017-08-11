//
//  ContactHandler.swift
//  CardToContact
//
//  Created by Griffin Solimini and Jansen Besecker on 8/9/17.
//  Copyright © 2017 Griffin Solimini. All rights reserved.
//

import Foundation

class ContactHandler {
    // define contact struct
    struct Contact {
        var email, phoneNumber, faxNumber, firstName, lastName, company, notes, address1, address2: String
        init() {
            //initial values for variables
            email = "hollaBackatCha@aim.com"
            phoneNumber = "5138675309"
            faxNumber = "people still have these?"
            firstName = "Lavender"
            lastName = "Gooms"
            company = "bronson bros brewing"
            address1 = "shelterly challenged"
            address2 = "Cbus, OH 43210"
            notes = ""
        }
    }
    func makeContact(rawText: String) {
        // TODO Jansen
        var myContact = Contact()
        print(rawText)
        //Create array of strings based on line
        let filteredText = rawText.components(separatedBy: "\n")
        print(filteredText)
        for line in filteredText {
            //remove non-numeric characters
            let result = String(line.characters.filter { "01234567890.".characters.contains($0) }).characters.count
            let eChar: Character = "@"
            //check for standard phone length
            if result == 10 {
                //eliminate fax
                let faxChar: Character = "f"
                if line.lowercased().characters.contains(faxChar) {
                    myContact.faxNumber = String(line.characters.filter { "01234567890.".characters.contains($0) })
                }
                    //store phone number
                else {
                    myContact.phoneNumber = String(line.characters.filter { "01234567890.".characters.contains($0) })
                }
            }
            else if line.characters.contains(eChar)
            {
                myContact.email = line
                
            }
                // Check if Address line has been changed and if numbers were found (zip code or house #)
            else if myContact.address1 == "shelterly challenged" && result > 2 {
                myContact.address1=line
            }
                //Check if numbers were found( Zip Code and House #)
            else if  result > 2 {
                myContact.address2 = line
            }
        }
        //display contact info
        print(myContact)
    }
    
}
