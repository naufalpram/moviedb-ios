//
//  Date.swift
//  Tugas_1_Pram
//
//  Created by edts on 03/04/24.
//  Copyright © 2024 Pram. All rights reserved.
//

import Foundation

extension Date {
    var age: Int {
    return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
}
