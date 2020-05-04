//
//  DetailViewController.swift
//  KursyWalutNBP
//
//  Tested on iphone 11
//  Created by xxx on 12/01/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

import UIKit
import Charts

//
// MARK: - Currency List View Controller
//
class DetailViewController: UIViewController {
    
    // MARK: - Variables And Properties
    var startDate: Date?
    var fromDate: Date?
    var code: String = ""
    var table: String = ""
    
    var currencyArray = [Currency]() {
        didSet {
            DispatchQueue.main.async {
                self.presentChart(data: self.currencyArray.first!.rates, code: self.code)
                self.setView(data: self.currencyArray)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDates()
        downloadData(table: table, code: code, fromDate: fromDate!.toString(), startDate: startDate!.toString())
    }
    
    private func downloadData(table: String, code: String, fromDate: String, startDate: String) -> Void {
        WebServices.loadDataWithDate(table: table, code: code, fromDate: fromDate, startDate: startDate) { (result) in
            switch result {
            case.failure(let error):
                print(error)
            case.success(let data):
                self.currencyArray = data
                print("success")
            }
        }
    }
    
    private func setDates() -> Void {
        startDate = Date()
        fromDate = startDate!.weekAgo()
    }
    
    private func setView(data: [Currency]) -> Void {
        minPriceLabel.text = String(data.first!.min)
        maxPriceLabel.text = String(data.first!.max)
        nameLabel.text = data.first!.currency
        setDifferenceInPriceLabel(value: data.first!.changeInPercent)
        
        // Custom Navigation Bar
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // Custom Tab Bar
        tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    private func setDifferenceInPriceLabel(value: Double) -> Void {
        var plus = ""
        if value < 0 {
            differenceInPriceLabel.textColor = .red
        } else {
            differenceInPriceLabel.textColor = .green
            plus = "+"
        }
        differenceInPriceLabel.text = plus + String(format: "%.3f", value) + " %"
    }
    
    // MARK: - Chart
    private func presentChart(data: [IndividualRate], code: String) -> Void {
        let chartData = getChartData(data: data)
        setChart(chartData: chartData, code: code)
        setCharView()
    }
    
    private func getChartData(data: [IndividualRate]) -> [ChartDataEntry] {
        var chartData : [ChartDataEntry] = []
        for (index, element) in data.enumerated() {
            let point = ChartDataEntry(x: Double(index + 1), y: element.mid)
            chartData.append(point)
        }
        return chartData
    }
    
    private func setChartData(data: LineChartDataSet) -> Void {
        data.mode = .cubicBezier
        data.drawCirclesEnabled = false
        data.lineWidth = 3
        data.setColor(.white)
        data.fill = Fill(color: .white)
        data.fillAlpha = 0.8
        data.drawFilledEnabled = true
    }
    
    private func setChart(chartData: [ChartDataEntry], code: String) -> Void {
        let dataSet = LineChartDataSet(entries: chartData, label: code)
        let data = LineChartData(dataSet:dataSet)
        data.setDrawValues(false)
        self.lineChartView.data = data
        setChartData(data: dataSet)
    }
    
    private func setCharView() -> Void {
        let yAxis = lineChartView.leftAxis
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
               
        lineChartView.rightAxis.enabled = false
        lineChartView.isUserInteractionEnabled = false
        lineChartView.xAxis.labelTextColor = UIColor.white
        lineChartView.leftAxis.labelTextColor = UIColor.white
        lineChartView.rightAxis.labelTextColor = UIColor.white
        lineChartView.legend.textColor = UIColor.white
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.animate(xAxisDuration: 0.5)
        
    }
    

    // MARK: - IBActions
    @IBAction func valueChanged(_ sender: Any) {
        print(datePicker.date.toString())
        startDate = datePicker.date
        fromDate = startDate!.weekAgo()
        segmentedControl.selectedSegmentIndex = 0
        downloadData(table: table, code: code, fromDate: fromDate!.toString(), startDate: startDate!.toString())
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Aktualna data - tydzień")
            fromDate = startDate!.weekAgo()
        case 1:
            print("Aktualna data - miesiac")
            fromDate = startDate!.monthAgo()
        case 2:
            print("Aktualna data - 90 dni")
            fromDate = startDate!.ninetyDaysAgo()
        default:
            print("Segmented Controll Error")
        }
        downloadData(table: table, code: code, fromDate: fromDate!.toString(), startDate: startDate!.toString())
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var differenceInPriceLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
}
    
 





