//
//  ViewController.swift
//  Aztec
//
//  Created by Andrea Gottardo on 22/04/2018.
//  Copyright © 2018 Andrea Gottardo. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {
    @IBOutlet weak var aztecImageView: UIImageView!
    
    @IBOutlet weak var msgLabel: UILabel!
    
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tock()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.tock), userInfo: nil, repeats: true)
    }
    
    @objc func tock() {
        let encoded = encodedTicketString(msg: "15436#123456789123456789#")
        let image = encodingToAztecImage(encoding: encoded.data(using: .ascii)! as NSData)
        aztecImageView.image = image
        msgLabel.text = encoded
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func encodedTicketString(msg: String) -> String {
        let salt = "HelloWorld".uppercased()
        let time = String(Int(Date().timeIntervalSince1970))
        let crypto : String = msg + time + salt
        let bytes: Array<UInt8> = crypto.bytes
        return msg + time + " " + bytes.sha3(SHA3.Variant.keccak512).toBase64()!
    }
    
    func encodingToAztecImage(encoding: NSData) -> UIImage {
        let filter = CIFilter(name: "CIAztecCodeGenerator")
        filter?.setValue(encoding, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 20.0, y: 20.0) // Scale by 5 times along both dimensions
        let output = filter!.outputImage?.transformed(by: transform)
        return UIImage(ciImage: output!)
    }


}

