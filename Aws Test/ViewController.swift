//
//  ViewController.swift
//  Aws Test
//
//  Created by Developer Skromanglobal on 26/07/22.
//

import UIKit
import AWSCore
import AWSIoT
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
 
    @IBOutlet weak var blur_effect: UIVisualEffectView!
    //    MARK: ======================= scene_array ===============================
    
    @IBOutlet weak var scene_CollectionView: UICollectionView!
    
    
    var scene_array = ["Scene 1", "Scene 2", "Scene 3", "Scene 4", "Scene 5", "Scene 6","Scene 7","Scene 8"]
    
    
    //    MARK: ======================= scene_array ===============================
    
    
    
    
//    MARK: ======================= scene_outlets ===============================
    
    
    @IBOutlet weak var scene_outlet_one: UIButton!
    
    @IBOutlet weak var scene_outlet_two: UIButton!
    
    @IBOutlet weak var scene_outlet_three: UIButton!
    
    @IBOutlet weak var scene_outlet_four: UIButton!
    
    
//    MARK: =======================scene_outlets CLOSED===============================
    
//MARK: ==== TOGGLE OUTLET ====
    
    @IBOutlet weak var toggle_button_outlet: UISwitch!
    var toggle_value = 0
    
//MARK: ==== TOGGLE OUTLET ====
    
    
    @IBOutlet weak var slider_one: UISlider!
    
    @IBOutlet weak var dim_level_slider: UISlider!
    
    @IBOutlet weak var fan_progrss: UIProgressView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var dim_button_label_constant: UILabel!
    @IBOutlet weak var dim_light_btn_number_label: UILabel!
    
    
    
    
//MARK: ================ DONE TRANSFER ================
    struct SearchResult: Decodable {
        
        let unique_id: String
        let ModelNo: Int
        let d_no: String
        let c_dim: String
        let c_nm: String
        let c_l:  String
        let c_f:  String
        let c_m: String
//        let working_mode: String
        let master: Int
        let ack: String
        let L_state: String
        let L_speed: String
        let F_state: String
        let F_speed: String
        
    }
    ///_    ================
    
    //MARK: ================ DONE TRANSFER ================
    var l_state_array = [Any]()
    var l_speed_array = [String]()
    var d_no_array = [Any]()
    var c_nm_array = [Any]()
    var final_array = [Any]()
    var fan_state_array = [Any]()
    var fan_speed_array = [String]()
    var fan_speed_number : Int = 0
    var master_array = [Any]()
    
    
//MARK: ===== CHILD LOCK ARRAY'S =====
    
    var child_lock_L_array = [""]
    var child_lock_F_array = [""]
    var child_lock_M_array = [""]
    
//MARK: ===== CHILD LOCK ARRAY'S CLOSED =====
    
    var c_dim_array = [String]()
    
    var dim_control_level : Int = 0
    var dim_control_number : Int = 0
    
    var temp_dim_number : Int = 0

//MARK: ==== NO CONNECTION =====
    @IBOutlet weak var L1_On_outlet: UIButton!
    
    @IBOutlet weak var L1_Off_outlet: UIButton!
    
    //    let backToString : String!
    ///_    ================
    
    
//MARK: === TRANSFERD ===
    let IOT_CERT = "IoT Cert"
    let IOT_WEBSOCKET = "IoT Websocket"
    
    var connectIoTDataWebSocket: UIButton!
    var activityIndicatorView: UIActivityIndicatorView!
    
    var logTextView: UITextView!
    var connectButton: UIButton!
    
    var connected = false
    
    
    var iotDataManager: AWSIoTDataManager!
    var iotManager: AWSIoTManager!
    var iot: AWSIoT!
    
    var my_test : String!
//    =============

    
    var stepper_label_in_pop : UILabel!
    var stepper_my_value : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if toggle_value == 0 {
            
            toggle_button_outlet.setOn(false, animated: true)
            
        }
        
        
        
        
        dim_level_slider.isHidden = true
        dim_light_btn_number_label.isHidden = true
        dim_button_label_constant.isHidden = true
        
        print("F DIM LEVEL", c_dim_array)
        connetion_aws_function()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        scene_CollectionView.delegate = self
        scene_CollectionView.dataSource = self
        
        collectionView.reloadData()
        scene_CollectionView.reloadData()

//    MARK: ==== LONG PRESS EVENT ====
        
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
       
        longPressedGesture.minimumPressDuration = 0.5
        
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressedGesture)
        
        
//        MARK: ================== SCENE LONG PRESS ==================
//
//        let tapGesture = UITapGestureRecognizer(target: self,action: #selector (tap))
//        tapGesture.numberOfTapsRequired = 1
//        tapGesture.delegate = self

        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(long(gestureRecognizer:)))
        
        longGesture.minimumPressDuration = 1
        longGesture.delegate = self
        longGesture.delaysTouchesBegan = true
        scene_CollectionView.addGestureRecognizer(longGesture)
 

//        MARK: ================== SCENE LONG PRESS CLOSED ==================
        
        
        
//    MARK: MENU BUTTON
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(Menu_Button))
        
        navigationController?.navigationBar.tintColor = .white
        
        let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        
     }
    
    
