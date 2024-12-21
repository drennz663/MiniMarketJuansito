//
//  marcaListaSnacksViewController.swift
//  MiniMarketJuancito
//
//  Created by DAMII on 20/12/24.
//

import UIKit


class marcaListaSnacksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var marcaListaSnacksTableView: UITableView!
    
    var arraySnack = [SnackResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchData()
    }
    
    func configureTableView() {
        marcaListaSnacksTableView.delegate = self
        marcaListaSnacksTableView.dataSource = self
        marcaListaSnacksTableView.register(UINib(nibName: "marcasSnacksTableViewCell", bundle: nil), forCellReuseIdentifier: "marcasSnacksTableViewCell")
        marcaListaSnacksTableView.rowHeight = 380
        marcaListaSnacksTableView.showsVerticalScrollIndicator = false
        marcaListaSnacksTableView.separatorStyle = .none
    }
    
    func fetchData() {
        let webService = "https://eliasmsk.github.io/pruebastdamii/MinimarketJuancitoSnacks.json"  // URL de snacks
        guard let url = URL(string: webService) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                print("Error general: \(String(describing: error?.localizedDescription))")
                return
            }
            
            do {
                guard let dataJSON = data else {
                    return
                }
                self?.arraySnack = try JSONDecoder().decode([SnackResponse].self, from: dataJSON)
                
                DispatchQueue.main.async {
                    self?.marcaListaSnacksTableView.reloadData()
                }
            } catch {
                print("Error al parsear datos")
            }
        }.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySnack.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = marcaListaSnacksTableView.dequeueReusableCell(withIdentifier: "marcasSnacksTableViewCell", for: indexPath) as? marcasSnacksTableViewCell
        let list = arraySnack[indexPath.row]
        cell?.configureMarcaSnacks(viewList: list)  // Método que configura la celda para snacks
        return cell ?? UITableViewCell()
    }
}



