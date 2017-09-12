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
    var sceneNode: GameScene?
    var needSave = false
    
    @IBOutlet weak var igBuildingTableView: IGBuildingTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        
        if let savedBuildings = loadBuildings() {
            buildings = savedBuildings
        }
        
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let trySceneNode = scene.rootNode as! GameScene? {
                print(game!.name!)
                
                sceneNode = trySceneNode
                sceneNode!.game = game
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
                    view.presentScene(sceneNode!)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
            
        }
        
        igBuildingTableView.dataSource = self
        igBuildingTableView.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.gamesNeedToSaveLastTime.object(forKey: game!.name) == nil {
            appDelegate.gamesNeedToSaveLastTime.setObject(game!.name, forKey: game!.name! as NSCopying)
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
    
    //MARK: Private Functions
    private func loadBuildings() -> [Building]? {
        print(game!.name!)
        return NSKeyedUnarchiver.unarchiveObject(withFile: Building.DocumentsDirectory.appendingPathComponent("usergame" + game!.name!).path) as? [Building]
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numRows")
        return buildings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "igBuildingViewCell")! as! IGBuildingCell
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
        
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        sceneNode?.buyBuilding(building: buildings[indexPath.row])
        
    }
    @IBAction func closeMenuPressed(_ sender: UIButton) {
        igBuildingTableView.isHidden = true
    }
    
    
}
