//
//  CalendarViewController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/17/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import JTAppleCalendar


protocol CalendarDateSelectedDelegate: AnyObject {
    func didSelectDates(startDate: String, endDate: String)
}


protocol CalendarUpdateSearchDelegate: AnyObject {
    func updateMainSearch(startDate: String, endDate: String)
}



class CalendarViewController: UIViewController {
    @IBOutlet weak var calendarCollectionView: JTAppleCalendarView! {
        didSet {
            self.calendarCollectionView.reloadData()
        }
    }
    weak var mainDelegate: CalendarUpdateSearchDelegate?
    weak var delegate: CalendarDateSelectedDelegate?
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    let formatter: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = Calendar.current.timeZone
        dateFormat.locale = Calendar.current.locale
        dateFormat.dateFormat = "yyyy MM dd"
        return dateFormat
    }()
    var firstDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        calendarCollectionView.scrollToDate(Date())
        calendarCollectionView.visibleDates { dateSegment in
            self.setUpCalendarViews(from: dateSegment)
        }
        calendarCollectionView.allowsMultipleSelection = true
        calendarCollectionView.isRangeSelectionUsed = true
    }

    
    func setupCalendarView() {
        calendarCollectionView.minimumLineSpacing = 0
        calendarCollectionView.minimumInteritemSpacing = 0
        //setup labeld
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        calendarCollectionView.visibleDates { (visibleDate) in
            self.setUpCalendarViews(from: visibleDate)
        }
        
        
        
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CalendarCell else { return }
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let customCell = view as? CalendarCell else { return }
        let todaysDate = Date()
        if cellState.isSelected {
            customCell.dateLabel.textColor = .white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                customCell.dateLabel.textColor = .black
                customCell.isUserInteractionEnabled = true
            } else {
                customCell.isUserInteractionEnabled = false
                customCell.dateLabel.textColor = .lightGray
            }
        }
        
        formatter.dateFormat = "MMM dd"
        let todayString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        if todayString == monthDateString {
            customCell.currentDay.isHidden = false
        } else {
            customCell.currentDay.isHidden = true
        }
        
        formatter.dateFormat = "d"
        let todaysDay = formatter.string(from: todaysDate)
        if let myDate = customCell.dateLabel.text {
            guard let myDateNumber = Int(myDate) else { return }
            guard let todayDateNumber = Int(todaysDay) else { return }
            if myDateNumber < todayDateNumber {
                customCell.isUserInteractionEnabled = false
            } else  {
                customCell.isUserInteractionEnabled = true
            }
        }
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func setUpCalendarViews(from visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        self.formatter.dateFormat = "MMMM"
        self.monthLabel.text = self.formatter.string(from: date)
        self.formatter.dateFormat = "yyyy"
        self.yearLabel.text = self.formatter.string(from: date)
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as? CalendarCell else { return JTAppleCell() }
        cell.dateLabel.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "2019 01 01")!
        let endDate = formatter.date(from: "2019 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarCell
        cell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpCalendarViews(from: visibleDates)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        if firstDate != nil {
            self.calendarCollectionView.selectDates(from: firstDate!, to: date, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            calendarCollectionView.reloadData()
            formatter.dateFormat = "MMM dd"
            let formatedFirstDate = formatter.string(from: firstDate!)
            let formatedSecondDate = formatter.string(from: date)
            showAlert(title: "Dates selected", message: "from \(formatedFirstDate) to \(formatedSecondDate)", style: .alert) { (alert) in
                self.delegate?.didSelectDates(startDate: formatedFirstDate, endDate: formatedSecondDate)
                if let _ = self.parent?.children[0] {
                    self.mainDelegate?.updateMainSearch(startDate: formatedFirstDate, endDate: formatedSecondDate)
                }
            }
        } else {
            firstDate = date
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func scrollDidEndDecelerating(for calendar: JTAppleCalendarView) {
        
    }
}
