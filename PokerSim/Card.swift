//
//  Card.swift
//  PokerSim
//
//  Created by Joao Paulo Aquino on 12/10/18.
//  Copyright © 2018 Joao Paulo Aquino. All rights reserved.
//

import UIKit

struct Hand {
    var cards:[Card?] = [nil,nil,nil,nil,nil]
    var primaryValue:Int = 0
    var secondaryValue:Int = 0
    
    var cardStrings:Set<String>{
        var st = Set<String>()
        for crd in cards{
            if let crd = crd{
                st.insert(crd.name)
            }
        }
        return st
    }
    
}

struct SimPlayer{
    var number: Int?
    var wins:Int = 0
    var losses: Int = 0
    var ties: Int = 0
}


class Card {
    var img: UIImage {
        return UIImage(named: name)!
    }
    
    let name: String
    
    var suit:String {
        return String(name.last!)
    }
    
    var value:Int {
        if let first = name.first, let firstValue = Int(String(first)){
            return firstValue
        }
        if(name.first == "A"){
            return 14
        }
        if(name.first == "T"){
            return 10
        }
        if(name.first == "J"){
            return 11
        }
        if(name.first == "Q"){
            return 12
        }
        if(name.first == "K"){
            return 13
        }
        return 0
    }
    
    init(name:String){
        self.name = name
    }
    

    
    
    
}

class Cards {
    
    static let allCards: Set<String> = ["AS","AD","AC","AH","2S","2D","2C","2H","3S","3D","3C","3H","4S","4D","4C","4H","5S","5D","5C","5H","6S","6D","6C","6H","7S","7D","7C","7H","8S","8D","8C","8H","9S","9D","9C","9H","TS","TD","TC","TH","JS","JD","JC","JH","QS","QD","QC","QH","KS","KD","KC","KH",
    ]
    
    
    
}
