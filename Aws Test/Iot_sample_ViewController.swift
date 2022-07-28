//
//  Iot_sample_ViewController.swift
//  Aws Test
//
//  Created by Developer Skromanglobal on 26/07/22.
//

import UIKit

class Iot_sample_ViewController: UIViewController {

    
    @objc var mqttStatus: String = "Disconnected"
    
    
    var topic_pub: String = "SKSL_1xGLn8/HA/A/req"
    var topic_sub : String = "SKSL_1xGLn8/HA/E/ack"
    
    
//    var topic_pub_two: String = "SKSL_AbCd123/HA/A/req"
//    var topic_sub_two : String = "SKSL_AbCd123/HA/E/ack"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
