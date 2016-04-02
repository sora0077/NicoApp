//
//  Video.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/20.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import NicoAPI
import RealmSwift
import Realm
import Himotoki
import RxSwift
import RxAPISchema
import NicoRepository


class VideoImpl: Object, Video, Decodable {
    
    dynamic var id: String = ""
    dynamic var title: String = ""
    dynamic var length_in_seconds: Int = 0
    dynamic var thumbnail_url: String = ""
    
    dynamic var upload_time: String = ""
    dynamic var first_retrieve: String = ""
    dynamic var view_counter: Int = 0
    dynamic var mylist_counter: Int = 0
    dynamic var comment_counter: Int = 0
    dynamic var option_flag_community: Int = 0
    dynamic var option_flag_nicowari: Int = 0
    dynamic var option_flag_middle_thumbnail: Int = 0
    
    dynamic var width: Int = 0
    dynamic var height: Int = 0
    
    dynamic var deleted: Int = 0
    
    dynamic var provider_type: String = ""
    
    dynamic var thread_id: String = ""
    
    required init(
        id: String,
        title: String,
        length_in_seconds: Int,
        thumbnail_url: String,
        upload_time: String,
        first_retrieve: String,
        view_counter: Int,
        mylist_counter: Int,
        comment_counter: Int,
        option_flag_community: Int,
        option_flag_nicowari: Int,
        option_flag_middle_thumbnail: Int,
        width: Int,
        height: Int,
        deleted: Int,
        provider_type: String,
        thread_id: String
        )
    {
        self.id = id
        self.title = title
        self.length_in_seconds = length_in_seconds
        self.thumbnail_url = thumbnail_url
        self.upload_time = upload_time
        self.first_retrieve = first_retrieve
        self.view_counter = view_counter
        self.mylist_counter = mylist_counter
        self.comment_counter = comment_counter
        self.option_flag_community = option_flag_community
        self.option_flag_nicowari = option_flag_nicowari
        self.option_flag_middle_thumbnail = option_flag_middle_thumbnail
        self.width = width
        self.height = height
        self.deleted = deleted
        self.provider_type = provider_type
        self.thread_id = thread_id
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    override init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

extension VideoImpl {
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
