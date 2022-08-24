//
//  HomeViewController.swift
//  SeSAC2DiaryRealm
//
//  Created by jack on 2022/08/22.
//

import UIKit
import SnapKit
import RealmSwift //Realm 1. import

class HomeViewController: BaseViewController {
    
    let localRealm = try! Realm() // Realm 2.
    
    lazy var tableView: UITableView = { //초기화 이후에 실행될 수 있다는 lazy 이렇게 옮기는게 답은 아님
        let view = UITableView()
        view.rowHeight = 60
        view.delegate = self
        view.dataSource = self
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    var tasks: Results<UserDiary_re>! {
        didSet {
            tableView.reloadData() // 테이블이 바뀌면 갱신을 해라 -> 여러군데에서 할 필요가 사라짐
        print("Tasks Changed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
        //화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요!
        //present, overCurrentContext, overFullScreen > viewWillAppear X
//        tableView.reloadData()
        
        //Realm 3. Realm 데이터를 정렬해 tasks 에 담기
        fetchRealm()
//
//        tableView.reloadData()
    }
    
    func fetchRealm() {
        tasks = localRealm.objects(UserDiary_re.self).sorted(byKeyPath: "diaryTitle", ascending: true)
    }
    
    override func configure() {
        view.addSubview(tableView)
        
        let plus = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        let backUp = UIBarButtonItem(image: UIImage(systemName: "archivebox.fill"), style: .plain, target: self, action: #selector(goBackUpPage))
       let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonClicked))
        let sortedButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        navigationItem.leftBarButtonItems = [filterButton, sortedButton]
        navigationItem.rightBarButtonItems = [plus, backUp]
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
   //MARK: - 버튼
   
    @objc func goBackUpPage() {
        let vc = BackupViewController()
        transition(vc, transitionStyle: .push)
    }
    
    @objc func plusButtonClicked() {
        let vc = WriteViewController()
        vc.transitionFetchfunction = fetchRealm
        transition(vc, transitionStyle: .presentNavigation)
    }
    
//realm filter query, NSPredicate
@objc func sortButtonClicked() {
   tasks = localRealm.objects(UserDiary_re.self).sorted(byKeyPath: "regdate", ascending: true)
}
    // ==이 아니라 몽고의 조건문 규칙을 써줘야함
    // 띄어쓰기하면 ''로 묶어줘야 찾을 수 있음
    @objc func filterButtonClicked() {
//        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle = '오늘의 일기171'")
        tasks = localRealm.objects(UserDiary_re.self).sorted(byKeyPath: "diaryTitle CONTAINS[c] '일기'") // [c]를 쓰면 대소문자랑 상관없이 찾아줌
    }
}

//MARK: - 테이블뷰 extension
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tasks.count)
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HomeTableViewCell else { return UITableViewCell() }
        if indexPath.row >= 0 {
        //이미지 화면에 반영하기
        cell.diaryImageView.image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
        cell.setData(data: tasks[indexPath.row])
        return cell
        } else {
            print("셀이 없어")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = tasks?[indexPath.row]
            try! localRealm.write({
                localRealm.delete(item!)
                removeImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
            })
        }
        fetchRealm()
    }
    
    //뷰안에 버튼이 들어가는 식이라고 했나?
    //칸이 좁으면 버튼의 타이틀이 짤리기도 함
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print("favorite ButtonClicked")

            //real data update
            try! self.localRealm.write({

                //하나의 레코드에서 특정 컬럼 하나만 변경
//                self.tasks[indexPath.row].favorite = !self.tasks[indexPath.row].favorite

                //하나의 테이블에 특정 컬럼 전체 값을 변경
//                self.tasks.setValue(true, forKey: "favorite")

                //하나의 레코드에서 여러 컬럼들이 변경
//                self.localRealm.create(UserDiary_re.self, value: ["objectId": self.tasks[indexPath.row].objectId, "diaryContent": "변경 테스트", "diaryTitle": "제목임"], update: .modified)


                print("Realm Update Succeed, reloadRows 필요")
            })

            // 1.스와이프한 셀 하나만 reloadRows 코드 구현 -> 상대적으로 효율적
            //2, 데이터가 변경됐으니 다시 Realm에서 데이터 가져오기 => didset 일관적 형태로 갱신
            self.fetchRealm()
        }

        let example = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
            print("example ButtonClicked")
        }

        let image = tasks[indexPath.row].favorite ? "star.fill" : "star"

        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [favorite, example])
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let favorite = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
//            print("favorite ButtonClicked")
//        }
//
//        let example = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, completionHandler in
//            print("favorite ButtonClicked")
//        }
//
//        return UISwipeActionsConfiguration(actions: [favorite, example])
//
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = WriteViewController()
//        
//        present(vc, animated: true)
//        
//    }
}
