//
//  ScannerViewController.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/5/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var session: AVCaptureSession?
    var getEventFromEarnVC:((String) -> Event?)?
    var video = AVCaptureVideoPreviewLayer()
    var QR:String?
    var event:Event?
    var data:[Event]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        
        
        session = AVCaptureSession()
        // Define capture device
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for:.video, position:.back)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session!.addInput(input)
        } catch {
            print("Error")
        }
        let output = AVCaptureMetadataOutput()
        session!.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session!)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        session!.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    if self.presentedViewController is UIAlertController {
                        print("alert is presented")
                    } else {
                        print("presenting uialert")
                        var title = ""
                        if(User.globalUser.adminEnabled!){
                            title = "Confirm Redemption QR Code?"
                        }else{
                            title = "Check in?"
                        }
                        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(nil) in
                            self.QR = object.stringValue ?? nil
                       
                            self.session!.stopRunning()
                            if (User.globalUser.adminEnabled!) {
                                self.confirmReward()
                            } else {
                                self.getEvent()
                            }
                        }
                        ))
                        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                        
                        present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func getEvent() {
        if let QRcode = self.QR, let safeEvent = self.getEventFromEarnVC?(QRcode){
            print(QRcode)
            print(safeEvent.name)
            let lm = LocationManager()
            lm.setCenter(event: safeEvent)
            self.customDismiss()
        }
        else{
            // alert saying event not found
            let alert = UIAlertController(title: "Sorry, we could not find the event in database.", message: "", preferredStyle: .alert)
             
            alert.addAction(UIAlertAction(title: "Ok.", style: .destructive, handler: {(nil) in
                self.customDismiss()}))
            
             present(alert, animated: true, completion: nil)
        }
        
    }
    
    func confirmReward() {
        NetworkManager.errorScanning = { () in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error connecting to server", message: "Unable to confirm reward at this time. Please check connection and try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                    self.customDismiss()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        if let QRcode = self.QR{
            let networkURL = Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String
            let url = "\(networkURL)/confirmReward/\(QRcode)?netid=\(User.globalUser.netid ?? "NA")"
            NetworkManager.getJSON(specific_url: url){jsonData in
                if let status = jsonData["status"] as? String{
                    if(status == "SUCCESS"){
                        if let response = jsonData["data"] as? Dictionary<String,String>{
                            let rewardName = response["rewardName"] ?? "Reward Name Not Found"
                            let studentName = response["studentName"] ?? "Student Name Not Found"
                            let alert = UIAlertController(title: rewardName, message: "\(studentName) is redeeming this reward", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in
                                alert.dismiss(animated: true, completion: nil)
                                self.customDismiss()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else if(status == "REPEAT"){
                        let alert = UIAlertController(title: "Student Already Redeemed", message: "The student has already redeemed this reward", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive){ (action) in
                            self.customDismiss()
                        })
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Unable to confirm", message: "Issue with reading/finding student's QR code. Contact support for more info", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive){ (action) in
                            self.customDismiss()
                        })
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func customDismiss(){
        // prevent repeated code in these alert cases
        // getEvent() can occur when user taps hamburger menu scanner or into an event and then Scan QR Code
        // confirmReward() only happens when user enables admin and taps into hamburger menu
        // For getEvent(), the scannerVC could've been pushed onto Navigation stack or presented modally
        navigationController?.popViewController(animated: true)
        // if no nav controller, nothing happens
        // otherwise it pops the last presented view controller on stack, which is this one
        
        // if no nav controller, then we dismiss like this
        self.dismiss(animated: true, completion: nil)
    }
    
}
