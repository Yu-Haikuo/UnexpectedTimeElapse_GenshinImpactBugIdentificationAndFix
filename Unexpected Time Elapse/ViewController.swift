//
//  ViewController.swift
//  Unexpected Time Elapse
//
//  Created by HAIKUO YU on 22/8/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var beforeFixProgressView: UIProgressView!
    @IBOutlet weak var afterFixProgressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLayoutConstraint.activate([
            beforeFixProgressView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            beforeFixProgressView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60),
            
            afterFixProgressView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            afterFixProgressView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60)
        ])
    }
    
    
    
}

