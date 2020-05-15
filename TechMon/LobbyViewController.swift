//
//  LobbyViewController.swift
//  TechMon
//
//  Created by Shu Fujita on 2020/05/15.
//  Copyright © 2020 Fujita shu. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    @IBOutlet var nameLabal: UILabel!
    @IBOutlet var staminaLabal: UILabel!

    let techMonManager = TechMonManager.shared
    
    var stamina: Int = 100
    var staminaTimer: Timer!
    
    //アプリの起動で一度だけ
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI設定
        nameLabal.text = "勇者"
        staminaLabal.text = "\(stamina) / 100"
        //タイマー
        staminaTimer = Timer.scheduledTimer(timeInterval: 3,
                                            target: self,
                                            selector: #selector(updateStaminaValue),
                                            userInfo: nil,
                                            repeats: true)
        staminaTimer.fire()
        
    }
    //ロービー画面が見える時
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "lobby")
    }
     //ロービー画面が見えなくなる時
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    //冒険へ行くボタン
    @IBAction func toBattle(){
        if stamina >= 50{
            stamina -= 50
            staminaLabal.text = "\(stamina) / 100"
            performSegue(withIdentifier: "toBattle", sender: nil)
        }else{
            let alert = UIAlertController(
            title: "バトルに行けません",
            message: "スタミナをためてください",
            preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    //スタミナの回復
    @objc func updateStaminaValue(){
        if stamina < 100{
            stamina += 1
            staminaLabal.text = "\(stamina) / 100"
        }

        // Do any additional setup after loading the view.
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