//MARK: === ALL DIM TOGGLE BUTTON FUNCTION ===
    
    
    @IBAction func all_dim_toggle_button(_ sender: UISwitch) {
        
        if sender.isOn {
            
            

                //create the Alert message with extra return spaces
                let sliderAlert = UIAlertController(title: "Set All Dim State", message: "Increase/Decrease \n\n\n\n\n\n", preferredStyle: .alert)

                //create a Slider and fit within the extra message spaces
                //add the Slider to a Subview of the sliderAlert
                
            
                let stepper = UIStepper(frame:CGRect(x: 50, y: 100, width: 250, height: 80))
                stepper_label_in_pop = UILabel(frame:CGRect(x: 180, y: 100, width: 50, height: 40))
            
            stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
            
            stepper.minimumValue = 1
            stepper.maximumValue = 7
            stepper.tintColor = UIColor.gray
            
            stepper_label_in_pop.tintColor = UIColor.gray
            
            stepper_label_in_pop.text = String(stepper.minimumValue)
            
            sliderAlert.view.addSubview(stepper_label_in_pop)
            
                sliderAlert.view.addSubview(stepper)
                
                //OK button action
                let sliderAction = UIAlertAction(title: "OK", style: .default, handler: { (result : UIAlertAction) -> Void in
                    
                    
                    self.all_dim_function()
                    
    //            MARK: CODE IN THIS
                    
                    })

                //Cancel button action
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

                //Add buttons to sliderAlert
                sliderAlert.addAction(sliderAction)
                sliderAlert.addAction(cancelAction)

                //present the sliderAlert message
                self.present(sliderAlert, animated: true, completion: nil)
            
            
        }
     }
    
//MARK: ===== ALL DIM POPUP STEPPER FUNCTION =====
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        
        stepper_my_value = String(sender.value)
        
        print(stepper_my_value!)
        
        stepper_label_in_pop.text = String(sender.value)
    }
    
    func all_dim_function() {
        
        
        let dim_pub_parameters : Parameters = [
        
            "control" : "all_dim",
            "speed" : stepper_my_value!
        
        ]
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: dim_pub_parameters,options: []) {
            
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            
            
            let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
            
            let iot_sample_vc = Iot_sample_ViewController()
            
            iotDataManager.publishString(theJSONText!, onTopic:iot_sample_vc.topic_pub, qoS:.messageDeliveryAttemptedAtMostOnce)
            
        }
        
        
    }
    
    
//MARK: ===== ALL DIM POPUP STEPPER FUNCTION CLOSED =====
    
    
//MARK: ===== MENU OPTION =====
    
    
//MARK: ===== MENU BUTTON =====
    
    @objc func Menu_Button() {
        
        
        menu_alert_box()
        
    }///_CLOSED
    
    
    
//MARK: ===== NAVIGATION FUNCTION TO DIM PAGE =====
    
    func Navigate_To_Dim_Config_Page() {
        
        let dim_config_vc : Dim_Config_ViewController = self.storyboard?.instantiateViewController(withIdentifier: "Dim_Config_ViewController") as! Dim_Config_ViewController
        
        
        
        dim_config_vc.dim_array = c_dim_array
        dim_config_vc.c_nm_array = c_nm_array
        
        present(dim_config_vc, animated: true)
        
        
    } ///_CLOSED
    
    
    
    func Navigate_To_Child_Lock_page() {
        
        let child_lock_vc : Child_lock_ViewController = self.storyboard?.instantiateViewController(withIdentifier: "Child_lock_ViewController") as! Child_lock_ViewController
        
        
        child_lock_vc.child_lock_vc_c_name = c_nm_array
        child_lock_vc.child_lock_vc_light_array = child_lock_L_array
        child_lock_vc.child_lock_vc_fan_array = child_lock_F_array
        child_lock_vc.child_lock_vc_master_array = child_lock_M_array
        
        
        print("MY CHILD MASTER: >>> ",child_lock_M_array)
        print("MY CHILD FAN : >>> ",child_lock_F_array)
        self.navigationController?.pushViewController(child_lock_vc, animated: true)
        
    }
    
    
    
//MARK: ===== ALERT BOX FOR MENU =====
    
    func menu_alert_box() {
        
        
        let alert = UIAlertController(title: "Select Your Option", message: "", preferredStyle: .actionSheet)
        
        
        let dim_option = UIAlertAction(title: "Dim Configure", style: .default) { action in
            
            self.Navigate_To_Dim_Config_Page()
            print("Dim Selected")
            
        }
        
        
        let child_lock = UIAlertAction(title: "Child Lock", style: .default) { action in
            
            self.Navigate_To_Child_Lock_page()
            
            print("Child Lock Selected")
        }
        
        alert.addAction(dim_option)
        alert.addAction(child_lock)
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        present(alert, animated: true)
        
        
        
    }///_CLOSED
    
    
    
//MARK: ===== MENU OPTION =====
    
//MARK: === ALL DIM TOGGLE BUTTON FUNCTION ===
    
    
    //MARK: ORIENTATION
        
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }
        
    //MARK: ORIENTATION
    
    
