//
//  ChoseIconViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 17.1.24..
//

import UIKit

class ChoseIconViewController: UIViewController, ColorCollectionViewDelegate, IconCollectionViewDelegate {
    weak var delegate: IconsSelectionDelegate?
    
    private var colorsCollectionView: UICollectionView!
    private var colorsDataSource: ColorCollectionViewDataSource!
    
    private var iconsCollectionView: UICollectionView!
    private var iconsDataSource: IconCollectionViewDataSource!
    
    private var saveButtonContainer = UIView()
    private var saveButton: UIButton!
    
    let iconView = AccountIconContainer()
    private var iconName: String = "wallet" {
        didSet {
            iconView.configure(name: iconName, color: iconColor)
            print("\(iconName)")
        }
    }
    private var iconColor: UIColor = .systemOrange {
        didSet {
            iconView.configure(name: iconName, color: iconColor)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItemSetup()
        setupUI()
        
        setupColorsCollectionView()
        setupIconsCollectionView()
        
        setupSaveButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.iconDidSelected(iconName: self.iconName, color: self.iconColor)
    }
    
    func setupColorsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 40, height: 40)
        colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorsCollectionView.backgroundColor = view.backgroundColor
        view.addSubview(colorsCollectionView)
        
        let colors: [UIColor] = [.systemPink, .systemRed, .systemOrange, UIColor(red: 1, green: 0.77, blue: 0, alpha: 1), .systemGreen, .systemTeal, .systemBlue, .systemIndigo, .systemPurple, .systemGray, .black]
        colorsDataSource = ColorCollectionViewDataSource(colors: colors)
        colorsCollectionView.dataSource = colorsDataSource
        colorsCollectionView.delegate = colorsDataSource
        colorsDataSource.delegate = self
        colorsCollectionView.register(CollorCollectionViewCell.self, forCellWithReuseIdentifier: CollorCollectionViewCell.reuseId)
        
        
        NSLayoutConstraint.activate([
            colorsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            colorsCollectionView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 28),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 40),
        ])
        
    }
    
    func setupIconsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        iconsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        iconsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        iconsCollectionView.backgroundColor = view.backgroundColor
        view.addSubview(iconsCollectionView)
        
        let icons = [
            IconSection(title: "Standart", icons: [
                Icon(name: "Gift"), Icon(name: "ShoppingBag"), Icon(name: "Storefront"), Icon(name: "acounts"), Icon(name: "briefcase"), Icon(name: "Barbell"), Icon(name: "Bathtub"), Icon(name: "FirstAid"), Icon(name: "HouseLine"), Icon(name: "Popcorn"), Icon(name: "Receipt"), Icon(name: "ShoppingCartSimple"), Icon(name: "Train"),
            ]),
            IconSection(title: "Money", icons: [
                Icon(name: "wallet"), Icon(name: "banknote"), Icon(name: "Cardholder"), Icon(name: "PiggyBank"), Icon(name: "Coin"), Icon(name: "CreditCard"), Icon(name: "CurrencyDollar"), Icon(name: "CurrencyEur"), Icon(name: "CurrencyBtc"),
            ]),
            IconSection(title: "Brands", icons: [
                Icon(name: "AndroidLogo"), Icon(name: "AppleLogo"), Icon(name: "GithubLogo"), Icon(name: "PinterestLogo"), Icon(name: "SketchLogo"), Icon(name: "TwitterLogo"), Icon(name: "WhatsappLogo"), Icon(name: "WindowsLogo"), Icon(name: "YoutubeLogo"),
            ])
        ]
        
        iconsDataSource = IconCollectionViewDataSource(sections: icons)
        iconsCollectionView.dataSource = iconsDataSource
        iconsCollectionView.delegate = iconsDataSource
        iconsCollectionView.register(IconCollectionViewCell.self, forCellWithReuseIdentifier: IconCollectionViewCell.reuseId)
        iconsCollectionView.register(IconHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: IconHeaderCollectionReusableView.reuseId)
        iconsDataSource.delegate = self
        
        NSLayoutConstraint.activate([
            iconsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            iconsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            iconsCollectionView.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 28),
            iconsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
    
    func setupSaveButton() {
        var saveButtonConfig = UIButton.Configuration.filled()
        saveButtonConfig.cornerStyle = .capsule
        saveButton = UIButton(configuration: saveButtonConfig)
        saveButton.setTitle("Save", for: .normal)
        saveButton.frame = CGRect(
            x: 36,
            y: 0,
            width: view.frame.size.width - 36 * 2,
            height: 50
        )
        saveButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        saveButtonContainer.addSubview(saveButton)
        
        saveButtonContainer.frame = CGRect(
            x: 0,
            y: view.bounds.height - 150,
            width: view.frame.width,
            height: 86
        )

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = saveButtonContainer.bounds
        gradientLayer.colors = [UIColor.secondarySystemBackground.withAlphaComponent(0.1).cgColor, UIColor.secondarySystemBackground.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        saveButtonContainer.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(saveButtonContainer)
    }
    
    func setupUI() {
        title = "Account Icon"
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(iconView)
        iconView.configure(name: iconName, color: iconColor)
        iconView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            iconView.heightAnchor.constraint(equalToConstant: 100),
            iconView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func navigationItemSetup() {
        // Кнопка закрытия
        let closeButtonContainer = CloseButtonContainer()
        
        closeButtonContainer.closeButton.closeButtonAction = {[weak self] in
            self?.closeButtonTapped()
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButtonContainer)
    }
    
    public func setIcon(iconName: String, iconColor: UIColor) {
        self.iconName = iconName
        self.iconColor = iconColor
    }
    
    func didSelectColor(_ color: UIColor) {
        iconColor = color
    }
    
    func didSelectedIcon(_ icon: String) {
        self.iconName = icon
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
}
