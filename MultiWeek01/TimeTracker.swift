//
//  TimeTracker.swift
//  MultiWeek01
//
//  Created by Kody Buss on 10/3/16.
//  Copyright © 2016 Kody Buss. All rights reserved.
//

import UIKit

class TimeTracker: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Hides navigation Controller
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //Button variables\\
    var timer = Timer()
    
    var started: Bool = false
    var addLap: Bool = false
    
    var lap: Int = 0
    var lapHolder: String = ""
    
    var lapContainer :  [ (lapMinutes: Int, lapSeconds: Int, lapFractions : Int) ] = []
    
    static var lapList : [String] = []
    static var fastestLapTime : Int = 0
    static var slowestLapTime : Int = 0
    static var averageLapTime : Int = 0
    
    //Calculation variables\\
    var fractions: Int = 0
    var seconds: Int = 0
    var minutes: Int = 0
    
    var lapFractions: Int = 0
    var lapSeconds: Int = 0
    var lapMinutes: Int = 0
    
    //UI Outlets and Buttons\\
    @IBOutlet var totalTime: UILabel!
    @IBOutlet var currentLapTime: UILabel!
    @IBOutlet var lapCounter: UILabel!
    
    @IBOutlet var newLapBtn: UIButton!
    @IBOutlet var startStopBtn: UIButton!
    @IBOutlet var statsBtn: UIButton!
    
    
    @IBAction func resetBtn(_ sender: AnyObject) {
        timer.invalidate()
        
        currentLapTime.text = "0 : 00 . 0"
        totalTime.text = "0 : 00 . 0"
        lapCounter.text = "0"
        
        fractions = 0
        seconds = 0
        minutes = 0
        lap = 0
        
        lapFractions = 0
        lapSeconds = 0
        lapMinutes = 0
        
        
        //Turn off lap Btn\\
        newLapBtn.isEnabled = false
        newLapBtn.alpha = 0.3
        
        //Turn off show stats btn\\
        statsBtn.isEnabled = false
        statsBtn.alpha = 0.3
        
        started = false
        
        //Turn on startStop btn\\
        startStopBtn.isEnabled = true
        startStopBtn.alpha = 1.0
        
        startStopBtn.setBackgroundImage(#imageLiteral(resourceName: "greenRect.png"), for:.normal);
        startStopBtn.setTitle("Start", for: .normal)
        startStopBtn.setTitleColor(UIColor.green, for: .normal)
        
        
        TimeTracker.lapList.removeAll()
    }

    @IBAction func tappedNewLapBtn(_ sender: AnyObject) {
        
        addLap = true
        
    }
    
    @IBAction func tappedStartStopBtn(_ sender: AnyObject) {
        
        if (started == false)
        {
            let aSelector : Selector = #selector(TimeTracker.updateTime)
        
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
            //Change Start button to Stop button\\
            startStopBtn.setBackgroundImage(#imageLiteral(resourceName: "redRect.png"), for:.normal);
            startStopBtn.setTitle("Stop", for: .normal)
            startStopBtn.setTitleColor(UIColor.red, for: .normal)
            
            //Turn on 'New Lap' Btn\\
            newLapBtn.isEnabled = true
            newLapBtn.alpha = 1.0
            
            //Keep 'Show Stats' Btn Off until 'Stop' is pressed\\
            statsBtn.isEnabled = false //only on when timer is set to stop
            statsBtn.alpha = 0.3
            
            started = true
        }
            
        else if(started == true)
        {
            //stop Timer\\
            timer.invalidate()
            
            let finalLap = currentLapTime.text //ISSUE???
            //submit final currentLapTime\\
            TimeTracker.lapList.insert((finalLap)!, at: 0)
            
            //Turn off lap Btn\\
            newLapBtn.isEnabled = false
            newLapBtn.alpha = 0.3
            
            //Turn on show stats btn\\
            statsBtn.isEnabled = true
            statsBtn.alpha = 1.0
            
            started = false
            
            //Turn off startStop btn\\
            startStopBtn.setBackgroundImage(#imageLiteral(resourceName: "greenRect.png"), for:.normal);
            
            startStopBtn.setTitle("Start", for: .normal)
            startStopBtn.setTitleColor(UIColor.green, for: .normal)
            
            startStopBtn.alpha = 0.3
            startStopBtn.isEnabled = false
            
        }
    }
    
    func updateTime()
    {
        
        //calculate totalTime
        fractions += 1
        if fractions == 100
        {
            seconds += 1
            fractions = 0
        }
        
        if seconds == 60
        {
            minutes += 1
            seconds = 0
        }
        
        //Calculate lap time
        lapFractions += 1
        if lapFractions == 100
        {
            lapSeconds += 1
            lapFractions = 0
        }
        
        if lapSeconds == 60
        {
            lapMinutes += 1
            lapSeconds = 0
        }
        
        //Convert total Time to string\\
        let fractionsString = fractions > 9 ? "\(fractions)" : "0\(fractions)"
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        //Convert lapTime to string\\
        let lapFractionsString = lapFractions > 9 ? "\(lapFractions)" : "0\(lapFractions)"
        let lapSecondsString = lapSeconds > 9 ? "\(lapSeconds)" : "0\(lapSeconds)"
        let lapMinutesString = lapMinutes > 9 ? "\(lapMinutes)" : "0\(lapMinutes)"
        
        if(addLap == true)
        {
            lapContainer.append((lapMinutes, lapSeconds, lapFractions))
            
            TimeTracker.slowestLapTime = calculateSlowestLap(lapContainer: lapContainer)
            
            currentLapTime.text = "\(lapMinutesString) : \(lapSecondsString) . \(lapFractionsString)"
            TimeTracker.lapList.insert((currentLapTime.text)!, at: 0)
            print(currentLapTime.text)
            
            lapFractions = 0
            lapSeconds = 0
            lapMinutes = 0
            
            lap += 1
            
            lapCounter.text = String(lap)
            print(lapCounter.text)
            
            addLap = false
        }
        
        currentLapTime.text = "\(lapMinutesString) : \(lapSecondsString) . \(lapFractionsString)"
        

        totalTime.text = "\(minutesString) : \(secondsString) . \(fractionsString)"
    }
    
    func calculateSlowestLap(lapContainer: [(Int, Int, Int)]) -> Int {
        var answer : Int = 0
        
    
        return answer
    }

    
}//end main


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


