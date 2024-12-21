import UIKit

class snackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var medidaLabel: UILabel!
    
    var snack: Snack?
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureSnack(snack: Snack, viewController: UIViewController) {
        self.idLabel.text = "ID: \(snack.id)"
        self.nombreLabel.text = "Nombre: \(snack.nombre ?? "")"
        self.descripcionLabel.text = "Descripción: \(snack.descripcion ?? "")"
        self.precioLabel.text = "Precio: \(snack.precio)"
        self.medidaLabel.text = "Medida: \(snack.medida ?? "")"
        
        self.snack = snack
        self.viewController = viewController
    }
}
