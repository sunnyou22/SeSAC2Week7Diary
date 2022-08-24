//
//  BackupViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by 방선우 on 2022/08/24.
//

import UIKit

enum CellTitle: Int, CaseIterable {
    case backup, restore
    
    var cellTitle: String {
        switch self {
        case .backup:
            return "  백업  "
        case .restore:
            return "  복구  "
        }
    }
}

class BackupViewController: BaseViewController {
    
    let tableSectionCount = 2
    
    lazy var tableview: UITableView = {
        let view = UITableView()
        view.rowHeight = 100
        view.delegate = self
        view.dataSource = self
        view.register(BackupTableViewCell.self, forCellReuseIdentifier: BackupTableViewCell.reuseIdentifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonClicked))
        let restoreButton = UIBarButtonItem(title: "복구", style: .plain, target: self, action: #selector(restoreButtonClicekd))
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 30
        
        navigationItem.rightBarButtonItems = [backupButton, spacer, restoreButton]
        view.addSubview(tableview)
    }
    
    override func setConstraints() {
        tableview.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    //MARK: - 버튼 액션
    
    @objc func backupButtonClicked() {
        
    }
    
    @objc func restoreButtonClicekd() {
        
    }
}
extension BackupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackupTableViewCell.reuseIdentifier, for: indexPath) as? BackupTableViewCell else { return UITableViewCell()}
        
        cell.titleLabel.text =  CellTitle.allCases[indexPath.row].cellTitle
        
        return cell
    }
}
