//
//  ContMonad.swift
//  RDMonad
//
//  Created by KatagiriSo on 2017/10/03.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

typealias CPSCallBack<R> = (R)->Void
typealias CPSFunction<R> = (@escaping CPSCallBack<R>)->Void


class ContMonad<R> {
    
    let cps: CPSFunction<R>
    
    init(cps:@escaping CPSFunction<R>) {
        self.cps = cps
    }
    
    func run(callBack:@escaping CPSCallBack<R>)->Void {
        return cps(callBack)
    }
    
    func fmap<T>(_ f:@escaping (R)->T) -> ContMonad<T>{
        return self >>= {(r:R) in unit(f(r))}
    }
}

class ContMonadCancel<R,S>: ContMonad<R> {
    
}


func >>=<R,T>(left:ContMonad<R>, right:@escaping (R)->ContMonad<T>) -> ContMonad<T> {
    
    
    let f = {(cb:@escaping CPSCallBack<T>) -> Void in
        left.run(callBack:{r in
            let c:ContMonad<T> = right(r)
            c.run(callBack:{t in
                cb(t)
            })
        })
    }
    
    return ContMonad<T>(cps:f)
}

func unit<R>(_ x:R) -> ContMonad<R> {
    
    let cps:(CPSCallBack<R>)->Void = {(cb:CPSCallBack<R>)->Void in
        return cb(x)
    }
    
    return ContMonad<R>(cps:cps)
}


func fmap<R,T>(f:@escaping (R) -> T, m:ContMonad<R>) -> ContMonad<T> {
    
    return m >>= {(r:R) in unit(f(r))}
}

func fmap<R,T>(f:@escaping (R)->T) -> (ContMonad<R>) -> ContMonad<T> {
    return {m in fmap(f:f, m:m)}
}


enum CPSResult<X>{
    case just(X)
    case error(Error)
}
