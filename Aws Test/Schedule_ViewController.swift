//
//  Schedule_ViewController.swift
//  Aws Test
//
//  Created by Developer Skromanglobal on 07/08/22.
//

import UIKit
import AWSCore
import AWSIoT
import Alamofire

class Schedule_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var Schedule_CollectionView: UICollectionView!
    
    
    @IBOutlet weak var schedule_button_collectionView: UICollectionView!
    
    
    @IBOutlet weak var weekly_box_outlet: UIButton!
    @IBOutlet weak var daily_box_outlet: UIButton!
    @IBOutlet weak var perticular_day_box_outlet: UIButton!
    
    
    
    @IBOutlet weak var day_collectionView: UICollectionView!
    
    let timePicker = UIDatePicker()
    var StartHours_Value : Int!
    var StartMinutes_Value : Int!
    let calender = Calendar.current
    var time_text : String!
    var schedule_selected_value : Int!
    var selected_days : String!
    
    @IBOutlet weak var time_label: UILabel!
    
    @IBOutlet weak var time_select: UITextField!
    
    var schedule_type_flag = false
    var schedule_type_string : String!
    
    
    let Schedule_array = ["Schedule 1",
                          "Schedule 2",
                          "Schedule 3",
                          "Schedule 4",
                          "Schedule 5",
                          "Schedule 6",
                          "Schedule 7",
                          "Schedule 8",
                          "Schedule 9",
                          "Schedule 10",]
    
    
    let Days_Array = ["Mon",
                      "Tue",
                      "Wed",
                      "Thur",
                      "Fri",
                      "Sat",
                      "Sun",]
    
    
    var Days_selected = ["0","0","0","0","0","0","0"]
    
    
    
    
    var publish_days_selected = [""]
    var publish_l_state = [""]
    var publish_fan_state = [""]
    
    
    
    var schedule_vc_l_state_array = [String]()
    
    var schedule_vc_fan_state_array = [String]()
    
    var schedule_vc_combine_array = [Any]()
    
    
    var schedule_vc_c_nm_array = [Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("schedule_vc_l_state_array : <<<NOW>>> " , schedule_vc_l_state_array)
        
//        day_collectionView.isHidden = true
        
        StartHours_Value = 0
        StartMinutes_Value = 0
        
        let StartTime_Tool_Bar = UIToolbar()
        StartTime_Tool_Bar.sizeToFit()
        
        let firstStartTime_Tool_Bar_Done_Btn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(firstStartTimeDoneBtn))
        
        StartTime_Tool_Bar.items = [firstStartTime_Tool_Bar_Done_Btn]
        
        
        StartTime_Tool_Bar.items = [firstStartTime_Tool_Bar_Done_Btn]
        
        timePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2 + 60), width: self.view.frame.width, height: 200)
        
        timePicker.backgroundColor = UIColor.gray
        firstStartTime_Tool_Bar_Done_Btn.tintColor = UIColor.black
        StartTime_Tool_Bar.tintColor = UIColor.lightGray
        
        
        
        time_select.inputAccessoryView = StartTime_Tool_Bar
        time_select.tintColor = UIColor.white
        time_select.inputView = timePicker
        
        
        
        
        
        
        print("L STATE ",schedule_vc_l_state_array)
        print("C N M ",schedule_vc_c_nm_array)
        print("Combine Array",schedule_vc_combine_array)
        
        Schedule_CollectionView.delegate = self
        Schedule_CollectionView.dataSource = self
        Schedule_CollectionView.reloadData()
        
        schedule_button_collectionView.delegate = self
        schedule_button_collectionView.dataSource = self
        schedule_button_collectionView.reloadData()
        
        day_collectionView.delegate = self
        day_collectionView.dataSource = self
        day_collectionView.reloadData()
        
    }
    
    @IBAction func weekly_box_button(_ sender: UIButton) {
        
        if schedule_type_flag == false {
            
            weekly_box_outlet.setImage(UIImage(named: "check"), for: UIControl.State.normal)
            schedule_type_flag = true
            schedule_type_string = "W"
            Days_selected = ["1","1","1","1","1","1","1"]
            day_collectionView.isHidden = false
            
            daily_box_outlet.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            perticular_day_box_outlet.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
        }
        
        else {
            
            weekly_box_outlet.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            schedule_type_flag = false
            
        }
        
    }
    
    
    @IBAction func daily_box_button(_ sender: UIButton) {
        
        if schedule_type_flag == false {
            
            daily_box_outlet.setImage(UIImage(named: "check"), for: UIControl.State.normal)
            schedule_type_flag = true
            schedule_type_string = "D"
            
            Days_selected = ["1","1","1","1","1","1","1"]
            
            weekly_box_outlet.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            perticular_day_box_outlet.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            
            day_collectionView.isHidden = true
            
        }
        
        else {
            
            daily_box_outlet.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            schedule_type_flag = false
            
        }
        
    }
    
    
    
    @IBAction func perticular_day_box_button(_ sender: UIButton) {
        
        if schedule_type_flag == false {
            
            perticular_day_box_outlet.setImage(UIImage(named: "check"), for: UIControl.State.normal)
            schedule_type_flag = true
            schedule_type_string = "P"
            
            daily_box_outlet.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            weekly_box_outlet.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            
            day_collectionView.isHidden = true
            
        }
        
        else {
            
            perticular_day_box_outlet.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            schedule_type_flag = false
            
        }
        
    }
    
    @objc func firstStartTimeDoneBtn() {
        
        let firstStartFormatter = DateFormatter()
        
        firstStartFormatter.dateFormat = "HH:mm"
        firstStartFormatter.timeStyle = .short
        
        time_select.text = firstStartFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
        
        StartHours_Value = calender.component(.hour, from: timePicker.date)
        StartMinutes_Value = calender.component(.minute, from: timePicker.date)
        
        print("HOURS =====", StartHours_Value!)
        print("Minutes =====", StartMinutes_Value!)
        
    }
    
    
    
    @IBAction func save_time(_ sender: UIButton) {
        
        var final_time : String!
        
        publish_days_selected = Days_selected
        let join_selected_days = publish_days_selected.joined(separator: "")
        
        publish_l_state = schedule_vc_l_state_array
        let join_l_state = publish_l_state.joined(separator: "")
        
        publish_fan_state = schedule_vc_fan_state_array
        let join_fan_state = publish_fan_state.joined(separator: "")
        
        
        
        print("join_selected_days", join_selected_days)
        print("join_l_state", join_l_state)
        print("join_fan_state", join_fan_state)
        
        
        if StartHours_Value < 10 && StartMinutes_Value < 10 {
            
            final_time = "0" + String(StartHours_Value) + ":" + "0" + String(StartMinutes_Value) + ":" + "00"
            print("final_time", final_time!)
            
        }
        
        else if StartHours_Value < 10 {
            
            final_time = "0" + String(StartHours_Value) + ":" + String(StartMinutes_Value) + ":" + "00"
            print("final_time", final_time!)
        }
        
        else if StartMinutes_Value < 10 {
            
            final_time = String(StartHours_Value) + ":" + "0" + String(StartMinutes_Value) + ":" + "00"
            print("final_time", final_time!)
            
        }
        
        
        else {
            
            final_time = String(StartHours_Value) + ":" + String(StartMinutes_Value) + ":" + "00"
            print("final_time", final_time!)
        }
        
        publish_shuffle_config(no: schedule_selected_value, sch_type: schedule_type_string, week_schedule: join_selected_days, time: final_time, L_state: join_l_state, fan_state: join_fan_state)
        
        
    }
    
    
    
    func publish_shuffle_config(no: Int, sch_type: String, week_schedule: String, time: String, L_state: String, fan_state : String) {
        
        
        let shuffle_params : Parameters = [
            
            "control":"scheduler_config",
            "no": no,
            "date":"00/00/00",
            "sch_type": sch_type,
            "week_schedule": week_schedule,
            "time": time,
            "L_state": L_state,
            "L_speed":"666666",
            "F_state": fan_state,
            "F_speed":"4",
            "m_state":0
            
        ]
        
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: shuffle_params,options: []) {
            
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            
            
            let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
            
            let iot_sample_vc = Iot_sample_ViewController()
            
            iotDataManager.publishString(theJSONText!, onTopic:iot_sample_vc.topic_pub, qoS:.messageDeliveryAttemptedAtMostOnce)
            
            
        }
        
        
    }
}

