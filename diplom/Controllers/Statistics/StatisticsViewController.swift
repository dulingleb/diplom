//
//  StatisticsViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 7.2.24..
//

import UIKit
import DGCharts

class StatisticsViewController: UIViewController, MonthPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let margin = 20.0
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 78, height: 100)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.register(StatisticCategoriesCollectionViewCell.self, forCellWithReuseIdentifier: StatisticCategoriesCollectionViewCell.reuseID)
        
        return cv
    }()
    
    let chooseAccountButton: ChoseAccountButton = {
        let chooseAccountButton = ChoseAccountButton(type: .system)
        chooseAccountButton.setRightArrow()
        chooseAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 36, bottom: 5, trailing: 25)
        chooseAccountButton.configuration = config

        
        return chooseAccountButton
    }()
    
    let totalExpenseAmount: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.textColor = .black
        return lbl
    }()
    
    let pieChartView: PieChartView = {
        let pieChartView = PieChartView()
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        
        return pieChartView
    }()
    
    var account: Account! {
        didSet {
            chooseAccountButton.setTitle(account.name, for: .normal)
            chooseAccountButton.setLeftImage(leftImage: UIImage(named: account.iconName)!, tintColor: UIColor(hexString: account.iconColor))
            
            sortCategories()
            collectionView.reloadData()
            setupPieChartData()
        }
    }
    
    var categories: [TransactionCategory]!
    var filterDate: Date! = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupCollectionView()
        setupPieChartData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categories = Array(StorageManager.shared.getTransactionCategories(type: .expense))
        account = StorageManager.shared.getAccounts().first
        setupPieChartData()
    }
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        titleLabel.text = "Statistics"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let monthYearSelector = MonthYearSelector()
        monthYearSelector.translatesAutoresizingMaskIntoConstraints = false
        monthYearSelector.delegate = self
        view.addSubview(monthYearSelector)
        
        let chartBlock = UIView()
        chartBlock.clipsToBounds = true
        chartBlock.layer.cornerRadius = 32
        chartBlock.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        chartBlock.translatesAutoresizingMaskIntoConstraints = false
        chartBlock.backgroundColor = .white
        view.addSubview(chartBlock)
        
        let accountLabel = UILabel()
        accountLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        accountLabel.text = "Account"
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        chartBlock.addSubview(accountLabel)
        
        chooseAccountButton.addTarget(self, action: #selector(chooseAccountButtonClick), for: .touchUpInside)
        categories = Array(StorageManager.shared.getTransactionCategories(type: .expense))
        account = StorageManager.shared.getAccounts().first
        chartBlock.addSubview(chooseAccountButton)
        
        chartBlock.addSubview(pieChartView)
        chartBlock.addSubview(collectionView)
        
        let totalAmounInfo = UILabel()
        totalAmounInfo.text = "Total Expense"
        totalAmounInfo.textColor = .secondaryLabel
        totalAmounInfo.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topBarHeight),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            
            monthYearSelector.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin * 2),
            monthYearSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            monthYearSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            
            chartBlock.topAnchor.constraint(equalTo: monthYearSelector.bottomAnchor, constant: margin * 2),
            chartBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartBlock.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            chooseAccountButton.topAnchor.constraint(equalTo: chartBlock.topAnchor, constant: 15),
            chooseAccountButton.trailingAnchor.constraint(equalTo: chartBlock.trailingAnchor, constant: -margin),
            
            accountLabel.topAnchor.constraint(equalTo: chartBlock.topAnchor, constant: margin),
            accountLabel.leadingAnchor.constraint(equalTo: chartBlock.leadingAnchor, constant: margin),
            
            pieChartView.topAnchor.constraint(equalTo: accountLabel.topAnchor, constant: margin * 2),
            pieChartView.leadingAnchor.constraint(equalTo: chartBlock.leadingAnchor, constant: margin),
            pieChartView.trailingAnchor.constraint(equalTo: chartBlock.trailingAnchor, constant: -margin),
            pieChartView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -margin),
            
            collectionView.leadingAnchor.constraint(equalTo: chartBlock.leadingAnchor, constant: margin),
            collectionView.trailingAnchor.constraint(equalTo: chartBlock.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            
            
        ])
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(StatisticCategoriesCollectionViewCell.self, forCellWithReuseIdentifier: StatisticCategoriesCollectionViewCell.reuseID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticCategoriesCollectionViewCell.reuseID, for: indexPath) as! StatisticCategoriesCollectionViewCell
        
        let category = categories[indexPath.row]
        let sumOfTransactions: Double = sumOfCategory(category: category)
        cell.config(title: category.name, iconName: category.iconName, iconColor: UIColor(hexString: category.iconColor), amount: sumOfTransactions.withCommas() + (account.currency?.symbol ?? "$"))
        
        return cell
    }
    
    func setupPieChartData() {
        
        let entries = categories.compactMap { category -> PieChartDataEntry? in
            let sum: Double = sumOfCategory(category: category)
            if sum > 0 {
                return PieChartDataEntry(value: sum, icon: NSUIImage(named: category.iconName)?.withTintColor(UIColor(hexString: category.iconColor)))
            } else {
                return nil
            }
        }
        
        
        
        var totalAmount: Double = 0
        for category in categories {
            totalAmount += sumOfCategory(category: category)
        }

        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = categories.compactMap({ UIColor(hexString: $0.iconColor).withAlphaComponent(0.4) })
        dataSet.valueTextColor = UIColor.black
        dataSet.sliceSpace = 5
        dataSet.drawValuesEnabled = false

        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.legend.enabled = false
        pieChartView.holeRadiusPercent = 0.8
        pieChartView.highlightPerTapEnabled = true
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributesForInfo: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
            .foregroundColor: UIColor.secondaryLabel,
            .paragraphStyle: paragraphStyle
        ]
        
        let centerText = NSMutableAttributedString(string: "Total Expense\n", attributes: attributesForInfo)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]

        let sumText = NSAttributedString(string: totalAmount.withCommas() + (account.currency?.symbol ?? "$"), attributes: attributes)
        centerText.append(sumText)

        pieChartView.centerAttributedText = centerText
    }
    
    func sortCategories() {
        categories.sort(by: { n1, n2 in
            let c1: Double = n1.getTransactionsByMonth(date: filterDate).sum(ofProperty: "amount")
            let c2: Double = n2.getTransactionsByMonth(date: filterDate).sum(ofProperty: "amount")
            return c1 > c2
        })
    }
    
    func sumOfCategory(category: TransactionCategory) -> Double {
        let sum: Double = category.getTransactionsByMonth(date: filterDate)
            .filter("account._id = %@", self.account._id).sum(of: \.amount)
        
        return sum
    }

    func didPickMonthYear(date: Date) {
        self.filterDate = date
        sortCategories()
        collectionView.reloadData()
        setupPieChartData()
    }
    
    @objc func chooseAccountButtonClick() {
        let accountsVC = ListAccountsViewController()
        let navigationVC = UINavigationController(rootViewController: accountsVC)
        
        if let sheet = navigationVC.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.large(), .custom(resolver: { context in
                    370
                })]
            } else {
                sheet.detents = [.large()]
            }
            
            navigationVC.sheetPresentationController?.preferredCornerRadius = 30
        }
        
        accountsVC.onAccountSelect = { [weak self] account in
            self?.account = account
        }
        
        navigationController?.present(navigationVC, animated: true)
    }
}
