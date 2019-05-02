//
//  TestImageMenuVC.swift
//  CompareImageLib
//
//  Created by Kaibo Lu on 4/16/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

class TestImageMenuVC: UIViewController {

    private var list: [(String, NoParamterBlock)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Image"
        
        let testBB = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(TestImageVC(type: .BBMetalImage), animated: true) }
        }
        let testGPU = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(TestImageVC(type: .GPUImage), animated: true) }
        }
        list = [("BBMetalImage", testBB),
                ("GPUImage", testGPU)]
        
        let tableView = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

extension TestImageMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.textLabel?.text = list[indexPath.row].0
        return cell
    }
}

extension TestImageMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        list[indexPath.row].1()
    }
}
