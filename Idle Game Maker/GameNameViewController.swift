//
//  GameNameViewController.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/4/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit
import os.log

class GameNameViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var gameName: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    //yo
    var games: NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet weak var namePromptLabel: UILabel!
    @IBOutlet weak var tfLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameName.delegate = self
        updateSaveButtonState()
        
        games = (UIApplication.shared.delegate as! AppDelegate).games
        
        //UI Adjustments
        UIHelper.makeTextAdjusting(label: namePromptLabel)
        UIHelper.makeTextAdjusting(label: tfLabel)
       
        
      
        
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
    
    //pass gameName to currencyViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let currencyViewController = segue.destination as? CurrencyViewController {
            
            
            currencyViewController.gameName = gameName.text
         
        }
    }
    
    //MARK: Archive
    private func saveGames() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(games, toFile: AppDelegate.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Saving games was successful", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save games...", log: OSLog.default, type: .debug)
        }
        //save the current gameIdentifier to know which game
        //was last displayed by the buildingTableViewController
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let text = gameName.text
        
        if games.object(forKey: text!) != nil {
            self.gameName.text = ""
            let alertController = UIAlertController(title: "Game already exists", message: "A game already exists with that name.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        updateSaveButtonState()
        
    }
    func updateSaveButtonState() {
        let name = gameName.text ?? ""
       
        let complete = !name.isEmpty
        saveButton.isEnabled = complete
    }
    
    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
}
