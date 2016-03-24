//
//  NicoAPIRequestToken.swift
//  NicoApp
//
//  Created by 林達也 on 2016/02/14.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import RxAPISchema
import Alamofire

protocol NicoAPIRequestToken: RequestSchema {
    
}

import Fuzi

protocol XMLSerializer: ResponseSerializerType {}
extension XMLSerializer {
    
    public var serializeResponse: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Result<XMLDocument, NSError> {
        return { req, res, data, error in
            
            do {
                return .Success(try XMLDocument(data: data ?? NSData()))
            } catch {
                return .Failure(error as NSError)
            }
            
        }
    }
}