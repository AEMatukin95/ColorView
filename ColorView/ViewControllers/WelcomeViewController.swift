//
//  WelcomeViewController.swift
//  ColorView
//
//  Created by Александр Матукин on 06.11.2021.
//

import UIKit
protocol NewViewColorDelegate {
    func setNewColor(for newColor: UIColor)
}

class WelcomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.7, alpha: 1)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let colorVC = segue.destination as? ColorViewController else { return }
        colorVC.viewColorPassed = view.backgroundColor
        colorVC.delegate = self
    }

}

// MARK: - NewViewColorDelegate

extension WelcomeViewController: NewViewColorDelegate {
    func setNewColor(for newColor: UIColor) {
        view.backgroundColor = newColor
    }
}

