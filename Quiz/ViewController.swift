//
//  ViewController.swift
//  Quiz
//
//  Created by Alexis Kirkman on 1/11/17.
//  Copyright © 2017 Alexis Kirkman. All rights reserved.
//  Displays quiz questions and answers.

import UIKit

class ViewController: UIViewController {
   @IBOutlet var currentQuestionLabel: UILabel!
   @IBOutlet var nextQuestionLabel: UILabel!
   @IBOutlet var answerLabel: UILabel!
   @IBOutlet var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
   @IBOutlet var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
   var labelSpace = UILayoutGuide() // UI Layout Guide
   var statusCount: Int = 1 // answer display count
   
   let questions: [String] = [
      "What is 7+7?",
      "What is the capital of Vermont?",
      "What is cognac made from?"
   ]
   let answers: [String] = [
      "14",
      "Montpelier",
      "Grapes"
   ]
   var currentQuestionIndex: Int=0
   
   override func viewDidLoad() {
      super.viewDidLoad()
      currentQuestionLabel.text = questions[currentQuestionIndex]
      
      //UILayoutGuide
      self.view.addLayoutGuide(labelSpace)
      labelSpace.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
      nextQuestionLabel.centerXAnchor.constraint(equalTo: labelSpace.leadingAnchor).isActive = true
      currentQuestionLabel.centerXAnchor.constraint(equalTo: labelSpace.trailingAnchor).isActive = true

      updateOffScreenLabel()
   }
   func updateOffScreenLabel() {
      let screenWidth = view.frame.width
      nextQuestionLabelCenterXConstraint.constant = -screenWidth
   }
   
   
   @IBAction func showNextQuestion(_ sender: UIButton){
      currentQuestionIndex += 1
      if currentQuestionIndex == questions.count{
         currentQuestionIndex = 0
      }
      let question: String = questions[currentQuestionIndex]
      nextQuestionLabel.text = question
      answerLabel.text = "???"
      
      animateLabelTransitions()
   }
   
   // Adjusts answer display. Doesn't show anwer when 
   // statusCount % 2 doesn't equal 0
   @IBAction func showAnswer(_ sender: UIButton){
      if(statusCount%2  != 0) {
         let answer: String = answers[currentQuestionIndex]
         answerLabel.text = answer
      }
      else{
        answerLabel.text = "???"
      }
   }
   
   func animateLabelTransitions(){
      // Force any outstanding layout changes to occur
      view.layoutIfNeeded()
      
      // Animate the alpha
      // and the center X constraints
      //let screenWidth = view.frame.width
      self.nextQuestionLabelCenterXConstraint.constant = 0
      //self.currentQuestionLabelCenterXConstraint.constant += screenWidth
      statusCount = statusCount + 1
      UIView.animate( withDuration: 0.5,
                      delay: 0,
                      usingSpringWithDamping: 0.5,//adds spring effect to questions
                      initialSpringVelocity: 0.5,
                      options: [.curveLinear],
                      animations: {
                        self.currentQuestionLabel.alpha = 0
                        self.nextQuestionLabel.alpha = 1
                        self.view.layoutIfNeeded()
                        
      }, completion: { _ in
         swap(&self.currentQuestionLabel,
              &self.nextQuestionLabel)
         swap(&self.currentQuestionLabelCenterXConstraint,
              &self.nextQuestionLabelCenterXConstraint)
         
         self.updateOffScreenLabel()
         
      })
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // Set the label's initial alpha
      nextQuestionLabel.alpha = 0
   }
   
}

