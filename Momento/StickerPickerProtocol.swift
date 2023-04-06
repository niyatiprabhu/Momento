//
//  StickerPickerProtocol.swift
//  Momento
//
//  Created by Shadin Hussein on 3/24/23.
//

import Foundation

protocol StickerPickerDelegate : AnyObject {
    func didPick(_ sticker: String)
}
