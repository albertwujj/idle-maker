//
//  QuickAddBuildingUpgradesViewController.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/25/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit

class QuickAddBuildingUpgradesViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var quickUpgradesTF: UITextField!
    
    var buildingUpgrades: NSMutableDictionary = NSMutableDictionary()
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    /*
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
    }
    */
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //private functions
    /*
    private func updateSaveButtonState() {
        let quText = quickUpgradesTF.text ?? ""
        
        for i in quText.characters.indices {
            if quText[i] == ';' {
                
            }
        }
        
     
    }
    
    */
    
}
