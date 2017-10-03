//
//  maybe_sample.swift
//  RDMonad
//
//  Created by KatagiriSo on 2017/10/03.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

func add(_ str:Maybe<String>, _ str2:Maybe<String>) -> Maybe<String> {
    
    if case .just(let t1) = str, case .just(let t2) = str2 {
        let res = t1 + t2
        if res.lengthOfBytes(using: .utf8) > 10 {
            return .nothing
        } else {
            return .just(res)
        }
    }
    
    return .nothing
}

func oddNumber(x:Int) -> Maybe<Int> {
    if x % 2 == 1 {
        return .just(x)
    } else {
        return .nothing
    }
}

func sample_maybe() {
    
    let m = Maybe.just(1000) >>= oddNumber
    let m2 = Maybe.just(1001) >>= oddNumber
    
    print("1000 = \(m)")
    print("1001 = \(m2)")
}

