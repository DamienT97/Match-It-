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
    
    var gamePositions = [String]()
    var icons = [String]()
    var buttons = [UIButton]()
    var iconsFlipped = 0
    var firstIconTapped: Int?
    var secondIconTapped: Int?
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        let files = try! fm.contentsOfDirectory(atPath: path)
        
        for file in files {
            
            if file.hasSuffix(".png") {
                icons.append(file)
                gamePositions += ["",""]
            }
            
        }
        
        for case let button as UIButton in self.view.subviews {
            buttons.append(button)
            button.setImage(UIImage(named: "gift"), for: .normal)
        }
        
        setupGame()
        
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
            score += 1
            print("Current Score: \(score)")
        } else {
             let buttonsToReset = [firstIconTapped,secondIconTapped]
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.buttons[buttonsToReset[0]!].isEnabled = true
                self.buttons[buttonsToReset[1]!].isEnabled = true
            })
           
        
        }
        
        iconsFlipped = 0
    }
    
    func setupGame() {
        
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
        print("Positions used: \(usedPositions)")
        print("Game board: \(gamePositions)")
        
    }
    
    
    
}

