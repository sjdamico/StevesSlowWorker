//
//  ViewController.swift
//  StevesSlowWorker
//
//  Created by Steve D'Amico on 10/4/17.
//  Copyright © 2017 Steve D'Amico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var startButton: UIButton!
    @IBOutlet var resultsTextView: UITextView!
    @IBOutlet var spinner : UIActivityIndicatorView!
    
    func fetchSomethingFromServer() -> String {
        Thread.sleep(forTimeInterval: 1)
        return "Hi there!"
    }
    func processData(data: String)-> String {
        Thread.sleep(forTimeInterval: 2)
        return data.uppercased()
    }
    func calculateFirstResult(data: String) -> String {
        Thread.sleep(forTimeInterval: 3)
        return "Number of chars: \(data.characters.count)"
    }
    func calculateSecondResult(data: String) -> String {
        Thread.sleep(forTimeInterval: 4)
        return data.replacingOccurrences(of: "E", with: "e")
    }
    @IBAction func doWork(sender: AnyObject) {
        let startTime = Date()
        self.resultsTextView.text = ""
        startButton.isEnabled = false
        spinner.startAnimating()
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let fetchedData = self.fetchSomethingFromServer()
            let processedData = self.processData(data: fetchedData)
            var firstResult: String!
            var secondResult: String!
            let group = DispatchGroup()
            queue.async(group: group) {
                firstResult = self.calculateFirstResult(data: processedData)
            }
            queue.async(group: group) {
                secondResult = self.calculateSecondResult(data: processedData)
            }
            group.notify(queue: queue) {
                let resultsSummary = "First: [\(firstResult!)]\nSecond: [\(secondResult!)]"
                DispatchQueue.main.async {
                    self.resultsTextView.text = resultsSummary
                    self.startButton.isEnabled = true
                    self.spinner.stopAnimating()
                }
                let endTime = Date()
                print("Completed in \(endTime.timeIntervalSince(startTime)) seconds")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

