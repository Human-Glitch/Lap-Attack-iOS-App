//  TimeTracker.swift
//  MultiWeek01
//
//  Created by Kody Buss on 10/3/16.
//  Copyright © 2016 Kody Buss. All rights reserved.
//

import UIKit

class TimeTracker: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Hides navigation Controller
    override func viewWillAppear(_ animated: Bool)
    {
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
    
    //Static variables that talk to Table View
    static var lapList : [String] = []
    static var fastestLapTime : (Int, Int, Int) = (0, 0, 0)
    static var slowestLapTime : (Int, Int, Int) = (0, 0, 0)
    static var averageLapTime : (Int, Int, Int) = (0, 0, 0)
    
    //totalTime Variables\\
    var fractions: Int = 0
    var seconds: Int = 0
    var minutes: Int = 0
    
    //currentLapTime Variables\\
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
    
    //RESET BTN\\
    @IBAction func resetBtn(_ sender: AnyObject)
    {
        timer.invalidate()
        
        //Reset label text on VC1
        currentLapTime.text = "00 : 00 . 00"
        totalTime.text = "00 : 00 . 00"
        lapCounter.text = "0"
        
        //reset totalTime members
        fractions = 0
        seconds = 0
        minutes = 0
        lap = 0
        
        //reset currentLapTime members
        lapFractions = 0
        lapSeconds = 0
        lapMinutes = 0
        
        //reset tuple member
        lapContainer.removeAll()
        
        //reset static variable members
        TimeTracker.lapList.removeAll()
        TimeTracker.fastestLapTime = (0, 0, 0)
        TimeTracker.slowestLapTime = (0, 0, 0)
        TimeTracker.averageLapTime = (0, 0, 0)
        
        
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
        
        //As green Start button
        startStopBtn.setBackgroundImage(#imageLiteral(resourceName: "greenRect.png"), for:.normal);
        startStopBtn.setTitle("Start", for: .normal)
        startStopBtn.setTitleColor(UIColor.green, for: .normal)
    }
    

    //NEW LAP BTN\\
    @IBAction func tappedNewLapBtn(_ sender: AnyObject)
    {
        addLap = true
    }
    
    //STOP START BTN\\
    @IBAction func tappedStartStopBtn(_ sender: AnyObject)
    {
        
        //Start Button
        if (started == false)
        {
            let aSelector : Selector = #selector(TimeTracker.updateTime)
        
            timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
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
        
        //Stop Btn
        else if(started == true)
        {
            //stop Timer\\
            timer.invalidate()
            
            lapContainer.append((lapMinutes, lapSeconds, lapFractions))
            
            //Only count current laptime if it is not the first lap
            if TimeTracker.lapList.count > 0
            {
                lap+=1
                lapCounter.text = String(lap)
                
                let finalLap = currentLapTime.text
                //submit final currentLapTime\\
                TimeTracker.lapList.insert((finalLap)!, at: 0)
            }
            
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
    
    @IBAction func tappedShowStatsBtn(_ sender: AnyObject)
    {
        
        //Assign static members the proper statistic calculations
        TimeTracker.slowestLapTime = calculateSlowestLap(lapContainer: lapContainer)
        TimeTracker.fastestLapTime = calculateFastestLap(lapContainer: lapContainer)
        TimeTracker.averageLapTime = calcAverageLap(lapContainer: lapContainer)
    }
    
    
    //Calculate time separately from totalTime and currentLapTime, convert to string for labels and tables
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
    
    //Calculate Slowest Lap for TableView Labels
    func calculateSlowestLap(lapContainer: [(Int, Int, Int)]) -> (Int, Int, Int)
    {
        //NOTE: LARGER NUMBER MEANS SLOWER
        
        var slowestTuple : (Int, Int, Int) = (0, 0, 0)
        
        slowestTuple = lapContainer[0]
    
        //COMPARE ALL ITEMS IN TABLE VIEW
        for index in lapContainer.indices
        {
            print()
            print("-----------------------------------------------")
            print("LapContainer \(index): \(lapContainer[index])")
            print("Slowest Tuple: \(slowestTuple)")
            print("-----------------------------------------------")
            
            //Check Minutes first
            if (lapContainer[index].0 == slowestTuple.0)
            {
                //Check Seconds next
                if(lapContainer[index].1 == slowestTuple.1)
                {
                    //Check Fractions next
                    if(lapContainer[index].2 > slowestTuple.2)
                    {
                        slowestTuple = lapContainer[index]
                    }
                //Seconds cont..
                }else if(lapContainer[index].1 > slowestTuple.1)
                {
                    //lapContainer seconds makes it new slowestTuple
                    slowestTuple = lapContainer[index]
                }
            //Minutes cont...
            }else if(lapContainer[index].0 > slowestTuple.0)
            {
                //lapContainer minutes makes it new slowestTuple
                slowestTuple = lapContainer[index]
            }
            
        }//end for loop
        return slowestTuple
    
    }//end function
    
    
    //Calculate Fastest Lap for TableView Labels
    func calculateFastestLap(lapContainer: [(Int, Int, Int)]) -> (Int, Int, Int)
    {
        //NOTE: SMALLER NUMBER MEANS FASTER
        
        var fastestTuple : (Int, Int, Int) = (0, 0, 0)
        
        fastestTuple = lapContainer[0]
        
        //COMPARE ALL ITEMS IN TABLE VIEW
        for index in lapContainer.indices
        {
            print()
            print("-----------------------------------------------")
            print("LapContainer \(index): \(lapContainer[index])")
            print("Fastest Tuple: \(fastestTuple)")
            print("-----------------------------------------------")
            
            //Check Minutes first
            if (lapContainer[index].0 == fastestTuple.0)
            {
                //Check Seconds next
                if(lapContainer[index].1 == fastestTuple.1)
                {
                    //Check Fractions next
                    if(lapContainer[index].2 < fastestTuple.2)
                    {
                        fastestTuple = lapContainer[index]
                    }
                    //Seconds cont..
                }else if(lapContainer[index].1 < fastestTuple.1)
                {
                    //lapContainer seconds makes it new slowestTuple
                    fastestTuple = lapContainer[index]
                }
                //Minutes cont...
            }else if(lapContainer[index].0 < fastestTuple.0)
            {
                //lapContainer minutes makes it new slowestTuple
                fastestTuple = lapContainer[index]
            }
            
        }//end for loop
        
        return fastestTuple
    }//end function

    func calcAverageLap( lapContainer: [(Int, Int, Int)] )-> (Int, Int, Int)
    {
        var averageTuple : (Int, Int, Int) = (0, 0, 0)
        
        //COMPARE ALL ITEMS IN TABLE VIEW
        for index in lapContainer.indices
        {
            /*
            print()
            print("-----------------------------------------------")
            print("LapContainer \(index): \(lapContainer[index])")
            print("Tuple minutes: \(averageTuple.0)")
            print("Tuple seconds: \(averageTuple.1)")
            print("Tuple fractions: \(averageTuple.2)")
            */
            print("-----------------------------------------------")
            
            averageTuple.0 += lapContainer[index].0
            averageTuple.1 += lapContainer[index].1
            averageTuple.2 += lapContainer[index].2
 
        }
        
        print("Total fractions : \(averageTuple.2)")
        
        if lapContainer.count == 2 && averageTuple.1 > 0
        {
            averageTuple.2 += 100
            averageTuple.2 = (averageTuple.2/lapContainer.count)
            
            print("Activated: lapContainer.count == 2 && averageTuple.1 > 0")
            
        }else {averageTuple.2 = ((averageTuple.2)/lapContainer.count)}
        
        while averageTuple.2 >= 100
        {
            averageTuple.2 -= 100
            averageTuple.1 += 1
        }
        
        print("Average fractions : \(averageTuple.2)")
        
        averageTuple.1 = ((averageTuple.1)/lapContainer.count)
        while averageTuple.1 >= 60
        {
            averageTuple.1 -= 60
            averageTuple.0 += 1
        }
    
        averageTuple.0 = ((averageTuple.0)/lapContainer.count)
        while averageTuple.0 >= 60
        {
            averageTuple.0 -= 60
            
        }
        
        return averageTuple
    
    }
    
}//end main
