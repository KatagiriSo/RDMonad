//
//  main.swift
//  RDMonad
//
//  Created by KatagiriSo on 2016/10/06.
//  Copyright © 2016年 Rodhos Soft. All rights reserved.
//

import Foundation


typealias CallBack<R> = (R)->Void
typealias Process<R> = (CallBack<R>)->Void


func unit<T>(t:T) -> Process<T> {
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

struct SomeUID {
    let uid:String
}
struct SomeRecord {
    let title:String
}

func getUIDs() -> Process<[SomeUID]> {
    func report(uids:[SomeUID], callBack:CallBack<[SomeUID]>) -> Void {
        callBack(uids)
    }
    
    func proc(callBack:CallBack<[SomeUID]>) {
        // 非同期処理を行う
        let uids:[SomeUID] = [SomeUID(uid:"hoge")]
        report(uids: uids, callBack:callBack)
    }
    
    return proc
}

func getRecords(uids:[SomeUID]) -> Process<[SomeRecord]> {
    func report(records:[SomeRecord], callBack:CallBack<[SomeRecord]>) {
        callBack(records)
    }
    
    func proc(callBack:CallBack<[SomeRecord]>) {
        // ここでuidを元にした(非同期)処理を行う。
        let records:[SomeRecord] = [SomeRecord(title:"fuga")]
        report(records: records, callBack:callBack)
    }
    
    return proc
}

func getAllRecords() -> Process<[SomeRecord]> {
    return getUIDs()>>=getRecords
}


(getAllRecords()) { records in
    print(records)
}

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


let helloEnv = hello(x: "poi")
let mathEnv = math(input: "hoge")

let result = hello(x: "poi") >>= math

print("helloEnv(0) == \(helloEnv(0))")
print("helloEnv(1) == \(helloEnv(1))")
print("helloEnv(2) == \(helloEnv(2))")

print("mathEnv(0) == \(mathEnv(0))")
print("mathEnv(1) == \(mathEnv(1))")
print("mathEnv(2) == \(mathEnv(2))")

print("result(0) == \(result(0))")
print("result(1) == \(result(1))")
print("result(2) == \(result(2))")












