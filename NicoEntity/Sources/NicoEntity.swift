//
//  NicoEntity.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/17.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import Himotoki

extension Decodable {
    
    func map<U>(@noescape transform: Self throws -> U) rethrows -> U {
        return try transform(self)
    }
    
    func map<U>(@noescape transform: Self -> U) -> U {
        return transform(self)
    }
}

infix operator <- { associativity left precedence 130 }

func <- <T, U>(value: T, converter: T -> U) -> U {
    return converter(value)
}

func <- <T, U>(value: T, converter: T throws -> U) rethrows -> U {
    return try converter(value)
}

func convertBool(v: String) throws -> Bool {
    
    if let int = Int(v) {
        return Bool(int)
    }
    
    switch v {
    case "true", "1":
        return true
    case "false", "0":
        return false
    default:
        throw DecodeError.TypeMismatch(expected: "Bool", actual: "String", keyPath: nil)
    }
}

func convertInt(v: String) throws -> Int {
    
    if v.isEmpty {
        return 0
    }
    
    if let int = Int(v) {
        return int
    }
    throw DecodeError.TypeMismatch(expected: "Int", actual: "String", keyPath: nil)
}