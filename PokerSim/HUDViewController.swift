//
//  HUDViewController.swift
//  PokerSim
//
//  Created by Joao Paulo Aquino on 16/10/18.
//  Copyright © 2018 Joao Paulo Aquino. All rights reserved.
//

import UIKit

class Player {
    var name: String
    var fold: Int = 0
    var call: Int = 0
    var bluff: Int =  0
    var value: Int = 0
    var vpip: Int = 0
    var hands:Int = 0
    
    init(name:String){
        self.name = name
    }
}

class HUDViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var tableView: UITableView!
    var players:[Player] = []
    
    var rowsSelected: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HUD"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))

    }
    
    @IBAction func vpipTapped(_ sender: UIButton) {
        for row in rowsSelected {
            players[row].vpip += 1
        }
        for player in players{
            player.hands += 1
        }
        rowsSelected = []
        self.tableView.reloadData()
        
        
    }
    @objc func addTapped(){
        
        let alertController = UIAlertController(title: "Add New Name", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let newName = firstTextField.text!
            let newPlayer = Player(name: newName)
            self.players.append(newPlayer)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let player = players[indexPath.row]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let bluffAction = UIAlertAction(title: "Bluff", style: .default ) {
            UIAlertAction in
            player.bluff += 1
            self.tableView.reloadData()
            
        }
        let valueAction = UIAlertAction(title: "Value", style: .default ) {
            UIAlertAction in
            player.value += 1
            self.tableView.reloadData()

        }
        let callAction = UIAlertAction(title: "Call", style: .default ) {
            UIAlertAction in
            player.call += 1
            self.tableView.reloadData()

        }
        let foldAction = UIAlertAction(title: "Fold", style: .default ) {
            UIAlertAction in
            player.fold += 1
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel ) {
            UIAlertAction in
        }
        alert.addAction(bluffAction)
        alert.addAction(valueAction)
        alert.addAction(callAction)
        alert.addAction(foldAction)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(rowsSelected.contains(indexPath.row)){
            rowsSelected.remove(at: indexPath.row)
        }else{
            rowsSelected.append(indexPath.row)
        }
   
    }
    

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.players.remove(at: indexPath.row)
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PlayerCell
        let player = players[indexPath.row]
        cell.plusButton.tag = indexPath.row
        cell.vpipLabel.text = "vpip \(player.vpip)/\(player.hands)"
        cell.nameLabel.text = player.name
        cell.bluffLabel.text = "bluff: \(player.bluff)"
        cell.valueLabel.text = "value: \(player.value)"
        cell.callLabel.text = "call: \(player.call)"
        cell.foldLabel.text = "fold: \(player.fold)"

        
        return cell
    }
  
}

class PlayerCell: UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bluffLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var foldLabel: UILabel!
    @IBOutlet weak var betWinLabel: UILabel!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var vpipLabel: UILabel!
}
