//
//  CalculatorViewModel.swift
//  Eltex_Calculator
//
//  Created by Леонид Шайхутдинов on 13.10.2024.
//

import Foundation

class CalculatorViewModel {
    var input: String = ""
    var result: String = ""
    var isLastDouble: Bool = false
    var operators: [Character] = ["/", "*", "+", "-", "%"]
    
    var onInputUpdate: ((String) -> Void)?
    var onResultUpdate: ((String) -> Void)?
    
    // Стоит ли на последней поизции оператор
    func isLastCharOperator() -> Bool {
        if let lastChar = input.last {
            return operators.contains(lastChar)
        }
        return false
    }
    
    // Стоит ли на первой поизиции оператор (кроме -)
    func isFirstCharOperator() -> Bool {
        if let firstChar = input.first {
            if firstChar == "*" || firstChar == "/" || firstChar == "+" {
                return true
            }
        }
        return false
    }
    
    func isCommaInTheEnd() -> Bool {
        if let lastChar = input.last {
            if lastChar == "." {
                return true
            }
        }
        return false
    }
    
    func validInput() throws {
        // Если в конце стоит оператор
        if isLastCharOperator() {
            throw InputError.OperatorInTheEnd
        }
        // Если в начале стоит оператор (кроме -)
        if isFirstCharOperator() {
            throw InputError.OperatorAtBegin
        }
        if isCommaInTheEnd() {
            throw InputError.NotEndedLastNumber
        }
    }
    
    func pushForwardToInput(value: String) {
        input = value + input
        onInputUpdate?(input)
    }
    
    
    func pushBackToInput(value: String) {
        input += value
        onInputUpdate?(input)  // Обновляем интерфейс через callback
    }
    
    func applyPercent() {
        pushForwardToInput(value: "(")
        pushBackToInput(value: ")")
        pushBackToInput(value: "*0.01")
        calculateResult()
        input = result
        onInputUpdate?(input)
    }
    
    
    func calculateResult() {
        do {
            try validInput()
            let formattedInput = input.replacingOccurrences(of: "/", with: "*1.0/")
            let expression = NSExpression(format: formattedInput)
            if let calcResult = expression.expressionValue(with: nil, context: nil) as? Double {
                result = formatResult(result: calcResult)
                onResultUpdate?("=" + result)  // Обновляем результат через callback
            }
        } 
        catch {
            switch error {
            case InputError.NotEndedLastNumber:
                onResultUpdate?("Last number not ended")
            case InputError.OperatorAtBegin:
                onResultUpdate?("Operator on first place")
            case InputError.OperatorInTheEnd:
                onResultUpdate?("Expression not ended")
            default:
                onResultUpdate?("Invalid input")
            }
        }
    }
    
    func formatResult(result: Double) -> String {
        // Если число целое, просто возвращаем его без дробной части
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", result)
        } 
        else {
            // Форматируем с максимальной точностью до 6 знаков
            var formattedResult = String(format: "%.6f", result)
            
            // Удаляем лишние нули в конце дробной части
            while formattedResult.last == "0" {
                formattedResult.removeLast()
            }
            
            // Если последним символом после удаления нулей осталась запятая, удаляем её
            if formattedResult.last == "." {
                formattedResult.removeLast()
            }
            
            return formattedResult
        }
    }

    

    func invertOperatorsAndAddMinus(in input: String) -> String {
        var result = ""
        var previousChar: Character? = nil
        var isNegativeNumber = false // Флаг для отслеживания отрицательных чисел

        for (index, char) in input.enumerated() {
            switch char {
            case "+":
                // Заменяем плюс на минус
                result.append("-")
                isNegativeNumber = false
            case "-":
                // Заменяем минус на плюс
                if (index != 0) {
                    result.append("+")
                }
                isNegativeNumber = false
            case "*", "/", "%":  // Другие операторы остаются без изменений
                result.append(char)
                isNegativeNumber = false
            default:
                // Если это цифра или точка (десятичный разделитель)
                if char.isNumber || char == "." {
                    // Проверяем, если это не первый символ и перед числом нет знака
                    if (index == 0 || (previousChar == nil || previousChar == "*" || previousChar == "/" || previousChar == "%")) && !isNegativeNumber {
                        result.append("-")
                        isNegativeNumber = true
                    }
                }
                result.append(char)
            }
            previousChar = char
        }
        
        return result
    }




    func applyPlusMinus() {
        do {
            try validInput()
            input = invertOperatorsAndAddMinus(in: input)
            onInputUpdate?(input)
            calculateResult()
        }
        catch {
            switch error {
            case InputError.NotEndedLastNumber:
                onResultUpdate?("Last number not ended")
            case InputError.OperatorAtBegin:
                onResultUpdate?("Operator on first place")
            case InputError.OperatorInTheEnd:
                onResultUpdate?("Expression not ended")
            default:
                onResultUpdate?("Invalid input")
            }
        }
    }


    
    func clearAll() {
        input = ""
        onInputUpdate?("")
        onResultUpdate?("")
        isLastDouble = false
    }
    
    func deleteLast() {
        if !input.isEmpty {
            if (input.last == ".") {
                isLastDouble = false
            }
            input.removeLast()
            onInputUpdate?(input)
        }
    }
}

