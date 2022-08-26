//
//  FileManager+Extension.swift
//  SeSAC2DiaryRealm
//
//  Created by 방선우 on 2022/08/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    func documentDirectoryPath() -> URL? {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
        
        return documentDirectory
    }
    
    //도큐먼트에 잇는 이미지 가져오기
    //이미지가 없을 수도 있으니 옵셔널
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 이걸로 도큐먼트에 저장해줌 세부파일 경로(이미지 저장위치)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "xmark")
        }
        
        let image = UIImage(contentsOfFile: fileURL.path)
        return image
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
    
    func saveImageToDocument(fileName: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 이걸로 도큐먼트에 저장해줌 세부파일 경로(이미지 저장위치)
        guard let data = image.jpegData(compressionQuality: 0.5) else { return } //용량을 줄이기 위함 용량을 키우는 건 못하고 작아질수밖에 없음
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error🔴", error)
        }
    }
    
    func fetchDocumentZipFile() {
        
        do {
            guard let path = documentDirectoryPath() else { return } //도큐먼트 경로 가져옴
            
//            let docs = try FileManager.default.contentsOfDirectory(atPath: <#T##String#>) 내부에서 알 수 있는 경로의 제약이 좀더 있음, 그래서 Url로 받아오는 아래걸 많이 씀
            let docs =  try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            print("👉 docs: \(docs)")
            
            let zip = docs.filter { $0.pathExtension == "zip" } //확장자가 모얀
            print("👉 zip: \(zip)")
            
            let result = zip.map { $0.lastPathComponent } //경로 다 보여줄 필요 없으니까 마지막 확장자를 string으로 가져오는 것
            print("👉 result: \(result)") // 오 이렇게 하면 폴더로 만들어서 관리하기도 쉬울듯
            
            
        } catch {
            print("Error🔴")
        }
    }
}
