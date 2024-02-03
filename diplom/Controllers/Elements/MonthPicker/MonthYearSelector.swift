//
//  MonthPickerView.swift
//  diplom
//
//  Created by Dulin Gleb on 3.2.24..
//

import UIKit

protocol MonthPickerViewDelegate: AnyObject {
    func didPickMonthYear(month: Int, year: Int)
}

class MonthYearSelector: UIView {
    private var currentMonthYear: DateComponents = {
        let components = Calendar.current.dateComponents([.year, .month], from: Date())
        return components
    }()
    
    private let monthYearLabel = UILabel()
    private let prevButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    
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
        prevButton.setTitle("<", for: .normal)
        prevButton.addTarget(self, action: #selector(prevMonth), for: .touchUpInside)
        
        nextButton.setTitle(">", for: .normal)
        nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        
        monthYearLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [prevButton, monthYearLabel, nextButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
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
        guard let newDate = Calendar.current.date(byAdding: .month, value: -1, to: Calendar.current.date(from: currentMonthYear)!) else { return }
        currentMonthYear = Calendar.current.dateComponents([.year, .month], from: newDate)
        updateLabel()
    }
    
    @objc private func nextMonth() {
        guard let newDate = Calendar.current.date(byAdding: .month, value: 1, to: Calendar.current.date(from: currentMonthYear)!) else { return }
        currentMonthYear = Calendar.current.dateComponents([.year, .month], from: newDate)
        updateLabel()
    }
}
