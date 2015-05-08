//
//  MessagesManager.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 5/8/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Foundation

class MessagesManager {

    public func getSkypeContacts() -> [String] {
        var result:[String]=[]
        if let dbase = self.db {
            let contacts=dbase["Contacts"]
            //select skypename from Contacts where type=1;
            let skypename = Expression<String?>("skypename")
            let type = Expression<Int?>("type")
            let query = contacts.select(skypename)
                .filter(type == 1)
                .order(skypename.asc)
            
            for row in query {
                result += ["\(row[skypename]!)"]
                // id: 1, name: Optional("Alice"), email: alice@mac.com
            }
        }
        return result;
        
    }
    
    func listAllContactDetailOptions() -> [String]{
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("ContactsColumns", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        var results:[String] = []
        if let dict = myDict {
            for value in dict.allValues {
                results += ["\(value)"]
            }
        }
        return results
    }
    
    //TODO look for swift hashtable data structure
    public func getContactDetailsForSkypeContact(name: String, havingContactDetails:[String])->[([(String,String)])]{
        let query=prepareContactDetails(forSkypeName: name, havingContactDetails: havingContactDetails)
        var result:[([(String,String)])]=[]
        if let dbase = self.db {
            let stmt = dbase.prepare(query)
            for row in stmt {
                var newRow:[(String,String)]=[]
                var i:Int = 0;
                for col in havingContactDetails {
                    newRow+=[("\(col)","\(row[i])")]
                    i++
                }
            }
        }
        return result
    }
    
    func prepareContactDetails(forSkypeName skypename: String, havingContactDetails contactDetails:[String]) -> String{
        let select="SELECT"
        let from="FROM CONTACTS"
        var whereQuery="WHERE skypename=\""
        var finalQuery=""
        var cols=""
        // todo find a nicer way to merge string array in swift
        if contactDetails.count>0 {
            for contactDetail in contactDetails {
                if contactDetail == contactDetails.last! {
                    cols+="\(contactDetail)"
                } else {
                    cols+="\(contactDetail) ,"
                }
            }
        } else {
            cols="*"
        }
        
        if (skypename=="") {
            whereQuery=""
        } else {
            whereQuery+="\(skypename)\""
        }
        return "\(select) \(cols) \(from) \(whereQuery);";
    }
    
    public func getAllContacts(havingContactDetails:[String]) -> [String] {
        let skypeContacts:[String] = getSkypeContacts();
        var result:[(skypeName:String, messages: [(from:String, timestamp:String, message:String)])]=[]
        for skypeContact in skypeContacts {
            var messagesForSkypeContact: [(from:String, timestamp:String, message:String)] = getMessagesForSkypeContact(dialogPartner: skypeContact)
            result+=[(skypeName: "\(skypeContact)", messages: messagesForSkypeContact)]
        }
        return result
        
        /*
        var result:[String]=[]
        if let dbase = self.db {
        let contacts=dbase["Contacts"]
        //select skypename from Contacts where type=1;
        let skypename = Expression<String?>("skypename")
        let type = Expression<Int?>("type")
        let query = contacts.select(skypename)
        .filter(type == 1)
        .order(skypename.asc)
        
        for row in query {
        result += ["\(row[skypename]!)"]
        // id: 1, name: Optional("Alice"), email: alice@mac.com
        }
        }
        return result;
        
        */
        // TODO
        return [""]
    }
    
    func getConversationIDsForSkypeContact(dialogPartner diaPartner:String) -> [Int?] {
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
    
    func getMessagesForSkypeContact(dialogPartner diaPartner: String) -> [(from:String, timestamp:String, message:String)] {
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
    
    func getAllMessages() -> [(skypeName:String, messages: [(from:String, timestamp:String, message:String)])] {
        let skypeContacts:[String] = getSkypeContacts();
        var result:[(skypeName:String, messages: [(from:String, timestamp:String, message:String)])]=[]
        for skypeContact in skypeContacts {
            var messagesForSkypeContact: [(from:String, timestamp:String, message:String)] = getMessagesForSkypeContact(dialogPartner: skypeContact)
            result+=[(skypeName: "\(skypeContact)", messages: messagesForSkypeContact)]
        }
        return result
    }

}