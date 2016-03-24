//
//  RxSwift.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/24.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import RxSwift


func ??<Element>(lhs: Observable<Element?>, @autoclosure(escaping) rhs: () -> Observable<Element>) -> Observable<Element> {
    return lhs.flatMap { elem -> Observable<Element> in
        if let elem = elem {
            return Observable.just(elem)
        }
        return rhs()
    }
}


func ??<Element>(lhs: Observable<Element?>, @autoclosure(escaping) rhs: () -> Element) -> Observable<Element> {
    return lhs.map { elem in
        if let elem = elem {
            return elem
        }
        return rhs()
    }
}


func ??<Element>(lhs: Observable<Element?>, @autoclosure(escaping) rhs: () -> Observable<Element?>) -> Observable<Element?> {
    return lhs.flatMap { elem -> Observable<Element?> in
        if let elem = elem {
            return Observable.just(elem)
        }
        return rhs()
    }
}
