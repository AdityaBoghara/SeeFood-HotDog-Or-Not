//
//  ViewController.swift
//  SeeFood
//
//  Created by Aditya Boghara on 1/5/24.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            
            guard let ciimage = CIImage(image: image) else{
                fatalError("Could not convert to ci image")
            }
            
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("can't load ML model")
        }
        
        
        let request = VNCoreMLRequest(model: model) { request, error in
            
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first
            else {
                fatalError("unexpected result type from VNCoreMLRequest")
            }
            
            if topResult.identifier.contains("hotdog") {
                            DispatchQueue.main.async {
                                self.navigationItem.title = "Hotdog!"
                                self.navigationController?.navigationBar.backgroundColor = UIColor.green
                                self.navigationController?.navigationBar.isTranslucent = false
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.navigationItem.title = "Not Hotdog!"
                                self.navigationController?.navigationBar.backgroundColor = UIColor.red
                                self.navigationController?.navigationBar.isTranslucent = false
                            }
                        }
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
        
        
        
        
        
    }
}
