//
//  NicoDomain.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/22.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoRepository


public protocol Repository {
    
    var session: SessionRepository { get }
    
    var video: VideoRepository { get }
    
    var ranking: RankingRepository { get }
    
    var history: HistoryRepository { get }
}

public protocol Domain {
    
    var repository: Repository { get }
}