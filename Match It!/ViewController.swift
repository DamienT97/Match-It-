//
//  ViewController.swift
//  Match It!
//
//  Created by Damien Townley on 30/11/2020.
//
//
// Christmas icons made by
// https://www.flaticon.com/authors/freepik
// from https://www.flaticon.com/
//
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!
    @IBOutlet var button9: UIButton!
    @IBOutlet var button10: UIButton!
    @IBOutlet var button11: UIButton!
    @IBOutlet var button12: UIButton!
    
    
    var timer = Timer()
    var gamePositions = [String]()
    var icons = [String]()
    var buttons = [UIButton]()
    var iconsFlipped = 0
    var firstIconTapped: Int?
    var secondIconTapped: Int?
    var score = 0
    var seconds = 60
    var iconsMatched = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let path = Bundle.main.path(forResource: "Icons", ofType: "txt")
        let iconsFile = try! String(contentsOfFile: path!,encoding: String.Encoding.utf8)
        
        icons = iconsFile.components(separatedBy: "\n")
        
            for _ in icons {
                    gamePositions += ["",""]
            }
        
        for case let button as UIButton in self.view.subviews {
            buttons.append(button)
            button.setImage(UIImage(named: "gift"), for: .normal)
        }
        
        setupGame(alert: nil)
    }

    @IBAction func tappedImage(_ sender: UIButton) {
        
        iconsFlipped += 1
        sender.isEnabled = false
        sender.setBackgroundImage(nil, for: .normal)
        
        switch iconsFlipped {
        case 1:
            firstIconTapped = sender.tag
            return
        case 2:
            secondIconTapped = sender.tag
        default:
            return
        }
        
        if gamePositions[firstIconTapped!] == gamePositions[secondIconTapped!] {
            score += seconds * 10
            scoreLabel.text = "Score: \(score)"
            iconsMatched += 1
        } else {
             let buttonsToReset = [firstIconTapped,secondIconTapped]
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.buttons[buttonsToReset[0]!].isEnabled = true
                self.buttons[buttonsToReset[1]!].isEnabled = true
            })
           
        
        }
        
        iconsFlipped = 0
    }
    
    @objc func setupGame(alert: UIAlertAction?) {
        score = 0
        seconds = 60
        scoreLabel.text = "Score: \(score)"
        timeLabel.text = "Time Remaining: \(seconds)"
        
        var usedPositions = [Int]()
        
        for icon in icons {
            
            // Generate two random index positions for button positions
            
            var firstRandomNumber = Int.random(in: 0...11)
            var secondRandomNumber = Int.random(in: 0...11)
            
            // Check to see if the index positions have already been used
            
            while usedPositions.contains(firstRandomNumber) {
                
                firstRandomNumber = Int.random(in: 0...11)
                
            }
            
            gamePositions[firstRandomNumber] = icon
            usedPositions.append(firstRandomNumber)
            
            while usedPositions.contains(secondRandomNumber) {
                
                secondRandomNumber = Int.random(in: 0...11)
                
            }
            
            gamePositions[secondRandomNumber] = icon
            usedPositions.append(secondRandomNumber)
            
            buttons[firstRandomNumber].setImage(UIImage(named: icon), for: .disabled)
            buttons[secondRandomNumber].setImage(UIImage(named: icon), for: .disabled)
            
            
        }
        
        for button in buttons {
            button.isEnabled = true
        }
        
        print("Positions used: \(usedPositions)")
        print("Game board: \(gamePositions)")
        iconsMatched = 0
        runTimer()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if seconds == 0 || iconsMatched == 6 {
            timer.invalidate()
            let ac = UIAlertController(title: "Game Over", message: "You scored: \(score)! Can you beat it?", preferredStyle: .alert)
            ac.addAction((UIAlertAction(title: "New Game", style: .default, handler: setupGame)))
            present(ac, animated: true)
            return
        }
        
        seconds -= 1
        timeLabel.text = "Time Remaining: \(seconds)"
    }
   
}

