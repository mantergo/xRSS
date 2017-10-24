//
//  Schedulers.swift
//  LoginAppMVVM
//
//  Created by Pavel Lopatine on 10/23/17.
//  Copyright © 2017 Pavel Lopatine. All rights reserved.
//

import Foundation
import RxSwift


var serial: SerialDispatchQueueScheduler = {
    let dispatchQueue = DispatchQueue(label: "serial")
    return SerialDispatchQueueScheduler(queue: dispatchQueue, internalSerialQueueName: "serialScheduler")
}()

let main: SerialDispatchQueueScheduler = MainScheduler.instance

