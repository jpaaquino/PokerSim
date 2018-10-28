//
//  ViewController.swift
//  PokerSim
//
//  Created by Joao Paulo Aquino on 12/10/18.
//  Copyright © 2018 Joao Paulo Aquino. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    var cards:[UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlayerTableViewCell
        cell.nameLabel.text = "Player \(indexPath.row)"
        cell.configureCell(cards: [UIImage(named: "5C")!, UIImage(named: "8C")!])

        
         return cell
    }




}

