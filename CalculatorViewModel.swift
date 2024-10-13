//
//  CalculatorViewModel.swift
//  Eltex_Calculator
//
//  Created by Леонид Шайхутдинов on 13.10.2024.
//

import Foundation

class CalculatorViewModel {
    var input: String = ""
    var operators: [Character] = ["/", "*", "+", "-", "%"]
    
    var onInputUpdate: ((String) -> Void)?
    var onResultUpdate: ((String) -> Void)?
    
    func isLastCharOperator() -> Bool {
        if let lastChar = input.last {
            return operators.contains(lastChar)
        }
        return false
    }
    
    func isFirstCharOperator() -> Bool {
        if let firstChar = input.first {
            if firstChar == "*" || firstChar == "/" {
                return true
            }
        }
        return false
    }
    
    func validInput() -> Bool {
        if isLastCharOperator() {
            return false
        }
        if isFirstCharOperator() {
            return false
        }
        return true
    }
    
    func pushForwardInput(value: String) {
        input = value + input
        onInputUpdate?(input)
    }
    
    
    func pushBackToInput(value: String) {
        input += value
        onInputUpdate?(input)  // Обновляем интерфейс через callback
    }
    
    func calculateResult() {
        if validInput() {
            let formattedInput = input.replacingOccurrences(of: "/", with: "*1.0/")
            let expression = NSExpression(format: formattedInput)
            if let result = expression.expressionValue(with: nil, context: nil) as? Double {
                let formattedResult = formatResult(result: result)
                onResultUpdate?(formattedResult)  // Обновляем результат через callback
            }
        } 
        else {
            print("Invalid input")
        }
    }
    
    func formatResult(result: Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "=%.0f", result)
        } else {
            return String(format: "=%.6f", result)
        }
    }
    
    func clearAll() {
        input = ""
        onInputUpdate?("")
        onResultUpdate?("")
    }
    
    func deleteLast() {
        if !input.isEmpty {
            input.removeLast()
            onInputUpdate?(input)
        }
    }
}

