//
//  SkypeFileSystem.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 2/12/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Foundation

public class SkypeExporterOutput {

    
    public func prepareMessagesForExport(messages:[Message])->[[String]]{
        var messageData:[[String]]=[]
        messageData+=[["author",
            "dialog_partner",
            "from_dispname",
            "identities",
            "participant_count",
            "timestamp",
            "body_xml"]]
        
        for message in messages {
            var singlemessage:[String]=[]
            if let author=message.author {
                singlemessage+=[author]
            } else {
                singlemessage+=[""]
            }
            if let dname=message.dialog_partner {
                singlemessage+=[dname]
            } else {
                singlemessage+=[""]
            }
            if let fname=message.from_dispname {
                singlemessage+=[fname]
            } else {
                singlemessage+=[""]
            }
            if let ids=message.identities {
                singlemessage+=[ids]
            } else {
                singlemessage+=[""]
            }
            if let pcount=message.participant_count {
                singlemessage+=[String(pcount)]
            } else {
                singlemessage+=[""]
            }
            if let tstamp=message.timestamp {
                singlemessage+=[printFormattedDate(NSDate(timeIntervalSince1970: Double(tstamp)))]
            } else {
                singlemessage+=[""]
            }
            if let body=message.body_xml {
                singlemessage+=[body]
            } else {
                singlemessage+=[""]
            }
            messageData+=[singlemessage]
        }
        return messageData
    }
   
    public func prepareContactsForExport(contacts:[Contact])->[[String]]{
        var contactData:[[String]]=[]
        contactData+=[["skypename",
                "given_displayname",
                "fullname",
                "gender",
                "main_phone",
                "phone_home",
                "phone_mobile",
                "phone_office",
                "emails",
                "timezone",
                "type",
                "nr_of_buddies"]]
            
            for contact in contacts {
                var singleContact:[String]=[]
                if let sname=contact.skypename {
                    singleContact+=[sname]
                } else {
                    singleContact+=[""]
                }
                if let dname=contact.given_displayname {
                    singleContact+=[dname]
                } else {
                    singleContact+=[""]
                }
                if let fname=contact.fullname {
                    singleContact+=[fname]
                } else {
                    singleContact+=[""]
                }
                if let gender=contact.gender {
                    singleContact+=[gender==1 ? "male": "female"]
                } else {
                    singleContact+=[""]
                }
                if let mphone=contact.main_phone {
                    singleContact+=[mphone]
                } else {
                    singleContact+=[""]
                }
                if let phome=contact.phone_home {
                    singleContact+=[phome]
                } else {
                    singleContact+=[""]
                }
                if let pmobile=contact.phone_mobile {
                    singleContact+=[pmobile]
                } else {
                    singleContact+=[""]
                }
                if let poffice=contact.phone_office {
                    singleContact+=[poffice]
                } else {
                    singleContact+=[""]
                }
                if let vemail=contact.emails {
                    singleContact+=[vemail]
                } else {
                    singleContact+=[""]
                }
                if let tzone=contact.timezone {
                    singleContact+=[String(tzone)]
                } else {
                    singleContact+=[""]
                }
                if let typ=contact.type {
                    singleContact+=[typ==1 ? "skype" : "external"]
                } else {
                    singleContact+=[""]
                }
                if let nbuddies=contact.nr_of_buddies {
                    singleContact+=[String(nbuddies)]
                } else {
                    singleContact+=[""]
                }
                contactData+=[singleContact]
            }
            return contactData
        
    }
    
    //TODO - fix the double quotes when they appear in the text
    public func saveToCSV(usingSelectedPath path: String, data text: [[String]]) -> Bool {
        var csvResult=""
        for row in text {
            for cell in row {
                if cell == row.last {
                    csvResult += "\"\(cell)\""
                } else {
                    csvResult += "\"\(cell)\":"
                }
            }
            csvResult+="\n"
        }
        return csvResult.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);

    }
    public func saveToHTML(usingSelectedPath path: String, data text: [[String]]) -> Bool {

        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
/*        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            let path = dir.stringByAppendingPathComponent(file);
            let text = "some text"
            
            //writing
            text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
            
            //reading
            let text2 = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        }*/
        var htmlResult="<html><body><table>"
        for row in text {
            if row == text.first! {
                htmlResult+="<thead><tr>"
                for cell in row {
                        htmlResult+="<th>\(cell)</th>"
                }
                htmlResult+="</tr></thead><tbody>\n"
            } else {
                htmlResult+="<tr>"
                for cell in row {
                    htmlResult+="<td>\(cell)</td>"
                }
                htmlResult+="</tr>\n"
            }
        }
    
        htmlResult += "</tbody></table></body></html>"
        return htmlResult.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
        
    }
    public func getAppSupportDir() -> String? {
        var error: NSError?
        
        let userURL : NSURL? = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomain: NSSearchPathDomainMask.AllDomainsMask, appropriateForURL: nil, create: true, error: &error)
        return userURL?.path
    }
    
    public func getCurrDir() -> String? {
        var error: NSError?
        
        let userURL : NSURL? = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.ApplicationDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: &error)
        return userURL?.path
    }
    func printFormattedDate(date: NSDate) -> String {
        let dateformat = NSDateFormatter()
        dateformat.timeStyle = .ShortStyle
        dateformat.dateStyle = .MediumStyle
        
        var stringDate = dateformat.stringFromDate(date)
        return stringDate
    }
}
