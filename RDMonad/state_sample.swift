//
//  state_sample.swift
//  RDMonad
//
//  Created by KatagiriSo on 2017/10/03.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

func add1(x:Int) -> State<Int,Int> {
    return {(s:Int) in
        let xx = x + s
        let ss = s + 1
        return (xx,ss)
    }
}

func sample_state() {
    
    var state:State<Int,Int> = unit(0) // value
    
    print(state(2)) // state 2
    print(state(5)) // state 5
    
    let re = state >>= add1
    
    print("re(1) = \(re(1))")
    print("re(2) = \(re(2))")
    print("re(3) = \(re(3))")
    
    let re2 = (state >>= add1) >>= add1
    
    print("re2(1) = \(re2(1))")
    print("re2(2) = \(re2(2))")
    print("re2(3) = \(re2(3))")
}
