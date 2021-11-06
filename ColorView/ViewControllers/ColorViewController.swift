//
//  ViewController.swift
//  ColorView
//
//  Created by Александр Матукин on 24.10.2021.
//

import UIKit

class ColorViewController: UIViewController {

    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    var viewColorPassed: UIColor!
    var delegate: NewViewColorDelegate!
    private var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        colorView.layer.cornerRadius = 10
        redSlider.tintColor = .red
        greenSlider.tintColor = .green
        blueSlider.tintColor = .blue
        colorView.backgroundColor = viewColorPassed
        calculationRGB()
        textFieldDidEndEditing(redTextField)
        textFieldDidEndEditing(greenTextField)
        textFieldDidEndEditing(blueTextField)
    }
    
// MARK: Передача значений в слайдеры, лейблы, текст  при переходе с экрана
    private func calculationRGB() {
        viewColorPassed.getRed(&r, green: &g, blue: &b, alpha: &a)
        redSlider.value = Float(r)
        greenSlider.value = Float(g)
        blueSlider.value = Float(b)
        redSliderAction()
        greenSliderAction()
        blueSliderAction()
    }

    
// MARK: Передача значений при изменении положений слайдера
    private func viewColors() {
        colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value),
                                            green: CGFloat(greenSlider.value),
                                            blue: CGFloat(blueSlider.value),
                                            alpha: 1)
        viewColorPassed = colorView.backgroundColor
    }
    
    @IBAction func redSliderAction() {
        viewColors()
        redLabel.text = String(format: "%.2f", redSlider.value)
        redTextField.text = String(format: "%.2f", redSlider.value)
    }
    
    @IBAction func greenSliderAction() {
        viewColors()
        greenLabel.text = String(format: "%.2f", greenSlider.value)
        greenTextField.text = String(format: "%.2f", greenSlider.value)
    }
    
    @IBAction func blueSliderAction() {
        viewColors()
        blueLabel.text = String(format: "%.2f", blueSlider.value)
        blueTextField.text = String(format: "%.2f", blueSlider.value)
    }
    
    // MARK: Передача цвета на WelcomeVC при нажатии на кнопку
    @IBAction func doneButtonPressed() {
        delegate.setNewColor(for: viewColorPassed)
        dismiss(animated: true)
    }
    
}

// MARK: - TextField
extension ColorViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else { return }
        guard let numberValue = Float(newValue) else { return }
        if numberValue > 1.1 || numberValue < -0.1 {
            showAlert(title: "Ooops!", message: "Enter a value from 0 to 1.")
        }
        if textField == redTextField {
            redSlider.value = numberValue
            redSliderAction()
        } else if textField == greenTextField {
            greenSlider.value = numberValue
            greenSliderAction()
        } else {
            blueSlider.value = numberValue
            blueSliderAction()
        }
        textField.addDoneButtonOnKeyboard(myAction: #selector(self.redTextField.resignFirstResponder))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}


// MARK: - Alert
extension ColorViewController {
    private func showAlert(title: String, message: String, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - doneButton
extension UITextField {
    func addDoneButtonOnKeyboard(myAction: Selector?) {
        let keyboardToolbar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        keyboardToolbar.items = [flexibleSpace, doneButton]
        keyboardToolbar.sizeToFit()
        self.inputAccessoryView = keyboardToolbar
        
    }
}
