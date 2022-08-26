//
//  BackupViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by 방선우 on 2022/08/24.
//

import UIKit
import Zip

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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.restoreButtonClicekd()
        }
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
    
    //백업
    @objc func backupButtonClicked() {
        
        var urlpath = [URL]()
        
        //도큐먼트트 위치에 백업 파일 확인
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let raalmFile = path.appendingPathComponent("default.realm") // 램파일이 어디에 위치했는지 알기위해, 사용자가 폴더를 임의로 만들 수 도 있으니까 이건 단순히 url이고 /Document뒤에 붙는 default.raelm임
        
        guard FileManager.default.fileExists(atPath: raalmFile.path) else {
            showAlertMessage(title: "백업할 파일이 없습니다")
            
            return
        }
        
        urlpath.append(URL(string: raalmFile.path)!)
        
        //백업 파일 압축 : URL
            //오픈소스 이용
        do {
            let zipFilePath = try Zip.quickZipFiles(urlpath, fileName: "SeSACDiary_1") // 확장자 없으면 저장이 안됨
            print("Archive Lcation: \(zipFilePath.lastPathComponent)")
            //ActicvityViewController
            showActicvityViewController()
        } catch {
            showAlertMessage(title: "🔴압축을 실패했습니다")
        }
    }
    
    //엑티비티 뷰컨띄우기 메서드
    func showActicvityViewController() {
        
        //도큐먼트트 위치에 백업 파일 확인
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let backupFileURL = path.appendingPathComponent("SeSACDiary_1.zip")
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        self.present(vc, animated: true)
        
    }
    
    //복구
    @objc func restoreButtonClicekd() {
        
        let doucumentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true) //archive로 하면 zip같은 복사파일만 선택가능
        doucumentPicker.delegate = self
        doucumentPicker.allowsMultipleSelection = false
        self.present(doucumentPicker, animated: true)
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

extension BackupViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("도큐머트픽커 닫음", #function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) { // 어떤 압축파일을 선택했는지 명세
        
        guard let selectedFileURL = urls.first else {
            showAlertMessage(title: "선택하진 파일을 찾을 수 없습니다.")
            return
        }
        
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        //sandboxFileURL 단지 경로
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent) //lastPathComponent: 경로의 마지막 구성요소 SeSACDiary_1.zip, 그니까 마지막 path를 가져오는 것 이것과 도큐먼트의 url의 path와 합쳐주는 것
        
        // 여기서 sandboxFileURL경로있는지 확인
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            let fileURL = path.appendingPathComponent("SeSACDiary_1.zip")
            
            do {
                //뭘 풀어줄거? -> 어디에? -> 덮어쓸거임? -> 비번있어? -> 얼마나 진행되고 있어? -> 완료되면 어케할거임?
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)") //로딩뷰로 띄워줄 수 잇음
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구완료~🟢")
                })
            } catch {
                showAlertMessage(title: "🔴 압축 해제 실패")
            }
            
        } else {
            
            do {
                //파일 앱의 zip -> 도큐먼트 폴더에 복사(at:원래경로, to: 복사하고자하는 경로) / sandboxFileURL -> 걍 경로
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("SeSACDiary_1.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)") //로딩뷰로 띄워줄 수 잇음
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구완료~🟢")
                })
                
            } catch {
                showAlertMessage(title: "🔴 압축 해제 실패")
            }
        }
    }
}
