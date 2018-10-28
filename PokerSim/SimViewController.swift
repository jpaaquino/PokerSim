//
//  SimViewController.swift
//  PokerSim
//
//  Created by Joao Paulo Aquino on 13/10/18.
//  Copyright © 2018 Joao Paulo Aquino. All rights reserved.
//

import UIKit

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class SimViewController: UIViewController {
    @IBOutlet weak var p1Card1Btn: UIButton!
    @IBOutlet weak var p1Card2Btn: UIButton!
    @IBOutlet weak var p1Card3Btn: UIButton!
    @IBOutlet weak var p1Card4Btn: UIButton!
    @IBOutlet weak var p1Card5Btn: UIButton!
    @IBOutlet weak var p2Card1Btn: UIButton!
    @IBOutlet weak var p2Card2Btn: UIButton!
    @IBOutlet weak var p2Card3Btn: UIButton!
    @IBOutlet weak var p2Card4Btn: UIButton!
    @IBOutlet weak var p2Card5Btn: UIButton!
    
    @IBOutlet weak var countOneLabel: UILabel!
    
    @IBOutlet weak var countTwoLabel: UILabel!
    
    var playersCards = [UIButton]()
    
    var imgs = [UIImage?]()
    
    var player1Hand = Hand()
    var player2Hand = Hand()
    
    var saved1Hand = Hand()
    var saved2Hand = Hand()

    var p1Wins = 0 {
        didSet{
            countOneLabel.text = String(p1Wins)
        }
    }
    var p2Wins = 0 {
        didSet{
            countTwoLabel.text = String(p2Wins)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        playersCards = [p1Card1Btn,p1Card2Btn,p1Card3Btn,p1Card4Btn,p1Card5Btn,p2Card1Btn,p2Card2Btn,p2Card3Btn,p2Card4Btn,p2Card5Btn]

    }
    
    
    @IBAction func selectCard(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose a card", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            let text = textField.text!.uppercased()
            let card = Card(name: text)
            if let img = UIImage(named: card.name){
                if(sender.tag <= 15){
                    if let _ = self.player1Hand.cards[safe: sender.tag - 11]{
                    self.player1Hand.cards[sender.tag - 11] = card
                    }else{
                    self.player1Hand.cards.insert(card, at: sender.tag - 11)
                    }
                }else{
                    if let _ = self.player2Hand.cards[safe: sender.tag - 21]{
                        self.player2Hand.cards[sender.tag - 21] = card
                    }else{
                        self.player2Hand.cards.insert(card, at: sender.tag - 21)
                    }                }
                sender.setImage(img, for: .normal)
            }else{
                if(sender.tag <= 15){
                    self.player1Hand.cards[sender.tag - 11] = nil
                }else{
                    self.player2Hand.cards[sender.tag - 21] = nil
                }
                let backImg = UIImage(named: "green_back")!
                sender.setImage(backImg, for: .normal)

            }
            
        }
        alert.addTextField { (textField) in
            textField.placeholder = "ie. 5H for 5 of hearts"
        }
        alert.addAction(action)
        present(alert, animated:true, completion: nil)
    }
    
    @IBAction func dealAction(_ sender: UIButton) {
        
        if(p1Wins + p2Wins == 0){
            saved1Hand = player1Hand
            saved2Hand = player2Hand
        }
        
        for _ in 1 ... 10000 {
            var liveCards = Cards.allCards.subtracting(player1Hand.cardStrings).subtracting(player2Hand.cardStrings)

        var index = 0
        for card in player1Hand.cards {
            if card == nil {
                let randomCardString = liveCards.randomElement()
                liveCards.remove(randomCardString!)
                let randomCard = Card(name: randomCardString!)
                player1Hand.cards[index] = randomCard
            }
            index += 1
        }
            
            var index2 = 0

            for card in player2Hand.cards {
                if card == nil {
                    let randomCardString = liveCards.randomElement()
                    liveCards.remove(randomCardString!)
                    let randomCard = Card(name: randomCardString!)
                    player2Hand.cards[index2] = randomCard
                }
                index2 += 1
        }
        
        let h1 = evaluate(cards: player1Hand.cards as! [Card])
        let h2 = evaluate(cards: player2Hand.cards as! [Card])
        compare(hand1: h1, hand2: h2)
        resetCards()
        }

    }
    
    @IBAction func resetAction(_ sender: UIButton) {
     //resetCards()
        player1Hand = Hand()
        player2Hand = Hand()
        
        for btn in playersCards {
            btn.setImage(UIImage(named: "green_back")!, for: .normal)
        }
        
        p1Wins = 0
        p2Wins = 0
    }
    
    func resetCards(){
        player1Hand = saved1Hand
        player2Hand = saved2Hand
    }
    
    
    func evaluate(cards:[Card]) -> Hand{
        var arr:[Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        var secondary = 0
        var primary = 0
        for crd in cards {
            let v = crd.value
            arr[v] += 1
        }
        
        print(arr)
        
        var setOfCards = Set<Int>()
        var arrayOfCardsSorted = [Int]()
        var duplicates = false
        
        for card in cards {
            setOfCards.insert(card.value)
            arrayOfCardsSorted.append(card.value)
        }
        
        var newSet = Set<Int>()
        for el in setOfCards {
            if(arr[el] >= 2){
                let newDecimal = pow(Decimal(el),arr[el])
                let decimalToInt = NSDecimalNumber(decimal: newDecimal).intValue
                newSet.insert(decimalToInt)
            }else{
                newSet.insert(el)
            }
        }
        
        for (index, element) in newSet.sorted().enumerated() {
            let value = Decimal(element) * pow(10.0, index)
            let decimalToInt = NSDecimalNumber(decimal: value).intValue
            secondary += decimalToInt
        }
        
        print(secondary)
        
        if(setOfCards.count == 5){
            print("no duplicates")
            duplicates = false
        }else{
            duplicates = true
        }
        
        //check if flush
        var isFlush = false
        if(!duplicates){
        let sameSuitCards = cards.filter{$0.suit == cards[0].suit}
        isFlush = sameSuitCards.count == 5 ? true : false
        print("is flush \(isFlush)")
        }
        
        //check if straight
        //let straightCards = cards.sorted(by: { $0.value > $1.value })
        var isStraight = false
        if(!duplicates){
        if(setOfCards.max()! - setOfCards.min()! == 4 && !duplicates){
            isStraight = true
        }else{
            let newSet = setOfCards.filter{$0 != 14}
            print(newSet)
            if(newSet.count == 4 && newSet.max()! == 5){
                isStraight = true
            }else{
                isStraight = false
            }
        }
        }
        
        switch setOfCards.count {
        case 5:
            if(isFlush && isStraight){
                primary = 9
                print("Straight Flush")
            }else if(isFlush && !isStraight){
                primary = 6
                print("Flush")
            }else if(!isFlush && isStraight){
                primary = 5
                print("Straight")
            }else if(!isFlush && !isStraight){
                primary = 1
                print("High card")
            }
        case 4:
            primary = 2
            print("One pair")
        case 3:
            if(arr.max()! == 3){
                primary = 4
                print("trips")
            }else{
                primary = 3
                print("2 pair")
            }
        case 2:
            if(arr.max()! == 3){
                primary = 7
                print("full house")
            }else{
                primary = 8
                print("quads")
            }
        default:
            print("error")
        }
        
        
        let hand = Hand(cards: cards, primaryValue: primary, secondaryValue: secondary)
        return hand
        
    }
    
  
    
    func compare(hand1:Hand,hand2:Hand) {
        print("p1cards \(hand1.cardStrings) p2cards \(hand2.cardStrings)")

        if(hand1.primaryValue > hand2.primaryValue){
            print("Hand 1 wins")
            p1Wins += 1
            return
        }
        if(hand1.primaryValue < hand2.primaryValue){
            print("Hand 2 wins")
            p2Wins += 1
            return
        }
        if(hand1.secondaryValue > hand2.secondaryValue){
            print("Hand 1 wins")
            p1Wins += 1
            return
        }
        if(hand1.secondaryValue < hand2.secondaryValue){
            print("Hand 2 wins")
            p2Wins += 1
            return
        }
        print("Tie")
    }
    
//    func compareHands(hands:[Hand]) -> Int{
//        let max = hands.map { $0.primaryValue }.max()
//        let hiHands = hands.filter{$0.primaryValue == max}
//        if(hiHands.count == 1){
//            return hand
//            
//        }
//
//        
//    }
    


}
