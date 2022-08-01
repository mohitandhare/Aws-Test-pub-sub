//
//  Dim_Config_ViewController.swift
//  Aws Test
//
//  Created by Developer Skromanglobal on 31/07/22.
//

import UIKit
import Alamofire
import AWSIoT
import AWSCore


class Dim_Config_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    var dim_array = [""]
    var c_nm_array = [Any]()
    
    @IBOutlet weak var dim_collection_view: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("GOT : >>> ",dim_array)
        print("GOT : >>> ",c_nm_array)
        
        dim_collection_view.delegate = self
        dim_collection_view.dataSource = self
        dim_collection_view.reloadData()
        
    }
    
    
    @IBAction func save_dim_config_button(_ sender: UIButton) {
        
        
        print("Config_dim",dim_array)

        let stringArray = dim_array
        let string_dim = stringArray.joined(separator: "")

        print(string_dim)
        publish_button(val: string_dim)
        
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func publish_button(val : String) {
        
        let fetch_all_params : Parameters = [
            
            "control": "config_dim",
            "val" : val
            
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

extension Dim_Config_ViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dim_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dim_Cell", for: indexPath) as! Dim_CollectionViewCell
        
        cell.c_nm_value = c_nm_array[indexPath.row] as! String
        
        if cell.c_nm_value == "L" {
        
            cell.dim_view.layer.cornerRadius = 10
            cell.dim_view.layer.borderWidth = 2
            cell.dim_view.layer.borderColor = UIColor.black.cgColor
            
            cell.dim_label.text = dim_array[indexPath.row] as! String
            
            cell.c_nm_value = c_nm_array[indexPath.row] as! String
            
            
            if cell.dim_label.text == "1" && cell.c_nm_value == "L"{
                
                cell.dim_view.layer.borderColor = UIColor.yellow.cgColor
                cell.dim_blub_image.image = UIImage(systemName: "lightbulb.fill")
            }
            
            else {
                
                 cell.dim_view.layer.borderColor = UIColor.black.cgColor
                cell.dim_blub_image.image = UIImage(systemName: "")
            }
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dim_Cell", for: indexPath) as! Dim_CollectionViewCell
        
        
        
        cell.c_nm_value = c_nm_array[indexPath.row] as! String
        
        if cell.c_nm_value == "L"{
        
            
            var dim_text = cell.dim_label.text
            
            dim_text = dim_array[indexPath.row] as? String

            print(dim_text!)
            
            if dim_text == "1" {
                
                dim_array[indexPath.row] = "0"
                dim_collection_view.reloadData()
                
            }
            
            else if dim_text == "0" {
                
                dim_array[indexPath.row] = "1"
                dim_collection_view.reloadData()
                
            }
            
        }
        
        
    }
    
    
    
}
