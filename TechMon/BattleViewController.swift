//
//  BattleViewController.swift
//  TechMon
//
//  Created by Shu Fujita on 2020/05/15.
//  Copyright © 2020 Fujita shu. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel:UILabel!
    @IBOutlet var playerImageView:UIImageView!
    @IBOutlet var playerHPLabel:UILabel!
    @IBOutlet var playerMPLabel:UILabel!
    @IBOutlet var playerTPLabel:UILabel!
    
    @IBOutlet var enemyNameLabel:UILabel!
    @IBOutlet var enemyImageView:UIImageView!
    @IBOutlet var enemyHPLabel:UILabel!
    @IBOutlet var enemyMPLabel:UILabel!
    
    let techMonManager = TechMonManager.shared
    
   
    var player: Character!
    var enemy: Character!
    
    var gameTimer: Timer!//ゲーム用タイマー
    var isPlayerAttackAvailable: Bool = true//攻撃できるか
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キャラクターの読み込み
        player = techMonManager.player
        enemy  = techMonManager.enemy
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
        playerTPLabel.text = "\(player.currentTP) / \(player.maxTP)"
        
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
        enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
        
        updateUI()
        
        //ゲームスタート
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1,target: self,selector: #selector(updateGame),
                                         userInfo: nil, repeats: true)
        gameTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           techMonManager.playBGM(fileName: "BGM_battle001")
    }
       
    override func viewWillDisappear(_ animated: Bool) {
        
           super.viewWillDisappear(animated)
           techMonManager.stopBGM()
    }

    
    //ステータスの反映
    func updateUI(){
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP) /"
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP) /"
        playerTPLabel.text = "\(player.currentTP) / \(player.maxTP) /"
        enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP) /"
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP) /"
    }

    //0.1秒ごとにゲームの状態を更新
    @objc  func updateGame(){
        //プレイヤー
        player.currentMP += 1
        if player.currentMP >= player.maxMP{
            isPlayerAttackAvailable = true
            player.currentMP = player.maxMP
        }else{
            isPlayerAttackAvailable = false
        }
        //敵
        enemy.currentMP += 1
        if enemy.currentMP >= enemy.maxMP{
            enemyAttack()
            enemy.currentMP = 0
        }
        updateUI()
    }
    
 

    //勝敗の決定
    func finishBattle(vanishImageView: UIImageView, isPlayerwin: Bool){
        
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishingMessage: String = ""
        if isPlayerwin{
            techMonManager.playSE(fileName: "SE_fanfare")
            finishingMessage = "勇者の勝利！！"
        }else{
            techMonManager.playSE(fileName: "SE_gameover")
            finishingMessage = "勇者の敗北…"
        }
        
       let alert = UIAlertController(title: "バトル終了",message: finishingMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil)
        }))
       present(alert, animated: true, completion: nil)
    }
 
        func enemyAttack(){
            techMonManager.damageAnimation(imageView: playerImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            player.currentHP -= 20
            playerHPLabel.text = "\(player.currentHP) / 100"
                
            if player.currentHP <= 0{
                finishBattle(vanishImageView: playerImageView, isPlayerwin: false)                }
            }
        

        //こうげき
         @IBAction func attackAction(){
             
             if isPlayerAttackAvailable{
                 techMonManager.damageAnimation(imageView: enemyImageView)
                 techMonManager.playSE(fileName: "SE_attack")
                 
                 enemy.currentHP -= player.attackPoint
                 player.currentTP += 10
                     if player.currentTP >= player.maxTP{
                         player.currentTP = player.maxTP
                     }
                 player.currentMP = 0
                 
                 updateUI()
                 judgeBattle()
             }
         }
         //ためる
         @IBAction func tameruAction(){
             
             if isPlayerAttackAvailable{
                 
                 techMonManager.playSE(fileName: "SE_charge")
                 player.currentTP += 40
                 if player.currentTP >= player.maxTP{
                     player.currentTP = player.maxTP
             }
             player.currentMP = 0
             }
         }
         //ファイア
         @IBAction func fireAction(){
             if isPlayerAttackAvailable && player.currentTP >= 40{
                 techMonManager.damageAnimation(imageView: enemyImageView)
                 techMonManager.playSE(fileName: "SE_fire")
                 
                 enemy.currentHP -= 100
                 player.currentTP -= 40
                 if player.currentTP <= 0{
                     player.currentTP = 0
                 }
                 player.currentMP = 0
                 
                 judgeBattle()
             }
    }
        //勝敗判定
        func judgeBattle(){
            if player.currentHP <= 0{
                finishBattle(vanishImageView: playerImageView, isPlayerwin: false)
            }else if enemy.currentHP <= 0{
                finishBattle(vanishImageView: enemyImageView, isPlayerwin: true)
        }

    }

 
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

