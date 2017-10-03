//
//  Environment.swift
//  RDMonad
//
//  Created by KatagiriSo on 2017/10/03.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

// Environment Monad

typealias Environment<E,T> = (E)->T

func unit<E,T>(_ t:T) -> Environment<E,T> {
    
    let environment = {(e:E) -> T in
        return t
    }
    
    return environment
}

func >>=<E,T,U>(left:@escaping Environment<E,T>, right:@escaping (T)->Environment<E,U>) -> Environment<E,U> {
    let environment = {(e:E) -> U in
        
        let t = left(e)
        let env = right(t)
        let u = env(e)
        return u
    }
    
    return environment
}
