//
//  AppDelegate.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 2/11/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var skypeUserName: NSComboBox!
    
    @IBOutlet weak var dialogPartner: NSTextField!

    @IBOutlet weak var skypeContacts: NSComboBox!
    @IBOutlet weak var macUsername: NSComboBox!
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        let (filenamesOpt, errorOpt) = contentsOfDirectoryAtPath("/Users")
        
        if let filenames=filenamesOpt?.filter(isMacUserName) {
            for item in filenames {
                macUsername.addItemWithObjectValue(item)
            }
        }
    }

    func isBusyHandler(Check: Int) -> Bool {
        let myPopup:NSAlert = NSAlert()
        myPopup.messageText = "Skype Database is Locked"
        myPopup.informativeText = "You need to quit skype before using Skype Exporter."
        myPopup.runModal()
        return true;
    }
    
    func errorHandler(error: SkypeDB.ERRORS) -> Void {
        let myPopup:NSAlert = NSAlert()
        myPopup.messageText = "Error"
        switch error {
        case SkypeDB.ERRORS.DB_FILE_NOT_FOUND:
            myPopup.informativeText = "Database File Not Found"
        case SkypeDB.ERRORS.DATABASE_NOT_LOADED:
            myPopup.informativeText = "Database could not be loaded"
        default:
            myPopup.informativeText = "Unknown Error Occurred"
        }
        myPopup.runModal()
    }


    @IBAction func loadSkypeUsers(sender: NSButton) {
        let (filenamesOpt, errorOpt) = contentsOfDirectoryAtPath("/Users/\(macUsername.stringValue)/Library/Application Support/Skype")
        
        if let filenames=filenamesOpt?.filter(isSkypeUserName) {
            for item in filenames {
                skypeUserName.addItemWithObjectValue(item)
            }
        }
        
    }
    
    @IBAction func getSkypeContacts(sender: AnyObject) {
        let dbPath="/Users/\(macUsername.stringValue)/Library/Application Support/Skype/\(skypeUserName.stringValue)/main.db"
        let skypeDB=SkypeDB(pathToDB: dbPath, isBusyHandler,errorHandler);
        let users=skypeDB.getSkypeContacts(fromSkypeUser: skypeUserName.stringValue)
        for user in users {
            skypeContacts.addItemWithObjectValue("\(user)")
        }
        
    }

    
    @IBAction func loadSkypeMessages(sender: AnyObject) {
        let dbPath="/Users/\(macUsername.stringValue)/Library/Application Support/Skype/\(skypeUserName.stringValue)/main.db"
        let skypeDB=SkypeDB(pathToDB: dbPath, isBusyHandler,errorHandler);
        let messages=skypeDB.getMessages(fromSkypeUser: skypeUserName.stringValue, withDialogPartner: skypeContacts.stringValue)
        var result:String="";
        for message in messages {
            result.extend("from: \(message.from), to: \(message.to), timestamp: \(message.timestamp), message: \(message.message)")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
        }
        
        let myPopup:NSAlert = NSAlert()
        myPopup.messageText = "Messages are displayed on consoel output.";
        myPopup.informativeText = "not here"
        myPopup.runModal()
        println("\(skypeContacts.stringValue)")
        println("\(result)")
    }
    @IBAction func exportAsCSV(sender: AnyObject) {
        var myFiledialog: NSSavePanel = NSSavePanel()
        
        myFiledialog.prompt = "Export"
        myFiledialog.worksWhenModal = true
        myFiledialog.title = "Choose Path"
        myFiledialog.message = "Please choose a path"
        myFiledialog.runModal()
        var chosenfile = myFiledialog.URL
        if (chosenfile != nil)
        {
            var TheFile = chosenfile?.path!
            
            let dbPath="/Users/\(macUsername.stringValue)/Library/Application Support/Skype/\(skypeUserName.stringValue)/main.db"
            let skypeDB=SkypeDB(pathToDB: dbPath, isBusyHandler,errorHandler);
            let messages=skypeDB.getMessages(fromSkypeUser: skypeUserName.stringValue, withDialogPartner: skypeContacts.stringValue)
            
            let exporter = SkypeExporterOutput()
            
            let result = exporter.saveToCSV(usingSelectedPath:"\(TheFile!)", messageTuples: messages)
            let myPopup:NSAlert = NSAlert()
            if (result) {
                myPopup.messageText = "Export Result";
                myPopup.informativeText = "Export to CSV is successful\nExported to \(TheFile!)"
            } else {
                myPopup.messageText = "Export Result";
                myPopup.informativeText = "Export to CSV failed"
                
            }
            
            
            myPopup.runModal()


        }
        else
        {
            println ("No file chosen")
        }
    }
    @IBAction func exportHTML(sender: AnyObject) {
        var myFiledialog: NSSavePanel = NSSavePanel()
        
        myFiledialog.prompt = "Export"
        myFiledialog.worksWhenModal = true
        myFiledialog.title = "Choose Path"
        myFiledialog.message = "Please choose a path"
        myFiledialog.runModal()
        var chosenfile = myFiledialog.URL
        if (chosenfile != nil)
        {
            var TheFile = chosenfile?.path!
            
            let dbPath="/Users/\(macUsername.stringValue)/Library/Application Support/Skype/\(skypeUserName.stringValue)/main.db"
            let skypeDB=SkypeDB(pathToDB: dbPath, isBusyHandler,errorHandler);
            let messages=skypeDB.getMessages(fromSkypeUser: skypeUserName.stringValue, withDialogPartner: skypeContacts.stringValue)
            
            let exporter = SkypeExporterOutput()
            
            let result = exporter.saveToHTML(usingSelectedPath:"\(TheFile!)", messageTuples: messages)
            let myPopup:NSAlert = NSAlert()
            if (result) {
                myPopup.messageText = "Export Result";
                myPopup.informativeText = "Export to HTML is successful\nExported to \(TheFile!)"
            } else {
                myPopup.messageText = "Export Result";
                myPopup.informativeText = "Export to HTML failed"
                
            }
            
            
            myPopup.runModal()
            
            
        }
        else
        {
            println ("No file chosen")
        }
    }
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func isMacUserName(text: String) -> Bool {
        return !text.hasPrefix(".") && text != "Shared" && text != "Guest"
    }
    func isSkypeUserName(text: String) -> Bool {

        return text.rangeOfString(".") == nil && !text.hasPrefix("shared_") && text != "Upgrade" && text != "DataRv"
    }
    
    
    // Tuple result
    
    // Get contents of directory at specified path, returning (filenames, nil) or (nil, error)
    func contentsOfDirectoryAtPath(path: String) -> (filenames: [String]?, error: NSError?) {
        var error: NSError? = nil
        let fileManager = NSFileManager.defaultManager()
        let contents = fileManager.contentsOfDirectoryAtPath(path, error: &error)
        if contents == nil {
            return (nil, error)
        }
        else {
            let filenames = contents as [String]
            return (filenames, nil)
        }
    }
  
    
    
    
/*    if let filenames = filenamesOpt {
        let myPopup:NSAlert = NSAlert()
        myPopup.messageText = "Modal NSAlert Popup";
        myPopup.informativeText = "Echo that variable:"// \(filenames)"
        myPopup.runModal()
         // [".localized", "kris", ...]
    }
    
    let (filenamesOpt2, errorOpt2) = contentsOfDirectoryAtPath("/NoSuchDirectory")
    if let err = errorOpt2 {
        err.description // "Error Domain=NSCocoaErrorDomain Code=260 "The operation couldn’t be completed. ... "
    }
    
*/
    

}

