//
//  Domain.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/22.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import RxAPISchema

import NicoDomain


public final class DomainImpl: Domain {
    
    private let client: Client
    
    public lazy var repository: Repository = RepositoryImpl(client: self.client)
    
    public init(client: Client) {
        
        self.client = client
    }
}
