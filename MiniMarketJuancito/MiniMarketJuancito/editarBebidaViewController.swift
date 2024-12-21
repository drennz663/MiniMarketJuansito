import UIKit
import CoreData

class editarBebidaViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var precioTextField: UITextField!
    @IBOutlet weak var medidaPickerView: UIPickerView!

    var bebidaUpdate: Producto?
    let medidas = ["Unidad", "Kilogramo", "Litro", "Caja"]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        medidaPickerView.dataSource = self
        medidaPickerView.delegate = self
    }

    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    func configureTextFields() {
        idTextField.text = String(bebidaUpdate?.id ?? 0)
        nombreTextField.text = bebidaUpdate?.nombre
        descripcionTextField.text = bebidaUpdate?.descripcion
        precioTextField.text = String(bebidaUpdate?.precio ?? 0.0)
        
        if let medida = bebidaUpdate?.medida, let index = medidas.firstIndex(of: medida) {
            medidaPickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }

    func updateProduct() {
        let context = connectBD()

        if let product = bebidaUpdate {
            product.setValue(nombreTextField.text, forKey: "nombre")
            product.setValue(descripcionTextField.text, forKey: "descripcion")

            if let priceText = precioTextField.text, let price = Double(priceText) {
                product.setValue(price, forKey: "precio")
            }

            let selectedMedida = medidaPickerView.selectedRow(inComponent: 0)
            let medida = medidas[selectedMedida]

            product.setValue(medida, forKey: "medida")

            do {
                try context.save()
                navigationController?.popViewController(animated: true)
                print("Producto actualizado correctamente")
            } catch let error as NSError {
                print("Error al actualizar el producto: \(error.localizedDescription)")
            }
        }
    }

    @IBAction func editarButton(_ sender: UIButton) {
        updateProduct()
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
}
