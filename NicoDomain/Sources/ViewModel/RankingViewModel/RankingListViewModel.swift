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


public protocol RankingListViewModel {

//    var items: Observable<[Video]> { get }
    
    var refreshEvent: ControlEvent<Void> { get }
    
    var itemSelected: ControlEvent<NSIndexPath> { get }
}
