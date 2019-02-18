//
//  CalendarViewController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/17/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import JTAppleCalendar


class CalendarViewController: UIViewController {
    @IBOutlet weak var calendarCollectionView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    let formatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
    }
    
    func setupCalendarView() {
        //setup labeld
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        calendarCollectionView.visibleDates { (visibleDate) in
            self.setUpCalendarViews(from: visibleDate)
        }
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        print("done button pressed")
    }
    
    
    func setUpCalendarViews(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
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
    
    
}