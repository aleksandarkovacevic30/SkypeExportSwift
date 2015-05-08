//
//  ContactsManager.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 5/8/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Foundation

class ContactsManager{
    public enum CONTACT_TYPE {
        case SKYPE_CONTACT
        case ALL
    }

    
    var db:Database?
    
    init(skypedb:SkypeDB) {
        if let db=skypedb.db {
            self.db=db
        }
    }
    
    //TODO look for swift hashtable data structure
    public func getContactDetailForSkypeuser(reqid: Int)->Contact{
        var result:Contact
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
                    result.id=id
                }
                if let is_permanentt=row[is_permanent] {
                    result.is_permanent=is_permanent
                }
                if let typet=row[type] {
                    result.type=type
                }
                if let skypenamet=row[skypename] {
                    result.skypename=skypename
                }
                if let pstnnumbert=row[pstnnumber] {
                    result.pstnnumber=pstnnumber
                }
                if let aliasest=row[aliases] {
                    result.aliases=aliases
                }
                if let fullnamet=row[fullname] {
                    result.fullname=fullname
                }
                if let birthdayt=row[birthday] {
                    result.birthday=birthday
                }
                if let gendert=row[gender] {
                    result.gender=gender
                }
                if let languagest=row[languages] {
                    result.languages=languages
                }
                if let countryt=row[country] {
                    result.country=country
                }
                if let provincet=row[province] {
                    result.province=province
                }
                if let cityt=row[city] {
                    result.city=city
                }
                if let phone_homet=row[phone_home] {
                    result.phone_home=phone_home
                }
                if let phone_officet=row[phone_office] {
                    result.phone_office=phone_office
                }
                if let phone_mobilet=row[phone_mobile] {
                    result.phone_mobile=phone_mobile
                }
                if let emailst=row[emails] {
                    result.emails=emails
                }
                if let hashed_emailst=row[hashed_emails] {
                    result.hashed_emails=hashed_emails
                }
                if let homepaget=row[homepage] {
                    result.homepage=homepage
                }
                if let aboutt=row[about] {
                    result.about=about
                }
                if let avatar_imaget=row[avatar_image] {
                    result.avatar_image=avatar_image
                }
                if let mood_Stringt=row[mood_String] {
                    result.mood_String=mood_String
                }
                if let rich_mood_Stringt=row[rich_mood_String] {
                    result.rich_mood_String=rich_mood_String
                }
                if let timezonet=row[timezone] {
                    result.timezone=timezone
                }
                if let capabilitiest=row[capabilities] {
                    result.capabilities=capabilities
                }
                if let profile_timestampt=row[profile_timestamp] {
                    result.profile_timestamp=profile_timestamp
                }
                if let nrof_authed_buddiest=row[nrof_authed_buddies] {
                    result.nrof_authed_buddies=nrof_authed_buddies
                }
                if let ipcountryt=row[ipcountry] {
                    result.ipcountry=ipcountry
                }
                if let avatar_timestampt=row[avatar_timestamp] {
                    result.avatar_timestamp=avatar_timestamp
                }
                if let mood_timestampt=row[mood_timestamp] {
                    result.mood_timestamp=mood_timestamp
                }
                if let received_authrequestt=row[received_authrequest] {
                    result.received_authrequest=received_authrequest
                }
                if let authreq_timestampt=row[authreq_timestamp] {
                    result.authreq_timestamp=authreq_timestamp
                }
                if let lastonline_timestampt=row[lastonline_timestamp] {
                    result.lastonline_timestamp=lastonline_timestamp
                }
                if let availabilityt=row[availability] {
                    result.availability=availability
                }
                if let displaynamet=row[displayname] {
                    result.displayname=displayname
                }
                if let refreshingt=row[refreshing] {
                    result.refreshing=refreshing
                }
                if let given_authlevelt=row[given_authlevel] {
                    result.given_authlevel=given_authlevel
                }
                if let given_displaynamet=row[given_displayname] {
                    result.given_displayname=given_displayname
                }
                if let assigned_speeddialt=row[assigned_speeddial] {
                    result.assigned_speeddial=assigned_speeddial
                }
                if let assigned_commentt=row[assigned_comment] {
                    result.assigned_comment=assigned_comment
                }
                if let alertstringt=row[alertstring] {
                    result.alertstring=alertstring
                }
                if let lastused_timestampt=row[lastused_timestamp] {
                    result.lastused_timestamp=lastused_timestamp
                }
                if let authrequest_countt=row[authrequest_count] {
                    result.authrequest_count=authrequest_count
                }
                if let assigned_phone1t=row[assigned_phone1] {
                    result.assigned_phone1=assigned_phone1
                }
                if let assigned_phone1_labelt=row[assigned_phone1_label] {
                    result.assigned_phone1_label=assigned_phone1_label
                }
                if let assigned_phone2t=row[assigned_phone2] {
                    result.assigned_phone2=assigned_phone2
                }
                if let assigned_phone2_labelt=row[assigned_phone2_label] {
                    result.assigned_phone2_label=assigned_phone2_label
                }
                if let assigned_phone3t=row[assigned_phone3] {
                    result.assigned_phone3=assigned_phone3
                }
                if let assigned_phone3_labelt=row[assigned_phone3_label] {
                    result.assigned_phone3_label=assigned_phone3_label
                }
                if let buddystatust=row[buddystatus] {
                    result.buddystatus=buddystatus
                }
                if let isauthorizedt=row[isauthorized] {
                    result.isauthorized=isauthorized
                }
                if let popularity_ordt=row[popularity_ord] {
                    result.popularity_ord=popularity_ord
                }
                if let external_idt=row[external_id] {
                    result.external_id=external_id
                }
                if let external_system_idt=row[external_system_id] {
                    result.external_system_id=external_system_id
                }
                if let isblockedt=row[isblocked] {
                    result.isblocked=isblocked
                }
                if let authorization_certificatet=row[authorization_certificate] {
                    result.authorization_certificate=authorization_certificate
                }
                if let certificate_send_countt=row[certificate_send_count] {
                    result.certificate_send_count=certificate_send_count
                }
                if let account_modification_serial_nrt=row[account_modification_serial_nr] {
                    result.account_modification_serial_nr=account_modification_serial_nr
                }
                if let saved_directory_Stringt=row[saved_directory_String] {
                    result.saved_directory_String=saved_directory_String
                }
                if let nr_of_buddiest=row[nr_of_buddies] {
                    result.nr_of_buddies=nr_of_buddies
                }
                if let server_syncedt=row[server_synced] {
                    result.server_synced=server_synced
                }
                if let contactlist_trackt=row[contactlist_track] {
                    result.contactlist_track=contactlist_track
                }
                if let last_used_networktimet=row[last_used_networktime] {
                    result.last_used_networktime=last_used_networktime
                }
                if let authorized_timet=row[authorized_time] {
                    result.authorized_time=authorized_time
                }
                if let sent_authrequestt=row[sent_authrequest] {
                    result.sent_authrequest=sent_authrequest
                }
                if let sent_authrequest_timet=row[sent_authrequest_time] {
                    result.sent_authrequest_time=sent_authrequest_time
                }
                if let sent_authrequest_serialt=row[sent_authrequest_serial] {
                    result.sent_authrequest_serial=sent_authrequest_serial
                }
                if let buddyStringt=row[buddyString] {
                    result.buddyString=buddyString
                }
                if let cbl_futuret=row[cbl_future] {
                    result.cbl_future=cbl_future
                }
                if let node_capabilitiest=row[node_capabilities] {
                    result.node_capabilities=node_capabilities
                }
                if let revoked_autht=row[revoked_auth] {
                    result.revoked_auth=revoked_auth
                }
                if let added_in_shared_groupt=row[added_in_shared_group] {
                    result.added_in_shared_group=added_in_shared_group
                }
                if let in_shared_groupt=row[in_shared_group] {
                    result.in_shared_group=in_shared_group
                }
                if let authreq_historyt=row[authreq_history] {
                    result.authreq_history=authreq_history
                }
                if let profile_attachmentst=row[profile_attachments] {
                    result.profile_attachments=profile_attachments
                }
                if let stack_versiont=row[stack_version] {
                    result.stack_version=stack_version
                }
                if let offline_authreq_idt=row[offline_authreq_id] {
                    result.offline_authreq_id=offline_authreq_id
                }
                if let node_capabilities_andt=row[node_capabilities_and] {
                    result.node_capabilities_and=node_capabilities_and
                }
                if let authreq_crct=row[authreq_crc] {
                    result.authreq_crc=authreq_crc
                }
                if let authreq_srct=row[authreq_src] {
                    result.authreq_src=authreq_src
                }
                if let pop_scoret=row[pop_score] {
                    result.pop_score=pop_score
                }
                if let authreq_nodeinfot=row[authreq_nodeinfo] {
                    result.authreq_nodeinfo=authreq_nodeinfo
                }
                if let main_phonet=row[main_phone] {
                    result.main_phone=main_phone
                }
                if let unified_servantst=row[unified_servants] {
                    result.unified_servants=unified_servants
                }
                if let phone_home_normalizedt=row[phone_home_normalized] {
                    result.phone_home_normalized=phone_home_normalized
                }
                if let phone_office_normalizedt=row[phone_office_normalized] {
                    result.phone_office_normalized=phone_office_normalized
                }
                if let phone_mobile_normalizedt=row[phone_mobile_normalized] {
                    result.phone_mobile_normalized=phone_mobile_normalized
                }
                if let sent_authrequest_initmethodt=row[sent_authrequest_initmethod] {
                    result.sent_authrequest_initmethod=sent_authrequest_initmethod
                }
                if let authreq_initmethodt=row[authreq_initmethod] {
                    result.authreq_initmethod=authreq_initmethod
                }
                if let verified_emailt=row[verified_email] {
                    result.verified_email=verified_email
                }
                if let verified_companyt=row[verified_company] {
                    result.verified_company=verified_company
                }
                if let sent_authrequest_extrasbitmaskt=row[sent_authrequest_extrasbitmask] {
                    result.sent_authrequest_extrasbitmask=sent_authrequest_extrasbitmask
                }
                if let liveid_cidt=row[liveid_cid] {
                    result.liveid_cid=liveid_cid
                }
                if let extprop_contact_ab_uuidt=row[extprop_contact_ab_uuid] {
                    result.extprop_contact_ab_uuid=extprop_contact_ab_uuid
                }
                if let extprop_external_datat=row[extprop_external_data] {
                    result.extprop_external_data=extprop_external_data
                }
                if let extprop_last_sms_numbert=row[extprop_last_sms_number] {
                    result.extprop_last_sms_number=extprop_last_sms_number
                }
                if let extprop_viral_upgrade_campaign_idt=row[extprop_viral_upgrade_campaign_id] {
                    result.extprop_viral_upgrade_campaign_id=extprop_viral_upgrade_campaign_id
                }
                if let is_auto_buddyt=row[is_auto_buddy] {
                    result.is_auto_buddy=is_auto_buddy
                }


            }
        }
        return result;

}

    public func getAllContactDetails()->[Contact] {
        var results:[Contact]=[]
        let allIds=getAllContacts()
        if let ids=allIds {
            for id in ids {
                results+=getContactDetailForSkypeuser(id)
            }
        }
        return results
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
        return result;
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
        var query = contacts.select(skypename)
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