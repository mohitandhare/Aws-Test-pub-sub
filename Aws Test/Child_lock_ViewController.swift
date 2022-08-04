//
//  Child_lock_ViewController.swift
//  Aws Test
//
//  Created by Developer Skromanglobal on 03/08/22.
//

import UIKit
import Alamofire
import AWSIoT
import AWSCore

class Child_lock_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    @IBOutlet weak var child_lock_collectionView: UICollectionView!
    
    
    var child_lock_vc_c_name = [Any]()
    
    
    var child_lock_vc_light_array = [""]
    var child_lock_vc_fan_array = [""]
    var child_lock_vc_master_array = [""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        child_lock_collectionView.delegate = self
        child_lock_collectionView.dataSource = self
        child_lock_collectionView.reloadData()
    }
    
    
    
    @IBAction func publish_child_lock_button(_ sender: UIButton) {
        
        
        let child_light_string = child_lock_vc_light_array
        let string_child_light_lock = child_light_string.joined(separator: "")
        
        let child_fan_string = child_lock_vc_fan_array
        let string_child_fan_lock = child_fan_string.joined(separator: "")
        
        let child_master_string = child_lock_vc_master_array
        let string_master_lock = child_master_string.joined(separator: "")
        
        
        print(string_child_light_lock)
        print(string_child_fan_lock)
        print(string_master_lock)
        
        publish_child_lock(L_Lock_Value: string_child_light_lock, F_Lock_Value: string_child_fan_lock, M_Lock_Value: string_master_lock)
//
//        self.navigationController?.popViewController(animated: true)
    }
    
    
    func publish_child_lock(L_Lock_Value : String,F_Lock_Value : String, M_Lock_Value: String) {
        
        let fetch_all_params : Parameters = [

            "control":"child_lock",
            "L": L_Lock_Value,
            "F": F_Lock_Value,
            "M": M_Lock_Value
            
        ]
        
        
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: fetch_all_params,options: []) {
            
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            
            
            let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
            
            let iot_sample_vc = Iot_sample_ViewController()
            
            iotDataManager.publishString(theJSONText!, onTopic:iot_sample_vc.topic_pub, qoS:.messageDeliveryAttemptedAtMostOnce)
            
            
        }
        
    }
    
    
    
    
}

extension Child_lock_ViewController {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return child_lock_vc_c_name.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Child_Lock_Cell", for: indexPath) as! Child_Lock_CollectionViewCell
        
        cell.label.text = child_lock_vc_c_name[indexPath.row] as? String
        
        cell.c_nm_value = child_lock_vc_c_name[indexPath.row] as? String
        
        
        
//    MARK: CHILD LOCK LIGHT CONDITION
        
        if cell.c_nm_value == "L" {
            
            let c_light_value = child_lock_vc_light_array[indexPath.row]
            
            print(c_light_value)
            
            if c_light_value as! String == "1" {
            cell.lock_image.image = UIImage(systemName: "lock")
            }
            
            else if c_light_value as! String == "0" {
            
                cell.lock_image.image = UIImage(systemName: "")
                
            }
            
            
        }
        
        
        if cell.c_nm_value == "M" {
            
            cell.master_value = child_lock_vc_master_array[0] as? String
            print("master Value",cell.master_value!)
            
            if cell.master_value == "1" {
                
                cell.lock_image.image = UIImage(systemName: "lock")
                
            }
            
            else {
                
                cell.lock_image.image = UIImage(systemName: "")
            }
            
        }
        
        if cell.c_nm_value == "F" {
            
            print("Fan",child_lock_vc_fan_array)
            cell.fan_value = child_lock_vc_fan_array[0] as? String
            print("FAn Value",cell.fan_value!)
            
            if cell.fan_value == "1" {
                
                cell.lock_image.image = UIImage(systemName: "lock")
                
            }
            
            else {
                
                cell.lock_image.image = UIImage(systemName: "")
            }
            
            
        }

        
        
        
        cell.child_lock_view.layer.cornerRadius = 10
        cell.child_lock_view.layer.borderColor = UIColor.black.cgColor
        cell.child_lock_view.layer.borderWidth = 2
        
        
        return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Child_Lock_Cell", for: indexPath) as! Child_Lock_CollectionViewCell
        
        cell.c_nm_value = child_lock_vc_c_name[indexPath.row] as? String
       
        if cell.c_nm_value == "L" {
            
            let c_light_value = child_lock_vc_light_array[indexPath.row]
            
            if c_light_value as! String == "1" {
                
                child_lock_vc_light_array[indexPath.row] = "0"
                child_lock_collectionView.reloadData()
                
                print(child_lock_vc_light_array)
            }
            
            else if c_light_value as! String == "0" {
                
                child_lock_vc_light_array[indexPath.row] = "1"
                child_lock_collectionView.reloadData()
                
                print(child_lock_vc_light_array)
            }
            
        }
        
//    MARK: MASTER
        if cell.c_nm_value == "M" {
            
            cell.master_value = child_lock_vc_master_array[0] as? String
           
            print("master Value",cell.master_value!)
            
            if cell.master_value == "1" {

                child_lock_vc_master_array[0] = "0"
                child_lock_collectionView.reloadData()
            }
            
            else {
                
                child_lock_vc_master_array[0] = "1"
                child_lock_collectionView.reloadData()
            }
            
        }
        
        
//    MARK: FAN
        
        if cell.c_nm_value == "F" {
            
            print("Fan",child_lock_vc_fan_array)
            
            cell.fan_value = child_lock_vc_fan_array[0] as? String
            print("FAn Value",cell.fan_value!)
            
            if cell.fan_value == "1" {
            
                child_lock_vc_fan_array = ["0","0","0"]
                child_lock_collectionView.reloadData()
                
                
            }
            
            else {
                
                child_lock_vc_fan_array = ["1","1","1"]
                child_lock_collectionView.reloadData()
            }
            
            
        }
        
        
        
        
    }
    
}
