//
//  Repository.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/22.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import RxAPISchema
import RealmSwift

import NicoDomain
import NicoRepository
import NicoRepositoryImpl


public final class RepositoryImpl: Repository {

    private let client: Client
    
    public private(set) lazy var session: SessionRepository = SessionRepositoryImpl(client: self.client)

    public private(set) lazy var ranking: RankingRepository = RankingRepositoryImpl(client: self.client)


    public init(client: Client) {
        
        repositoryInit()

        self.client = client
    }
}
