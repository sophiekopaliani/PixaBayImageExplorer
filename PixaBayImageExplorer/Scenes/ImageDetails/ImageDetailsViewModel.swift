//
//  ImageDetailsViewModel.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import Foundation

protocol ImageDetailsViewModel {
    var imageDetails: Image? { get }
    var tags: [String] { get }
    var details: [ImageDetailsModel] { get }
}

class ImageDetailsViewModelImpl: ImageDetailsViewModel  {
    var imageDetails: Image?
    var tags: [String] { imageDetails?.tags ?? [] }
    
    var details: [ImageDetailsModel] {
        guard let imageDetails else { return [] }
        
        return [
            ImageDetailsModel.init(name: "Author", description: imageDetails.user),
            ImageDetailsModel.init(name: "Views", description: "\(imageDetails.views)"),
            ImageDetailsModel.init(name: "Likes", description: "\(imageDetails.likes)"),
            ImageDetailsModel.init(name: "Comments", description: "\(imageDetails.comments)"),
            ImageDetailsModel.init(name: "Downloads", description: "\(imageDetails.downloads)")
        ]
    }
    
    init(imageDetails: Image) {
        self.imageDetails = imageDetails
    }
}
