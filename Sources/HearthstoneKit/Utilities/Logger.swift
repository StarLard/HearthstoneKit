//
//  HSKLog.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/13/20.
//

import Foundation
import os.log

extension Logger {
    static let hearthstoneKit = Logger(subsystem: "com.calebfriden.hearthstone-kit", category: "general")
    
    init(category: String) {
        self.init(subsystem: "com.calebfriden.hearthstone-kit", category: category)
    }
}
