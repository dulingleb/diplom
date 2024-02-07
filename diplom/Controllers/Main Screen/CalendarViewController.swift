//
//  CalendarViewController.swift
//  diplom
//
//  Created by Dulin Gleb on 29.1.24..
//

import UIKit

@available(iOS 16.0, *)
class CalendarViewController: UIViewController, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    var onDateSelect: ((Date) -> Void)?
    
    private var calendarView: UICalendarView!
    var currentDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Transaction Date"
        view.backgroundColor = .secondarySystemBackground

        calendarView = UICalendarView(frame: .zero)
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        
        let currentDate = currentDate ?? Date()

        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        
        dateSelection.setSelected(DateComponents(calendar: Calendar(identifier: .gregorian), year: year, month: month, day: day), animated: true)
        calendarView.selectionBehavior = dateSelection
        
        calendarView.availableDateRange = DateInterval.init(start: Date.distantPast, end: Date())
        view.addSubview(calendarView)

        // Настройка Auto Layout
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 68),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -61)
        ])

        calendarView.backgroundColor = .white
        calendarView.layer.cornerRadius = 12
        calendarView.calendar = Calendar.current
        calendarView.delegate = self
        
        navigationItemSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        onDateSelect?(currentDate ?? Date())
    }
    
    private func navigationItemSetup() {
        
        // Кнопка закрытия
        let closeButtonContainer = CloseButtonContainer()
        
        closeButtonContainer.closeButton.closeButtonAction = {[weak self] in
            self?.closeTapped()
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButtonContainer)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        self.currentDate = dateComponents?.date
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
}
