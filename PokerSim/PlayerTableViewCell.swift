//
//  PlayerTableViewCell.swift
//  PokerSim
//
//  Created by Joao Paulo Aquino on 12/10/18.
//  Copyright © 2018 Joao Paulo Aquino. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell",
                                                      for: indexPath) as! CardCollectionViewCell

        cell.imgView.image = cards[indexPath.row]
        
        return cell
    }
    
    var cards:[UIImage] = [UIImage(named: "5D")!,UIImage(named: "5C")!]
    

    @IBOutlet weak var nameLabel: UILabel!
    
    func configureCell(cards:[UIImage]){
    collectionView.delegate = self
    self.cards = cards
    collectionView.reloadData()
        
    }
    

}

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    
}
