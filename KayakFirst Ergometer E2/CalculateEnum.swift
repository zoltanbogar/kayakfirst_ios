//
//  CalculateEnum.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

enum CalculateEnum: String {
    case OMEGA_MIN = "omega_min"
    case OMEGA_MAX = "omega_max"
    case P = "performance"
    case F = "pull_force"
    case F_AV = "pull_force_av"
    case T_1 = "t_1"
    case T_2 = "t_2"
    case V = "speed"
    case V_AV = "speed_av"
    case S = "currant_distance"
    case S_SUM = "sum_distance"
    case DURATION = "duration"
    case STROKES = "strokes"
    case STROKES_AV = "strokes_av"
    case T_200 = "t_200"
    case T_500 = "t_500"
    case T_1000 = "t_1000"
    case T_200_AV = "t_200_av"
    case T_500_AV = "t_500_av"
    case T_1000_AV = "t_1000_av"
    
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
            return getString("calculate_t200")
        case CalculateEnum.T_500:
            return getString("calculate_t500")
        case CalculateEnum.T_1000:
            return getString("calculate_t1000")
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
    
    static func getTrainingListSumByLabel(diagramLabel: DiagramLabel, createTrainingList: CreateTrainingList) -> [[Training]] {
        switch diagramLabel.getLabel() {
        case CalculateEnum.T_200:
            return createTrainingList.t200List
        case CalculateEnum.T_500:
            return createTrainingList.t500List
        case CalculateEnum.T_1000:
            return createTrainingList.t1000List
        case CalculateEnum.STROKES:
            return createTrainingList.strokesList
        case CalculateEnum.F:
            return createTrainingList.fList
        case CalculateEnum.V:
            return createTrainingList.vList
        default:
            fatalError("There is no createTrainingList for this")
        }
    }
}
