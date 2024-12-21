import UIKit
import CoreData

class listaBebidasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listaBebidasTableView: UITableView!
    @IBOutlet weak var bebidaContador: UILabel!
    @IBOutlet weak var FiltroSegmentedControl: UISegmentedControl!
    
    var productData = [Producto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchProductList()
        updateBebidasCount()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProductList()
        listaBebidasTableView.reloadData()
        updateBebidasCount()
    }

    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    func configureTableView() {
        listaBebidasTableView.delegate = self
        listaBebidasTableView.dataSource = self
        listaBebidasTableView.rowHeight = 180
    }

    func fetchProductList() {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Producto> = Producto.fetchRequest()
        do {
            productData = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error al obtener los productos: \(error.localizedDescription)")
        }
    }

    func updateBebidasCount() {
        if productData.isEmpty {
            bebidaContador.text = "No hay bebidas disponibles"
        } else {
            bebidaContador.text = "Total de Bebidas: \(productData.count)"
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bebidaTableViewCell", for: indexPath) as! bebidaTableViewCell
        let bebida = productData[indexPath.row]
        cell.configureBebida(bebida: bebida, viewController: self)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
         
            let alertController = UIAlertController(title: "Confirmar eliminación", message: "¿Estás seguro de que deseas eliminar esta bebida?", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
                let context = self?.connectBD()
                let product = self?.productData[indexPath.row]
                context?.delete(product!)

                do {
                    try context?.save()
                    self?.productData.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    self?.updateBebidasCount()
                } catch let error as NSError {
                    print("Error al eliminar el producto: \(error.localizedDescription)")
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "updateView", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateView" {
            if let indexPath = listaBebidasTableView.indexPathForSelectedRow {
                let selectedProduct = productData[indexPath.row]
                let editarBebidaViewController = segue.destination as! editarBebidaViewController
                editarBebidaViewController.bebidaUpdate = selectedProduct
            }
        }
    }
}
