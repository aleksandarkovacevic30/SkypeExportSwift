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
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let skypePath:String = "\(getAppSupportDir()!)/Skype"
        let (filenamesOpt, errorOpt) = contentsOfDirectoryAtPath(skypePath)
        
        if let filenames=filenamesOpt?.filter(isSkypeUserName) {
            for item:(filename: String, isDir: Bool) in filenames {
                skypeUserName.addItemWithObjectValue(item.filename)
            }
        }
    }

    @IBAction func loadContactOptionsDialog(sender: AnyObject) {
        
    }
    func isBusyHandler(Check: Int) -> Bool {
        let myPopup:NSAlert = NSAlert()
        myPopup.messageText = "Skype Database is Locked"
        myPopup.informativeText = "You need to quit skype before using Skype Exporter."
        myPopup.runModal()
        return true
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
    
    @IBAction func showSkypeContacts(sender: AnyObject) {
        let dbPath="\(getAppSupportDir()!)/Skype/\(skypeUserName.stringValue)/main.db"
        let skypeDB=SkypeDB(skypeUser: skypeUserName.stringValue, isBusyHandler: isBusyHandler,errorHandler: errorHandler,debugPath: "")
        let contactsManager:ContactsManager=ContactsManager(skypedb: skypeDB)
        let users=contactsManager.getSkypeContacts()
        for user in users {
            skypeContacts.addItemWithObjectValue("\(user)")
        }
        
    }

    
    @IBAction func loadSkypeMessages(sender: AnyObject) {
        let skypeDB=SkypeDB(skypeUser: skypeUserName.stringValue, isBusyHandler: isBusyHandler,errorHandler: errorHandler,debugPath: "");
/*        let messages=skypeDB.getMessagesForSkypeContact(dialogPartner: skypeContacts.stringValue)
        var result:String="";
        for message in messages {
            result.extend("from: \(message.from), timestamp: \(message.timestamp), message: \(message.message)")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
        }
        
        let myPopup:NSAlert = NSAlert()
        myPopup.messageText = "Messages are displayed on consoel output.";
        myPopup.informativeText = "not here"
        myPopup.runModal()
        println("\(skypeContacts.stringValue)")
        println("\(result)")*/
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
            
            let dbPath="\(getAppSupportDir()!)/Skype/\(skypeUserName.stringValue)/main.db"
            let skypeDB=SkypeDB(skypeUser: dbPath, isBusyHandler: isBusyHandler,errorHandler: errorHandler,debugPath: "");
/*            let messages=skypeDB.getMessagesForSkypeContact(dialogPartner: skypeContacts.stringValue)
            
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

*/
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
            
            let dbPath="\(getAppSupportDir()!)/Skype/\(skypeUserName.stringValue)/main.db"
            let skypeDB=SkypeDB(skypeUser: skypeUserName.stringValue, isBusyHandler: isBusyHandler,errorHandler: errorHandler,debugPath: "");
/*           let messages=skypeDB.getMessagesForSkypeContact(dialogPartner: skypeContacts.stringValue)
            
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
  */          
            
        }
        else
        {
            println ("No file chosen")
        }
    }
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func isMacUserName(text: String, isDir:Bool) -> Bool {
        return isDir && !text.hasPrefix(".") && text != "Shared" && text != "Guest"
    }
    func isSkypeUserName(text: String, isDir:Bool) -> Bool {
        return isDir && !text.hasPrefix("shared_") && text != "Upgrade" && text != "DataRv"
    }
    
    func isDir(path: String) -> Bool {
        var error: NSError?
//        let documentURL : NSURL? = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.UserDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: &error)
        var isDirectory: ObjCBool = ObjCBool(false)
        NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDirectory);
        return isDirectory.boolValue
    }
    
    // Tuple result
    
    // Get contents of directory at specified path, returning (filenames, nil) or (nil, error)
    func contentsOfDirectoryAtPath(path: String) -> (filenames: [(filename: String, isDir: Bool)]?, error: NSError?) {

        var error: NSError?
        var result: [(filename: String, isDir: Bool)] = []
        let fileManager = NSFileManager.defaultManager()

        let contents = fileManager.contentsOfDirectoryAtPath(path, error: &error)
        if contents != nil  {
            let filenames = contents as [String]
            for filename in filenames {
                    result += [(filename: filename, isDir: isDir(path+"/"+filename))]
            }
        }
        return (result,nil);
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