//MARK: Scene BUTTON ACTIONS ==========
   
    func publish_scene_function(control_state : String, control_no: Int) {
        
        let scene_pub_parameters : Parameters = [
        
            "control" : control_state,
            "no" : control_no
        
        ]
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: scene_pub_parameters,options: []) {
            
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            
            
            let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
            
            let iot_sample_vc = Iot_sample_ViewController()
            
            iotDataManager.publishString(theJSONText!, onTopic:iot_sample_vc.topic_pub, qoS:.messageDeliveryAttemptedAtMostOnce)
            
        }
     }

    func tap(control_no: Int) {

       print("TAPPED >>>>>>>>> ",control_no)
        
        
        publish_scene_function(control_state: "scene_control", control_no: control_no)
        
    }

    @objc func long(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            
            return
            
        }

        let p = gestureRecognizer.location(in: scene_CollectionView)

        if let indexPath = scene_CollectionView?.indexPathForItem(at: p) {
            print("Long press at item: \(indexPath.row)")
            
            publish_scene_function(control_state: "scene_config", control_no: indexPath.row + 1)
                    scene_btn_long_press_func()
                    print("Long press")
            }
            
          }
    
    func scene_btn_long_press_func() {
        
        let alert_box = UIAlertController(title: "Congrats", message: "Scene Configuration Done", preferredStyle: .alert)
        
        
        let when = DispatchTime.now() + 2.0
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            alert_box.dismiss(animated: true, completion: nil)
            
        }

          self.present(alert_box, animated: true)
        
    }
    
    //    MARK: =======================scene_buttons===============================
    
    
    @IBAction func scene_button_one(_ sender: UIButton) {
        tap(control_no: 1)
//        long(config_no: 1)
        print(sender.tag)
        
    }
    
    
    
    @IBAction func scene_button_two(_ sender: UIButton) {
        tap(control_no: 2)
//        long(config_no: 2)
        print(sender.tag)
    }
    
    
    @IBAction func scene_button_three(_ sender: UIButton) {
        tap(control_no: 3)
//        long(config_no: 3)
        print(sender.tag)
    }
    
    
    
    @IBAction func scene_button_four(_ sender: UIButton) {
        
        tap(control_no: 4)
//        long(config_no: 4)
        print(sender.tag)
        
    }
 
    
    
    //    MARK: =======================scene_buttons===============================
    
 
//    MARK: =================
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            
            return
            
        }

        let p = gestureRecognizer.location(in: collectionView)

        if let indexPath = collectionView?.indexPathForItem(at: p) {
            print("Long press at item: \(indexPath.row)")
            
            temp_dim_number = indexPath.row
            
            
            let temp_c_nm = c_nm_array[temp_dim_number]
            dim_light_btn_number_label.isHidden = false
            dim_button_label_constant.isHidden = false
            
            dim_light_btn_number_label.text = d_no_array[temp_dim_number] as? String
            
            if temp_c_nm as! String == "L"  {
               
                
                
                dim_control_number = indexPath.row + 1
                
                dim_level_slider.isHidden = false
                
                print(l_speed_array.description)
              
                
                
                
                let set_value = l_speed_array[temp_dim_number]
                
                dim_level_slider.setValue(Float(set_value)!, animated: true)
                print("L SPEED TEST ",l_speed_array[temp_dim_number])
                

                
            }
            
          }
    }
//MARK: ========================
    
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetch_all_function()
        
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        subscribe_topic_function()
  }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        
        let iot_sample_vc = Iot_sample_ViewController()
        
        iotDataManager.unsubscribeTopic(iot_sample_vc.topic_sub)
        
        
        collectionView.reloadData()
        
    }
//MARK: ===== FAN CONTROL FUNCTIONS =====
    
    
    @IBAction func fan_stepper(_ sender: UIStepper) {
        
        
        
        let fan_stepper_value = Int(sender.value)
        
        publish_button(control: "F", no: 1, state: 1, speed: fan_stepper_value)
        
        
    }
    
    
    
    @IBAction func fan_control_button(_ sender: UISlider) {
        
        
        if (sender.isTracking) {
//               print("Slider Touched")
           }
        else {
               print("Slider Released")
               print(sender.value)
            
            if sender.value >= 0.10 && sender.value <= 1.0 {
                
                publish_button(control: "F", no: 1, state: 1, speed: 1)
                print("1")
            }
            
            else if sender.value >= 1.0 && sender.value <= 2.0 {
                
                publish_button(control: "F", no: 1, state: 1, speed: 2)
                print("2")
            }
            
            else if sender.value >= 2.0 && sender.value <= 3.0 {
                
                publish_button(control: "F", no: 1, state: 1, speed: 3)
                print("3")
            }
            
            else if sender.value >= 3.0 && sender.value <= 4.0{
                
                publish_button(control: "F", no: 1, state: 1, speed: 4)
                print("4")
            }
            
               
           }
        
        
    }
    
    
    
    func Fan_Speed() {
        
        if l_speed_array.last == "1" {
            
            slider_one.setValue(1, animated: true)
            
        }
        
       else if l_speed_array.last == "2" {
           
           slider_one.setValue(2, animated: true)
           
        }
        
        else if l_speed_array.last == "3" {
            
            slider_one.setValue(3, animated: true)
            
        }
        
        else if l_speed_array.last == "4" {
            
            slider_one.setValue(4, animated: true)
            
        }
        else if l_speed_array.last == "0" {
            
            slider_one.isHidden = true
        }
        
    }
    
