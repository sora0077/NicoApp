//
//  HistoryRepository.swift
//  NicoApp
//
//  Created by 林達也 on 2016/04/03.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import NicoAPI
import RxSwift
import RxAPISchema
import NicoRepository


public final class HistoryRepositoryImpl: HistoryRepository {
    
    private let client: Client
    
    public init(client: Client) {
        self.client = client
    }

    public func add(video: Video) throws {
        
        let realm = try Realm()
        try realm.write {
            let history = HistoryImpl()
            history._video = video as! VideoImpl
            realm.add(history)
        }
    }
    
    public func list() -> Observable<[History]> {
        
        return Observable.create { observer in
            
            MainScheduler.ensureExecutingOnScheduler()
            
            do {
                let realm = try Realm()
                let results = realm.objects(HistoryImpl).sorted("listenAt", ascending: false)
                
                let token = results.addNotificationBlock { results, error in
                    
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext(results!.lazy.map { $0 })
                    }
                }
                
                return AnonymousDisposable {
                    token.stop()
                }
            } catch {
                observer.onError(error)
                return NopDisposable.instance
            }
        }
    }
}
