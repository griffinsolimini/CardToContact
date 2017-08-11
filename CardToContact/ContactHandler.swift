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
        let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :"1234567890" ))
        contact.phoneNumbers = [homePhone]
        
        return contact
        
    }
    
}
