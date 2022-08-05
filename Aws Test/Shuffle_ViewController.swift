//
//  Shuffle_ViewController.swift
//  Aws Test
//
//  Created by Developer Skromanglobal on 05/08/22.
//

import UIKit

class Shuffle_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var shuffle_collection_view: UICollectionView!
    @IBOutlet weak var shuffle_two_collection_view: UICollectionView!
    
    
    var shuffle_vc_d_no_array = [Any]()
    var shuffle_vc_c_nm_array = [Any]()
    
    
    
    var replace_from : Int!
    var value_replace_to : String!
    
    
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
