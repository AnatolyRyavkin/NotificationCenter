//
//  ViewController.swift
//  NotificationCenter
//
//  Created by Anatoly Ryavkin on 01.04.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit
let KeyNotifyChangeSomeClassNum = NSNotification.Name(rawValue: "keyNotifyChangeSomeClassNum")
let KeyNum = NSNotification.Name(rawValue: "KeyNum")
let KeyDate = NSNotification.Name(rawValue: "KeyDate")
let NC = NotificationCenter.default

class SomeClass{
    var num = 10000
    init() {
        NC.addObserver(self, selector: #selector(decrimentNum), name: KeyNotifyChangeSomeClassNum, object: self)
    }
    func changeNum(num: Int){
        let numOut = num + 20
        let userInfo: [AnyHashable : Any] = [KeyNum: numOut, KeyDate : Date.init()]
        NC.post(name: KeyNotifyChangeSomeClassNum, object: self, userInfo: userInfo)
    }
    @ objc func decrimentNum( _ notification: Notification) {
        if let userInfo = notification.userInfo{
            if let num = userInfo[KeyNum]{
                self.num = (num as? Int ?? 0) / 2
                return
            }
        }
        print("Get notification for ")
    }
    deinit{
        NC.removeObserver(self)
    }
}

class ViewController: UIViewController {

    var someClass: SomeClass!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        someClass = SomeClass()
        sleep(1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NC.addObserver(forName: KeyNotifyChangeSomeClassNum, object: someClass, queue: OperationQueue.main) { (notification) in
            let numNew: Int = (notification.object as! SomeClass).num
            let date = notification.userInfo![KeyDate]
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.init(rawValue: 2)!
            print("date = ",dateFormatter.string(from: date as! Date)," New num = ",numNew)
        }
        for _ in 0...10{
            someClass.changeNum(num: someClass.num)
            sleep(0)
        }
        print("end self.someClass.num = ",self.someClass.num)
        self.someClass = nil
        NC.removeObserver(self)
    }
}

