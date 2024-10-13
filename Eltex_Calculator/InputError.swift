//
//  InputError.swift
//  Eltex_Calculator
//
//  Created by Леонид Шайхутдинов on 13.10.2024.
//

import Foundation

enum InputError: Error {
    case NotEndedLastNumber
    case OperatorInTheEnd
    case OperatorAtBegin
}
