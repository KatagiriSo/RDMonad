//
//  CPS.swift
//  RDMonad
//
//  Created by KatagiriSo on 2017/10/03.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

typealias CallBack<R> = (R)->Void
typealias Process<R> = (CallBack<R>)->Void


func unit<T>(_ t:T) -> Process<T> {
    func process(callBack:CallBack<T>) {
        callBack(t)
    }
    return process
}

func >>=<T,U>(left:@escaping Process<T>, right:@escaping (T)->Process<U>) -> Process<U> {
    
    let proc = {(callBack:CallBack<U>) -> Void in
        left {(t:T) in
            (right(t)) {(u:U) in
                callBack(u)
            }
        }
    }
    
    return proc
}
