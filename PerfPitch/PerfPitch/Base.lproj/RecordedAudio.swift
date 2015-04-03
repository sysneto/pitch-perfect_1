//
//  RecordedAudio.swift
//  PerfPitch
//
//  Created by Kadar Toth Istvan on 24/03/15.
//  Copyright (c) 2015 Kadar Toth Istvan. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}