//MARK: ===== FAN CONTROL FUNCTIONS CLOSED =====
    
    
    
    @IBAction func dim_stepper_button(_ sender: UIStepper) {
        
      
        let dim_stepper = Int(sender.value)
        
        publish_button(control: "L", no: dim_control_number, state: 1, speed: dim_stepper)
        
    }
    
    @IBAction func dim_control_button(_ sender: UISlider) {
        
        if (sender.isTracking) {
//               print("Slider Touched")
           }
        else {
               print("Slider Released")
               print(sender.value)
            
            if sender.value >= 0.10 && sender.value <= 1.0 {
                
                publish_button(control: "L", no: dim_control_number, state: 1, speed: 1)
                dim_level_slider.setValue(1, animated: true)
                print("1")
            }
            
            else if sender.value >= 1.0 && sender.value <= 2.0 {
                
                publish_button(control: "L", no: dim_control_number, state: 1, speed: 2)
                dim_level_slider.setValue(2, animated: true)
                print("2")
            }
            
            else if sender.value >= 2.0 && sender.value <= 3.0 {
                
                publish_button(control: "L", no: dim_control_number, state: 1, speed: 3)
                dim_level_slider.setValue(3, animated: true)
                print("3")
            }
            
            else if sender.value >= 3.0 && sender.value <= 4.0{
                
                publish_button(control: "L", no: dim_control_number, state: 1, speed: 4)
                dim_level_slider.setValue(4, animated: true)
                print("4")
            }
            
            else if sender.value >= 4.0 && sender.value <= 5.0{
                
                publish_button(control: "L", no: dim_control_number, state: 1, speed: 5)
                dim_level_slider.setValue(5, animated: true)
                print("5")
            }
            
            else if sender.value >= 5.0 && sender.value <= 6.0{
                
                publish_button(control: "L", no: dim_control_number, state: 1, speed: 6)
                dim_level_slider.setValue(6, animated: true)
                print("6")
            }
            
            else if sender.value >= 6.0 && sender.value <= 7.0{
                
                publish_button(control: "L", no: dim_control_number, state: 1, speed: 7)
                dim_level_slider.setValue(7, animated: true)
                print("7")
            }
               
           }
        
        
    }
    
    
    func Dim_Control_Function() {
        
        
        
        
    }
    
    
    
    
    //MARK: == CONNECTION AWS FUNCTION ==
    
    func connetion_aws_function() {
        
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:AWS_REGION,
                                                                identityPoolId:IDENTITY_POOL_ID)
        initializeControlPlane(credentialsProvider: credentialsProvider)
        initializeDataPlane(credentialsProvider: credentialsProvider)
        
        if (connected == false) {
            handleConnectViaCert()
            
        } else {
            handleDisconnect()
            
        }
        
        
    }
    
    
    
//MARK: == PAYLOAD FUNCTION ==
    
