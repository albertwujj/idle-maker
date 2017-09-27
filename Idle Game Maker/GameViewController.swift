//
//  GameViewController.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/2/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
   
    var game: Game?
    var buildings: [Building] = []
    var upgrades: [Any] = []
    var sceneNode: GameScene?
    
    var needSave = false
    
    
    @IBOutlet weak var hiddenTableView: UITableView!
    @IBOutlet weak var igBuildingTableView: IGBuildingTableView!
    //TableView Settings
    var menuButtonPressed: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        
        if let savedBuildings = loadBuildings() {
            buildings = savedBuildings
        }
        if let clickUpgrades = loadClickUpgrades() {
            upgrades.append(clickUpgrades)
        }
        
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let trySceneNode = scene.rootNode as! GameScene? {
                print(game!.name!)
                
                sceneNode = trySceneNode
                sceneNode!.scaleMode = .aspectFill
                sceneNode!.game = game
                sceneNode!.buildings = buildings
                sceneNode!.igBuildingTableView = igBuildingTableView
                sceneNode!.upgrades = upgrades
             
                
                // Copy gameplay related content over to the scene
                /*
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                */
                
                // Set the scale mode to scale to fit the window
                sceneNode!.scaleMode = .aspectFill
                sceneNode!.viewController = self
               
                // Present the scene
                if let view = self.view as! SKView? {
                    sceneNode!.size = view.bounds.size
                    view.presentScene(sceneNode!)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        
        }
        
        igBuildingTableView.dataSource = self
        igBuildingTableView.delegate = self
        igBuildingTableView.rowHeight = 64
        /*
        hiddenTableView.dataSource = self
        hiddenTableView.delegate = self
        */
        
        hiddenTableView.frame=CGRect(x:20,y:50,width:280,height:200)
        hiddenTableView.isHidden = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.gamesNeedToSaveLastTime.object(forKey: game!.name) == nil {
            appDelegate.gamesNeedToSaveLastTime.setObject(game!.name, forKey: game!.name! as NSCopying)
            print("???")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //as soon as the game loads up, the game needs saving of lastclosedtime upon app exit
        needSave = true
        sceneNode!.game = game
        if let savedBuildings = loadBuildings() {
            buildings = savedBuildings
        }
        sceneNode!.buildings = buildings
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
   
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(menuButtonPressed == nil || (menuButtonPressed!.currentTitle)! == "Buildings") {
            return buildings.count
        }
        else { return upgrades.count }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if menuButtonPressed == nil || menuButtonPressed?.currentTitle == "Buildings" {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "igBuildingViewCell")! as! IGBuildingTableViewCell
            let building = buildings[indexPath.row]
            cell.nameLabel.text = building.name!
          
            //whenever displaying cost, display correct value based on initialCost and count
            if let count = sceneNode!.countBuildings.object(forKey: building.name!) as? Int {
                cell.countLabel.text = String(count)
                cell.costLabel.text = (Double(building.initialCost)! * pow(1.15, Double(count))).format(f: ".1")
            }
            else {
                cell.countLabel.text = "0"
                cell.costLabel.text = building.initialCost
            }
            cell.cpsLabel.text = building.cps!
            cell.customImageView.image = building.photo
            return cell
        }
        else {
      
            let cell = tableView.dequeueReusableCell(withIdentifier: "igBuildingViewCell")! as! IGBuildingTableViewCell
            //if indexPath.row == 0 {
            
                let clickUpgrade = upgrades[indexPath.row] as! BasicClickUpgrade
                cell.nameLabel.text = "Power Click"
                
                //whenever displaying cost, display correct value based on initialCost and count
                let count = sceneNode!.basicClickUpgradeLevel
                cell.countLabel.text = String(count)
                cell.costLabel.text = (Double(clickUpgrade.cost)! * pow(Double(clickUpgrade.costMultiplier)!, Double(count))).format(f: ".1")
                cell.cpsLabel.text = String(pow(Double(clickUpgrade.cpMultiplier)!, Double(count)))
                cell.customImageView.image = #imageLiteral(resourceName: "DefaultImage")
                /*
                else {
                    cell.countLabel.text = "0"
                    cell.costLabel.text = clickUpgrade.cost
                    cell.cpsLabel.text = "1"
                }
                */
                return cell
           // }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(menuButtonPressed == nil || (menuButtonPressed!.currentTitle)! == "Buildings") {
            sceneNode?.buyBuilding(building: buildings[indexPath.row])
        }
        else {
            sceneNode?.buyBasicClickUpgrade(basicClickUpgrade: upgrades[indexPath.row] as! BasicClickUpgrade)
        }
        igBuildingTableView.reloadData()
        
    }
    /*
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return "Section \(section)"
     }
    */
    
    
    //MARK: Actions
    @IBAction func closeMenuPressed(_ sender: UIButton) {
        igBuildingTableView.isHidden = true
    }
   
    @IBAction func upgradesButtonPressed(_ sender: UIButton) {
        menuButtonPressed = sender
        igBuildingTableView.reloadData()
    }
    @IBAction func buildingsButtonPressed(_ sender: UIButton) {
        menuButtonPressed = sender
        igBuildingTableView.reloadData()
    }
    
    //MARK: Load Persisted Data Functions
    private func loadBuildings() -> [Building]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Building.DocumentsDirectory.appendingPathComponent("usergamebuildings" + game!.name!).path) as? [Building]
    }
    
    private func loadClickUpgrades() -> BasicClickUpgrade? {
        let clickUpgrades = NSKeyedUnarchiver.unarchiveObject(withFile: Building.DocumentsDirectory.appendingPathComponent("usergamebasicclickupgrades" + game!.name!).path) as? BasicClickUpgrade
        return clickUpgrades
    }

}
