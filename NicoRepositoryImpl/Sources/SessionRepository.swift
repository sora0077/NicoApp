//
//  SessionRepository.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/06.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoAPI
import NicoEntity
import NicoRepository
import RxAPISchema
import RxSwift
import QueryKit
import RealmSwift

public final class SessionRepositoryImpl: SessionRepository {
    
    let client: Client
    
    public init(client: Client) {
        self.client = client
    }
    
    public func session() throws -> Session? {
        
        let realm = try Realm()
        return realm.objects(SessionImpl).filter(
            SessionImpl.user_session_expired > NSDate()
        ).first
    }
    
    public func login(mailaddress mailaddress: String, password: String) -> Observable<Session> {
        return client
            .start {
                client.request(DebugRequest(GetSession<SessionImpl>(mailaddress: mailaddress, password: password)))
            }
            .map { session in
                let realm = try Realm()
                try realm.write {
                    let session = session as! SessionImpl
                    session.mail_address = mailaddress
                    realm.add(session, update: true)
                }
                return session
            }
    }
}
