//
//  ViewController.swift
//  Quiz
//
//  Created by Iza on 03.08.2016.
//  Copyright © 2016 IB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {  
    @IBOutlet var currentQuestionLabel: UILabel!
    @IBOutlet var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var nextQuestionLabelCeneterXConstraint: NSLayoutConstraint!
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    var currentQuestionIndex: Int = 0
    
    var gradientLayer: CAGradientLayer!
    var colorSets = [[CGColor]]()
    var currentColorSet: Int!
    
    let questions: [String] = ["From what is cognac made?" , "7 + 7 is" , "The capital of Vermont?", " Capital of Poland? ", " First human on the moon?"]
    let answers: [String] = [" Grapes ", " 14 ", " Montpelier ", " Warsaw ", " Neil Armstrong "]
    
    
    func changeGradient(){
        if currentColorSet < colorSets.count - 1 {
            currentColorSet! += 1
        }
        else {
            currentColorSet = 0
        }
        
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.duration = 2.0
        colorChangeAnimation.toValue = colorSets[currentColorSet]
        colorChangeAnimation.fillMode = kCAFillModeForwards
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
    }
    
    func createColorSets() {
        colorSets.append([UIColor(red: 255/255, green: 95/255, blue: 109/255, alpha: 1.0).cgColor as CGColor, UIColor(red: 255/255, green: 195/255, blue: 113/255, alpha: 1.0).cgColor as CGColor])
        colorSets.append([UIColor(red: 229/255, green: 93/255, blue: 135/255, alpha: 1.0).cgColor as CGColor, UIColor(red: 95/255, green: 195/255, blue: 228/255, alpha: 1.0).cgColor as CGColor])
        colorSets.append([UIColor(red: 155/255, green: 15/255, blue: 251/255, alpha: 0.8).cgColor as CGColor, UIColor(red: 255/255, green: 4/255, blue: 51/255, alpha: 0.2).cgColor as CGColor])
        
        currentColorSet = 0
    }
    
    func createGradientLayer() {
    gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.view.bounds
    gradientLayer.colors = colorSets[currentColorSet]
    self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    

    func updateOffScreenLabel(){
        let screenWidth = view.frame.width
        nextQuestionLabelCeneterXConstraint.constant = -screenWidth
    }
    
    
    func animateLabelTransitions(){
        //animate the alpha
        //and the center X constraint
        let screenWidth = view.frame.width
        self.nextQuestionLabelCeneterXConstraint.constant = 0
        self.currentQuestionLabelCenterXConstraint.constant += screenWidth
        
        UIView.animate(withDuration: 1.0,
            delay: 0,
            options: [],
            animations:  {
            self.currentQuestionLabel.alpha = 0
            self.nextQuestionLabel.alpha = 1
            self.view.layoutIfNeeded()
            },
            completion: { _ in swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
                swap(&self.currentQuestionLabelCenterXConstraint, &self.nextQuestionLabelCeneterXConstraint)
                self.updateOffScreenLabel()
            })
    }
    
    

    @IBAction func showNextQuestion(_ sender: AnyObject) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count{
            currentQuestionIndex = 0
        }
        
        let question: String = questions[currentQuestionIndex]
        nextQuestionLabel.text = question
        answerLabel.text = "???"
        
        animateLabelTransitions()
        changeGradient()
    }
    
    @IBAction func showAnswer(_ sender: AnyObject) {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //set the label initial alpha
        nextQuestionLabel.alpha = 0
        createGradientLayer()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let question = questions[currentQuestionIndex]
        currentQuestionLabel.text = question
        updateOffScreenLabel()
        createColorSets()
    }
}

