//
//  SkypeSQLiteDao.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 2/12/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Foundation
import SQLite

public class SkypeDB: MessagesManager, ContactsManager {
    var exporter=SkypeExporterOutput()
    public enum CONTACT_TYPE {
        case SKYPE_CONTACT
        case ALL
    }

    public enum ERRORS {
        case DATABASE_NOT_LOADED
        case DB_FILE_NOT_FOUND
        case DB_NON_EXISTING_SKYPENAME
        case NONE
    }
    public var skypeUser: String
    public var errorHandler: (ERRORS -> Void)
    public var lastError: ERRORS
    public var db: Database?
    
    public init(skypeUser skypeuser: String, isBusyHandler: (Int -> Bool), errorHandler: (ERRORS -> Void),debugPath: String) {
        self.skypeUser=skypeuser
        self.errorHandler=errorHandler
        self.lastError=ERRORS.NONE
        var userDirPath=exporter.getAppSupportDir()

        var path: String
        if debugPath != "" {
           path = debugPath
        } else {
            path = "\(userDirPath!)/Skype/\(skypeuser)/main.db"
        }
        
        
        if (NSFileManager.defaultManager().fileExistsAtPath(path)){
            self.db = Database(path, readonly: true)
            if let dbase = self.db {
                dbase.busyHandler(isBusyHandler)
            } else {
                self.lastError=ERRORS.DATABASE_NOT_LOADED
                errorHandler(ERRORS.DATABASE_NOT_LOADED)
            }
        } else {
            self.lastError=ERRORS.DB_FILE_NOT_FOUND
            errorHandler(ERRORS.DB_FILE_NOT_FOUND)
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
    
    public func getMessagesForSkypeContact(dialogPartner diaPartner: String) -> [(from:String, dialog_partner:String, timestamp:String, message:String)] {
        var result:[(from:String, dialog_partner:String, timestamp:String, message:String)]=[]
        if let dbase=self.db {
            let messages=dbase["Messages"]
            let convoids = getConversationIDsForSkypeContact(dialogPartner: "\(diaPartner)")
            let convids=convoids.filter{ $0 != nil }.map{ $0! }
            let convo_id=Expression<Int?>("convo_id")
            let author = Expression<String?>("author")
            let dialog_partner = Expression<String?>("dialog_partner")
            let timeInEpochs = Expression<Int?>("timestamp")
            let body = Expression<String?>("body_xml")
            
            let query = messages.select(author,dialog_partner,timeInEpochs,body,convo_id)           // SELECT "email" FROM "users"
            //TODO fix the issue with these stupid errors, or use just a regular text for messages
        
            .filter(contains(convids,convo_id))     // WHERE "name" IS NOT NULL
             // ORDER BY "email" DESC, "name"
            .order(timeInEpochs.desc)
            var formattedTimestamp:String="";
            for message in query {
                if let auth=message[author] {
                    if let diapartner=message[dialog_partner] {
                        if let timestamp=message[timeInEpochs] {
                            if let body=message[body] {
                                result += [(from: "\(auth)",
                                    dialog_partner: "\(diapartner)",
                                    timestamp: "\(timestamp)",
                                    message: "\(body)")]
                                
                            }
                        }
                    }
                }
                
            }
        }
        return result
    }
    
    public func getSkypeContacts() -> [String] {
        var result:[String]=[]
        if let dbase=self.db {
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
    
    
    public func getAllMessages() -> [(skypeName:String, messages: [(from:String, dialog_partner:String, timestamp:String, message:String)])] {
        let skypeContacts:[String] = getSkypeContacts()
        var result:[(skypeName:String, messages: [(from:String, dialog_partner:String, timestamp:String, message:String)])]=[]
        for skypeContact in skypeContacts {
            var messagesForSkypeContact: [(from:String, dialog_partner:String, timestamp:String, message:String)] = getMessagesForSkypeContact(dialogPartner: skypeContact)
            result+=[(skypeName: "\(skypeContact)", messages: messagesForSkypeContact)]
        }
        return result
    }

    
    //TODO look for swift hashtable data structure
    public func getContactDetailForSkypeuser(reqid: Int)->Contact{
        var result:Contact=Contact()
        if let dbase = self.db {
            let contacts=dbase["Contacts"]
            //select skypename from Contacts where type=1;
            let id = Expression<Int?>("id")
            let is_permanent = Expression<Int?>("is_permanent")
            let type = Expression<Int?>("type")
            let skypename = Expression<String?>("skypename")
            let pstnnumber = Expression<String?>("pstnnumber")
            let aliases = Expression<String?>("aliases")
            let fullname = Expression<String?>("fullname")
            let birthday = Expression<Int?>("birthday")
            let gender = Expression<Int?>("gender")
            let languages = Expression<String?>("languages")
            let country = Expression<String?>("country")
            let province = Expression<String?>("province")
            let city = Expression<String?>("city")
            let phone_home = Expression<String?>("phone_home")
            let phone_office = Expression<String?>("phone_office")
            let phone_mobile = Expression<String?>("phone_mobile")
            let emails = Expression<String?>("emails")
            let hashed_emails = Expression<String?>("hashed_emails")
            let homepage = Expression<String?>("homepage")
            let about = Expression<String?>("about")
            let avatar_image = Expression<String?>("avatar_image")
            let mood_String = Expression<String?>("mood_String")
            let rich_mood_String = Expression<String?>("rich_mood_String")
            let timezone = Expression<Int?>("timezone")
            let capabilities = Expression<String?>("capabilities")
            let profile_timestamp = Expression<Int?>("profile_timestamp")
            let nrof_authed_buddies = Expression<Int?>("nrof_authed_buddies")
            let ipcountry = Expression<String?>("ipcountry")
            let avatar_timestamp = Expression<Int?>("avatar_timestamp")
            let mood_timestamp = Expression<Int?>("mood_timestamp")
            let received_authrequest = Expression<String?>("received_authrequest")
            let authreq_timestamp = Expression<Int?>("authreq_timestamp")
            let lastonline_timestamp = Expression<Int?>("lastonline_timestamp")
            let availability = Expression<Int?>("availability")
            let displayname = Expression<String?>("displayname")
            let refreshing = Expression<Int?>("refreshing")
            let given_authlevel = Expression<Int?>("given_authlevel")
            let given_displayname = Expression<String?>("given_displayname")
            let assigned_speeddial = Expression<String?>("assigned_speeddial")
            let assigned_comment = Expression<String?>("assigned_comment")
            let alertstring = Expression<String?>("alertstring")
            let lastused_timestamp = Expression<Int?>("lastused_timestamp")
            let authrequest_count = Expression<Int?>("authrequest_count")
            let assigned_phone1 = Expression<String?>("assigned_phone1")
            let assigned_phone1_label = Expression<String?>("assigned_phone1_label")
            let assigned_phone2 = Expression<String?>("assigned_phone2")
            let assigned_phone2_label = Expression<String?>("assigned_phone2_label")
            let assigned_phone3 = Expression<String?>("assigned_phone3")
            let assigned_phone3_label = Expression<String?>("assigned_phone3_label")
            let buddystatus = Expression<Int?>("buddystatus")
            let isauthorized = Expression<Int?>("isauthorized")
            let popularity_ord = Expression<Int?>("popularity_ord")
            let external_id = Expression<String?>("external_id")
            let external_system_id = Expression<String?>("external_system_id")
            let isblocked = Expression<Int?>("isblocked")
            let authorization_certificate = Expression<String?>("authorization_certificate")
            let certificate_send_count = Expression<Int?>("certificate_send_count")
            let account_modification_serial_nr = Expression<Int?>("account_modification_serial_nr")
            let saved_directory_String = Expression<String?>("saved_directory_String")
            let nr_of_buddies = Expression<Int?>("nr_of_buddies")
            let server_synced = Expression<Int?>("server_synced")
            let contactlist_track = Expression<Int?>("contactlist_track")
            let last_used_networktime = Expression<Int?>("last_used_networktime")
            let authorized_time = Expression<Int?>("authorized_time")
            let sent_authrequest = Expression<String?>("sent_authrequest")
            let sent_authrequest_time = Expression<Int?>("sent_authrequest_time")
            let sent_authrequest_serial = Expression<Int?>("sent_authrequest_serial")
            let buddyString = Expression<String?>("buddyString")
            let cbl_future = Expression<String?>("cbl_future")
            let node_capabilities = Expression<Int?>("node_capabilities")
            let revoked_auth = Expression<Int?>("revoked_auth")
            let added_in_shared_group = Expression<Int?>("added_in_shared_group")
            let in_shared_group = Expression<Int?>("in_shared_group")
            let authreq_history = Expression<String?>("authreq_history")
            let profile_attachments = Expression<String?>("profile_attachments")
            let stack_version = Expression<Int?>("stack_version")
            let offline_authreq_id = Expression<Int?>("offline_authreq_id")
            let node_capabilities_and = Expression<Int?>("node_capabilities_and")
            let authreq_crc = Expression<Int?>("authreq_crc")
            let authreq_src = Expression<Int?>("authreq_src")
            let pop_score = Expression<Int?>("pop_score")
            let authreq_nodeinfo = Expression<String?>("authreq_nodeinfo")
            let main_phone = Expression<String?>("main_phone")
            let unified_servants = Expression<String?>("unified_servants")
            let phone_home_normalized = Expression<String?>("phone_home_normalized")
            let phone_office_normalized = Expression<String?>("phone_office_normalized")
            let phone_mobile_normalized = Expression<String?>("phone_mobile_normalized")
            let sent_authrequest_initmethod = Expression<Int?>("sent_authrequest_initmethod")
            let authreq_initmethod = Expression<Int?>("authreq_initmethod")
            let verified_email = Expression<String?>("verified_email")
            let verified_company = Expression<String?>("verified_company")
            let sent_authrequest_extrasbitmask = Expression<Int?>("sent_authrequest_extrasbitmask")
            let liveid_cid = Expression<String?>("liveid_cid")
            let extprop_contact_ab_uuid = Expression<String?>("extprop_contact_ab_uuid")
            let extprop_external_data = Expression<String?>("extprop_external_data")
            let extprop_last_sms_number = Expression<String?>("extprop_last_sms_number")
            let extprop_viral_upgrade_campaign_id = Expression<Int?>("extprop_viral_upgrade_campaign_id")
            let is_auto_buddy = Expression<Int?>("is_auto_buddy")
            
            let query = contacts.select(id,is_permanent,type,skypename,pstnnumber,aliases,fullname,birthday,gender,languages,country,province,city,phone_home,phone_office,phone_mobile,emails,hashed_emails,homepage,about,avatar_image,mood_String,rich_mood_String,timezone,capabilities,profile_timestamp,nrof_authed_buddies,ipcountry,avatar_timestamp,mood_timestamp,received_authrequest,authreq_timestamp,lastonline_timestamp,availability,displayname,refreshing,given_authlevel,given_displayname,assigned_speeddial,assigned_comment,alertstring,lastused_timestamp,authrequest_count,assigned_phone1,assigned_phone1_label,assigned_phone2,assigned_phone2_label,assigned_phone3,assigned_phone3_label,buddystatus,isauthorized,popularity_ord,external_id,external_system_id,isblocked,authorization_certificate,certificate_send_count,account_modification_serial_nr,saved_directory_String,nr_of_buddies,server_synced,contactlist_track,last_used_networktime,authorized_time,sent_authrequest,sent_authrequest_time,sent_authrequest_serial,buddyString,cbl_future,node_capabilities,revoked_auth,added_in_shared_group,in_shared_group,authreq_history,profile_attachments,stack_version,offline_authreq_id,node_capabilities_and,authreq_crc,authreq_src,pop_score,authreq_nodeinfo,main_phone,unified_servants,phone_home_normalized,phone_office_normalized,phone_mobile_normalized,sent_authrequest_initmethod,authreq_initmethod,verified_email,verified_company,sent_authrequest_extrasbitmask,liveid_cid,extprop_contact_ab_uuid,extprop_external_data,extprop_last_sms_number,extprop_viral_upgrade_campaign_id,is_auto_buddy)
                .filter(id == reqid)
                .order(id.asc)
            
            for row in query {
                if let idt=row[id] {
                    result.id=idt
                }
                if let is_permanentt=row[is_permanent] {
                    result.is_permanent=is_permanentt
                }
                if let typet=row[type] {
                    result.type=typet
                }
                if let skypenamet=row[skypename] {
                    result.skypename=skypenamet
                }
                if let pstnnumbert=row[pstnnumber] {
                    result.pstnnumber=pstnnumbert
                }
                if let aliasest=row[aliases] {
                    result.aliases=aliasest
                }
                if let fullnamet=row[fullname] {
                    result.fullname=fullnamet
                }
                if let birthdayt=row[birthday] {
                    result.birthday=birthdayt
                }
                if let gendert=row[gender] {
                    result.gender=gendert
                }
                if let languagest=row[languages] {
                    result.languages=languagest
                }
                if let countryt=row[country] {
                    result.country=countryt
                }
                if let provincet=row[province] {
                    result.province=provincet
                }
                if let cityt=row[city] {
                    result.city=cityt
                }
                if let phone_homet=row[phone_home] {
                    result.phone_home=phone_homet
                }
                if let phone_officet=row[phone_office] {
                    result.phone_office=phone_officet
                }
                if let phone_mobilet=row[phone_mobile] {
                    result.phone_mobile=phone_mobilet
                }
                if let emailst=row[emails] {
                    result.emails=emailst
                }
                if let hashed_emailst=row[hashed_emails] {
                    result.hashed_emails=hashed_emailst
                }
                if let homepaget=row[homepage] {
                    result.homepage=homepaget
                }
                if let aboutt=row[about] {
                    result.about=aboutt
                }
                if let avatar_imaget=row[avatar_image] {
                    result.avatar_image=avatar_imaget
                }
                if let mood_Stringt=row[mood_String] {
                    result.mood_String=mood_Stringt
                }
                if let rich_mood_Stringt=row[rich_mood_String] {
                    result.rich_mood_String=rich_mood_Stringt
                }
                if let timezonet=row[timezone] {
                    result.timezone=timezonet
                }
                if let capabilitiest=row[capabilities] {
                    result.capabilities=capabilitiest
                }
                if let profile_timestampt=row[profile_timestamp] {
                    result.profile_timestamp=profile_timestampt
                }
                if let nrof_authed_buddiest=row[nrof_authed_buddies] {
                    result.nrof_authed_buddies=nrof_authed_buddiest
                }
                if let ipcountryt=row[ipcountry] {
                    result.ipcountry=ipcountryt
                }
                if let avatar_timestampt=row[avatar_timestamp] {
                    result.avatar_timestamp=avatar_timestampt
                }
                if let mood_timestampt=row[mood_timestamp] {
                    result.mood_timestamp=mood_timestampt
                }
                if let received_authrequestt=row[received_authrequest] {
                    result.received_authrequest=received_authrequestt
                }
                if let authreq_timestampt=row[authreq_timestamp] {
                    result.authreq_timestamp=authreq_timestampt
                }
                if let lastonline_timestampt=row[lastonline_timestamp] {
                    result.lastonline_timestamp=lastonline_timestampt
                }
                if let availabilityt=row[availability] {
                    result.availability=availabilityt
                }
                if let displaynamet=row[displayname] {
                    result.displayname=displaynamet
                }
                if let refreshingt=row[refreshing] {
                    result.refreshing=refreshingt
                }
                if let given_authlevelt=row[given_authlevel] {
                    result.given_authlevel=given_authlevelt
                }
                if let given_displaynamet=row[given_displayname] {
                    result.given_displayname=given_displaynamet
                }
                if let assigned_speeddialt=row[assigned_speeddial] {
                    result.assigned_speeddial=assigned_speeddialt
                }
                if let assigned_commentt=row[assigned_comment] {
                    result.assigned_comment=assigned_commentt
                }
                if let alertstringt=row[alertstring] {
                    result.alertstring=alertstringt
                }
                if let lastused_timestampt=row[lastused_timestamp] {
                    result.lastused_timestamp=lastused_timestampt
                }
                if let authrequest_countt=row[authrequest_count] {
                    result.authrequest_count=authrequest_countt
                }
                if let assigned_phone1t=row[assigned_phone1] {
                    result.assigned_phone1=assigned_phone1t
                }
                if let assigned_phone1_labelt=row[assigned_phone1_label] {
                    result.assigned_phone1_label=assigned_phone1_labelt
                }
                if let assigned_phone2t=row[assigned_phone2] {
                    result.assigned_phone2=assigned_phone2t
                }
                if let assigned_phone2_labelt=row[assigned_phone2_label] {
                    result.assigned_phone2_label=assigned_phone2_labelt
                }
                if let assigned_phone3t=row[assigned_phone3] {
                    result.assigned_phone3=assigned_phone3t
                }
                if let assigned_phone3_labelt=row[assigned_phone3_label] {
                    result.assigned_phone3_label=assigned_phone3_labelt
                }
                if let buddystatust=row[buddystatus] {
                    result.buddystatus=buddystatust
                }
                if let isauthorizedt=row[isauthorized] {
                    result.isauthorized=isauthorizedt
                }
                if let popularity_ordt=row[popularity_ord] {
                    result.popularity_ord=popularity_ordt
                }
                if let external_idt=row[external_id] {
                    result.external_id=external_idt
                }
                if let external_system_idt=row[external_system_id] {
                    result.external_system_id=external_system_idt
                }
                if let isblockedt=row[isblocked] {
                    result.isblocked=isblockedt
                }
                if let authorization_certificatet=row[authorization_certificate] {
                    result.authorization_certificate=authorization_certificatet
                }
                if let certificate_send_countt=row[certificate_send_count] {
                    result.certificate_send_count=certificate_send_countt
                }
                if let account_modification_serial_nrt=row[account_modification_serial_nr] {
                    result.account_modification_serial_nr=account_modification_serial_nrt
                }
                if let saved_directory_Stringt=row[saved_directory_String] {
                    result.saved_directory_String=saved_directory_Stringt
                }
                if let nr_of_buddiest=row[nr_of_buddies] {
                    result.nr_of_buddies=nr_of_buddiest
                }
                if let server_syncedt=row[server_synced] {
                    result.server_synced=server_syncedt
                }
                if let contactlist_trackt=row[contactlist_track] {
                    result.contactlist_track=contactlist_trackt
                }
                if let last_used_networktimet=row[last_used_networktime] {
                    result.last_used_networktime=last_used_networktimet
                }
                if let authorized_timet=row[authorized_time] {
                    result.authorized_time=authorized_timet
                }
                if let sent_authrequestt=row[sent_authrequest] {
                    result.sent_authrequest=sent_authrequestt
                }
                if let sent_authrequest_timet=row[sent_authrequest_time] {
                    result.sent_authrequest_time=sent_authrequest_timet
                }
                if let sent_authrequest_serialt=row[sent_authrequest_serial] {
                    result.sent_authrequest_serial=sent_authrequest_serialt
                }
                if let buddyStringt=row[buddyString] {
                    result.buddyString=buddyStringt
                }
                if let cbl_futuret=row[cbl_future] {
                    result.cbl_future=cbl_futuret
                }
                if let node_capabilitiest=row[node_capabilities] {
                    result.node_capabilities=node_capabilitiest
                }
                if let revoked_autht=row[revoked_auth] {
                    result.revoked_auth=revoked_autht
                }
                if let added_in_shared_groupt=row[added_in_shared_group] {
                    result.added_in_shared_group=added_in_shared_groupt
                }
                if let in_shared_groupt=row[in_shared_group] {
                    result.in_shared_group=in_shared_groupt
                }
                if let authreq_historyt=row[authreq_history] {
                    result.authreq_history=authreq_historyt
                }
                if let profile_attachmentst=row[profile_attachments] {
                    result.profile_attachments=profile_attachmentst
                }
                if let stack_versiont=row[stack_version] {
                    result.stack_version=stack_versiont
                }
                if let offline_authreq_idt=row[offline_authreq_id] {
                    result.offline_authreq_id=offline_authreq_idt
                }
                if let node_capabilities_andt=row[node_capabilities_and] {
                    result.node_capabilities_and=node_capabilities_andt
                }
                if let authreq_crct=row[authreq_crc] {
                    result.authreq_crc=authreq_crct
                }
                if let authreq_srct=row[authreq_src] {
                    result.authreq_src=authreq_srct
                }
                if let pop_scoret=row[pop_score] {
                    result.pop_score=pop_scoret
                }
                if let authreq_nodeinfot=row[authreq_nodeinfo] {
                    result.authreq_nodeinfo=authreq_nodeinfot
                }
                if let main_phonet=row[main_phone] {
                    result.main_phone=main_phonet
                }
                if let unified_servantst=row[unified_servants] {
                    result.unified_servants=unified_servantst
                }
                if let phone_home_normalizedt=row[phone_home_normalized] {
                    result.phone_home_normalized=phone_home_normalizedt
                }
                if let phone_office_normalizedt=row[phone_office_normalized] {
                    result.phone_office_normalized=phone_office_normalizedt
                }
                if let phone_mobile_normalizedt=row[phone_mobile_normalized] {
                    result.phone_mobile_normalized=phone_mobile_normalizedt
                }
                if let sent_authrequest_initmethodt=row[sent_authrequest_initmethod] {
                    result.sent_authrequest_initmethod=sent_authrequest_initmethodt
                }
                if let authreq_initmethodt=row[authreq_initmethod] {
                    result.authreq_initmethod=authreq_initmethodt
                }
                if let verified_emailt=row[verified_email] {
                    result.verified_email=verified_emailt
                }
                if let verified_companyt=row[verified_company] {
                    result.verified_company=verified_companyt
                }
                if let sent_authrequest_extrasbitmaskt=row[sent_authrequest_extrasbitmask] {
                    result.sent_authrequest_extrasbitmask=sent_authrequest_extrasbitmaskt
                }
                if let liveid_cidt=row[liveid_cid] {
                    result.liveid_cid=liveid_cidt
                }
                if let extprop_contact_ab_uuidt=row[extprop_contact_ab_uuid] {
                    result.extprop_contact_ab_uuid=extprop_contact_ab_uuidt
                }
                if let extprop_external_datat=row[extprop_external_data] {
                    result.extprop_external_data=extprop_external_datat
                }
                if let extprop_last_sms_numbert=row[extprop_last_sms_number] {
                    result.extprop_last_sms_number=extprop_last_sms_numbert
                }
                if let extprop_viral_upgrade_campaign_idt=row[extprop_viral_upgrade_campaign_id] {
                    result.extprop_viral_upgrade_campaign_id=extprop_viral_upgrade_campaign_idt
                }
                if let is_auto_buddyt=row[is_auto_buddy] {
                    result.is_auto_buddy=is_auto_buddyt
                }
                
                
            }
        }
        return result;
        
    }
    
    public func getAllContactDetails()->[Contact] {
        var results:[Contact]=[]
        let allIds:[Int]=getAllContacts()
        for conid in allIds {
            results+=[getContactDetailForSkypeuser(conid)]
        }
        return results
    }
    
    public func listAllContactDetailOptions() -> [String]{
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
    
    public func getAllContacts() -> [Int] {
        var result:[Int]=[]
        if let dbase = self.db {
            let contacts=dbase["Contacts"]
            //select skypename from Contacts where type=1;
            let id = Expression<Int?>("id")
            var query = contacts.select(id)
                .order(id.asc)
            
            for row in query {
                if let cur_id=row[id] {
                    result += [cur_id]
                }
                // id: 1, name: Optional("Alice"), email: alice@mac.com
            }
        }
        return result;
    }
    
}