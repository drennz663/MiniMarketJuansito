//
//  bebidaTableViewCell.swift
//  MiniMarketJuancito
//
//  Created by DAMII on 20/12/24.
//

import UIKit

class bebidaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var medidaLabel: UILabel!
    
    var bebida: Producto?
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureBebida(bebida: Producto, viewController: UIViewController) {
        self.idLabel.text = "ID: \(bebida.id)"
        self.nombreLabel.text = "Nombre: \(bebida.nombre ?? "")"
        self.descripcionLabel.text = "Descripción: \(bebida.descripcion ?? "")"
        self.precioLabel.text = "Precio: \(bebida.precio)"
        self.medidaLabel.text = "Medida: \(bebida.medida ?? "")"
        
        self.bebida = bebida
        self.viewController = viewController
    }
}
