//
//  EventListController.swift
//  RouteRoutePro
//
//  Created by 安齋洸也 on 2018/11/09.
//  Copyright © 2018年 安齋洸也. All rights reserved.
//

import Foundation
import UIKit

class EventListController: UITableViewController {
    var userid:String?
    
    // sample data
    let eventlist = [(id:"e00000001",name:"Test Cycle!",detail:"This is test!",email:"hogehoge@yahoo.co.jp",latitude:"35.658581",longitude:"139.745433",date:"20181120",starttime:"1120",endtime:"1320"),(id:"e00000002",name:"Happy Cycle!",detail:"This is happy test!",email:"fugafuga@gmail.com",latitude:"12.345678",longitude:"123.456789",date:"20181224",starttime:"1020",endtime:"2020"),(id:"e00000003",name:"Horihori Cycle!",detail:"This is horihori!",email:"horifuga@yahoo.co.jp",latitude: "35.658510",longitude:"139.745420",date:"20181027",starttime:"0820",endtime:"2320")]
    
    private lazy var routeModel = RouteModel()
    private lazy var eventList = Array<Event>()
    let dateFormat = DateFormatter()
    let dbDateFormat = DateFormatter()
    var sysTime: Int64?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        userid = appDelegate.userid!
        
        let NotifMycation = NSNotification.Name(rawValue:"MyNSNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NotifMycation, object: nil)
        
        loadData()
        dateFormat.dateFormat = "yyyy/MM/dd"
        dbDateFormat.dateFormat = "yyyy/MM/dd HH:mm"
    }
    
    func loadData() {
        routeModel.eventList { (result: EventListResult) in
            guard result.eventList != nil else {
                return
            }
            self.sysTime = result.sysTime
            self.eventList = result.eventList!
            self.tableView?.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func upDataChange(notif: NSNotification) {
        loadData()
    }
    
    //route event
    @IBAction func selectRouteEvent(_ sender: Any) {
        self.performSegue(withIdentifier: "goRouteEvent", sender: self)
    }
    
    //number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    //create cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventcell", for: indexPath)
        let event = eventList[indexPath.row]
        let title = cell.viewWithTag(1001) as! UILabel
        let subtitle = cell.viewWithTag(1002) as! UILabel
        let state = cell.viewWithTag(1003) as! UILabel
        if event.name != nil {
            title.text = event.name
        }
        if event.detail != nil {
            subtitle.text = event.detail
        }
        
        if event.startDate != nil && event.startTime != nil && event.endDate != nil && event.endTime != nil {
            let sTime = dbDateFormat.date(from: event.startDate! + " " + event.startTime!)?.milliStamp
            let eTime = dbDateFormat.date(from: event.endDate! + " " + event.endTime!)?.milliStamp
            let timeInterval:TimeInterval = TimeInterval(sysTime!/1000)
            let date = Date(timeIntervalSince1970: timeInterval)
            let nowDate = dateFormat.string(from: date as Date)
            if sTime != nil && eTime != nil {
                if sysTime! >= sTime! && sysTime! <= eTime! {
                    state.text = "開催中!"
                    state.isHidden = false
                }else if nowDate >= event.startDate! && nowDate <= event.endDate! {
                    state.text = "本日開催!"
                    state.isHidden = false
                }else {
                    state.isHidden = true
                }
            }else{
                state.isHidden = true
            }
        }
        
        return cell
    }
    
    //tap cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventList[indexPath.row]
        // ここで管理者か一般ユーザか分岐。今はまだ未実装
        if userid == event.userid {
            //監理者イベント
            self.performSegue(withIdentifier: "goOwnerEvent", sender: self)
        }else{
            //参加イベント
            self.performSegue(withIdentifier: "goUserEvent", sender: self)
        }
    }
    
    //data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goOwnerEvent" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let eventData = eventList[(indexPath as NSIndexPath).row]
                let nav = segue.destination as! UINavigationController
                let secondView = nav.topViewController as! OwnerEventController
                secondView.eventData = eventData
            }
        }else if segue.identifier == "goUserEvent" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let eventData = eventList[(indexPath as NSIndexPath).row]
                let nav = segue.destination as! UINavigationController
                let secondView = nav.topViewController as! UserEventController
                secondView.eventData = eventData
            }
        }
    }
    
    //戻る実装
    @IBAction func myUnwindAction(segue: UIStoryboardSegue) {
        
    }

    @IBAction func backSegue(segue : UIStoryboardSegue){
        if segue.identifier == "goRouteEvent"{
            //获取返回的控制器
            let backVC = segue.source as! RouteEventController
            print(backVC.goallat)//获取返回值
        }
    }
    
}
