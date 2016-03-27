//
//  RankingRepository.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/06.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoAPI
import NicoEntity
import RxAPISchema
import RxSwift
import QueryKit
import RealmSwift
import Timepiece
import NicoRepository


private func ==(lhs: RankingRepositoryImpl.TokenKey, rhs: RankingRepositoryImpl.TokenKey) -> Bool {
    return lhs.category == rhs.category
    && lhs.period == rhs.period
    && lhs.target == rhs.target
}


public final class RankingRepositoryImpl: RankingRepository {
    
    private struct TokenKey: Hashable {
        var category: GetRanking.Category
        var period: GetRanking.Category
        var target: GetRanking.Target
        
        private var hashValue: Int {
            return "\(category)-\(period)-\(target)".hashValue
        }
    }
    
    private let client: Client
    private var tokens: [TokenKey: NotificationToken] = [:]
    
    public init(client: Client) {
        self.client = client
    }
    
    public func categories() -> [GetRanking.Category] {
        return [
            .All, .Music, .Ent, .Anime, .Game, .Animal, .Science, .Other
        ]
    }
    
    public func list(category: GetRanking.Category, period: GetRanking.Period, target: GetRanking.Target) -> Observable<[Video]> {
        
        func cache() -> Observable<[Video]?> {
            return Observable.create { subscribe in
                do {
                    let realm = try Realm()
                    let ref = realm.objects(RefRanking)
                        .filter(RefRanking.category == category.rawValue
                            && RefRanking.period == period.rawValue
                            && RefRanking.target == target.rawValue
                            && RefRanking.createAt > NSDate() - 30.minutes
                        ).first
                    subscribe.onNext(ref.map {
                        $0.items.map { $0 }
                    })
                    subscribe.onCompleted()
                } catch {
                    subscribe.onError(error)
                }
                return NopDisposable.instance
            }.subscribeOn(mainScheduler)
        }
        
        func get() -> Observable<[Video]> {
            return client
                .start {
                    self.client.request(GetRanking(target: target, period: period, category: category))
                }
                .flatMap { ids in
                    self.client.request(GetThumbInfo<VideoImpl>(videos: ids))
                }
                .observeOn(backgroundScheduler)
                .map { videos -> String in
                    let ref = RefRanking()
                    ref._category = category.rawValue
                    ref._period = period.rawValue
                    ref._target = target.rawValue
                    let realm = try Realm()
                    try realm.write {
                        realm.delete(
                            realm.objects(RefRanking)
                                .filter(RefRanking.category == category.rawValue
                                    && RefRanking.period == period.rawValue
                                    && RefRanking.target == target.rawValue
                                )
                        )
                        
                        let items: [VideoImpl] = videos.map {
                            let video = $0 as! VideoImpl
                            realm.add(video, update: true)
                            return video
                        }
                        ref.items.appendContentsOf(items)
                        realm.add(ref)
                    }
                    return ref.id
                }
                .observeOn(mainScheduler)
                .map { id in
                    let realm = try Realm()
                    realm.refresh()
                    let ref = realm.objectForPrimaryKey(RefRanking.self, key: id)!
                    return ref.items.map { $0 }
                }
        }
        
        return cache() ?? get()
    }
}
