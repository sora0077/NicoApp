//
//  VideoRepository.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/14.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import NicoAPI
import RxSwift
import RxAPISchema
import NicoRepository


public final class VideoRepositoryImpl: VideoRepository {
    
    private let client: Client
    
    public init(client: Client) {
        self.client = client
    }
    
    public func cache(id: String) -> Video? {
        
        let realm = try? Realm()
        return realm?.objectForPrimaryKey(VideoImpl.self, key: id)
    }
    
    public func get(id: String) -> Observable<Video?> {
        
        func cache() -> Observable<Video?> {
            return Observable.create { [weak self] observer in
                observer.onNext(self?.cache(id))
                return NopDisposable.instance
            }.subscribeOn(mainScheduler)
        }
        
        return cache() ?? self.client
            .start {
                self.client.request(GetThumbInfo<VideoImpl>(videos: [id]))
            }
            .observeOn(backgroundScheduler)
            .map { videos -> String? in
                let realm = try Realm()
                try realm.write {
                    realm.add(videos.lazy.map { $0 as! VideoImpl}, update: true)
                }
                return videos.first?.id
            }
            .observeOn(mainScheduler)
            .map {
                guard let id = $0 else { return nil }
                
                let realm = try Realm()
                return realm.objectForPrimaryKey(VideoImpl.self, key: id)
            }
    }
    
    public func watch(video: Video) -> Observable<Flv> {
        
        let id = video.id
        let thread_id = video.thread_id
        return client
            .start {
                self.client.request(WatchVideo(id: id))
            }
            .flatMap { video in
                self.client.request(GetFlv<FlvImpl>(id: thread_id))
            }
    }
}
