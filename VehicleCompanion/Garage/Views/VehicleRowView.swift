//
//  VehicleRowView.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI

struct VehicleRowView: View {
    let vehicle: Vehicle
    
    var body: some View {
        HStack {
            if let data = vehicle.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "car")
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.gray)
            }
            
            VStack(alignment: .leading) {
                Text(vehicle.name)
                    .font(.headline)
                Text("\(vehicle.make) \(vehicle.model) \(vehicle.year)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(vehicle.name), \(vehicle.make) \(vehicle.model) \(vehicle.year)")
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.imageData = image.pngData()
            }
            
            parent.dismiss()
        }
    }
}
