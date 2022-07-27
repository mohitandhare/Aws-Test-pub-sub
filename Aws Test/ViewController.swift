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

class ViewController: UIViewController {
    
    
    struct SearchResult: Decodable {
        
        let unique_id: String
        let ModelNo: Int
        let d_no: String
        let c_dim: String
        let c_nm: String
        let c_l:  String
        let c_f:  String
        let c_m: String
        let working_mode: String
        let master: Int
        let ack: String
        let L_state: String
        let L_speed: String
        let F_state: String
        let F_speed: String
         
    }
    
    
    
    
    
    
    
    
    @IBOutlet weak var L1_On_outlet: UIButton!
    
    @IBOutlet weak var L1_Off_outlet: UIButton!
    
    //    let backToString : String!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:AWS_REGION,
                                                                identityPoolId:IDENTITY_POOL_ID)
        initializeControlPlane(credentialsProvider: credentialsProvider)
        initializeDataPlane(credentialsProvider: credentialsProvider)
        
        
        //        sender.isEnabled = false
        if (connected == false) {
            handleConnectViaCert()
            
        } else {
            handleDisconnect()
            
            //            DispatchQueue.main.async {
            //                sender.setTitle("Connect \(self.IOT_CERT)", for:UIControl.State())
            //                sender.isEnabled = true
            //            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        
        let ios_sample_vc = Iot_sample_ViewController()
        
        iotDataManager.subscribe(toTopic: ios_sample_vc.topic_sub, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
            
            
            let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)!
            
            print("received: \(stringValue)")
            
            self.payload_pass(params: payload)
            
            self.my_test = String(stringValue)
            
            print("MY TEST", self.my_test!)
            
            
        }
        )
        
     }
    
    
    
    func payload_pass(params: Data) {
        
        do {
        let model = try JSONDecoder().decode(SearchResult.self, from: params)
        
            let test = model.L_state
            
            let separate = test.map(String.init)
            
            print("MY L STATE  ",test)
            
            print("SEPARATE ",separate)
            
        }
        catch {
            print(error)
        }
        
        
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        
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
              
        }
        
        
        
    }
        
        override func viewWillDisappear(_ animated: Bool) {
            
            let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
            
            let iot_sample_vc = Iot_sample_ViewController()
            
            iotDataManager.unsubscribeTopic(iot_sample_vc.topic_sub)
        }
        
        
        
        @IBAction func connect_button(_ sender: UIButton) {
            
            
            
        }
        
        
        @IBAction func pub_button(_ sender: UIButton) {
            
            
            let aws_params : Parameters = [
                
                "control": "M",
                "no" : 1,
                "state" : 1,
                "speed" : 0
                
            ]
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: aws_params,
                options: []) {
                
                let theJSONText = String(data: theJSONData,
                                         encoding: .ascii)
                print("JSON string = \(theJSONText!)")
                
                let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
                
                let iot_sample_vc = Iot_sample_ViewController()
                
                iotDataManager.publishString(theJSONText!, onTopic:iot_sample_vc.topic_pub, qoS:.messageDeliveryAttemptedAtMostOnce)
                
            }
        }
        
        
        @IBAction func pub_button_off(_ sender: UIButton) {
            
            let aws_params : Parameters = [
                
                "control": "M",
                "no" : 1,
                "state" : 0,
                "speed" : 0
            ]
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: aws_params,
                options: []) {
                
                let theJSONText = String(data: theJSONData,
                                         encoding: .ascii)
                print("JSON string = \(theJSONText!)")
                
                let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
                
                let iot_sample_vc = Iot_sample_ViewController()
                
                iotDataManager.publishString(theJSONText!, onTopic:iot_sample_vc.topic_pub, qoS:.messageDeliveryAttemptedAtMostOnce)
                
            }
        }
        
        
        @IBAction func sub_button(_ sender: UIButton) {
            
            //        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
            //
            //        let ios_sample_vc = Iot_sample_ViewController()
            //
            //        iotDataManager.subscribe(toTopic: ios_sample_vc.topic_sub, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            //            (payload) ->Void in
            //
            //
            //            let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)!
            //
            //            print("received: \(stringValue)")
            //
            //
            //
            //        })
            
            
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
            
            let iot_sample_vc = Iot_sample_ViewController()
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