//MARK: DONE TRANSFER
    func payload_pass(params: Data) {
        
        
        
        do {
           
            let model = try JSONDecoder().decode(SearchResult.self, from: params)
            
            let my_l_state = model.L_state
            let my_l_speed = model.L_speed
            let my_d_no = model.d_no
            let my_master = model.master
            let my_c_nm = model.c_nm
            let my_fan_state = model.F_state
            let my_fan_speed = String(model.F_speed)
           
            let my_dim_config = model.c_dim
            
            
            
//        MARK: ==== CHILD LOCK MODEL TO ARRAY =====

            
            let child_light_lock = model.c_l
            let child_fan_lock = model.c_f
            let child_master_lock = model.c_m
            
            
//        MARK: ==== CHILD LOCK MODEL TO ARRAY CLOSED =====
            
            
            
//        MARK: ===== SEPARATE CHILD LOCKS =====
            
            let separate_child_light_lock = child_light_lock.map(String.init)
            let separate_child_fan_lock = child_fan_lock.map(String.init)
            let separate_child_master_lock = child_master_lock.map(String.init)
            
            
            child_lock_L_array = separate_child_light_lock
            child_lock_F_array = separate_child_fan_lock
            child_lock_M_array = separate_child_master_lock
            child_lock_M_array.append(child_master_lock)
            
            print("child_lock_L_array : >>",child_lock_L_array)
            print("child_lock_F_array : >>",child_lock_F_array)
            print("child_lock_M_array : >>",child_lock_M_array)
            
            
            
//        MARK: ===== SEPARATE CHILD LOCKS =====
            print("Model DIM LEVEL", my_dim_config)
            
            //MARK: ==================
            
            
            if model.F_speed == "NA" {
                
                
                
            }
            else {
                
                fan_speed_number = Int(model.F_speed)!
                print("fan_speed_number :>>>>",fan_speed_number)
                
                print("my_fan_speed", my_fan_speed)
                
                fan_speed_number = Int(model.F_speed)!
                print("fan_speed_number :>>>>",fan_speed_number)
                
                print("my_fan_speed", my_fan_speed)
            }
            
            
            
            let separate_l_state = my_l_state.map(String.init)
            
            let separate_dim_config = my_dim_config.map(String.init)
            
            
            
            let separate_l_speed = my_l_speed.map(String.init)
            let separate_d_no = my_d_no.map(String.init)
            let separate_c_nm = my_c_nm.map(String.init)

            
            fan_speed_array.removeAll()
            fan_speed_array.append(my_fan_speed)
            
            print("my_fan_speed_in_array", fan_speed_array)
            
            
            l_state_array = separate_l_state
            
            c_dim_array = separate_dim_config
            
            print("C DIM ARRAY ",c_dim_array)
            
            l_speed_array = separate_l_speed
            d_no_array = separate_d_no
            c_nm_array = separate_c_nm
            
            
            
            fan_state_array.removeAll()
//            fan_speed_array.removeAll()
            if my_fan_state == "NA" || my_fan_state == "N/A"{
                
                
            }

            else if my_fan_state == "1" {
                
                fan_state_array.append(my_fan_state)
            }

            else if my_fan_state == "0" {
                
                
                  fan_state_array.append(my_fan_state)
            }

            else {
                let Separate_F_State = my_fan_state.map(String.init)

                for separate_f_state in Separate_F_State {
                    fan_state_array.append(separate_f_state)
                }

            }
            
            
            
            
            print("Separate L State",separate_l_state)
            print("Separate L Speed", separate_l_speed)
            print("Separate D_No", separate_d_no)
            print("Separate C NM", separate_c_nm)
            

            if my_fan_state == "NA" || my_fan_state == "N/A"{
          
            }
            
            else {
                
            l_state_array.append(contentsOf: fan_state_array)
            print("L STATE WITH FAN", l_state_array)
                
                
            d_no_array.append(contentsOf: fan_state_array)
            print("D_NO WITH FAN", l_state_array)
            
            c_nm_array.append("F")
            print("C N M WITH FAN",c_nm_array)
                
                
            l_speed_array.append(contentsOf: fan_speed_array)
            print("L_SPEED_ARRAY : >> ",l_speed_array)
                
//                c_dim_array.append("0")
                
            }
           
            
            
           
            
            
            
            
//        MARK: MASTER APPEND FUNCTIONS
           
            master_array.removeAll()
            let master_state_change = String(my_master)
            master_array.append(master_state_change)
           
            l_state_array.append(contentsOf: master_array)
            d_no_array.append(contentsOf: master_array)
            c_nm_array.append("M")
            
            
//            c_dim_array.append("0")
            
            
            
            
        print("L STATE WITH M",l_state_array)
        print("C N M ARRAY ",c_nm_array)
        print("last _ do ",d_no_array)
                 
        }
        catch {
            print(error)
        }
    }
    
    
    //MARK: == SUBSCRIBE FUNCTION ==
    
    func subscribe_topic_function() {
        
        
        
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        
        let ios_sample_vc = Iot_sample_ViewController()
        
        iotDataManager.subscribe(toTopic: ios_sample_vc.topic_sub, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
            
            
            let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)!
            
            print("received: \(stringValue)")
            
            self.payload_pass(params: payload)
            
            self.my_test = String(stringValue)
            
            
            print("MY TEST", self.my_test!)
            
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
            }
        }
        )
        
    }
    
//MARK: == FETCH ALL FUNCTIONS ==

    //MARK: DONE TRANSFER
    
    func fetch_all_function() {
        
        let fetch_all_params : Parameters = [
            
            "control": "fetch_all",
            "no" : 0,
            "state" : 0,
            "speed" : 0
            
        ]
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: fetch_all_params,options: []) {
            
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            
            
            let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
            
            let iot_sample_vc = Iot_sample_ViewController()
            
            iotDataManager.publishString(theJSONText!, onTopic:iot_sample_vc.topic_pub, qoS:.messageDeliveryAttemptedAtMostOnce)
            
            collectionView.reloadData()
        }
    }
    
    
