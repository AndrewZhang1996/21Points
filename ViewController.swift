//
//  ViewController.swift
//  21points
//
//  Created by 张雲淞 on 2018/5/7.
//  Copyright © 2018年 张雲淞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var PlayerDisplay: UILabel!
    @IBOutlet weak var PlayerStandButton: UIButton!
    @IBOutlet weak var PlayerHitButton: UIButton!
    @IBOutlet weak var PlayerNameLabel: UILabel!
    @IBOutlet weak var PlayerStatusLabel: UILabel!
    
    @IBOutlet weak var BankerDisplay: UILabel!
    @IBOutlet weak var BankerBlindCard: UILabel!
    @IBOutlet weak var BankerShowBlindCardButton: UIButton!
    @IBOutlet weak var BankerHitButton: UIButton!
    @IBOutlet weak var BankerStandButton: UIButton!
    @IBOutlet weak var BankerStatusLabel: UILabel!
    
    var isBlindCardShow:Bool = false
    var playerSeenCards:String = ""
    var bankerSeenCards:String = ""
    var isFirstRound:Bool = true
    var isBankerBust:Bool = false
    var isPlayerBust:Bool = false
    
    var player = Rules(isBankerFlag: false)
    var banker = Rules(isBankerFlag: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PlayerDisplay.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        PlayerStandButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        PlayerHitButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        PlayerNameLabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        PlayerStatusLabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bankerDone(displayText:String){
        BankerStatusLabel.text = displayText
        BankerBlindCard.isHidden=false
        BankerShowBlindCardButton.isEnabled = false
        BankerHitButton.isEnabled = false
        BankerStandButton.isEnabled = false
        BankerShowBlindCardButton.setTitle("Hide Blind Card", for: .normal)
    }
    func playerDone(displayText:String){
        PlayerStatusLabel.text = displayText
        PlayerHitButton.isEnabled = false
        PlayerStandButton.isEnabled = false
    }

    @IBAction func Restart(_ sender: UIButton) {
        isFirstRound=true
        banker.initialize()
        player.initialize()
        PlayerDisplay.text = ""
        PlayerStatusLabel.text = ""
        BankerDisplay.text = ""
        BankerBlindCard.text = ""
        BankerStatusLabel.text = ""
        BankerBlindCard.isHidden = true
        PlayerHitButton.isEnabled = true
        PlayerStandButton.isEnabled = true
        BankerShowBlindCardButton.isEnabled = true
        BankerHitButton.isEnabled = true
        BankerStandButton.isEnabled = true
        BankerShowBlindCardButton.setTitle("Show Blind Card", for: .normal)
    }
    
    @IBAction func Start(_ sender: UIButton) {
        if isFirstRound{
            BankerBlindCard.isHidden = true
            let bankerStartCards = banker.start()
            let playerStartCards = player.start().seenCards
            let bankerStartSeenCards = bankerStartCards.seenCards
            let bankerStartBlindCard = bankerStartCards.blindCard
            let bankerStartTotalPoints = banker.calculateAfterGetACardInSilence()
            let playerStartTotalPoints = player.calculateAfterGetACardInSilence()
            
            playerSeenCards = playerStartCards[0] + " " + playerStartCards[1]
            PlayerDisplay.text = playerSeenCards
            bankerSeenCards = bankerStartSeenCards[0]
            BankerDisplay.text = bankerSeenCards
            BankerBlindCard.text = bankerStartBlindCard
            isFirstRound = false
            if bankerStartTotalPoints=="21"{
                bankerDone(displayText: "BlackJack!")
            }
            if playerStartTotalPoints=="21"{
                playerDone(displayText: "BlackJack!")
            }
        }else{
            
        }
    }
    
    @IBAction func BankerShowBlindCard(_ sender: UIButton) {
        if isBlindCardShow{
            BankerBlindCard.isHidden=true
            isBlindCardShow=false
            BankerShowBlindCardButton.setTitle("Show Blind Card", for: .normal)
        }else{
            BankerBlindCard.isHidden=false
            isBlindCardShow=true
            BankerShowBlindCardButton.setTitle("Hide Blind Card", for: .normal)
        }
    }
    
    @IBAction func HitBanker(_ sender: UIButton) {
        if isFirstRound==false{
            let bankerGetACard = banker.getACard()
            bankerSeenCards+=" " + bankerGetACard
            BankerDisplay.text = bankerSeenCards
            let totalPoints = banker.calculateAfterGetACardInSilence()
            //print("total:"+totalPoints)
            if totalPoints=="Bust"{
                isBankerBust = true
                bankerDone(displayText: "Bust!")
            }else if totalPoints=="21"{
                bankerDone(displayText: "21!")
            }
        }
    }
    
    @IBAction func BankerStand(_ sender: UIButton) {
        if isFirstRound==false{
            let totalPoints = banker.Stand()
            bankerDone(displayText: String(totalPoints))
        }
    }
    
    @IBAction func HitPlayer(_ sender: UIButton) {
        if isFirstRound==false{
            let playerGetACard = player.getACard()
            playerSeenCards+=" " + playerGetACard
            PlayerDisplay.text = playerSeenCards
            let totalPoints = player.calculateAfterGetACardInSilence()
            if totalPoints=="Bust"{
                isPlayerBust=true
                playerDone(displayText: "Bust!")
            }else if totalPoints=="21"{
                playerDone(displayText: "21!")
            }
        }
    }
    
    @IBAction func PlayerStand(_ sender: UIButton) {
        if isFirstRound==false{
            let totalPoints = player.Stand()
            playerDone(displayText: String(totalPoints))
        }
    }
}

