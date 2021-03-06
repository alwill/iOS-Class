//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Alex Will on 4/4/16.
//  Copyright © 2016 Alex Will. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
    
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
   private var opStack =  [Op]() //array
    
   private var knownOps = [String:Op]() //dictionary
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        knownOps ["✕"] = Op.BinaryOperation("✕", *)
        knownOps ["⌹"] = Op.BinaryOperation("⌹") { $1 / $0 }
        knownOps ["-"] = Op.BinaryOperation("-") { $1 - $0 }
        knownOps ["+"] = Op.BinaryOperation("+", +)
        knownOps ["％"] = Op.BinaryOperation("％") { $1 % $0 }
        knownOps ["√"] = Op.UnaryOperation("√", sqrt)
    }
    
   private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty {
            var remaingOps = ops
            let op = remaingOps.removeLast()
            switch op {
                
            case .Operand(let operand):
                return (operand, remaingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remaingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
                
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remaingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
}