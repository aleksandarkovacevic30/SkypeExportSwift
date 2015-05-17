//
//  MessagesManager.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 5/8/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Foundation
import SQLite

public class MessagesManager {

    
    var db:Database?
    
    init(skypedb:SkypeDB) {
        if let db=skypedb.db {
            self.db=db
        }
    }

    public func getConversationIDsForSkypeContact(dialogPartner diaPartner:String) -> [Int?] {
        var convoids = [Int?]()
        if let dbase=self.db {
            let conversations=dbase["Conversations"]
            let cid=Expression<Int?>("id")
            let identity=Expression<String?>("identity")
            let cids = conversations.select(cid)
                .filter(identity == diaPartner)
            for id in cids {
                convoids.append(Int(id[cid]!));
            }
        }
        return convoids
    }
    
    public func getMessagesForSkypeContact(dialogPartner diaPartner: String) -> [(from:String, timestamp:String, message:String)] {
        var result:[(from:String, timestamp:String, message:String)]=[]
        if let dbase=self.db {
            let messages=dbase["Messages"]
            let convoids = getConversationIDsForSkypeContact(dialogPartner: "\(diaPartner)")
            let convo_id=Expression<Int?>("convo_id")
            let author = Expression<String?>("author")
            let dialog_partner = Expression<String?>("dialog_partner")
            let timeInEpochs = Expression<Int?>("timestamp")
            let body = Expression<String?>("body_xml")
            let query = messages.select(author,dialog_partner,timeInEpochs,body,convo_id)           // SELECT "email" FROM "users"
                .filter(contains(convoids,convo_id))     // WHERE "name" IS NOT NULL
                .order(timeInEpochs.desc) // ORDER BY "email" DESC, "name"
            var formattedTimestamp:String="";
            for message in query {
                var epochs:Double = Double(message[timeInEpochs]!);
                formattedTimestamp=printFormattedDate(NSDate(timeIntervalSince1970: epochs))
                result += [(from: "\(message[author]!)",
                    timestamp: "\(formattedTimestamp)",
                    message: "\(message[body]!)")]
            }
        }
        
        return result
    }
    
    public func getSkypeContacts() -> [String] {
        var result:[String]=[]
        if let dbase = self.db {
            let contacts=dbase["Contacts"]
            //select skypename from Contacts where type=1;
            let skypename = Expression<String?>("skypename")
            let type = Expression<Int?>("type")
            var query = contacts.select(skypename)
                .filter(type == 1)
                .order(skypename.asc)
            
            for row in query {
                result += ["\(row[skypename]!)"]
                // id: 1, name: Optional("Alice"), email: alice@mac.com
            }
        }
        return result
    }

    
    public func getAllMessages() -> [(skypeName:String, messages: [(from:String, timestamp:String, message:String)])] {
        let skypeContacts:[String] = getSkypeContacts()
        var result:[(skypeName:String, messages: [(from:String, timestamp:String, message:String)])]=[]
        for skypeContact in skypeContacts {
            var messagesForSkypeContact: [(from:String, timestamp:String, message:String)] = getMessagesForSkypeContact(dialogPartner: skypeContact)
            result+=[(skypeName: "\(skypeContact)", messages: messagesForSkypeContact)]
        }
        return result
    }

}