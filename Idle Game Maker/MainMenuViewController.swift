//
//  MainMenuViewController.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/4/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    var games: NSMutableDictionary = [:]
    
    @IBOutlet weak var makeNewGameButton: UIButton!
    @IBOutlet weak var editGameButton: UIButton!
    @IBOutlet weak var playGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        makeTextAdjusting(button: makeNewGameButton)
        print(makeNewGameButton.titleLabel!.fontSize)
    
        let mNGButtonFont =  makeNewGameButton.titleLabel!.font.withSize(getApproximateAdjustedFontSizeWithLabel(button: makeNewGameButton))
        editGameButton.titleLabel!.font = mNGButtonFont
        playGameButton.titleLabel!.font = mNGButtonFont
        */
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        games = appDelegate.games
        
        constrainButtonsToProperWidth(button1: makeNewGameButton, button2: editGameButton)
        constrainButtonsToProperWidth(button1: editGameButton, button2: playGameButton)
        UIHelper.makeTextAdjusting(label: makeNewGameButton.titleLabel!)
        UIHelper.makeTextAdjusting(label: editGameButton.titleLabel!)
        UIHelper.makeTextAdjusting(label: playGameButton.titleLabel!)
        UIHelper.setButtonBorder(button: makeNewGameButton)
        UIHelper.setButtonBorder(button: playGameButton)
        UIHelper.setButtonBorder(button: editGameButton)
        
        
        // Do any additional setup after loading the view.
    }
    
    func getApproximateAdjustedFontSizeWithLabel(button: UIButton) -> CGFloat {
        let label = button.titleLabel!
        if label.adjustsFontSizeToFitWidth {
            var currentFont: UIFont = label.font
            let originalFontSize = currentFont.pointSize
            var currentSize: CGSize = (label.text! as NSString).size(attributes: [NSFontAttributeName: currentFont])
            
            while currentSize.width > label.intrinsicContentSize.width && currentFont.pointSize > (originalFontSize * label.minimumScaleFactor) {
                currentFont = currentFont.withSize(currentFont.pointSize - 1)
                currentSize = (label.text! as NSString).size(attributes: [NSFontAttributeName: currentFont])
            }
            
            
            return currentFont.pointSize
        }
        
        return label.font.pointSize
        
        
    }
    private func constrainButtonsToProperWidth(button1: UIButton, button2: UIButton) {
        let button1Font = button1.titleLabel!.font
        let button2Font = button2.titleLabel!.font
        button1.titleLabel!.font = button1.titleLabel!.font.withSize(20)
        button2.titleLabel!.font = button2.titleLabel!.font.withSize(20)
        let scale = button2.intrinsicContentSize.width/button1.intrinsicContentSize.width
        NSLayoutConstraint(item: button2, attribute: .width, relatedBy: .equal, toItem: button1, attribute:.width, multiplier: scale, constant:0.0).isActive = true
        button1.titleLabel!.font = button1Font
        button2.titleLabel!.font = button2Font
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "ChooseToEdit":
            guard let gameSelectorTableViewController = segue.destination.childViewControllers.first! as? GameSelectorTableViewController else {
                fatalError("\(segue.destination) is not GameSelectorTableViewController as expected")
            }
            gameSelectorTableViewController.segueHere = segue
        case "ChooseToPlay":
            guard let gameSelectorTableViewController = segue.destination.childViewControllers.first! as? GameSelectorTableViewController else {
                fatalError("\(segue.destination) is not GameSelectorTableViewController as expected")
            }
            gameSelectorTableViewController.segueHere = segue
        default:
            print("segue from main menu to new game")
        }
    }
    
    
}
