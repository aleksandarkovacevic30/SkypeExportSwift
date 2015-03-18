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
    /* todo
    modify the query to the new one
    select author, timestamp, body_xml from Messages where convo_id in (select id from Conversations where identity = '$2');
*/
    func getMessages(fromSkypeUser skypeUser:String, withDialogPartner diaPartner: String) -> [(from:String, timestamp:String, message:String)] {
        println("input: skypeUser - \(skypeUser) , dialogPartner - \(diaPartner)")
        var result:[(from:String, timestamp:String, message:String)]=[]
        if let dbase=self.db {
            let messages=dbase["Messages"]
            let conversations=dbase["Conversations"]
            let cid=Expression<Int?>("id")
            let identity=Expression<String?>("identity")
            let cids = conversations.select(cid)
                .filter(identity == diaPartner)
            var convoids = [Int?]()
            for id in cids {
                convoids.append(Int(id[cid]!));
            }
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
                // id: 1, name: Optional("Alice"), email: alice@mac.com
            }
        }
        
        return result;
    }

    
    func getMessages2(fromSkypeUser skypeUser:String, withDialogPartner diaPartner: String) -> [(from:String, to:String, timestamp:String, message:String)] {
        println("input: skypeUser - \(skypeUser) , dialogPartner - \(diaPartner)")
        var result:[(from:String, to:String, timestamp:String, message:String)]=[]
        if let dbase=self.db {
            let messages=dbase["Messages"]
            let author = Expression<String?>("author")
            let dialog_partner = Expression<String?>("dialog_partner")
            let timeInEpochs = Expression<Int?>("timestamp")
            let body = Expression<String?>("body_xml")
            let query = messages.select(author,dialog_partner,timeInEpochs,body)           // SELECT "email" FROM "users"
                .filter(dialog_partner == diaPartner)     // WHERE "name" IS NOT NULL
                .order(timeInEpochs.desc) // ORDER BY "email" DESC, "name"
            var formattedTimestamp:String="";
            for message in query {
                var epochs:Double = Double(message[timeInEpochs]!);
                formattedTimestamp=printFormattedDate(NSDate(timeIntervalSince1970: epochs))
                    result += [(from: "\(message[author]!)",
                        to: "\(message[dialog_partner]!)",
                        timestamp: "\(formattedTimestamp)",
                        message: "\(message[body]!)")]
            // id: 1, name: Optional("Alice"), email: alice@mac.com
            }
        }
        
        return result;
    }
    
    func getContacts(ofSkypeUser skypeUser:String) -> [(name:String, contactName:String, phone:String)]{
        var dummy:[(name:String, contactName:String, phone:String)] = []
        dummy += [(name:"Sandra", contactName:"sandrestina", phone:"1234567")]
        return dummy;
    }
/*select author,dialog_partner,datum as datetime(timestamp, 'unixepoch', 'localtime'),body_xml from Messages where dialog_partner = '$2';*/

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