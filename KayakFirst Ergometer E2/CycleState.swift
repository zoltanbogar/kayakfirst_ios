//
//  CycleState.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
public enum CycleState: String {
    //TODO: delete idle
    case idle = "idle"
    case bluetoothDisconnected = "bluetoothDisconnected"
    case resumed = "resumed"
    case paused = "paused"
    case stopped = "stopped"
}
