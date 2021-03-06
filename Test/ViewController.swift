//
//  ViewController.swift
//  Test
//
//  Created by Mohamed Abdelkhalek Salah on 02/10/2021.
//

import UIKit

class ResultVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }
}
class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    let searchController = UISearchController()
    
    lazy var data = DataModel.data
    lazy var shipmentDataSucced = DataModel.shipmentDataSucced

    @IBOutlet weak var shipmentData: UITableView!
    @IBOutlet weak var addToShopButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    fileprivate func configureSearchBar() {
        searchController.searchBar.placeholder = "Ref. No / Barcode"
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
    }
    
    // configure tableview
    fileprivate func configureTableView() {
        shipmentData.delegate = self
        shipmentData.dataSource = self
    }
    
    // configure Navigation Bar
    fileprivate func configureNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Scan", style: .plain, target: self, action: #selector(addTapped))
    }
    
    // configure View Controller
    fileprivate func configureVC() {
        title = "Search"
        configureSearchBar()
        configureTableView()
        configureNavigationBar()
        showContent(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    func showContent(_ isShown: Bool) {
        shipmentData.isHidden = !isShown
        addToShopButton.isHidden = !isShown
        doneButton.isHidden = !isShown
    }
    
    @objc func addTapped() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
}

// confirm ViewController to UISearchBarDelegate protocol
extension ViewController: UISearchBarDelegate {
    
    // apply action after press search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.lowercased(),
              let mobile_no = shipmentDataSucced["Mobile_no"]?.lowercased(),
              let shipper_acc = shipmentDataSucced["Shipper_Acc"]?.lowercased(),
              let country_id = shipmentDataSucced["Country_ID"]?.lowercased()
        
        else {
            return
        }
        
        if  mobile_no.containsOrContentOf(searchText)   ||
            shipper_acc.containsOrContentOf(searchText) ||
            country_id.containsOrContentOf(searchText)
        {
            data[0] = "Mob. No: \(mobile_no)"
            data[1] = "Custome Name:  \(shipmentDataSucced["Weight"] ?? "")"
            data[2] = "Address: \(shipmentDataSucced["Country_ID"] ?? "")"
            data[3] = "Weight: \(shipmentDataSucced["Weight"] ?? "")"
            data[4] = "Description: \(country_id)"
            data[5] = "Shipper: \(shipper_acc)"
            if shipmentDataSucced["editable"] == "false" {
                data.append("COD: 5200")
                data.append("AWBCharges: 50")
            }
            data.append("Total Collection: 5250")
            showContent(true)
            shipmentData.reloadData()
        } else {
            showContent(false)
        }
    }
}

// confirm ViewController to UITableViewDelegate, UITableViewDataSource protocol
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    
}
