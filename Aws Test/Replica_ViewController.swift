//
//  Replica_ViewController.swift
//  Aws Test
//
//  Created by Developer Skromanglobal on 08/08/22.
//

import UIKit
import AWSCore
import AWSIoT
import Alamofire

class Replica_ViewController: UIViewController {

    @IBOutlet weak var replica_check_box: UIButton!
    
    @IBOutlet weak var non_replica_box: UIButton!
    
    var check_box_flag = false
    
    var Rp_value : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func configure_button(_ sender: UIButton) {
        
        replica_config(mode: Rp_value)
        
    }
    
    @IBAction func replica_button_box(_ sender: UIButton) {
        
        
        if check_box_flag == false {
            
            replica_check_box.setImage(UIImage(named: "check"), for: UIControl.State.normal)
            
            check_box_flag = true
            Rp_value = "replica"
            print("Rp_value", Rp_value!)
            non_replica_box.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
        }
        
        else {
            
            replica_check_box.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            
            
            check_box_flag = false
        }
        
        
    }
    
    @IBAction func non_replica_button_box(_ sender: UIButton) {
        
        
        if check_box_flag == false {
            
            non_replica_box.setImage(UIImage(named: "check"), for: UIControl.State.normal)
            
            check_box_flag = true
            Rp_value = "non_replica"
            print("Rp_value", Rp_value!)
            replica_check_box.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
        }
        
        else {
            
            non_replica_box.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            check_box_flag = false
        }
        
    }
    
    
    
    func replica_config(mode: String) {
        
        
        let replica_params : Parameters = [
            
            
            "control":"work_mode",
            "mode": mode
            
        ]
        
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: replica_params,options: []) {
            
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            
            
            let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
            
            let iot_sample_vc = Iot_sample_ViewController()
            
            iotDataManager.publishString(theJSONText!, onTopic:iot_sample_vc.topic_pub, qoS:.messageDeliveryAttemptedAtMostOnce)
            
            
        }
        
        
    }
    
    
}
