//
//  SkypeSQLiteDao.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 2/12/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Foundation
import SQLite

public class SkypeDB {
    public enum ERRORS {
        case DATABASE_NOT_LOADED
        case DB_FILE_NOT_FOUND
        case DB_NON_EXISTING_SKYPENAME
        case NONE
    }
    var skypeUser: String
    var errorHandler: (ERRORS -> Void)
    public var lastError: ERRORS
    var db: Database?;
    
    public init(skypeUser skypeuser: String, isBusyHandler: (Int -> Bool), errorHandler: (ERRORS -> Void),debugPath: String) {
        self.skypeUser=skypeuser
        self.errorHandler=errorHandler
        self.lastError=ERRORS.NONE
        var userDirPath=getAppSupportDir()

        var path: String
        if debugPath != "" {
           path = debugPath
        } else {
            path = "\(userDirPath!)/Skype/\(skypeuser)/main.db"
        }
        
        
        if (NSFileManager.defaultManager().fileExistsAtPath(path)){
            self.db = Database(path, readonly: true)
            if let dbase = self.db {
                dbase.busy(isBusyHandler)
            } else {
                self.lastError=ERRORS.DATABASE_NOT_LOADED
                errorHandler(ERRORS.DATABASE_NOT_LOADED)
            }
        } else {
            self.lastError=ERRORS.DB_FILE_NOT_FOUND
            errorHandler(ERRORS.DB_FILE_NOT_FOUND)
        }
    }
    
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
    
    public func getContactDetailsForSkypeContact(name: String, havingContactDetails:[String]){
    }
    
    func prepareContactDetails(forSkypeName skypename: String, havingContactDetails contactDetails:[String]) -> String{
        let selectQuery1="SELECT"
        let selectQuery2="FROM CONTACTS"
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
        return "SELECT";

    }
    
    public func getAllContacts(havingContactDetails:[String]) -> [String] {
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
    
/*
let messages=db["Messages"]
let users = db["users"]
let id = Expression<Int>("id")
let name = Expression<String?>("name")
let email = Expression<String>("email")

db.create(table: users) { t in
    t.column(id, primaryKey: true)
    t.column(name)
    t.column(email, unique: true)
}
// CREATE TABLE "users" (
//     "id" INTEGER PRIMARY KEY NOT NULL,
//     "name" TEXT,
//     "email" TEXT NOT NULL UNIQUE
// )

var alice: Query?
if let insertId = users.insert(name <- "Alice", email <- "alice@mac.com") {
    println("inserted id: \(insertId)")
    // inserted id: 1
    alice = users.filter(id == insertId)
}
// INSERT INTO "users" ("name", "email") VALUES ('Alice', 'alice@mac.com')

for user in users {
    println("id: \(user[id]), name: \(user[name]), email: \(user[email])")
    // id: 1, name: Optional("Alice"), email: alice@mac.com
}
// SELECT * FROM "users"

alice?.update(email <- replace(email, "mac.com", "me.com"))?
// UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
// WHERE ("id" = 1)

alice?.delete()?
// DELETE FROM "users" WHERE ("id" = 1)

users.count
// SELECT count(*) FROM "users"
*/
}