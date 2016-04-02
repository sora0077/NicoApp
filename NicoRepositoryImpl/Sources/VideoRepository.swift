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
    
    public func watch(video: Video) -> Observable<Flv> {
        
        let id = video.id
        return client
            .start {
                self.client.request(DebugRequest(WatchVideo(id: id)))
            }
            .flatMap {
                self.client.request(DebugRequest(GetFlv<FlvImpl>(id: id)))
            }
    }
}
