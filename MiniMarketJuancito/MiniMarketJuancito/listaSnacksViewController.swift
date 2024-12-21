import UIKit
import CoreData

class listaSnacksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listaSnacksTableView: UITableView!
    @IBOutlet weak var contadorSnacks: UILabel!
    
    var productData = [Snack]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchProductList()
        updateSnacksCount()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProductList()
        listaSnacksTableView.reloadData()
        updateSnacksCount()
    }

    func connectBD() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    func configureTableView() {
        listaSnacksTableView.delegate = self
        listaSnacksTableView.dataSource = self
        listaSnacksTableView.rowHeight = 180
    }

    func fetchProductList() {
        let context = connectBD()
        let fetchRequest: NSFetchRequest<Snack> = Snack.fetchRequest()
        do {
            productData = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error al obtener los productos: \(error.localizedDescription)")
        }
    }

    func updateSnacksCount() {
        if productData.isEmpty {
            contadorSnacks.text = "No hay snacks disponibles"
        } else {
            contadorSnacks.text = "Total de Snacks: \(productData.count)"
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "snackTableViewCell", for: indexPath) as! snackTableViewCell
        let snack = productData[indexPath.row]
        cell.configureSnack(snack: snack, viewController: self)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
         
            let alertController = UIAlertController(title: "Confirmar eliminación", message: "¿Estás seguro de que deseas eliminar este snack?", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
                let context = self?.connectBD()
                let product = self?.productData[indexPath.row]
                context?.delete(product!)

                do {
                    try context?.save()
                    self?.productData.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    self?.updateSnacksCount()
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
        performSegue(withIdentifier: "updateSnack", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateSnack" {
            if let indexPath = listaSnacksTableView.indexPathForSelectedRow {
                let selectedProduct = productData[indexPath.row]
                let editarSnackViewController = segue.destination as! editarSnackViewController
                editarSnackViewController.snackUpdate = selectedProduct
            }
        }
    }
}
