//
//  Child_lock_ViewController.swift
//  Aws Test
//
//  Created by Developer Skromanglobal on 03/08/22.
//

import UIKit

class Child_lock_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    @IBOutlet weak var child_lock_collectionView: UICollectionView!
    
    
    var child_lock_vc_c_name = [Any]()
    
    
    var child_lock_vc_light_array = [Any]()
    var child_lock_vc_fan_array = [Any]()
    var child_lock_vc_master_array = [Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        child_lock_collectionView.delegate = self
        child_lock_collectionView.dataSource = self
        child_lock_collectionView.reloadData()
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
        
        
        
        if cell.c_nm_value == "M" {
              
        }
        
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
        
        
        
    }
    
}
