//
//  Rules.swift
//  21points
//
//  Created by 张雲淞 on 2018/5/7.
//  Copyright © 2018年 张雲淞. All rights reserved.
//

import Foundation

class Rules {
    var isBankerFlag:Bool=false
    
    var cards=[1,1,1,1,
               2,2,2,2,
               3,3,3,3,
               4,4,4,4,
               5,5,5,5,
               6,6,6,6,
               7,7,7,7,
               8,8,8,8,
               9,9,9,9,
               10,10,10,10,
               11,11,11,11,
               12,12,12,12]
    
    var cardsInHand:[String] = []
    var cardsBlind:String = ""
    
    init(isBankerFlag:Bool) {
        self.isBankerFlag=isBankerFlag
    }
    
    func initialize(){
        cards = [1,1,1,1,
                2,2,2,2,
                3,3,3,3,
                4,4,4,4,
                5,5,5,5,
                6,6,6,6,
                7,7,7,7,
                8,8,8,8,
                9,9,9,9,
                10,10,10,10,
                11,11,11,11,
                12,12,12,12]
        cardsInHand = []
        cardsBlind = ""
    }
    
    func getACard()->String{
        let remainingNumberOfCards=cards.count
        let randomCardIndex = Int(arc4random_uniform(UInt32(remainingNumberOfCards)))
        
        let randomCardNumber = cards[randomCardIndex]
        cards.remove(at: randomCardIndex)
        switch randomCardNumber {
            case 1:
                addCardIntoHand(card:"A")
                return "A"
            case 10,11,12:
                addCardIntoHand(card:"T")
                return "T"
            default:
                addCardIntoHand(card:String(randomCardNumber))
                return String(randomCardNumber)
        }
    }
    
    func addCardIntoHand(card:String){
        cardsInHand.append(card)
    }
    
    func start()->(seenCards:[String],blindCard:String){
        if isBankerFlag{
            getACard()
            getACard()
            let blindCard = cardsInHand.popLast()!
            
            cardsBlind=blindCard
            return (cardsInHand,cardsBlind)
        }
        else{
            getACard()
            getACard()
            return (cardsInHand,cardsBlind)
        }
    }
    
    func Stand()->Int{
        var totalPoints:Int = 0
        var numberOfAce:Int = 0
        let numberOfCardsInHand = calculateNumberOfCardsInHand()
        totalPoints=numberOfCardsInHand.totalPoints
        numberOfAce=numberOfCardsInHand.numberOfAce
        //print("StandTotal:"+String(totalPoints))
        //print("StandAce:"+String(numberOfAce))
        if isBankerFlag {
            switch cardsBlind{
            case "A":
                totalPoints+=11
                numberOfAce+=1
                for i in 1...numberOfAce{
                    if totalPoints>21{
                        totalPoints-=i*10
                    }else{
                        break
                    }
                }
                
            case "T":
                totalPoints+=10
                if numberOfAce != 0{
                    for i in 1...numberOfAce{
                        if totalPoints>21{
                            totalPoints-=i*10
                        }else{
                            break
                        }
                    }
                }
            default:
                totalPoints+=Int(cardsBlind)!
                if numberOfAce != 0{
                    for i in 1...numberOfAce{
                        if totalPoints>21{
                            totalPoints-=i*10
                        }else{
                            break
                        }
                    }
                }
            }
        }else{
            if numberOfAce != 0{
                for i in 1...numberOfAce{
                    if totalPoints>21{
                        totalPoints-=i*10
                    }else{
                        break
                    }
                }
            }
        }
        return totalPoints
    }
    
    func calculateAfterGetACardInSilence()->String{
        var totalPoints:Int = 0
        totalPoints=Stand()
        //print(cardsInHand)
        //print(totalPoints)
        if totalPoints>21{
            return "Bust"
        }else if totalPoints==21{
            return "21"
        }else{
            return "<21"
        }
    }
    
    func calculateNumberOfCardsInHand()->(totalPoints:Int,numberOfAce:Int){
        var totalPoints:Int = 0
        var numberOfAce:Int = 0
        
        for card in cardsInHand {
            
            switch card{
            case "A":
                numberOfAce+=1
                totalPoints+=11
            case "T":
                totalPoints+=10
            default:
                totalPoints+=Int(card)!
            }
        }
        return (totalPoints,numberOfAce)
    }
    
}
