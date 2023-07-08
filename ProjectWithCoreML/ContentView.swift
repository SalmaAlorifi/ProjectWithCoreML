//
//  ContentView.swift
//  ProjectWithCoreML
//
//  Created by salma alorifi on 15/12/1444 AH.
//

import SwiftUI
import CoreML
import Vision

struct ContentView: View {
    
    let images = ["car","cat","cloud","orange","person","strawberry"]
    
    @State private var currentIndex: Int = 0
    @State private var classificationResult: String = ""
    
    let model: MobileNetV2 = {
        do {
            let config = MLModelConfiguration()
            return try MobileNetV2(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create MobileNetV2")
        }
    }()
    
    private func classifyImage() {
        guard let image = UIImage(named: images[currentIndex]),
              let ciImage = CIImage(image: image) else {
            return
        }
        
        let mlModel = try! VNCoreMLModel(for: model.model)
        let request = VNCoreMLRequest(model: mlModel) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                self.classificationResult = "Error classifying the image."
                return
            }
            
            self.classificationResult = "Classified as: \(topResult.identifier)"
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            print(error)
            classificationResult = "Error classifying the image."
        }
    }
    
    var body: some View {
        VStack {
            Text("Image Classifier")
                .padding()
                .font(.largeTitle)
            
            Image(images[currentIndex])
                .resizable()
                .aspectRatio(contentMode: .fit)
            
                .padding()
            
            Button("Next Image") {
                currentIndex = (currentIndex + 1) % images.count
            }
            .padding()
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(Color.blue)
            .cornerRadius(10)
            Button("Classify") {
                
                classifyImage()
                
            }
            .padding()
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(Color.green)
            .cornerRadius(10)
            
            Text(classificationResult)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