extension Schedule_ViewController {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == Schedule_CollectionView {
            
            return Schedule_array.count
            
        }
        
        else if collectionView == schedule_button_collectionView {
            
            return schedule_vc_combine_array.count
            
        }
        
        else {
            
            
            return Days_Array.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == Schedule_CollectionView {
            
            
            
            let schedule_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Schedule_Cell", for: indexPath) as! Schudule_CollectionViewCell
            
            
            schedule_cell.Schedule_View.layer.cornerRadius = 10
            schedule_cell.Schedule_View.layer.borderColor = UIColor.black.cgColor
            schedule_cell.Schedule_View.layer.borderWidth = 2
            
            schedule_cell.Schedule_Label.text = Schedule_array[indexPath.row]
            
            
            
            return schedule_cell
            
        }
        
        else if collectionView == schedule_button_collectionView {
            
            let schedule_button_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "schedule_button_cell", for: indexPath) as! Schedule_button_CollectionViewCell
            
            
            schedule_button_cell.schedule_button_view.layer.cornerRadius = 10
            schedule_button_cell.schedule_button_view.layer.borderColor = UIColor.black.cgColor
            schedule_button_cell.schedule_button_view.layer.borderWidth = 2
            
            schedule_button_cell.schedule_button_label.text = schedule_vc_c_nm_array[indexPath.row] as! String
            
            let c_nm_value = schedule_button_cell.schedule_button_label.text

            
            print("c_nm_value <<<NOW>>>", c_nm_value)
            
            
            if c_nm_value == "L" {
            
                schedule_button_cell.light_value = schedule_vc_l_state_array[indexPath.row]
                
                print("schedule_button_cell.light_value <NOW>", schedule_button_cell.light_value)
                
                if schedule_button_cell.light_value == "1" {
                    
                    schedule_button_cell.schedule_button_image.image = UIImage(systemName: "lightbulb.fill")
                }
                
                else {
                    
                    schedule_button_cell.schedule_button_image.image = UIImage(systemName: "lightbulb")
                    
                }
            
            }
//
            
            
            return schedule_button_cell
            
        }
        
