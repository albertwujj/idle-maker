//
//  GameSelectorTableViewController.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/4/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit

class GameSelectorTableViewController: UITableViewController {
    
    
    var games: NSMutableDictionary = [:]
    var indexToGameName: [String] = []
    //keep track of the latest game selected to pass in when seguing
    var lastGameNameSelected: String = ""
    
    var segueHere: UIStoryboardSegue?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make a local array containing the values of global games dictionary
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        games = appDelegate.games
        
        indexToGameName = [String](repeating: String(), count: games.count)
        var i = 0
        for gameName in games.allKeys {
            indexToGameName[i] = gameName as! String
            i += 1
        }
 
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.rowHeight = 90.0
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "EditSelectedGame":
            guard let buildingTableViewController = segue.destination.childViewControllers.first! as? BuildingTableViewController else {
                fatalError("Unexpected segue destination: \(segue.destination)")
            }
            buildingTableViewController.gameName = lastGameNameSelected
        case "PlaySelectedGame":
            guard let gameViewController = segue.destination as? GameViewController else {
                fatalError("Unexpected segue destination: \(segue.destination)")
            }
            gameViewController.game = games.object(forKey: lastGameNameSelected) as? Game
        default:
            print("neither EditGame nor PlayGame")
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    // Override to support editing the table view.
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
            AppDelegate.saveGames(gamesPassed: games)
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
    
   
    
}
