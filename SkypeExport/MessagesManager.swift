//
//  MessagesManager.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 5/8/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Foundation
import SQLite

protocol MessagesManager {

    
func getConversationIDsForSkypeContact(dialogPartner diaPartner:String) -> [Int?]
    
func getMessagesForSkypeContact(dialogPartner diaPartner: String) -> [(from:String, dialog_partner:String, timestamp:String, message:String)]
    
func getSkypeContacts() -> [String]
    
func getAllMessages() -> [(skypeName:String, messages: [(from:String, dialog_partner:String, timestamp:String, message:String)])]

}