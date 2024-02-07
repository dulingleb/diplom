//
//  MonthPickerView.swift
//  diplom
//
//  Created by Dulin Gleb on 3.2.24..
//

import UIKit

protocol MonthPickerViewDelegate: AnyObject {
    func didPickMonthYear(date: Date)
}

class MonthYearSelector: UIView {
    private var currentDate: Date = Date()
    private var currentMonthYear: DateComponents = {
        let components = Calendar.current.dateComponents([.year, .month], from: Date())
        return components
    }() {
        didSet {
            if currentMonthYear == Calendar.current.dateComponents([.year, .month], from: Date()) {
                nextButton.isEnabled = false
            } else {
                nextButton.isEnabled = true
            }
        }
    }
    
    private let monthYearLabel = UILabel()
    private let prevButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    
    weak var delegate: MonthPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        updateLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        updateLabel()
    }
    
    private func setupViews() {
        prevButton.setImage(UIImage(named: "arrow.left"), for: .normal)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.addTarget(self, action: #selector(prevMonth), for: .touchUpInside)
        
        nextButton.setImage(UIImage(named: "arrow.right"), for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        
        monthYearLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [prevButton, monthYearLabel, nextButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            prevButton.widthAnchor.constraint(equalToConstant: 20),
            nextButton.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func updateLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        if let date = Calendar.current.date(from: currentMonthYear) {
            monthYearLabel.text = formatter.string(from: date)
        }
    }
    
    @objc private func prevMonth() {
        guard let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) else { return }
        currentDate = newDate.startOfMonth
        currentMonthYear = Calendar.current.dateComponents([.year, .month], from: newDate)
        updateLabel()
        self.delegate?.didPickMonthYear(date: currentDate)
    }
    
    @objc private func nextMonth() {
        guard let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) else { return }
        currentDate = newDate.startOfMonth
        currentMonthYear = Calendar.current.dateComponents([.year, .month], from: newDate)
        updateLabel()
        
        self.delegate?.didPickMonthYear(date: currentDate)
    }
}