        else {
            
            let days_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "days_cell", for: indexPath) as! Days_CollectionViewCell
            
            
            days_cell.days_view.layer.cornerRadius = 10
            days_cell.days_view.layer.borderColor = UIColor.black.cgColor
            days_cell.days_view.layer.borderWidth = 2
            
            days_cell.days_label.text = Days_Array[indexPath.row]
            
            
            return days_cell
            
            
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == Schedule_CollectionView {
            
            
            var select_val_time : Int!
            select_val_time = indexPath.row + 1
            
            schedule_selected_value = select_val_time
            
            print(schedule_selected_value!)
            
            
        }
        
        else if collectionView == schedule_button_collectionView {
            
            let schedule_button_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "schedule_button_cell", for: indexPath) as! Schedule_button_CollectionViewCell
            
            var c_name = schedule_vc_c_nm_array[indexPath.row]
            var l_state = schedule_vc_combine_array[indexPath.row]
      
            if c_name as! String == "L" {
                
                if l_state as! String == "1" {
                    
                    schedule_vc_combine_array[indexPath.row] = "0"
                    schedule_vc_l_state_array[indexPath.row] = "0"
                    
                }
                
                else {
                    
                    schedule_vc_combine_array[indexPath.row] = "1"
                    schedule_vc_l_state_array[indexPath.row] = "1"
                    schedule_button_cell.schedule_button_image.image = UIImage(systemName: "lightbulb.fill")
                }
                
            }
            
            if c_name as! String == "F" {
                
                if l_state as! String == "1" {
                    
                    schedule_vc_combine_array[indexPath.row] = "0"
                    schedule_vc_fan_state_array[0] = "0"
                    
                }
                
                else {
                    
                    schedule_vc_combine_array[indexPath.row] = "1"
                    schedule_vc_fan_state_array[0] = "1"
                }
                
                
            }
            
            print("MY COMBINE STATE : >>> ",schedule_vc_combine_array)
            print("schedule_vc_l_state_array : >>>", schedule_vc_l_state_array)
            print("schedule_vc_Fan_state_array : >>>", schedule_vc_fan_state_array)
        }
        
        
        else {
            
            
            selected_days = Days_selected[indexPath.row]
            
            
            if selected_days == "1" {
                
                Days_selected[indexPath.row] = "0"
                
            }
            
            else if selected_days == "0" {
                
                Days_selected[indexPath.row] = "1"
                
            }
            
            print("Now selected_days : >>>> ",Days_selected)
            
        }
        
        
    }
}
