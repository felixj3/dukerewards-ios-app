//
//  QRCodeViewController.swift
//  DukeRewards
//
//  Created by codeplus on 7/6/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    @IBOutlet weak var qrCode: UIImageView!
    var codeContents: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(codeContents! == "ERROR")
        {
            qrCode.image = UIImage(named: "defaultImage")
        }else{
            qrCode.image = generateQRCode(from: codeContents!)
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.isoLatin1)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
