//
//  GameSelectorTableViewController.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/4/17.
//
//

import UIKit
import os.log

/* SHORT EXPLANATION:
 The Game class represents the data associated with a game that the user has created.
 
 GameSelectorTableViewController displays and controls the TableView that allows the user to select a specific game to
either play or edit. The user can get to this view by either selecting the Play Game or Edit Game button on the main menu.
Depending on which button was pressed to get here, once the user selects a game on the TableView, the app will allow the
user to then either play or edit the game.
 
 Pretty straightfoward class, but easiest to understand without context.
*/

class GameSelectorTableViewController: UITableViewController {
    
    //NSMutable dictionary where the key is a String representing the game's name, and the value is the Game class itself
    var games: NSMutableDictionary = [:]
    
    //a map mapping indexes to gameNames in order to allow the TableViewController to access the games
    //in a consistent order to display consistently in the TableView
    var indexToGameName: [String] = []
    
    //keep track of the latestGameNameSelected to pass to the new ViewController when seguing
    var lastGameNameSelected: String = ""
    
    //keep track of the segue activated to get here, in order to know whether to play or edit a game
    var segueHere: UIStoryboardSegue?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set reference to global games dictionary
        //most of the project's classes need access to the games dictionary
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        games = appDelegate.games
        
        //map indexes to gameNames
        indexToGameName = [String](repeating: String(), count: games.count)
        var i = 0
        for gameName in games.allKeys {
            indexToGameName[i] = gameName as! String
            i += 1
        }
        
        self.tableView.rowHeight = 90.0
        //navigationItem.leftBarButtonItem = editButtonItem
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        //pass gameName and currencyName to game editor
        case "EditSelectedGame":
            guard let buildingTableViewController = segue.destination.childViewControllers.first! as? BuildingTableViewController else {
                fatalError("Unexpected segue destination: \(segue.destination)")
            }
            buildingTableViewController.gameName = lastGameNameSelected
            buildingTableViewController.currencyName = (games.object(forKey: lastGameNameSelected) as! Game).currencyName
        //pass Game object to GameViewController
        case "PlaySelectedGame":
            guard let gameViewController = segue.destination as? GameViewController else {
                fatalError("Unexpected segue destination: \(segue.destination)")
            }
            gameViewController.game = (games.object(forKey: lastGameNameSelected) as! Game)
        default:
            print("neither EditGame nor PlayGame")
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return indexToGameName.count
    }

    //provide the cell for the TableView to display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> GameSelectorTableViewCell {
        let cellID = "GameSelectorTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? GameSelectorTableViewCell else {
            fatalError("The dequeued cell is not an instance of GameSelectorTableViewCell")
        }
        
        let game = games.object(forKey: indexToGameName[indexPath.row] as String) as! Game
        cell.gameName.text = game.name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    //based on the segue activated to get here, either play or edit the selected game
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameNameSelected = (games.object(forKey: indexToGameName[indexPath.row]) as? Game)?.name
        lastGameNameSelected = gameNameSelected!
        
        if segueHere!.identifier == "ChooseToEdit" {
            self.performSegue(withIdentifier: "EditSelectedGame", sender: gameNameSelected)
        }
        else if segueHere!.identifier == "ChooseToPlay"{
            self.performSegue(withIdentifier: "PlaySelectedGame", sender: gameNameSelected)
        }
        else if segueHere!.identifier == "ChangeGameFromEditor"{
            self.performSegue(withIdentifier: "EditSelectedGame", sender: gameNameSelected)
        }
    }
    
    
    //Support deleting games from the TableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let gameName = indexToGameName[indexPath.row]
            //delete buildings for corresponding game
            do {
                try FileManager.default.removeItem(atPath: Building.DocumentsDirectory.appendingPathComponent("usergame" + gameName).path)
            } catch {
                print("gameName not found")
            }
            
            //delete game from dictionary
            indexToGameName.remove(at: indexPath.row)
            games.removeObject(forKey: gameName)
            
            //save the updated dictionary of games to storage
            saveGames()
            
            //delete the progressData for the game
            //deleteProgressData(gameName: gameName)
 
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            //Unsuppported
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

    //MARK: Private Functions
    //save the dictionary of games to storage
    private func saveGames() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(games, toFile: AppDelegate.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Saving buildings was successful", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save buildings...", log: OSLog.default, type: .debug)
        }
    }
    private func deleteProgressData(gameName: String) {
       
        do {
            try FileManager.default.removeItem(at: URL(string: GameScene.DocumentsDirectory.appendingPathComponent("usergameprogress" + gameName).path)!)
        }
        catch let error as NSError {
            print("Unable to delete gameprogressdata: \(error)")
        }
        
    }
   
    
}
