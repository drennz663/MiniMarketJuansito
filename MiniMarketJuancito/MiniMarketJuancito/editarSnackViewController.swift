import UIKit
import CoreData

class editarSnackViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var precioTextField: UITextField!
    @IBOutlet weak var medidaPickerView: UIPickerView!

    var snackUpdate: Snack?

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
        idTextField.text = String(snackUpdate?.id ?? 0)
        nombreTextField.text = snackUpdate?.nombre
        descripcionTextField.text = snackUpdate?.descripcion
        precioTextField.text = String(snackUpdate?.precio ?? 0.0)
        
        if let medida = snackUpdate?.medida, let index = medidas.firstIndex(of: medida) {
            medidaPickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }

    func updateProduct() {
        let context = connectBD()

        if let product = snackUpdate {
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

    @IBAction func actualizarButton(_ sender: UIButton) {
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
