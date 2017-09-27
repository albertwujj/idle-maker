//
//  BuildingTableViewController.swift
//  FoodTracker
//
//  Created by Albert Wu on 8/23/17.
//  Copyright © 2017 Albert Wu. All rights reserved.
//

import UIKit
import os.log

/* TODO:
 change building cost and cps to string
 change ImageViews to !
*/
class BuildingTableViewController: UITableViewController {
    
    //MARK: Properties
    var gameIdentifier: NSString = "Sample"
    //var usedGameIDS = NSMutableDictionary.init()
    var buildings = [Building]()
    
    var gameName: String?
    var currencyName: String!
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var gameNameTextField: UITextField!
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("currentGameID")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //if a game name was given by another controller, 
        //load buildings for that game
        if let gameNamePassedIn = gameName {
            gameIdentifier = gameNamePassedIn as NSString
            if let savedBuildings = loadBuildings() {
                buildings = savedBuildings
            }
            
            navigationItem.title = gameName
        }
        //else load buildings for saved gameName
        else if let savedGameID = loadCurrentGameID() {
            gameIdentifier = savedGameID
            if let savedBuildings = loadBuildings() {
                
                buildings = savedBuildings
            }
        }
        else {
            loadSampleBuildings()
        }
        
        gameNameTextField.text = gameIdentifier as String
        
        self.tableView.rowHeight = 90.0
        navigationItem.leftBarButtonItem = editButtonItem
    }
   
    override func viewDidAppear(_ animated: Bool) {
        //if a game name was given by another controller,
        //load buildings for that game
        
        if let gameNamePassedIn = gameName {
            gameIdentifier = gameNamePassedIn as NSString
            if let savedBuildings = loadBuildings() {
                buildings = savedBuildings
                print(gameIdentifier)
            }
           
            gameNameTextField.text = gameIdentifier as String

        }
       
    }
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings.count
    }
    /*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
   */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BuildingTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BuildingTableViewCell else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier)")
        }
        
        let building = buildings[indexPath.row]
        
        cell.nameLabel.text = building.name
        if let viewPhoto = building.photo {
            cell.photoImageView?.image = viewPhoto
        }
        
        cell.cpsLabel.text = building.cps
        cell.initialCostLabel.text = building.initialCost
        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            buildings.remove(at: indexPath.row)
            saveBuildings()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        saveBuildings()
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new building.", log: OSLog.default, type: .debug)
            guard let buildingViewController = segue.destination.childViewControllers.first! as? BuildingViewController else {
                fatalError("Unexpected destinaton: \(segue.destination)")
                
            }
            buildingViewController.currencyName = currencyName

        case "ShowDetail":
            guard let buildingViewController = segue.destination as? BuildingViewController else {
                fatalError("Unexpected destinaton: \(segue.destination)")
                
            }
            buildingViewController.currencyName = currencyName
            guard let selectedBuildingCell = sender as? BuildingTableViewCell else {
                fatalError("Unexpected source: \(sender ?? "")")
            }
            guard let indexPath = tableView.indexPath(for: selectedBuildingCell) else {
                fatalError("Selected building cell is not being displayed by the table")
            }
            
            let correspondingBuilding = buildings[indexPath.row]
            buildingViewController.building = Building(name: correspondingBuilding.name!, photo: correspondingBuilding.photo,
                                                       initialCost: correspondingBuilding.initialCost, cps: correspondingBuilding.cps)
        case "":
            guard let gameSelectorTableViewController = segue.destination.childViewControllers.first! as? GameSelectorTableViewController else {
                fatalError("Unexpected destinaton: \(segue.destination)")
            }
            gameSelectorTableViewController.segueHere = segue
        case "AddBasicClickUpgrade":
            guard let basicClickUpgradeViewController = segue.destination.childViewControllers.first! as? BasicClickUpgradeViewController else {
                fatalError("Unexpected destinaton: \(segue.destination)")
            }
            basicClickUpgradeViewController.gameID = gameIdentifier as String!
        default:
            print("different segue")
        }
        
        
    }
    
    
    //MARK: Private Methods
    
    private func loadSampleBuildings() {
      
        
        guard let building1 = Building(name: "Pizza", initialCost: "15.0", cps:"0.1") else {
            fatalError("Unable to instantiate building")
        }
        guard let building2 = Building(name: "Square Sushi", initialCost: "100", cps: "0.5") else {
            fatalError("Unable to instantiate building")
        }
        guard let building3 = Building(name: "Rainbow Bagel", initialCost: "500", cps: "2") else {
            fatalError("Unable to instantiate building")
        }
        
        buildings += [building1, building2, building3]
        gameIdentifier = "The True Power of Food"
    }
    
    //save Buildings under the current gameIdentifier
    
    private func saveBuildings() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(buildings, toFile: Building.DocumentsDirectory.appendingPathComponent("usergamebuildings" + (gameIdentifier as String)).path)
        print(gameIdentifier)
        if isSuccessfulSave {
            os_log("Saving buildings was successful", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save buildings...", log: OSLog.default, type: .debug)
        }
        //save the current gameIdentifier to know which game
        //was last displayed by the buildingTableViewController
        saveCurrentGameID()
    }
    
    
    
    private func loadBuildings() -> [Building]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Building.DocumentsDirectory.appendingPathComponent("usergamebuildings" + (gameIdentifier as String)).path) as? [Building]
    }
    
    private func saveCurrentGameID() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(gameIdentifier, toFile: BuildingTableViewController.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Saving currentGameID was successful", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save currentGameID...", log: OSLog.default, type: .debug)
        }
    }
    private func loadCurrentGameID() -> NSString? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: BuildingTableViewController.ArchiveURL.path) as? NSString
    }
    
    //MARK: Actions
    
    @IBAction func unwindToBuildingList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? BuildingViewController, let building = sourceViewController.building {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                buildings[selectedIndexPath.row] = building
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            } else {
                let newIndexPath = IndexPath(row: buildings.count, section: 0)
                
                buildings.append(building)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveBuildings()
            
        }
        
        
    }
    @IBAction func changeGameSelected(_ sender: UIButton) {
        
    }
 
}
