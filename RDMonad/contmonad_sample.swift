//
//  contmonad_sample.swift
//  RDMonad
//
//  Created by KatagiriSo on 2017/10/03.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation


func getRecordCont(uid:SomeUID?) -> ContMonad<CPSResult<SomeRecord>> {
    return ContMonad{cb in
        let cb_ = cb
        DispatchQueue.global().async {
            let r = SomeRecord(title: "\(uid?.uid) - record")
            cb_(CPSResult.just(r))
        }
    }
}

func getUIDsCont()->ContMonad<CPSResult<SomeUID>> {
    return ContMonad { cb in
        DispatchQueue.global().async {
            let r = SomeUID(uid: "PO")
            cb(CPSResult.just(r))
        }
    }
}

func uidFromResult(_ r:CPSResult<SomeUID>) -> SomeUID? {
    switch r {
    case let .just(uid):
        return uid
    default:
        return nil
    }
}


func sample_contmonad() {
    
    var b = getUIDsCont().fmap(uidFromResult)
    let c = b >>= getRecordCont
    
    c.run { r in
        print("ContMonad result = \(r)")
    }
}
