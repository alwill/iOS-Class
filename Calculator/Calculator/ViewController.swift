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
    
    var brain = CalculatorBrain()
    
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
        if userIsInTheMiddleOfTypingANumber
        {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    

    
    @IBAction func enter()
    {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
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

