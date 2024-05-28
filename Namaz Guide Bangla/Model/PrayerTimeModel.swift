//
//  PrayerTimeModel.swift
//  Namaz Guide Bangla
//
//  Created by Talut mahamud Deep on 27/5/24.
//


// PrayerTimes.swift
import Foundation

struct PrayerTimesResponse: Codable {
    let data: PrayerTimesData
}

struct PrayerTimesData: Codable {
    let timings: Timings
    let date: DateInfo
}

struct Timings: Codable {
    let Fajr, Dhuhr, Asr, Maghrib, Isha: String
}

struct DateInfo: Codable {
    let hijri: HijriDate
}

struct HijriDate: Codable {
    let date: String
    let month: HijriMonth
    let year: String
}

struct HijriMonth: Codable {
    let en: String
    let ar: String
}
