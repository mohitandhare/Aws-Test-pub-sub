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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shuffle_collection_view.delegate = self
        shuffle_collection_view.dataSource = self
        shuffle_collection_view.reloadData()
    
    }
    
    
    @IBAction func save_button(_ sender: UIButton) {
        
        
        
        
    }
    
    
}



extension Shuffle_ViewController {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shuffle_vc_d_no_array.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let shuffle_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Shuffle_Cell", for: indexPath) as! Shuffle_CollectionViewCell
        
        
        shuffle_cell.shuffle_view.layer.cornerRadius = 10
        shuffle_cell.shuffle_view.layer.borderWidth = 2
        shuffle_cell.shuffle_view.layer.borderColor = UIColor.black.cgColor
        
        
        shuffle_cell.shuffle_button_label.text = shuffle_vc_d_no_array[indexPath.row] as! String
        
        
        return shuffle_cell
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let shuffle_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Shuffle_Cell", for: indexPath) as! Shuffle_CollectionViewCell
        
        
        print(indexPath)
        
        
        
    }
    
}
