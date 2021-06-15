//
//  DemoListViewController.swift
//  InfoChartDemo-iOS
//
//  Created by Heo on 2021/06/15.
//

import UIKit

private struct ItemDef {
    let title: String
    let subtitle: String
    let `class`: AnyClass
}

class DemoListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    private var itemDefs = [ItemDef(title: "RealTime Vital Chart",
                                    subtitle: "실시간 ECG 그래프",
                                    class: RealTimeVitalChartViewController.self)]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "InfoChart Demo"
        self.tableView.rowHeight = 70
    }

}

extension DemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDefs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let def = self.itemDefs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = def.title
        cell.detailTextLabel?.text = def.subtitle
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let def = self.itemDefs[indexPath.row]
        
        let vcClass = def.class as! UIViewController.Type
        let vc = vcClass.init()
        
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
