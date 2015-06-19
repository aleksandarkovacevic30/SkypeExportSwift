//
//  Message.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 5/8/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Foundation

struct Message {
    var id:Int
    var is_permanent:Int
    var convo_id:Int
    var chatname:String
    var author:String
    var from_dispname:String
    var author_was_live:Int
    var guid:String
    var dialog_partner:String
    var timestamp :Int
    var type :Int
    var sending_status :Int
    var consumption_status :Int
    var edited_by :String
    var edited_timestamp :Int
    var param_key :Int
    var param_value :Int
    var body_xml :String
    var identities :String
    var reason :String
    var leavereason :Int
    var participant_count :Int
    var error_code :Int
    var chatmsg_type :Int
    var chatmsg_status :Int
    var body_is_rawxml :Int
    var oldoptions :Int
    var newoptions :Int
    var newrole :Int
    var pk_id :Int
    var crc :Int
    var remote_id :Int
    var call_guid :String
    var extprop_chatmsg_ft_index_timestamp :Int
    var extprop_chatmsg_is_pending :Int
}
