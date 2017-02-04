//
//  Movie.swift
//  DannyWeiner-Lab4
//
//  Created by Danny Weiner on 10/4/16.
//  Copyright © 2016 cse438s. All rights reserved.
//

import Foundation
import UIKit

struct Movie {
    var title: String
    var poster: UIImage
    var plot: String
    var year: Int
    var id: String
    //var score: Int
    //var rating: String
    
    init(title: String, poster: UIImage, plot: String, year: Int, id: String) {
        self.title = title
        self.poster = poster
        self.plot = plot
        self.year = year
        self.id = id
//        self.score = score
//        self.rating = rating
    }
}