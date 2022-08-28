//
//  UserDiaryRepository.swift
//  SeSAC2DiaryRealm
//
//  Created by 방선우 on 2022/08/26.
//

import Foundation
import RealmSwift
import UIKit

// 레포지토리가 하나라고 해도. 어떤 메서드가 있는지 보기 편하게 프로토콜 만드는게 좋음
protocol UserDiaryRepositoryType {
    func fetch() -> Results<UserDiary_re>
    func fetchSort(_ sort: String) -> Results<UserDiary_re>
    func fetchFilter() -> Results<UserDiary_re>
    func fetchDate(date: Date) -> Results<UserDiary_re>
    func updateFavortie(item: UserDiary_re)
    func deleteRecord(item: UserDiary_re)
//    func addItem(item: UserDiary_re)
}

//램에 대한 코드 모으기
//함수 매개변수를 이후 만들어 재사용성 높이기
class UserDiaryRepository: UserDiaryRepositoryType {
    
    func fetchDate(date: Date) -> Results<UserDiary_re> {
        return localRealm.objects(UserDiary_re.self).filter("diaryDate >= %@ AND diaryDate < %@", date, Date(timeInterval: 86400, since: date)) //NSPredicate 애플이 만들어준 Filter
    }
    
//    func addItem(item: UserDiary_re) {
//        <#code#>
//    }
    
    
    let localRealm = try! Realm()
    
    func fetch() -> Results<UserDiary_re> {
        return localRealm.objects(UserDiary_re.self).sorted(byKeyPath: "diaryTitle", ascending: true)
    }
    
    func fetchSort(_ sort: String) -> Results<UserDiary_re> {
        return localRealm.objects(UserDiary_re.self).sorted(byKeyPath: sort, ascending: true)
    }
    
    func fetchFilter() -> Results<UserDiary_re> {
        return localRealm.objects(UserDiary_re.self).filter("diaryTitle CONTAINS[c] '일기'") // [c]를 쓰면 대소문자랑 상관없이 찾아줌
    }
    
    //어차피 tableView 메서드 안에서 쓰니까
    func updateFavortie(item: UserDiary_re) {
        try! localRealm.write({
            
            //                하나의 레코드에서 특정 컬럼 하나만 변경
            item.favorite = !item.favorite
            print("Realm Update Succeed, reloadRows 필요")
            
            //하나의 테이블에 특정 컬럼 전체 값을 변경
            //                self.tasks.setValue(true, forKey: "favorite")
            
            //하나의 레코드에서 여러 컬럼들이 변경
            //                                self.localRealm.create(UserDiary_re.self, value: ["objectId": self.tasks[indexPath.row].objectId, "diaryContent": "변경 테스트", "diaryTitle": "제목임"], update: .modified)
        })
    }
    
    func deleteRecord(item: UserDiary_re) {
        
        removeImageFromDocument(fileName: "\(item.objectId).jpg")
        
        try! localRealm.write {
            localRealm.delete(item)
            print(item)
        }
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
        let fileURL = documentDirectory.appendingPathComponent(fileName)

        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
}
