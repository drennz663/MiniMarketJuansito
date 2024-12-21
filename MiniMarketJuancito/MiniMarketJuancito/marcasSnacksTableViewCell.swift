//
//  marcasSnacksTableViewCell.swift
//  MiniMarketJuancito
//
//  Created by DAMII on 20/12/24.
//

import UIKit
import AlamofireImage

class marcasSnacksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var marcaLabel: UILabel!
    
    @IBOutlet weak var empresaLabel: UILabel!
    
    @IBOutlet weak var correoLabel: UILabel!
    
    @IBOutlet weak var rucLabel: UILabel!
    
    @IBOutlet weak var generalView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        layer.cornerRadius = 10
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureMarcaSnacks(viewList: SnackResponse?) {
        guard let list = viewList else { return }
        
        marcaLabel.text = list.marca
        empresaLabel.text = list.empresa
        correoLabel.text = list.correo
        rucLabel.text = list.ruc
        
        let urlLogoSnack = list.logo
        if let url = URL(string: urlLogoSnack) {
            logoImageView?.af.setImage(withURL: url, placeholderImage: UIImage(named: "icon"))
        }
        
        logoImageView?.contentMode = .scaleAspectFill
        logoImageView?.layer.cornerRadius = 10
        generalView?.layer.shadowOffset = CGSize.zero
        generalView?.layer.shadowRadius = 1
        generalView?.layer.shadowOpacity = 1
        generalView?.layer.cornerRadius = 40
    }
    
}
