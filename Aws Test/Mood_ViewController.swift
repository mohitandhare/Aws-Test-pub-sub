//
//  Mood_ViewController.swift
//  Aws Test
//
//  Created by Developer Skromanglobal on 08/08/22.
//

import UIKit
import AWSCore
import AWSIoT
import Alamofire

class Mood_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    

    @IBOutlet weak var mood_collectionView: UICollectionView!
    
    var device_no_array = ["Device No.1",
                           "Device No.2",
                           "Device No.3",
                           "Device No.4",
                           "Device No.5",
                           "Device No.6",
                           "Device No.7",
                           "Device No.8"]
    
    var array_value = ["0","0","0","0","0","0","0","0"]
    
    var string_array = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mood_collectionView.delegate = self
        mood_collectionView.dataSource = self
        mood_collectionView.reloadData()
        
        
    }
    
    @IBAction func set_config_button(_ sender: UIButton) {
        
        let join_selected_device = array_value.joined(separator: "")
        
        mood_config(val: join_selected_device)
        
    }
    
    
    
    
    func mood_config(val: String) {
        
        
        let mood_params : Parameters = [
            
            
            "control":"how_many_dev_control",
            "val": val
            
        ]
        
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: mood_params,options: []) {
            
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            
            
            let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
            
            let iot_sample_vc = Iot_sample_ViewController()
            
            iotDataManager.publishString(theJSONText!, onTopic:iot_sample_vc.topic_pub, qoS:.messageDeliveryAttemptedAtMostOnce)
            
            
        }
        
        
    }
    
    
    
}


extension Mood_ViewController {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return device_no_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let mood_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Mood_Cell", for: indexPath) as! Mood_CollectionViewCell
        
        mood_cell.mood_device_no_label.text = device_no_array[indexPath.row]
        
        mood_cell.mood_device_view.layer.cornerRadius = 10
        mood_cell.mood_device_view.layer.borderColor = UIColor.black.cgColor
        mood_cell.mood_device_view.layer.borderWidth = 2
        
        
        
        return mood_cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mood_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Mood_Cell", for: indexPath) as! Mood_CollectionViewCell
        
        
        var select_val_device : Int!
       
        select_val_device = indexPath.row + 1
        
        print("select_val_device >>", select_val_device!)
        
        if array_value[indexPath.row] == "1" {
        
            array_value[indexPath.row] = "0"
            
        }
        
        else if array_value[indexPath.row] == "0" {
            
            array_value[indexPath.row] = "1"
            mood_cell.check_image.image = UIImage(named: "check")
            
        }
        print("array_value", array_value)
        
    }
    
    
    
}
