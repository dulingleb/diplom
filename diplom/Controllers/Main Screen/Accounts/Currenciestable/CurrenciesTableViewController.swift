//
//  CurrenciesTableViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 15.1.24..
//

import UIKit
import RealmSwift

class CurrenciesTableViewController: UITableViewController, UISearchResultsUpdating {
    
    weak var delegate: CurrencySelectionDelegate?
    
    var currencies: Results<Currency>!
    var filteredCurrencies = [Currency]()
    var searchController: UISearchController!
    var isSearching = false
    var sections = [Section]()

    struct Section {
        let letter: String
        let currencies: [Currency]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Choose Currency"
        navigationItemSetup()
        
        tableView.register(CurrenciesTableViewCell.self, forCellReuseIdentifier: CurrenciesTableViewCell.reuseId)

        currencies = StorageManager.shared.getCurrencies().sorted(byKeyPath: "code", ascending: false)

        
        setupSections(with: Array(currencies))
        
        // Настройка поискового контроллера
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Currencies"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        tableView.reloadData()
    }
    
    // кнопки закрыть
    private func navigationItemSetup() {
        
        // Кнопка закрытия
        let closeButtonContainer = CloseButtonContainer()
        
        closeButtonContainer.closeButton.closeButtonAction = {[weak self] in
            self?.closeButtonTapped()
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButtonContainer)
    }
    
    func setupSections(with currencies: [Currency]) {
        let groupedData = Dictionary(grouping: currencies) { String($0.code.prefix(1)) }
        sections = groupedData.map { Section(letter: $0.key, currencies: $0.value) }
        sections.sort { $0.letter < $1.letter }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].currencies.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrenciesTableViewCell.reuseId, for: indexPath) as! CurrenciesTableViewCell

        let currency = sections[indexPath.section].currencies[indexPath.row]

        // Настройка ячейки с именем и кодом валюты
        cell.configure(with: currency)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency = sections[indexPath.section].currencies[indexPath.row]
        delegate?.currencyDidSelect(currency: selectedCurrency)
        
        self.searchController.searchBar.endEditing(false)
        dismiss(animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        if searchText.isEmpty {
            isSearching = false
            setupSections(with: Array(currencies))
        } else {
            isSearching = true
            filteredCurrencies = Array(currencies).filter { currency in
                currency.name.lowercased().contains(searchText.lowercased()) ||
                currency.code.lowercased().contains(searchText.lowercased())
            }
            setupSections(with: filteredCurrencies)
        }

        tableView.reloadData()
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func keyboardDidHide(notification: NSNotification) {
        dismiss(animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
