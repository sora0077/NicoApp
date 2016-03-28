//
//  SessionRepository.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/24.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoAPI
import NicoEntity
import RxSwift

public protocol SessionRepository {
    
    func session() throws -> Session?
    
    func login(mailaddress mailaddress: String, password: String) -> Observable<Session>

    func logout() -> Observable<Void>
}

