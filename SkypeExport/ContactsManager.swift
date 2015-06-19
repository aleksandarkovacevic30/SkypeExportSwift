//
//  ContactsManager.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 5/8/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Foundation
import SQLite


protocol ContactsManager{

    
    //TODO look for swift hashtable data structure
    func getContactDetailForSkypeuser(reqid: Int)->Contact
    
    func getAllContactDetails()->[Contact]
        
    func listAllContactDetailOptions() -> [String]
    
    func getAllContacts() -> [Int]
    
    
}