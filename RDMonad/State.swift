//
//  State.swift
//  RDMonad
//
//  Created by KatagiriSo on 2017/10/03.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

// State Monad


typealias State<S,T> = (S) -> (T,S)

func unit<S,T>(_ t:T) -> State<S,T> {
    return {(s:S)->(T,S) in (t,s)}
}

func >>=<S,T,U>(left:@escaping State<S,T>, right:@escaping (T) -> State<S,U>) -> State<S,U> {
    
    return {s in
        let (t,ss) = left(s)
        let stateMon = right(t)
        let ret = stateMon(ss)
        return ret
    }
}
