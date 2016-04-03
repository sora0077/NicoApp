//
//  History.swift
//  NicoApp
//
//  Created by 林達也 on 2016/04/03.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import NicoAPI
import RealmSwift
import Realm
import RxSwift
import RxAPISchema
import NicoRepository


class HistoryImpl: Object, History {

    dynamic var listenAt: NSDate = NSDate()
    dynamic var _video: VideoImpl!
    
    var video: Video {
        return _video
    }
    
}
