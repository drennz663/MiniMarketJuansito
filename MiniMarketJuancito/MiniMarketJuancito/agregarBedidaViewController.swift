//
//  agregarBedidaViewController.swift
//  MiniMarketJuancito
//
//  Created by DAMII on 20/12/24.
//

import UIKit
import CoreData

	
class agregarBedidaViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var precioTextField: UITextField!
    @IBOutlet weak var medidaPickerView: UIPickerView!
    
    let medidas = ["Unidad", "Kilogramo", "Litro", "Caja"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        medidaPickerView.dataSource = self
        medidaPickerView.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return medidas.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return medidas[row]
    }

    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    func guardarProducto() {
        let context = connectBD()

        guard let entityProducto = NSEntityDescription.insertNewObject(forEntityName: "Producto", into: context) as? Producto else {
            print("Error al crear la entidad Producto")
            return 
        }

        entityProducto.id = Int32(idTextField.text ?? "0") ?? 0
        entityProducto.nombre = nombreTextField.text
        entityProducto.descripcion = descripcionTextField.text
        entityProducto.precio = Double(precioTextField.text ?? "") ?? 0.0
        entityProducto.medida = medidas[medidaPickerView.selectedRow(inComponent: 0)]

        do {
            try context.save()
            limpiarCampos()
            mostrarAlerta(titulo: "Éxito", mensaje: "Producto guardado correctamente.")
        } catch let error as NSError {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudo guardar: \(error.localizedDescription)")
        }
    }

    func validarCampos() -> Bool {
        guard let idText = idTextField.text, !idText.isEmpty,
              let name = nombreTextField.text, !name.isEmpty,
              let description = descripcionTextField.text, !description.isEmpty,
              let priceText = precioTextField.text, !priceText.isEmpty, Double(priceText) != nil else {
            return false
        }
        return true
    }

    func limpiarCampos() {
        idTextField.text = ""
        nombreTextField.text = ""
        descripcionTextField.text = ""
        precioTextField.text = ""
        medidaPickerView.selectRow(0, inComponent: 0, animated: true)
        idTextField.becomeFirstResponder()
    }

    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alerta, animated: true, completion: nil)
    }

    @IBAction func agregarButton(_ sender: UIButton) {
        if validarCampos() {
            guardarProducto()
        } else {
            mostrarAlerta(titulo: "Advertencia", mensaje: "Por favor, complete todos los campos correctamente.")
        }
    }
}
