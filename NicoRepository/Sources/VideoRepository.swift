//
//  VideoRepository.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/27.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import NicoEntity
import RxSwift

public protocol VideoRepository {
    
    func cache(id: String) -> Video?
    
    func watch(video: Video) -> Observable<Flv>
}


