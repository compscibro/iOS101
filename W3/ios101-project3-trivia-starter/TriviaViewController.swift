//
//  TriviaViewController.swift
//  Trivia
//
//  Created by Mohammed Abdur Rahman on 10/10/25.
//

import UIKit

struct Question
{
    let text: String
    let choices: [String]
    let correctIndex: Int
}

class TriviaViewController: UIViewController
{
    // This is connected to the header text label
    @IBOutlet var headerLabel: UILabel!
    // This is connected to the question text label
    @IBOutlet var questionLabel: UILabel!
    // This IBOutlet is connected to all four buttons
    @IBOutlet var choiceButtons: [UIButton]!
    
    // Questions
    
}
