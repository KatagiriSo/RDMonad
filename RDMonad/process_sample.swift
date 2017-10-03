//
//  process_sample.swift
//  RDMonad
//
//  Created by KatagiriSo on 2017/10/03.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

struct SomeUID {
    let uid:String
}
struct SomeRecord {
    let title:String
}


// CPS
func getUIDs(callBack:CallBack<[SomeUID]>) {
    let uids:[SomeUID] = [SomeUID(uid:"AX"),SomeUID(uid:"BC")]
    callBack(uids)
}

// CPS
func getRecords(uids:[SomeUID],callBack:CallBack<[SomeRecord]>) {
    // async...
    let records:[SomeRecord] = uids.map {uid in
        SomeRecord(title:"\(uid)'-record")
    }
    
    callBack(records)
}


func getUIDs() -> Process<[SomeUID]> {
    return getUIDs
}

func getRecords(uids:[SomeUID]) -> Process<[SomeRecord]> {
    func gR(callBack:CallBack<[SomeRecord]>) -> Void{
        getRecords(uids: uids, callBack: callBack)
    }
    
    return gR
}

func getAllRecords() -> Process<[SomeRecord]> {
    return getUIDs()>>=getRecords
}


func sample_process() {
    (getAllRecords()) { records in
        print(records)
    }
    
    
    let proc = unit([SomeUID(uid:"X"), SomeUID(uid:"Y")]) >>= getRecords
    proc {records in
        print(records)
    }
}
