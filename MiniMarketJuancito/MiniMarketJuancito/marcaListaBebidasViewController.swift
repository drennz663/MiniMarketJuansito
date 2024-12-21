import UIKit

class marcaListaBebidasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var marcaListaBebidasTableView: UITableView!
    
    var arrayBebida = [BebidaResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchData()
    }
    
    func configureTableView() {
        marcaListaBebidasTableView.delegate = self
        marcaListaBebidasTableView.dataSource = self
        marcaListaBebidasTableView.register(UINib(nibName: "marcasBebidasTableViewCell", bundle: nil), forCellReuseIdentifier: "marcasBebidasTableViewCell")
        marcaListaBebidasTableView.rowHeight = 380
        marcaListaBebidasTableView.showsVerticalScrollIndicator = false
        marcaListaBebidasTableView.separatorStyle = .none
    }
    
    func fetchData() {
        let webService = "https://eliasmsk.github.io/pruebastdamii/MinimarketJuancito.json"
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
                self?.arrayBebida = try JSONDecoder().decode([BebidaResponse].self, from: dataJSON)
                
                DispatchQueue.main.async {
                    self?.marcaListaBebidasTableView.reloadData()
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
        return arrayBebida.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = marcaListaBebidasTableView.dequeueReusableCell(withIdentifier: "marcasBebidasTableViewCell", for: indexPath) as? marcasBebidasTableViewCell
        let list = arrayBebida[indexPath.row]
        cell?.configureMarcaBebidas(viewList: list)
        return cell ?? UITableViewCell()
    }
}
