//
//  PickerHelperArtOfPaddling.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 22..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PickerHelperArtOfPaddling: PickerHelper {
    
    //MARK: constants
    private static let artOfPaddlingOptions = [getString("user_art_of_paddling_racing_kayaking"), getString("user_art_of_paddling_racing_canoeing"), getString("user_art_of_paddling_recreational_kayaking"), getString("user_art_of_paddling_recreational_canoeing"), getString("user_art_of_paddling_sup"), getString("user_art_of_paddling_dragon"), getString("user_art_of_paddling_rowing")]
    
    //MARK: functions
    override func getOptions() -> [String] {
        return PickerHelperArtOfPaddling.artOfPaddlingOptions
    }
    
    override func getTitle(value: String) -> String {
        switch value {
        case ArtOfPaddle.racingKayaking.rawValue:
            return getString("user_art_of_paddling_racing_kayaking")
        case ArtOfPaddle.racingCanoeing.rawValue:
            return getString("user_art_of_paddling_racing_canoeing")
        case ArtOfPaddle.recreationalKayaking.rawValue:
            return getString("user_art_of_paddling_recreational_kayaking")
        case ArtOfPaddle.recreationalCanoeing.rawValue:
            return getString("user_art_of_paddling_recreational_canoeing")
        case ArtOfPaddle.sup.rawValue:
            return getString("user_art_of_paddling_sup")
        case ArtOfPaddle.dragon.rawValue:
            return getString("user_art_of_paddling_dragon")
        case ArtOfPaddle.rowing.rawValue:
            return getString("user_art_of_paddling_rowing")
        default:
            break
        }
        return ""
    }
    
    override func getValue() -> String? {
        var value: String?
        if (textField.text != nil) {
            switch textField.text! {
            case getString("user_art_of_paddling_racing_kayaking"):
                value = ArtOfPaddle.racingKayaking.rawValue
            case getString("user_art_of_paddling_racing_canoeing"):
                value = ArtOfPaddle.racingCanoeing.rawValue
            case getString("user_art_of_paddling_recreational_kayaking"):
                value = ArtOfPaddle.recreationalKayaking.rawValue
            case getString("user_art_of_paddling_recreational_canoeing"):
                value = ArtOfPaddle.recreationalCanoeing.rawValue
            case getString("user_art_of_paddling_sup"):
                value = ArtOfPaddle.sup.rawValue
            case getString("user_art_of_paddling_dragon"):
                value = ArtOfPaddle.dragon.rawValue
            case getString("user_art_of_paddling_rowing"):
                value = ArtOfPaddle.rowing.rawValue
            default:
                break
            }
        }
        return value
    }
}
