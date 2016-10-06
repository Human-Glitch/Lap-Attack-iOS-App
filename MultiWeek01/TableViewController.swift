//
//  TableViewController.swift
//  MultiWeek01
//
//  Created by Kody Buss on 10/4/16.
//  Copyright © 2016 Kody Buss. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController{

    @IBOutlet var LapsTableView: UITableView!
    @IBOutlet var fastestLapTimeLbl: UILabel!
    @IBOutlet var slowestLapTimeLbl: UILabel!
    @IBOutlet var averageLapTimeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = view as? UITableView
        {
            view.contentInset.top = 10
            view.scrollIndicatorInsets.top = 10
        
        }
        TimeTracker.lapList.reverse()
        
    //slowestTimeLabel
        var minutesString = TimeTracker.slowestLapTime.0 > 9 ? "\(TimeTracker.slowestLapTime.0)" : "0\(TimeTracker.slowestLapTime.0)"
        
        var secondsString = TimeTracker.slowestLapTime.1 > 9 ? "\(TimeTracker.slowestLapTime.1)" : "0\(TimeTracker.slowestLapTime.1)"
        
        var fractionsString = TimeTracker.slowestLapTime.2 > 9 ? "\(TimeTracker.slowestLapTime.2)" : "0\(TimeTracker.slowestLapTime.2)"
        
        slowestLapTimeLbl.text = ("\(minutesString) : \(secondsString) . \(fractionsString)")
        
    //fastestLapTimeLbl
        minutesString = TimeTracker.fastestLapTime.0 > 9 ? "\(TimeTracker.fastestLapTime.0)" : "0\(TimeTracker.fastestLapTime.0)"
        
        secondsString = TimeTracker.fastestLapTime.1 > 9 ? "\(TimeTracker.fastestLapTime.1)" : "0\(TimeTracker.fastestLapTime.1)"
        
        fractionsString = TimeTracker.fastestLapTime.2 > 9 ? "\(TimeTracker.fastestLapTime.2)" : "0\(TimeTracker.fastestLapTime.2)"
        
        fastestLapTimeLbl.text = ("\(minutesString) : \(secondsString) . \(fractionsString)")
        
    //avergeLapTimeLbl
        minutesString = TimeTracker.averageLapTime.0 > 9 ? "\(TimeTracker.averageLapTime.0)" : "0\(TimeTracker.averageLapTime.0)"
        
        secondsString = TimeTracker.averageLapTime.1 > 9 ? "\(TimeTracker.averageLapTime.1)" : "0\(TimeTracker.averageLapTime.1)"
        
        fractionsString = TimeTracker.averageLapTime.2 > 9 ? "\(TimeTracker.averageLapTime.2)" : "0\(TimeTracker.averageLapTime.2)"
        
        averageLapTimeLbl.text = ("\(minutesString) : \(secondsString) . \(fractionsString)")
        
    //Reload TableView with data
        LapsTableView.reloadData()
        
    
    }
    
    //Shows navigation controller
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TimeTracker.lapList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFirstCell", for: indexPath)

        //let row = (TimeTracker.lapList.count - indexPath.row)
        let row = indexPath.row
        
        cell.textLabel?.text = "Lap \(row)"
    
        cell.detailTextLabel?.text = TimeTracker.lapList[(indexPath.row)]
        
        return cell
    }
    
    
}
