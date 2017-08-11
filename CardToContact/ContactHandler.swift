//
//  ContactHandler.swift
//  CardToContact
//
//  Created by Griffin Solimini on 8/9/17.
//  Copyright © 2017 Griffin Solimini. All rights reserved.
//

import Foundation
import Contacts
import UIKit
import ContactsUI

class ContactHandler {
    
    func makeContact(rawText: String) -> CNMutableContact {
        // TODO Jansen
        
        print(rawText)
        
        let contact = CNMutableContact()
        
        contact.givenName = "First"
        contact.familyName = "Last"
        contact.organizationName = "Company"
        contact.jobTitle = "Title"
        
        let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :"2312312341"))
        let cellPhone = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: "2312312341"))
        let workPhone = CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: "2312312341"))
        let homeFax = CNLabeledValue(label: CNLabelPhoneNumberHomeFax, value: CNPhoneNumber(stringValue: "2345612341"))
        let workFax = CNLabeledValue(label: CNLabelPhoneNumberWorkFax, value: CNPhoneNumber(stringValue: "2345612341"))
        
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: NSString(string: "email@gmail.com"))
        let workEmail = CNLabeledValue(label: CNLabelWork, value: NSString(string: "email@gmail.com"))
        
        contact.phoneNumbers = [homePhone, cellPhone, workPhone, homeFax, workFax]
        contact.emailAddresses = [homeEmail, workEmail]
        
        return contact
        
    }
    
}
