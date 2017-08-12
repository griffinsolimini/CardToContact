//
//  ContactHandler.swift
//  CardToContact
//
//  Created by Griffin Solimini and Jansen Besecker on 8/9/17.
//  Copyright © 2017 Griffin Solimini. All rights reserved.
//

import Foundation
import Contacts
import UIKit
import ContactsUI

class ContactHandler {
    // define contact struct
    func makeContact(rawText: String) -> CNMutableContact {
        // TODO Jansen
        let contact = CNMutableContact()
        contact.givenName = "First"
        contact.familyName = "Last"
        contact.organizationName = "Company"
        contact.jobTitle = "Title"
        let homeAddress = CNMutablePostalAddress()
        homeAddress.street = "1 Infinite Loop"
        homeAddress.city = "Cupertino"
        homeAddress.state = "CA"
        homeAddress.postalCode = "95014"
        contact.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:homeAddress)]

        let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :"2312312341"))
        let workPhone = CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: "2312312341"))
        let cellPhone = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: "2312312341"))
        let workFax = CNLabeledValue(label: CNLabelPhoneNumberWorkFax, value: CNPhoneNumber(stringValue: "2345612341"))
        let workEmail = CNLabeledValue(label: CNLabelWork, value: NSString(string: "email@gmail.com"))
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: NSString(string: "email@gmail.com"))
        let homeFax = CNLabeledValue(label: CNLabelPhoneNumberHomeFax, value: CNPhoneNumber(stringValue: "2345612341"))

        contact.phoneNumbers = [homePhone, cellPhone, workPhone, homeFax, workFax]
        contact.emailAddresses = [homeEmail, workEmail]
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
                    contact.phoneNumbers[3] = CNLabeledValue(label: CNLabelPhoneNumberHomeFax, value: CNPhoneNumber(stringValue: "2345612341"))
                }
                //store phone number
                else {
                    contact.phoneNumbers[1] = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: "2312312341"))
                }
            }
            else if line.characters.contains(eChar)
                {
                contact.emailAddresses[1] = CNLabeledValue(label: CNLabelWork, value: NSString(string: "email@gmail.com"))
            
                }
            // Check if Address line has been changed and if numbers were found (zip code or house #)
            else if homeAddress.street == "1 infinite loop" && result > 2 {
                homeAddress.street = line
                }
            //Check if numbers were found( Zip Code and House #)
            else if  result > 2 {
                homeAddress.city = line
                }
            }
    //display contact info
   
        return contact
        }
    
    }
    
