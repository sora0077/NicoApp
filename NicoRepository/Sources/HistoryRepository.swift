//
//  HistoryRepository.swift
//  NicoApp
//
//  Created by 林達也 on 2016/04/03.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import RxSwift

public protocol HistoryRepository {
    
    func add(video: Video) throws
    
    func list() -> Observable<[History]>
}
