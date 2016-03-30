//
//  ViewController.swift
//  Calculator
//
//  Created by Alex Will on 3/17/16.
//  Copyright (c) 2016 Alex Will. All rights reserved.
//
//  Created for Stanford ITunesU course.
//  Day 1
//  CS193P

import UIKit

class ViewController: UIViewController
{
    //properties = instance variables
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    @IBAction func appendDigit(sender: UIButton)
    {
        //let is the same as var but a const
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber
        {
            display.text = display.text! + digit
        }
        else
        {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }        
    }
    @IBAction func operate(sender: UIButton)
    {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber
        {
            enter()
        }
        switch operation
        {
        case "✕": performOperations { $0 * $1 }
        case "⌹": performOperations { $1 / $0}
        case "-": performOperations { $1 - $0 }
        case "+": performOperations { $0 + $1 }
        case "√": performOperation { sqrt($0) }
        default: break
        }
    }
    
    func performOperations(operation: (Double, Double)->Double)
    {
        if operandStack.count >= 2
        {
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double)
    {
        if operandStack.count >= 1
        {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter()
    {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double
    {
        get
        {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set
        {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

