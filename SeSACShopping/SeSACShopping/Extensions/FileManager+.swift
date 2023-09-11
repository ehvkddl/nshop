//
//  FileManager+.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/11.
//

import UIKit

extension UIViewController {
    
    func fileName(id: String) -> String {
        return "Wish_\(id).jpg"
    }
    
    func downloadImage(from url: String, returnCompletion: @escaping (UIImage) -> ()) {
        
        DispatchQueue.global().async {
            guard let url = URL(string: url) else { return }
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else { return }
                
                returnCompletion(image)
                
            } catch {
                print(error)
            }
        }
    }
    
    func loadImageFromDocument(fileName: String) -> UIImage {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(systemName: "cube.box")! }

        let fileURL = documentDirectory.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            guard let image = UIImage(contentsOfFile: fileURL.path) else { return UIImage(systemName: "cube.box")! }
            return image
        } else {
            return UIImage(systemName: "cube.box")!
        }
    }
    
    func saveImageToDocument(fileName: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileURL = documentDirectory.appendingPathComponent(fileName)

        guard let data = image.jpegData(compressionQuality: 0.5) else { return }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("사진 저장 실패!", error)
        }
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileURL = documentDirectory.appendingPathComponent(fileName)

        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("사진 삭제 실패!", error)
        }
    }
    
}
