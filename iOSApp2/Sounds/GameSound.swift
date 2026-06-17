//
//  GameSound.swift
//  iOSApp2
//
//  Created by stephanie otteson on 2026-06-15.
//

import Foundation

enum GameSound {
    case tap
    case close
    case cameraShutter
    case cameraFlash
    case itemCollect
    case paperNote
    case doorLocked
    case doorUnlock
    case iceCrack
    case icicleCrash
    case blackoutRumble
    case lairWakeup
    case curatorSuccess
    case curatorWrong
    case click
    case locationTravel
    case nuggetReveal
    
    var fileName: String {
        switch self {
        case .tap:
            return "tap.wav"
        case .close:
            return "close.wav"
        case .click:
            return "click.wav"
        case .cameraShutter:
            return "camera_shutter.wav"
        case .cameraFlash:
            return "camera_flash.wav"
        case .itemCollect:
            return "item_collect.wav"
        case .paperNote:
            return "paper_note.wav"
        case .doorLocked:
            return "door_locked.wav"
        case .doorUnlock:
            return "door_unlock.wav"
        case .iceCrack:
            return "ice_crack.wav"
        case .icicleCrash:
            return "icicle_crash.wav"
        case .blackoutRumble:
            return "blackout_rumble.wav"
        case .lairWakeup:
            return "lair_wakeup.wav"
        case .locationTravel:
            return "return.wav"
        case .nuggetReveal:
            return "nugget_reveal.wav"
        case .curatorSuccess:
            return "curator_success.wav"
        case .curatorWrong:
            return "curator_wrong.wav"
        }
    }
}
