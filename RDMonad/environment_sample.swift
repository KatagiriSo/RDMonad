//
//  environment_sample.swift
//  RDMonad
//
//  Created by KatagiriSo on 2017/10/03.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

func ask<E>(e:E) -> E {
    return e
}

func local<E,T>(modify:@escaping ((E)->E), env:@escaping Environment<E,T>) -> Environment<E,T> {
    let environment = {(e:E) -> T in
        env(modify(e))
    }
    
    return environment
}


let count:Int = 0

func hello(x:String)->Environment<Int,String> {
    let env = {(e:Int) -> String in
        
        switch e {
        case 0:
            return "hello, \(x)."
        case 1:
            return "hi."
        default:
            return "..."
        }
    }
    
    return env
}

func math(input:String)->Environment<Int,Int> {
    let env = {(e:Int) -> Int in
        switch e {
        case 0:
            return input.lengthOfBytes(using: .utf8)
        case 1:
            return input.lengthOfBytes(using: .utf8) * 5
        default:
            return 0
        }
    }
    
    return env
}



func sample_environment() {
    let helloEnv = hello(x: "poi")
    let mathEnv = math(input: "hoge")
    
    let result = hello(x: "poi") >>= math
    let result2 = local(modify: {e in 0},env: hello(x: "poi")) >>= math
    
    
    print("helloEnv(0) == \(helloEnv(0))")
    print("helloEnv(1) == \(helloEnv(1))")
    print("helloEnv(2) == \(helloEnv(2))")
    
    print("mathEnv(0) == \(mathEnv(0))")
    print("mathEnv(1) == \(mathEnv(1))")
    print("mathEnv(2) == \(mathEnv(2))")
    
    print("result(0) == \(result(0))")
    print("result(1) == \(result(1))")
    print("result(2) == \(result(2))")
    
    print("result2(0) == \(result2(0))")
    print("result2(1) == \(result2(1))")
    print("result2(2) == \(result2(2))")
}
