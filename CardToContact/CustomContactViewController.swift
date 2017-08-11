//
//  CustomContactViewController.swift
//  CardToContact
//
//  Created by Griffin Solimini on 8/10/17.
//  Copyright © 2017 Griffin Solimini. All rights reserved.
//

import Foundation
import ContactsUI

class CustomContactViewController : CNContactViewController {
    
    var viewController: ViewController?
    
    override func viewWillDisappear(_ animated: Bool) {
        
        viewController?.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }
    
}
