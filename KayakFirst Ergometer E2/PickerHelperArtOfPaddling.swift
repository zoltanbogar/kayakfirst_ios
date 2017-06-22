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
    private static let artOfPaddlingRacingKayaking = "racing_kayaking"
    private static let artOfPaddlingRacingCanoeing = "racing_canoeing"
    private static let artOfPaddlingRecreationalKayaking = "recreational_kayaking"
    private static let artOfPaddlingRecreationalCanoeing = "recreational_canoeing"
    private static let artOfPaddlingSup = "sup"
    private static let artOfPaddlingDragon = "dragon"
    private static let artOfPaddlingRowing = "rowing"
    
    //MARK: init
    override init(pickerView: UIPickerView, textField: UITextField) {
        super.init(pickerView: pickerView, textField: textField)
    }
    
    //MARK: functions
    override func getOptions() -> [String] {
        return PickerHelperArtOfPaddling.artOfPaddlingOptions
    }
    
    override func getTitle(value: String) -> String {
        switch value {
        case PickerHelperArtOfPaddling.artOfPaddlingRacingKayaking:
            return getString("user_art_of_paddling_racing_kayaking")
        case PickerHelperArtOfPaddling.artOfPaddlingRacingCanoeing:
            return getString("user_art_of_paddling_racing_canoeing")
        case PickerHelperArtOfPaddling.artOfPaddlingRecreationalKayaking:
            return getString("user_art_of_paddling_recreational_kayaking")
        case PickerHelperArtOfPaddling.artOfPaddlingRecreationalCanoeing:
            return getString("user_art_of_paddling_recreational_canoeing")
        case PickerHelperArtOfPaddling.artOfPaddlingSup:
            return getString("user_art_of_paddling_sup")
        case PickerHelperArtOfPaddling.artOfPaddlingDragon:
            return getString("user_art_of_paddling_dragon")
        case PickerHelperArtOfPaddling.artOfPaddlingRowing:
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
                value = PickerHelperArtOfPaddling.artOfPaddlingRacingKayaking
            case getString("user_art_of_paddling_racing_canoeing"):
                value = PickerHelperArtOfPaddling.artOfPaddlingRacingCanoeing
            case getString("user_art_of_paddling_recreational_kayaking"):
                value = PickerHelperArtOfPaddling.artOfPaddlingRecreationalKayaking
            case getString("user_art_of_paddling_recreational_canoeing"):
                value = PickerHelperArtOfPaddling.artOfPaddlingRecreationalCanoeing
            case getString("user_art_of_paddling_sup"):
                value = PickerHelperArtOfPaddling.artOfPaddlingSup
            case getString("user_art_of_paddling_dragon"):
                value = PickerHelperArtOfPaddling.artOfPaddlingDragon
            case getString("user_art_of_paddling_rowing"):
                value = PickerHelperArtOfPaddling.artOfPaddlingRowing
            default:
                break
            }
        }
        return value
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedArtOfPaddling = getOptions()[row]
        
        textField.text = selectedArtOfPaddling
    }
    
}
