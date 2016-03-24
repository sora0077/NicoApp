//
//  RankingRepository.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/22.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoAPI
import NicoEntity
import RxSwift

public protocol RankingRepository {
    
    func categories() -> [GetRanking.Category]
    
    func list(category: GetRanking.Category, period: GetRanking.Period, target: GetRanking.Target) -> Observable<[Video]>
}

