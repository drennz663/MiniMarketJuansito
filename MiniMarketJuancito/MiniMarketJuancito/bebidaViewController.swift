import UIKit
import CoreData
import FirebaseAuth
import Firebase

class bebidaViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var productosData: [Producto] = []
    var searchTimer: Timer?
    let medidas = ["Unidad", "Kilogramo", "Litro", "Caja"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(realizarBusqueda), userInfo: nil, repeats: false)
        return true
    }
    
    @objc func realizarBusqueda() {
        guard let searchText = searchTextField.text?.trimmingCharacters(in: .whitespaces), !searchText.isEmpty else {
            mostrarResultados([])
            return
        }
        buscarProducto(nombre: searchText)
    }
    
    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    func buscarProducto(nombre: String) {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Producto> = Producto.fetchRequest()
        
        if let idBuscado = Int32(nombre) {
            let idPredicate = NSPredicate(format: "id == %d", idBuscado)
            fetchRequest.predicate = idPredicate
        } else {
            let nombrePredicate = NSPredicate(format: "nombre CONTAINS[cd] %@", nombre)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [nombrePredicate])
            fetchRequest.predicate = compoundPredicate
        }
        
        do {
            let resultados = try context.fetch(fetchRequest)
            mostrarResultados(resultados)
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "Hubo un problema al realizar la búsqueda.")
        }
    }
    
    func mostrarResultados(_ resultados: [Producto]) {
        var mensaje = ""
        
        if resultados.isEmpty {
            mensaje = "No se encontraron bebidas."
        } else {
            for producto in resultados {
                mensaje += "ID: \(producto.id)\n"
                mensaje += "Nombre: \(producto.nombre ?? "N/A")\n"
                mensaje += "Descripción: \(producto.descripcion ?? "N/A")\n"
                mensaje += "Precio: \(producto.precio)\n"
                mensaje += "Medida: \(producto.medida ?? "N/A")\n\n"
            }
        }
        
        mostrarAlerta(titulo: "Resultados", mensaje: mensaje)
    }
    
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func ordenarButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Ordenar por", message: "Elige el criterio de ordenación", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Nombre (A-Z)", style: .default, handler: { _ in
            self.ordenarProductosPorNombre()
        }))
        
        alert.addAction(UIAlertAction(title: "ID (A-Z)", style: .default, handler: { _ in
            self.ordenarProductosPorID()
        }))
        
        alert.addAction(UIAlertAction(title: "Medida", style: .default, handler: { _ in
            self.seleccionarMedida()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func ordenarProductosPorNombre() {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Producto> = Producto.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nombre", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            productosData = try context.fetch(fetchRequest)
            mostrarResultados(productosData)
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "Hubo un problema al ordenar los productos.")
        }
    }
    
    func ordenarProductosPorID() {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Producto> = Producto.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            productosData = try context.fetch(fetchRequest)
            mostrarResultados(productosData)
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "Hubo un problema al ordenar los productos.")
        }
    }
    
    func ordenarProductosPorMedida() {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Producto> = Producto.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "medida", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            productosData = try context.fetch(fetchRequest)
            mostrarResultados(productosData)
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "Hubo un problema al ordenar los productos.")
        }
    }

    func seleccionarMedida() {
        let alert = UIAlertController(title: "Selecciona una medida", message: "Elige el tipo de medida", preferredStyle: .actionSheet)
        
        for medida in medidas {
            alert.addAction(UIAlertAction(title: medida, style: .default, handler: { _ in
                self.filtrarPorMedida(medidaSeleccionada: medida)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
   
    func filtrarPorMedida(medidaSeleccionada: String) {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Producto> = Producto.fetchRequest()
        let medidaPredicate = NSPredicate(format: "medida == %@", medidaSeleccionada)
        fetchRequest.predicate = medidaPredicate
        
        do {
            productosData = try context.fetch(fetchRequest)
            mostrarResultados(productosData)
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "Hubo un problema al filtrar por medida.")
        }
    }
    
    
    
   
    func logOut() {
        navigationController?.popViewController(animated: true)
          try? Auth.auth().signOut()
          self.dismiss(animated: true, completion: nil)
      }
      
    func getUser() {
            let _ = Auth.auth().currentUser?.email
        }
    
    
    @IBAction func cerrarSesion(_ sender: UIButton) {
        logOut()
    }
    
}
