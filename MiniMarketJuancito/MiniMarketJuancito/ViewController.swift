//
//  ViewController.swift
//  MiniMarketJuancito
//
//  Created by DAMII on 19/12/24.
//

import UIKit


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [
            UIColor(red: 0xFB / 255.0, green: 0xE4 / 255.0, blue: 0xD8 / 255.0, alpha: 1.0).cgColor,
            UIColor(red: 0xDF / 255.0, green: 0xB6 / 255.0, blue: 0xB2 / 255.0, alpha: 1.0).cgColor,
            UIColor(red: 0x52 / 255.0, green: 0x2B / 255.0, blue: 0x5B / 255.0, alpha: 1.0).cgColor,
            UIColor(red: 0x2B / 255.0, green: 0x12 / 255.0, blue: 0x4C / 255.0, alpha: 1.0).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}