//MARK: == PUBLISH FUNCTION ==
    

    func publish_function() {

        let fetch_all_params : Parameters = [

            "control": "L",
            "no" : 1,
            "state" : 1,
            "speed" : 0

        ]



        if let theJSONData = try? JSONSerialization.data(withJSONObject: fetch_all_params,options: []) {

            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")


            let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)

            let iot_sample_vc = Iot_sample_ViewController()

            iotDataManager.publishString(theJSONText!, onTopic:iot_sample_vc.topic_pub, qoS:.messageDeliveryAttemptedAtMostOnce)

            collectionView.reloadData()
        }


    }
    
    func publish_button(control: String, no: Int, state: Int, speed: Int) {

        let fetch_all_params : Parameters = [

            "control": control,
            "no" : no,
            "state" : state,
            "speed" : speed

        ]

//
//        let fetch_all_params : Parameters = [
//
//            "control" : "LED_STRIP",
//            "red" : 255,
//            "green" : 200,
//            "blue" : 0
//
//        ]

        
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: fetch_all_params,options: []) {
            
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            
            
            let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
            
            let iot_sample_vc = Iot_sample_ViewController()
            
            iotDataManager.publishString(theJSONText!, onTopic:iot_sample_vc.topic_pub, qoS:.messageDeliveryAttemptedAtMostOnce)
            
            
            collectionView.reloadData()
        }
        
    }
    
    
    
    func mqttEventCallback( _ status: AWSIoTMQTTStatus ) {
        DispatchQueue.main.async {
            let iot_sample_vc = Iot_sample_ViewController()
            print("connection status = \(status.rawValue)")
            
            switch status {
            case .connecting:
                iot_sample_vc.mqttStatus = "Connecting..."
                print( iot_sample_vc.mqttStatus )
                //                self.logTextView.text = iot_sample_vc.mqttStatus
                
            case .connected:
                iot_sample_vc.mqttStatus = "Connected"
                print( iot_sample_vc.mqttStatus )
                //                self.connectButton.setTitle( "Disconnect \(self.IOT_CERT)", for:UIControl.State())
                //                self.activityIndicatorView.stopAnimating()
                self.connected = true
                //                self.connectButton.isEnabled = true
                let uuid = UUID().uuidString;
                let defaults = UserDefaults.standard
                let certificateId = defaults.string( forKey: "certificateId")
                
                //                self.logTextView.text = "Using certificate:\n\(certificateId!)\n\n\nClient ID:\n\(uuid)"
                
                
            case .disconnected:
                iot_sample_vc.mqttStatus = "Disconnected"
                print( iot_sample_vc.mqttStatus )
                //                self.activityIndicatorView.stopAnimating()
                //                self.logTextView.text = nil
                
            case .connectionRefused:
                iot_sample_vc.mqttStatus = "Connection Refused"
                print( iot_sample_vc.mqttStatus )
                //                self.activityIndicatorView.stopAnimating()
                //                self.logTextView.text = iot_sample_vc.mqttStatus
                
            case .connectionError:
                iot_sample_vc.mqttStatus = "Connection Error"
                print( iot_sample_vc.mqttStatus )
                //                self.activityIndicatorView.stopAnimating()
                //                self.logTextView.text = iot_sample_vc.mqttStatus
                
            case .protocolError:
                iot_sample_vc.mqttStatus = "Protocol Error"
                print( iot_sample_vc.mqttStatus )
                //                self.activityIndicatorView.stopAnimating()
                //                self.logTextView.text = iot_sample_vc.mqttStatus
                
            default:
                iot_sample_vc.mqttStatus = "Unknown State"
                print("unknown state: \(status.rawValue)")
                //                self.activityIndicatorView.stopAnimating()
                //                self.logTextView.text = iot_sample_vc.mqttStatus
            }
            
            NotificationCenter.default.post( name: Notification.Name(rawValue: "connectionStatusChanged"), object: self )
        }
    }
    
    
    
    
    
    
    func handleConnectViaCert() {
        //        self.connectIoTDataWebSocket.isHidden = true
        //        activityIndicatorView.startAnimating()
        
        let defaults = UserDefaults.standard
        let certificateId = defaults.string( forKey: "certificateId")
        if (certificateId == nil) {
            DispatchQueue.main.async {
                //                self.logTextView.text = "No identity available, searching bundle..."
            }
            let certificateIdInBundle = searchForExistingCertificateIdInBundle()
            
            if (certificateIdInBundle == nil) {
                DispatchQueue.main.async {
                    //                    self.logTextView.text = "No identity found in bundle, creating one..."
                }
                createCertificateIdAndStoreinNSUserDefaults(onSuccess: {generatedCertificateId in
                    let uuid = UUID().uuidString
                    //                    self.logTextView.text = "Using certificate: \(generatedCertificateId)"
                    self.iotDataManager.connect( withClientId: uuid, cleanSession:true, certificateId:generatedCertificateId, statusCallback: self.mqttEventCallback)
                }, onFailure: {error in
                    print("Received error: \(error)")
                })
            }
        } else {
            let uuid = UUID().uuidString;
            // Connect to the AWS IoT data plane service w/ certificate
            iotDataManager.connect( withClientId: uuid, cleanSession:true, certificateId:certificateId!, statusCallback: self.mqttEventCallback)
        }
    }
    
    func searchForExistingCertificateIdInBundle() -> String? {
        let defaults = UserDefaults.standard
        // No certificate ID has been stored in the user defaults; check to see if any .p12 files
        // exist in the bundle.
        let myBundle = Bundle.main
        let myImages = myBundle.paths(forResourcesOfType: "p12" as String, inDirectory:nil)
        let uuid = UUID().uuidString
        
        guard let certId = myImages.first else {
            let certificateId = defaults.string(forKey: "certificateId")
            return certificateId
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: certId)) else {
            print("[ERROR] Found PKCS12 File in bundle, but unable to use it")
            let certificateId = defaults.string( forKey: "certificateId")
            return certificateId
        }
        
        DispatchQueue.main.async {
            self.logTextView.text = "found identity \(certId), importing..."
        }
        if AWSIoTManager.importIdentity( fromPKCS12Data: data, passPhrase:"", certificateId:certId) {
            
            defaults.set(certId, forKey:"certificateId")
            defaults.set("from-bundle", forKey:"certificateArn")
            DispatchQueue.main.async {
                self.logTextView.text = "Using certificate: \(certId))"
                self.iotDataManager.connect( withClientId: uuid,
                                             cleanSession:true,
                                             certificateId:certId,
                                             statusCallback: self.mqttEventCallback)
            }
        }
        
        let certificateId = defaults.string( forKey: "certificateId")
        return certificateId
    }
    
    func createCertificateIdAndStoreinNSUserDefaults(onSuccess:  @escaping (String)->Void,
                                                     onFailure: @escaping (Error) -> Void) {
        let defaults = UserDefaults.standard
        // Now create and store the certificate ID in NSUserDefaults
        let csrDictionary = [ "commonName": CertificateSigningRequestCommonName,
                              "countryName": CertificateSigningRequestCountryName,
                              "organizationName": CertificateSigningRequestOrganizationName,
                              "organizationalUnitName": CertificateSigningRequestOrganizationalUnitName]
        
        self.iotManager.createKeysAndCertificate(fromCsr: csrDictionary) { (response) -> Void in
            guard let response = response else {
                DispatchQueue.main.async {
                    self.connectButton.isEnabled = true
                    self.activityIndicatorView.stopAnimating()
                    self.logTextView.text = "Unable to create keys and/or certificate, check values in Constants.swift"
                }
                onFailure(NSError(domain: "No response on iotManager.createKeysAndCertificate", code: -2, userInfo: nil))
                return
            }
            defaults.set(response.certificateId, forKey:"certificateId")
            defaults.set(response.certificateArn, forKey:"certificateArn")
            let certificateId = response.certificateId
            print("response: [\(String(describing: response))]")
            
            let attachPrincipalPolicyRequest = AWSIoTAttachPrincipalPolicyRequest()
            attachPrincipalPolicyRequest?.policyName = POLICY_NAME
            attachPrincipalPolicyRequest?.principal = response.certificateArn
            
            // Attach the policy to the certificate
            self.iot.attachPrincipalPolicy(attachPrincipalPolicyRequest!).continueWith (block: { (task) -> AnyObject? in
                if let error = task.error {
                    print("Failed: [\(error)]")
                    onFailure(error)
                } else  {
                    print("result: [\(String(describing: task.result))]")
                    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                        if let certificateId = certificateId {
                            onSuccess(certificateId)
                        } else {
                            onFailure(NSError(domain: "Unable to generate certificate id", code: -1, userInfo: nil))
                        }
                    })
                }
                return nil
            })
        }
    }
    
    func handleDisconnect() {
        
//        let iot_sample_vc = Iot_sample_ViewController()
        self.connectButton.isHidden = false
        self.connectIoTDataWebSocket.isHidden = false
        activityIndicatorView.startAnimating()
        logTextView.text = "Disconnecting..."
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.iotDataManager.disconnect();
            DispatchQueue.main.async {
                self.connected = false
                
            }
        }
    }
    
    
    
    
    
    
    
    func initializeControlPlane(credentialsProvider: AWSCredentialsProvider) {
        
        let controlPlaneServiceConfiguration = AWSServiceConfiguration(region:AWS_REGION, credentialsProvider:credentialsProvider)
        
        
        AWSServiceManager.default().defaultServiceConfiguration = controlPlaneServiceConfiguration
        iotManager = AWSIoTManager.default()
        iot = AWSIoT.default()
    }
    
    func initializeDataPlane(credentialsProvider: AWSCredentialsProvider) {
        
        
        let iotEndPoint = AWSEndpoint(urlString: IOT_ENDPOINT)
        
        
        let iotDataConfiguration = AWSServiceConfiguration(region: AWS_REGION,
                                                           endpoint: iotEndPoint,
                                                           credentialsProvider: credentialsProvider)
        
        AWSIoTDataManager.register(with: iotDataConfiguration!, forKey: AWS_IOT_DATA_MANAGER_KEY)
        iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
    }
    
    
    func mqttEventCallbackWebsocket(_ status: AWSIoTMQTTStatus) {
        guard case .connected = status else {
            mqttEventCallback(status)
            return
        }
        
        DispatchQueue.main.async {
            
            let iot_sample_vc = Iot_sample_ViewController()
            iot_sample_vc.mqttStatus = "Connected"
            
            self.activityIndicatorView.stopAnimating()
            
            self.connected = true
            
            self.connectIoTDataWebSocket.setTitle("Disconnect \(self.IOT_WEBSOCKET)", for:UIControl.State())
            
            self.logTextView.text = "Connected via websocket"
            
            self.connectIoTDataWebSocket.isEnabled = true
            
        }
    }
    
    @objc func didTapConnectIoTDataWebSocket(_ sender: UIButton) {
        sender.isEnabled = false
        if (connected == false) {
            handleConnectViaWebsocket()
        } else {
            handleDisconnect()
            DispatchQueue.main.async {
                sender.setTitle("Connect \(self.IOT_WEBSOCKET)", for:UIControl.State())
                sender.isEnabled = true
            }
        }
    }
    
    func handleConnectViaWebsocket() {
        self.connectButton.isHidden = true
        activityIndicatorView.startAnimating()
        DispatchQueue.main.async {
            self.logTextView.text = "Connecting (data plane)..."
        }
        let uuid = UUID().uuidString
        // Connect to the AWS IoT data plane service over websocket
        iotDataManager.connectUsingWebSocket(withClientId: uuid, cleanSession: true, statusCallback: mqttEventCallbackWebsocket(_:))
    }
}



