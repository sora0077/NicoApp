//
//  NicoRepositoryImpl.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/22.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import RxSwift
import RxAPISchema
import RealmSwift

let backgroundScheduler = SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Default)
let mainScheduler = MainScheduler.instance

private var _configuration: Realm.Configuration!

public func repositoryInit() {
    _configuration = RealmSwift.Realm.Configuration.defaultConfiguration
//    _configuration.inMemoryIdentifier = "debug"
}

extension Client {
    
    func start<U>(@noescape transform: () -> Observable<U>) -> Observable<U> {
        return transform()
    }
}


func Realm() throws -> RealmSwift.Realm {
    return try RealmSwift.Realm(configuration: _configuration)
}

//struct Realm {
//    
//    static func writer(@noescape block: () -> Void) throws {
//        
//        let realm = try RealmSwift.Realm()
//        try realm.write(block)
//    }
//}
