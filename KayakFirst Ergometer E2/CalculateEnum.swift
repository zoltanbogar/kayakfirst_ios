//
//  CalculateEnum.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

enum CalculateEnum: String {
    
    //MARK: current values
    case F = "pull_force"
    case V = "speed"
    case S_SUM = "sum_distance"
    case STROKES = "strokes"
    case T_200 = "t_200"
    case T_500 = "t_500"
    case T_1000 = "t_1000"
    
    //MARK: avarege values
    case F_AV = "pull_force_av"
    case V_AV = "speed_av"
     case STROKES_AV = "strokes_av"
    case T_200_AV = "t_200_av"
    case T_500_AV = "t_500_av"
    case T_1000_AV = "t_1000_av"
    
    //MARK: helper values
    case DURATION = "duration"
    case OMEGA_MIN = "omega_min"
    case OMEGA_MAX = "omega_max"
    case S = "currant_distance"
    case P = "performance"
    case T_1 = "t_1"
    case T_2 = "t_2"
    
    static let savingTypes: [CalculateEnum] = [CalculateEnum.T_200, CalculateEnum.T_500, CalculateEnum.T_1000, CalculateEnum.STROKES, CalculateEnum.F, CalculateEnum.S, CalculateEnum.V]
    
    static func getColor(calculate: CalculateEnum) -> UIColor {
        switch calculate {
        case CalculateEnum.T_200:
            return Colors.colorT
        case CalculateEnum.T_500:
            return Colors.colorT
        case CalculateEnum.T_1000:
            return Colors.colorT
        case CalculateEnum.STROKES:
            return Colors.colorStrokes
        case CalculateEnum.F:
            return Colors.colorF
        case CalculateEnum.V:
            return Colors.colorV
        default:
            return UIColor.clear
        }
    }
    
    static func getTitle(calculate: CalculateEnum) -> String {
        switch calculate {
        case CalculateEnum.T_200:
            return UnitHelper.getCalculatePaceTitle(pace: Pace.pace200)
        case CalculateEnum.T_500:
            return UnitHelper.getCalculatePaceTitle(pace: Pace.pace500)
        case CalculateEnum.T_1000:
            return UnitHelper.getCalculatePaceTitle(pace: Pace.pace1000)
        case CalculateEnum.STROKES:
            return getString("calculate_strokes")
        case CalculateEnum.F:
            return getString("calculate_f")
        case CalculateEnum.V:
            return getString("calculate_v")
        default:
            fatalError("There is no title for this")
        }
    }
}
