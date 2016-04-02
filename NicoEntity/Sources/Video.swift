//
//  Video.swift
//  NicoEntity
//
//  Created by 林達也 on 2016/02/14.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import Himotoki

public protocol Video {
    
    var id: String { get }
    var title: String { get }
    var length_in_seconds: Int { get }
    var thumbnail_url: String { get }
    
    var upload_time: String { get }
    var first_retrieve: String { get }
    var view_counter: Int { get }
    var mylist_counter: Int { get }
    var comment_counter: Int { get }
    var option_flag_community: Int { get }
    var option_flag_nicowari: Int { get }
    var option_flag_middle_thumbnail: Int { get }
    
    var width: Int { get }
    var height: Int { get }
    
    var deleted: Int { get }
    
    var provider_type: String { get }
    
    var thread_id: String { get }
    
    init(
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
}

extension Video where Self: Decodable {
    
    public static func decode(e: Extractor) throws -> Self {
        
        return try Self.init(
            id: e <| ["video", "id"],
            title: e <| ["video", "title"],
            length_in_seconds: e <| ["video", "length_in_seconds"] <- convertInt,
            thumbnail_url: e <| ["video", "thumbnail_url"],
            upload_time: e <| ["video", "upload_time"],
            first_retrieve: e <| ["video", "first_retrieve"],
            view_counter: e <| ["video", "view_counter"] <- convertInt,
            mylist_counter: e <| ["video", "mylist_counter"] <- convertInt,
            comment_counter: e <| ["thread", "num_res"] <- convertInt,
            option_flag_community: e <| ["video", "option_flag_community"] <- convertInt,
            option_flag_nicowari: e <| ["video", "option_flag_nicowari"] <- convertInt,
            option_flag_middle_thumbnail: e <| ["video", "option_flag_middle_thumbnail"] <- convertInt,
            width: e <| ["video", "width"] <- convertInt,
            height: e <| ["video", "height"] <- convertInt,
            deleted: e <| ["video", "deleted"] <- convertInt,
            provider_type: e <| ["video", "provider_type"],
            thread_id: e <| ["thread", "id"]
        )
    }
}
