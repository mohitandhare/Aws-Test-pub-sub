//
//  Shuffle_ViewController.swift
//  Aws Test
//
//  Created by Developer Skromanglobal on 05/08/22.
//

import UIKit
import AWSCore
import AWSIoT
import Alamofire

class Shuffle_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var shuffle_collection_view: UICollectionView!
    @IBOutlet weak var shuffle_two_collection_view: UICollectionView!
    
    
    var shuffle_vc_d_no_array = [Any]()
    var shuffle_vc_c_nm_array = [Any]()
    
    
    
    var replace_from : Int!
    var value_replace_to : String!
    
    var result = [Any]()
    var duplicateArr = [""]

    var shuffle_publish_array : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("Shuffle C Name Array >>> ",shuffle_vc_c_nm_array)
        
        shuffle_collection_view.delegate = self
        shuffle_collection_view.dataSource = self
        shuffle_collection_view.reloadData()
        
        
        
        shuffle_two_collection_view.delegate = self
        shuffle_two_collection_view.dataSource = self
        shuffle_two_collection_view.reloadData()
        
    }
    
    
    @IBAction func save_button(_ sender: UIButton) {
        

        for i in 0..<shuffle_vc_d_no_array.count {
            var isDuplicate = false
            if duplicateArr.count == 0 {
            
                duplicateArr.append(shuffle_vc_d_no_array[i] as! String)
            }else{
                print(shuffle_vc_d_no_array[i])
                 for j in 0..<duplicateArr.count{
                     if duplicateArr[j] as! String == shuffle_vc_d_no_array[i] as! String{
                         isDuplicate = true
                     }
                 }
                if isDuplicate {
                   
                    result.append(shuffle_vc_d_no_array[i] as! String)
                    
                    self.alert_for_duplicate_value()
                    
                    
                }else{
                    
                    
                    duplicateArr.append(shuffle_vc_d_no_array[i] as! String)
                    
                    shuffle_publish_array = duplicateArr.joined(separator: "")
                    
                    print("My Duplicate :>>",shuffle_publish_array!)
                    
                    publish_shuffle_config()

                    
                    navigationController?.popViewController(animated: true)

                    dismiss(animated: true, completion: nil)
                }
            }
        }
        print("Duplicate list -> \(result)")
        
        
        
    }
    
    
    func alert_for_duplicate_value() {
        
        let alert = UIAlertController(title: "Shuffle of button has not finish", message: "Please shuffle it properly..", preferredStyle: .alert)
        
        
        
        let when = DispatchTime.now() + 3.0
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            alert.dismiss(animated: true, completion: nil)
            
        }

        self.present(alert, animated: true)
        
     }
    
    
    
    func publish_shuffle_config() {
        
        
        let shuffle_params : Parameters = [
        
        
            "control":"config_shuffle",
            "dest": shuffle_publish_array
        
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
    
    extension Shuffle_ViewController {
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return shuffle_vc_c_nm_array.count
            
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if collectionView == shuffle_collection_view {
                
                
                let shuffle_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Shuffle_Cell", for: indexPath) as! Shuffle_CollectionViewCell
                
                
                
                shuffle_cell.shuffle_button_label.text = shuffle_vc_d_no_array[indexPath.row] as? String
                
                
                
                return shuffle_cell
                
            }
            
            else {
                
                let shuffle_two_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Shuffle_Two_Cell", for: indexPath) as! Shuffle_Two_CollectionViewCell
                
                let val_to_change = indexPath.row + 1
                
                shuffle_two_cell.shuffle_two_button_label.text = String(val_to_change)
                
                print(val_to_change)
                
                return shuffle_two_cell
            }
            
            return UICollectionViewCell()
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            if collectionView == shuffle_collection_view {
                
                let shuffle_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Shuffle_Cell", for: indexPath) as! Shuffle_CollectionViewCell
                
                
                let index_to_replace = indexPath.row
                
                replace_from = index_to_replace
                
                print(replace_from!)
                
                
                
            }
            
            else {
                
                let shuffle_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Shuffle_Two_Cell", for: indexPath) as! Shuffle_Two_CollectionViewCell
                
                let index_to_what = indexPath.row + 1
                //            shuffle_vc_d_no_array[indexPath.row]
                
                value_replace_to = String(index_to_what)
                
                print(value_replace_to!)
                
                shuffle_vc_d_no_array[replace_from] = value_replace_to!
                
                print(shuffle_vc_d_no_array)
                
                shuffle_collection_view.reloadData()
                
             }
            
            
            
            
            
        }
    }
