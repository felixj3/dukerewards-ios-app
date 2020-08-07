//
//  NetworkManager.swift
//  DukeRewards
//
//  Created by Anni Chen on 6/10/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager{
    static var stopRefresh: (() -> ())? // static closure because we call NetworkManager.getJSON static function
    
    static var errorScanning: (() -> ())?
    
    static func getJSON(specific_url: String, completion:@escaping ([String: Any]) -> () ){
        
        print(specific_url)
        let url = URL(string: specific_url)
        print(url)
       
        let task = URLSession.shared.dataTask(with: url!){ data, response, error in //response is HTTP response, data is data
            if error != nil {
                print(response)
                print(error)
                stopRefresh?() // inside a static function so this is a static closure
                errorScanning?()
                return
            }
            
            do{
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]{
                    //Serialize = convert the data into JSON
                    DispatchQueue.main.async{
                        completion(json)
                    }
                }else{
                    stopRefresh?()
                    errorScanning?()
                }
                
                
            } catch {
                print( "JSON error: \(error.localizedDescription)")
                stopRefresh?() // call this closure whenever completion isn't called, so refresh can stop without going through reloadData closure
                errorScanning?()
            }
            //catches if the try fails
            //Any is any data type
            //higher-order function takes another function as a parameter
        }
        task.resume()
    }
    
    // used in getUser in UserManager
    // no stopRefresh closure or errorScanning because those are not used when calling this method
    // returns Data type, not [String:Any]
    static func getData(specific_url: String, completion:@escaping (Data) -> () ){
        print(specific_url)
        let url = URL(string: specific_url)
       
        let task = URLSession.shared.dataTask(with: url!){ data, response, error in //response is HTTP response, data is data
            if error != nil {
                print(response)
                print(error)
                return
            }
            if let safeData = data {
                DispatchQueue.main.async {
                    completion(safeData)
                }
            }else{
                print("Error in getData")
            }
        }
        task.resume()
    }
    
    static func uploadData(uploadData: Data?, specific_url: String, httpMethod: String, completion:@escaping ([String: Any]) -> ()){
        
        let url = URL(string: specific_url)!
        var request = URLRequest(url: url)
        var upData = uploadData
        request.httpMethod = httpMethod // "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // NOTE: uploadData can not be nil when passed into URLSession!!!
        // Error Domain=NSURLErrorDomain Code=-999 "cancelled" will pop up if it's nil
        if upData == nil{
            upData = Data()
        }
        let task = URLSession.shared.uploadTask(with: request, from: upData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                // print ("got data: \(dataString)")
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    DispatchQueue.main.async {
                        completion(json!)
                    }
                }catch{
                    print("ERROR Serializing response data from upload")
                }
                
            }
        }
        task.resume()
    }
    
    static func uploadToken(token: String, failToConnect: @escaping () -> (), completion: @escaping ([String: Any]) -> ()){
        // completion will return the netid in a string and a bool for if the user model already exists or not
        // this should only be responsible for uploading token and getting the user netid back, other functions get user rewards and all users
        
        let url = URL(string: Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String +  "/userFromToken")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X_AUTHENTICATED_INTROSPECTION")
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                print ("error: \(error)")
                DispatchQueue.main.async {
                    failToConnect()
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                DispatchQueue.main.async {
                    failToConnect()
                }
                return
            }
            
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                // print ("got data: \(dataString)")
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    DispatchQueue.main.async {
                        completion(json!)
                    }
                }catch{
                    print("ERROR parsing data")
                    DispatchQueue.main.async {
                        failToConnect()
                    }
                }
            }
        }
        task.resume()

    }
    
    static func getEventImageFromURL(url: String, completion: @escaping (UIImage) -> ()){
        if let fillSpaces = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imageURL = URL(string: fillSpaces){
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData){
                    DispatchQueue.main.async {
                        completion(image)
                        // completion(UIImage(data: imageData)!)
                    }
                }else{
                    let imageData = try? Data(contentsOf: URL(string: EventManager.getRandomImageURL())!)
                    DispatchQueue.main.async {
                        completion(UIImage(data: imageData!)!)
                    }
                }
//                let imageData = try? Data(contentsOf: URL(string: EventManager.getRandomImageURL())!)
//                DispatchQueue.main.async {
//                    completion(UIImage(data: imageData!)!)
//                }
            }
        }else{
            DispatchQueue.main.async {
                completion(UIImage(named: "defaultImage")!)
            }
        }
    }
    
    static func getRewardImageFromURL(url: String, completion: @escaping (UIImage) -> ()){
        if let imageURL = URL(string: url){
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData){
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(UIImage(named: "defaultImage")!)
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                completion(UIImage(named: "defaultImage")!)
            }
        }
    }
    
    // this function is useless since there's a date format that works already
    // spent so long messing with swift substrings and the code is useless
    static func formatTime(created_at: String) -> String{
        // slice the created at time from ruby to fit date formatter in swift
        if(created_at != "NA")
        {
            // "2020-06-17T16:53:00.873Z" is what the format is on ruby
            if let dateEndIndex = created_at.firstIndex(of: "T") {
                let date = created_at[..<dateEndIndex] // up to but not including dateEndIndex
                let dateString = String(date) // created "2020-06-17"
                
                let timeStartIndex = created_at.index(dateEndIndex, offsetBy: 1) // shifts index up by one
                
                if let index2 = created_at.firstIndex(of: ":"){
                    let timeEndIndex = created_at.index(index2, offsetBy: 3) // shifts index up by three
                    let time = created_at[timeStartIndex..<timeEndIndex]
                    let timeString = String(time) // created "16:53"
                    
                    return dateString + " " + timeString
                }
            }
        }
        return "NA"
    }
}
