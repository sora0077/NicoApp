//
//  RankingListViewModel.swift
//  NicoApp
//
//  Created by 林達也 on 2016/04/06.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

import NicoEntity
import NicoAPI

public typealias GetRanking = NicoAPI.GetRanking

public final class RankingListViewModel: RequestViewModel<Video> {
    
    private let category: GetRanking.Category
    private let period: GetRanking.Period
    private let target: GetRanking.Target

    public init(category: GetRanking.Category, period: GetRanking.Period, target: GetRanking.Target) {
        self.category = category
        self.period = period
        self.target = target
        super.init()
    }

    override func stream() -> Observable<[Video]> {
        return domain().repository.ranking.list(category, period: period, target: target)
    }
    
    public var itemSelected: Observable<Video> {
        fatalError()
    }
}