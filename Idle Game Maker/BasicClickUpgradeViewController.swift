//
//  BasicClickUpgradeViewController.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/11/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit
import os.log

class BasicClickUpgradeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var initialCostTF: UITextField!
    
    @IBOutlet weak var cpMultiplierTF: UITextField!
    
    @IBOutlet weak var costMultiplierTF: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var gameID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialCostTF.delegate = self
        cpMultiplierTF.delegate = self
        costMultiplierTF.delegate = self
        updateSaveButtonState()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        saveClickUpgrades()
    }
    
    private func saveClickUpgrades() {
        let clickUpgradeData = BasicClickUpgrade(cost: initialCostTF.text!, cpMultiplier: cpMultiplierTF.text!, costMultiplier: costMultiplierTF.text!)
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(clickUpgradeData!, toFile: AppDelegate.DocumentsDirectory.appendingPathComponent("usergamebasicclickupgrades" + (gameID as String)).path)
       
        if isSuccessfulSave {
            os_log("Saving clickupgrades was successful", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save clickupgrades...", log: OSLog.default, type: .debug)
        }
        
       
    }
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let cost = initialCostTF.text ?? ""
        let cpMultiplier = cpMultiplierTF.text ?? ""
        let costMultiplier = costMultiplierTF.text ?? ""
        let complete = !cost.isEmpty && !cpMultiplier.isEmpty
        && !costMultiplier.isEmpty
        saveButton.isEnabled = complete
    }

}
 