extension ViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            return l_state_array.count
            
        }
        else {
            
            return scene_array.count
            
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.collectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollCell", for: indexPath) as! CollectionViewCell
             
             
             cell.label.text = c_nm_array[indexPath.row] as? String
             cell.l_state_value = l_state_array[indexPath.row] as? String
             
             
             cell.collView.layer.cornerRadius = 10
             cell.collView.layer.borderWidth = 2
             cell.collView.layer.borderColor = UIColor.black.cgColor
             
             
             if cell.label.text == "L" {
             cell.dim_level = c_dim_array[indexPath.row]
             
             
             
             
             let test_dim = cell.dim_level
             
             
             if test_dim == "1" {
                 
                 
                 cell.dim_blub.image = UIImage(systemName: "lightbulb.fill")
                 
                 
             }
             
             else if test_dim == "0" {
              
                 cell.dim_blub.image = UIImage(systemName: "")
                 
             }
             }
             
             if cell.label.text == "F" {
                 
                 cell.dim_blub.image = UIImage(systemName: "")
                 
             }
             
             if cell.label.text == "M" {
                 
                 cell.dim_blub.image = UIImage(systemName: "")
                 
             }
             
             
             
             if cell.l_state_value == "1" {
                 
                 cell.collView.layer.borderColor = UIColor.yellow.cgColor
                 cell.light_image.image = UIImage(named: "Light_Off")
             }
             
             
             else if cell.l_state_value == "0"{
                 
                 cell.collView.layer.borderColor = UIColor.black.cgColor
                 cell.light_image.image = UIImage(named: "Light_On")
             }
             
             
             
             else if cell.label.text == "L" {
                 
                 cell.light_image.image = UIImage(named: "Light_Off")
                 
             }
             
             if cell.label.text == "M"{
                 
                 cell.light_image.image = UIImage(named: "Master")
                 
             }
             
             else if cell.label.text == "F"{
                 
                 cell.light_image.image = UIImage(named: "Fan_1")
                 
             }
                 Fan_Speed()
             
             
             
             return cell
            
        }
        
        else {
            
            
            
            let cell_scene = collectionView.dequeueReusableCell(withReuseIdentifier: "Scene_Cell", for: indexPath) as! Scene_CollectionViewCell
            
            cell_scene.scene_view.layer.cornerRadius = 10
            cell_scene.scene_view.layer.borderWidth = 2
            cell_scene.scene_view.layer.borderColor = UIColor.black.cgColor
            
            cell_scene.scene_label.text = scene_array[indexPath.row]
            
            
            return cell_scene
            
            
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {

        if collectionView == self.collectionView {
            
            
            
            let index_Path = collectionView.indexPathsForSelectedItems?.first

            print(index_Path!)
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollCell", for: indexPath) as! CollectionViewCell
            
            cell.test_two = d_no_array[indexPath.row] as? String
            cell.l_state_value = l_state_array[index_Path!.row] as? String
            cell.control_name = c_nm_array[indexPath.row] as? String
           
            
            
            
            
            
            
            
            let number = Int(cell.test_two)
            let L_State_number = Int(cell.l_state_value)
            
            print("L STATE NUMBER : **** ", L_State_number as Any)
            print("MY DIM LEVEL : >>> ",cell.dim_level as Any)
         
            /// control Light checking
            if cell.control_name == "L" {
                
                if L_State_number == 1 {

                    publish_button(control: "L", no: number!, state: 0, speed: 0)
                    
                    
                }
                else {

                    publish_button(control: "L", no: number!, state: 1, speed: 0)
                    
                }
            }
            
            
            
            if cell.control_name == "F" {
                
                if L_State_number == 1 {

                    
                    publish_button(control: "F", no: 1, state: 0, speed: fan_speed_number)
                   
                    slider_one.isEnabled = false
                    
                    slider_one.thumbTintColor = UIColor.gray
                    slider_one.minimumTrackTintColor = UIColor.gray
                    slider_one.maximumTrackTintColor = UIColor.gray
                    
                    
                }
                else {
                    
                    publish_button(control: "F", no: 1, state: 1, speed: fan_speed_number)
                   
                    slider_one.isEnabled = true
                    
                    slider_one.thumbTintColor = UIColor.white
                    slider_one.minimumTrackTintColor = UIColor.yellow
                    slider_one.maximumTrackTintColor = UIColor.gray
                    
                 }
            }
            
            
            
            
            /// control name checking
            
           if cell.control_name == "M" {
               
               print("master")
               
                if cell.l_state_value.last == "1" {
                    
                    publish_button(control: "M", no: number!, state: 0, speed: 0)
                    
                    
                    
                    if L_State_number == 1 {
                        
                        slider_one.isEnabled = true
                        
                        self.slider_one.thumbTintColor = UIColor.white
                        self.slider_one.minimumTrackTintColor = UIColor.yellow
                        self.slider_one.maximumTrackTintColor = UIColor.gray
                                            
                    }
                    
                    else {
                       
                        let when = DispatchTime.now() + 0.1
                        
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            self.slider_one.isEnabled = false
                            
                            self.slider_one.thumbTintColor = UIColor.gray
                            self.slider_one.minimumTrackTintColor = UIColor.gray
                            self.slider_one.maximumTrackTintColor = UIColor.gray
                            
                        }
                        
                    }
                    
                }
                
                else {
                    
                    publish_button(control: "M", no: number!, state: 1, speed: 0)
                    
                    let when = DispatchTime.now() + 0.1
                    
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.slider_one.isEnabled = false
                        
                        self.slider_one.thumbTintColor = UIColor.gray
                        self.slider_one.minimumTrackTintColor = UIColor.gray
                        self.slider_one.maximumTrackTintColor = UIColor.gray
                        

                    }
                    
                }
                
            }
            
            
            
        }
        
        
        else {
            
            
                tap(control_no: indexPath.row + 1)
            
            
            
        }
            
       
        
     }
    
}


