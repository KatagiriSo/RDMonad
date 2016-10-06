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



