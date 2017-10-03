//
//  Maybe.swift
//  RDMonad
//
//  Created by KatagiriSo on 2017/10/03.
//  Copyright © 2017年 rodhos. All rights reserved.
//

import Foundation

// Maybe Monad

enum Maybe<T> {
    case just(T)
    case nothing
}

func >>=<T,U>(left:Maybe<T>, right:(T)->Maybe<U>) -> Maybe<U> {
    switch left {
    case .nothing:
        return .nothing
    case let .just(t):
        return right(t)
    }
}
