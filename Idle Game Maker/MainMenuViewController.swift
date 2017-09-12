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
    
    override func viewDidLoad() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        games = appDelegate.games
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
