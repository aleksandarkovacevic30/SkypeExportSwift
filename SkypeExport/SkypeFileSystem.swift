//
//  SkypeFileSystem.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 2/12/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Foundation

class SkypeExporterOutput {

    
    //TODO - fix the double quotes when they appear in the text
    func saveToCSV(usingSelectedPath path: String, messageTuples messages: [(from:String, to:String, timestamp:String, message:String)]) -> Bool {
        var csvResult="\"from\":\"to\":\"timestamp\":\"message\"\n"
        for message in messages {
            csvResult += "\"\(message.from)\":\"\(message.to)\":\"\(message.timestamp)\":\"\(message.message)\"\n"
        }
        return csvResult.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);

    }
    func saveToHTML(usingSelectedPath path: String, messageTuples messages: [(from:String, to:String, timestamp:String, message:String)]) -> Bool {

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
        
        var htmlResult="<html><body><table><thead><tr><th>From</th><th>To</th><th>TimeStamp</th><th>Message</th></tr></thead><tbody>\n"
        for message in messages {
            htmlResult += "<tr><td>\(message.from)</td><td>\(message.to)</td><td>\(message.timestamp)</td><td>\(message.message)</td></tr>\n"
        }
        htmlResult += "</tbody></table></body></html>"
        return htmlResult.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
        
    }
    
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
