//
//  BasicClickUpgradeViewController.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/11/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//
/*
import UIKit

class BasicClickUpgradeViewController: UIViewController {

    @IBOutlet weak var initialCostTF: UITextField!
    
    @IBOutlet weak var dpMultiplierTF: UITextField!
    
    @IBOutlet weak var costMultiplierTF: UITextField!
    
    override func viewDidLoad() {
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
    
    private func saveGameData() {
        let toSaveData = [numCurrency, cps, countBuildings] as [Any]
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(toSaveData, toFile: GameScene.DocumentsDirectory.appendingPathComponent("usergameprogress" + game!.name!).path)
        if isSuccessfulSave {
            os_log("Saving progressdata was successful", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save progressdata...", log: OSLog.default, type: .debug)
        }
        saveTimeLastClosed()
    }

}
 */
