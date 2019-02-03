//
//  ApiClientEntities.swift
//  RevoluteTest
//
//  Created by Yaroslav Minaev on 27/01/2019.
//  Copyright © 2019 Minaev.pro. All rights reserved.
//

enum Result<Value, Error> {
    case success(Value)
    case failure(Error)
}
