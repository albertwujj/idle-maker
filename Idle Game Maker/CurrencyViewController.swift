//
//  CurrencyViewController.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/4/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController, UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet weak var currencyName: UITextField!
    @IBOutlet weak var startingCurrency: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var currencyNamePrompt: UILabel!
    
    var games: NSMutableDictionary = NSMutableDictionary()
    var gameName:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyName.delegate = self
        startingCurrency.delegate = self
        updateSaveButtonState()
        
         games = (UIApplication.shared.delegate as! AppDelegate).games
        
        
        //UI Adjustments
        UIHelper.makeTextAdjusting(label: currencyNamePrompt)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The CurrencyViewController is not in a navigation controller")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //pass name to BuildingTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let buildingTableViewController = segue.destination.childViewControllers.first as? BuildingTableViewController {
            //add new Game to global dictionary
            let currName: String = currencyName!.text!
            let game = Game(name: gameName!, currencyName: currName)
            games.setObject(game!, forKey: game!.name! as NSString)
            AppDelegate.saveGames(gamesPassed: games)

            
            buildingTableViewController.gameName = self.gameName
        
            buildingTableViewController.currencyName = currencyName.text!
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
        let cName = currencyName.text ?? ""
        let cAmount = startingCurrency.text ?? ""
        
        let complete = !cName.isEmpty && !cAmount.isEmpty
        saveButton.isEnabled = complete
    }
}
