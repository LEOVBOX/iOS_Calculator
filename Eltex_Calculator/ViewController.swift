//
//  ViewController.swift
//  Eltex_Calculator
//
//  Created by Леонид Шайхутдинов on 09.10.2024.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var viewModel = CalculatorViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Подписываемся на обновления от ViewModel
        viewModel.onInputUpdate = { [weak self] input in
            self?.inputLabel.text = input
        }
        viewModel.onResultUpdate = { [weak self] result in
            self?.resultLabel.text = result
        }
    }

    @IBAction func percentTap(_ sender: Any) {
        if !viewModel.isLastCharOperator() {
            viewModel.pushForwardInput(value: "(")
            viewModel.pushBackToInput(value: ")")
            viewModel.pushBackToInput(value: "*0.01")
            
        }
        viewModel.calculateResult()
    }
    
    @IBAction func divideTap(_ sender: Any) {
        if !viewModel.isLastCharOperator() && !viewModel.input.isEmpty {
            viewModel.pushBackToInput(value: "/")
        }
        
    }
    @IBAction func sevenTap(_ sender: Any) {
        viewModel.pushBackToInput(value: "7")
    }
    
    @IBAction func eightTap(_ sender: Any) {
        viewModel.pushBackToInput(value: "8")
    }
    
    @IBAction func nineTap(_ sender: Any) {
        viewModel.pushBackToInput(value: "9")
    }
    @IBAction func multiplyTap(_ sender: Any) {
        if !viewModel.isLastCharOperator() && viewModel.input.count != 0{
            viewModel.pushBackToInput(value: "*")
        }
        
    }
    @IBAction func fourTap(_ sender: Any) {
        viewModel.pushBackToInput(value: "4")
    }
    @IBAction func fiveTap(_ sender: Any) {
        viewModel.pushBackToInput(value: "5")
    }
    @IBAction func sixTap(_ sender: Any) {
        viewModel.pushBackToInput(value: "6")
    }
    @IBAction func minusTap(_ sender: Any) {
        viewModel.pushBackToInput(value: "-")
    }
    @IBAction func oneTap(_ sender: Any) {
        viewModel.pushBackToInput(value: "1")
    }
    @IBAction func twoTap(_ sender: Any) {
        viewModel.pushBackToInput(value: "2")
    }
    @IBAction func threeTap(_ sender: Any) {
        viewModel.pushBackToInput(value: "3")
    }
    @IBAction func plusTap(_ sender: Any) {
        if !viewModel.isLastCharOperator() {
            viewModel.pushBackToInput(value: "+")
        }
    }
    @IBAction func zeroTap(_ sender: Any) {
        viewModel.pushBackToInput(value: "0")
    }
    @IBAction func comaTap(_ sender: Any) {
        if let lastChar = viewModel.input.last, lastChar != "." {
            viewModel.pushBackToInput(value: ".")
        }
        
    }
    @IBAction func equalTap(_ sender: Any) {
        viewModel.calculateResult()
    }
    
    @IBAction func clearTap(_ sender: Any) {
        viewModel.clearAll()
    }
    
    @IBAction func deleteTap(_ sender: Any) {
        viewModel.deleteLast()
    }

}

