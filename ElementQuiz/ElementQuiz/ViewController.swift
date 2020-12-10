//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Jack Sorenson on 12/1/20.
//

import UIKit

//Declaring the Mode Enum
enum Mode {
    case flashCard
    case quiz
}

// Declaring the State Enum
enum State {
    case question
    case answer
    case score
}

class ViewController: UIViewController, UITextFieldDelegate {
    var mode: Mode = .flashCard {
        didSet {
            switch mode {
            case .flashCard:
                setupFlashCards()
            case .quiz:
                setupQuiz()
            }
            
            
            updateUI()
        }
    }
    var state: State = .question
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFieldContents = textField.text!
    
        if textFieldContents.lowercased() ==
            elementList[currentElementIndex].lowercased()
        {
            answerIsCorrect = true
            correctAnswerCount += 1
        } else {
            answerIsCorrect = false
        }
        state = .answer
        
        updateUI()
        
        if answerIsCorrect {
            print ("Correct!")
        } else {
            print("❌")
        }

        return true
    }
    
    func UpdateQuizUI(elementName: String) {
        
        //Segmented Control
        modeSelector.selectedSegmentIndex = 1
        
        //textField and keyboard
        textField.isHidden = false
        switch state {
        case .question:
            textField.isEnabled = true
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.isEnabled = false
            textField.resignFirstResponder()
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
        
        // Answer Label
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct!"
            } else {
                answerLabel.text = "❌\nCorrect Answer: " + elementName
            }
        case .score:
            answerLabel.text = ""
            //print("Your score is \(correctAnswerCount) out of \(elementList.count).")

        }
        // Score display
        if state == .score {
            displayScoreAlert()
        }
    
        //Buttons
        showAnswerButton.isHidden = true
        if currentElementIndex == elementList.count - 1 {
            nextButton.setTitle("Show Score", for: .normal)
        } else {
            nextButton.setTitle("Next Question", for: .normal)
        }
        switch state {
        case .question:
            nextButton.isEnabled = false
        case .answer:
            nextButton.isEnabled = true
        case .score:
            nextButton.isEnabled = false
        }
    }
        
    
    func updateUI() {
        // shared code: updating the image
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            UpdateQuizUI(elementName: elementName)
        }
    }
    
    // The outlets for the storyboard
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    //The actions for the show answer and next element buttons
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        
        updateUI()
        
    }
    @IBAction func next(_ sender: Any) {
        currentElementIndex += 1
        if currentElementIndex >= elementList.count{
            currentElementIndex = 0
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
        }
        state = .question
        updateUI()
    }
    
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        } else {
            mode = .quiz
        }
    }


    //The list of elements for the quiz
    //var elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var elementList: [String] = []
    let fixedElementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var currentElementIndex = 0
    
    func updateFlashCardUI(elementName: String) {
        
        //textField and keyboard
        textField.isHidden = true
        textField.resignFirstResponder()
        
        //answer label
        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
        //Segmented Control
        modeSelector.selectedSegmentIndex = 0
    
        //Buttons
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Next Element", for: .normal)
    }
    
    
    func displayScoreAlert() {
        let alert = UIAlertController(title: "Quiz Score", message: "Your score is \(correctAnswerCount) out of \(elementList.count). ", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }
    func scoreAlertDismissed(_ action: UIAlertAction) {
        mode = .flashCard
    }
    
    func setupFlashCards() {
        state = .question
        currentElementIndex = 0
        elementList = fixedElementList
    }
    
    func setupQuiz() {
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        correctAnswerCount = 0
        elementList = fixedElementList.shuffled()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mode = .flashCard
    }
    
    
    


}

