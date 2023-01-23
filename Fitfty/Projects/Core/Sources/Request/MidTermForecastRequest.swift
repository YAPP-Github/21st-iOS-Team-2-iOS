//
//  MidTermForecastRequest.swift
//  Core
//
//  Created by Ari on 2023/01/21.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

struct MidTermForecastRequest: Codable {
    
    let numOfRows: Int
    let pageNo: Int
    let regId: String
    let tmFc: String
    
}

enum MiddleWeatherTemperatureZone: CaseIterable {
    case baengnyeongDo, seoul, gwacheon, gwangmyeong, ganghwa, gimpo, incheon, siheung
    case ansan, bucheon, uijeongbu, goyang, yangju, paju, dongducheon, yeoncheon, pocheon, gapyeong
    case copper, namyangju, yangpyeong, hanam, suwon, anyang, osan, mars, seongnam, pyeongtaek
    case uiwang, gunpo, anseong, yongin, icheon, gwangjuGyeonggiDo, yeoju, chungju, jincheon, voice
    case jecheon, danyang, cheongju, boeun, goesan, jeungpyeong, chupungnyeong, yeongdong, okcheon, seosan
    case taean, dangjin, hongseong, boryeong, seocheon, cheonan, asan, budget, daejeon, princess, gyeryong, sejong
    case grant, chengyang, geumsan, nonsan, cheorwon, hwacheon, inje, yanggu, chuncheon, hongcheon, column, hoengseong
    case yeongwol, jeongseon, pyeongchang, daegwallyeong, taebaek, sokcho, goseonGunGangwonDo, yangyang
    case gangneung, donghae, samcheok, ulleungdo, dokdo, jeonju, iksan, jeongeup, complete, longevity, muju
    case jinan, namwon, imsil, sunchang, gunsan, gimje, gochang, buan, hampyeong, glory, jindo
    case wando, haenam, gangjin, jangheung, yeosu, gwangyang, goheung, bosung, suncheonSi, gwangjuJeollaDo
    case great, naju, damyang, hwasun, gurye, gokseong, suncheon, heuksando, mokpo, yeongam, sinan
    case muan, seongsan, jeju, seongpanak, seogwipo, alpine, ieodo, chujado, uljin, yeongdeok
    case pohang, gyeongju, mungyeong, resident, yecheon, yeongju, beacon, yeongYang, andong, uiseong, cheongsong
    case gunwi, senior, seongju, daegu, yeongcheon, gyeongsan, qingdao, chilgok, ulsan, parasol, busan, changwon
    case gimhae, tongyeong, sichuan, geoje, goseongGunGyeongsangDo, namhae, hamyang, geochang, hapcheon, gimcheon, gumi
    case miryang, uiryeong, haman, changnyeong, jinju, sancheong, hadong, sariwon, singye, haeju, personality, jangyeon
    case sinuiju, sakju, guseong, jaseong, kanggye, heechun, pyongyang, jinnampo, anju
    case yangdeok, cheongjin, woonggi, seongjin, musan, hamheung, jangjin, bukcheong, hyesan
    case poongsan, wonsan, goseongJangjeon, pyeonggang
    
    var code: String {
        switch self {
        case .baengnyeongDo: return "11A00101"
        case .seoul: return "11B10101"
        case .gwacheon: return "11B10102"
        case .gwangmyeong: return "11B10103"
        case .ganghwa: return "11B20101"
        case .gimpo: return "11B20102"
        case .incheon: return "11B20201"
        case .siheung: return "11B20202"
        case .ansan: return "11B20203"
        case .bucheon: return "11B20204"
        case .uijeongbu: return "11B20301"
        case .goyang: return "11B20302"
        case .yangju: return "11B20304"
        case .paju: return "11B20305"
        case .dongducheon: return "11B20401"
        case .yeoncheon: return "11B20402"
        case .pocheon: return "11B20403"
        case .gapyeong: return "11B20404"
        case .copper: return "11B20501"
        case .namyangju: return "11B20502"
        case .yangpyeong: return "11B20503"
        case .hanam: return "11B20504"
        case .suwon: return "11B20601"
        case .anyang: return "11B20602"
        case .osan: return "11B20603"
        case .mars: return "11B20604"
        case .seongnam: return "11B20605"
        case .pyeongtaek: return "11B20606"
        case .uiwang: return "11B20609"
        case .gunpo: return "11B20610"
        case .anseong: return "11B20611"
        case .yongin: return "11B20612"
        case .icheon: return "11B20701"
        case .gwangjuGyeonggiDo: return "11B20702"
        case .yeoju: return "11B20703"
        case .chungju: return "11C10101"
        case .jincheon: return "11C10102"
        case .voice: return "11C10103"
        case .jecheon: return "11C10201"
        case .danyang: return "11C10202"
        case .cheongju: return "11C10301"
        case .boeun: return "11C10302"
        case .goesan: return "11C10303"
        case .jeungpyeong: return "11C10304"
        case .chupungnyeong: return "11C10401"
        case .yeongdong: return "11C10402"
        case .okcheon: return "11C10403"
        case .seosan: return "11C20101"
        case .taean: return "11C20102"
        case .dangjin: return "11C20103"
        case .hongseong: return "11C20104"
        case .boryeong: return "11C20201"
        case .seocheon: return "11C20202"
        case .cheonan: return "11C20301"
        case .asan: return "11C20302"
        case .budget: return "11C20303"
        case .daejeon: return "11C20401"
        case .princess: return "11C20402"
        case .gyeryong: return "11C20403"
        case .sejong: return "11C20404"
        case .grant: return "11C20501"
        case .chengyang: return "11C20502"
        case .geumsan: return "11C20601"
        case .nonsan: return "11C20602"
        case .cheorwon: return "11D10101"
        case .hwacheon: return "11D10102"
        case .inje: return "11D10201"
        case .yanggu: return "11D10202"
        case .chuncheon: return "11D10301"
        case .hongcheon: return "11D10302"
        case .column: return "11D10401"
        case .hoengseong: return "11D10402"
        case .yeongwol: return "11D10501"
        case .jeongseon: return "11D10502"
        case .pyeongchang: return "11D10503"
        case .daegwallyeong: return "11D20201"
        case .taebaek: return "11D20301"
        case .sokcho: return "11D20401"
        case .goseonGunGangwonDo: return "11D20402"
        case .yangyang: return "11D20403"
        case .gangneung: return "11D20501"
        case .donghae: return "11D20601"
        case .samcheok: return "11D20602"
        case .ulleungdo: return "1.10E+102"
        case .dokdo: return "1.10E+103"
        case .jeonju: return "11F10201"
        case .iksan: return "11F10202"
        case .jeongeup: return "11F10203"
        case .complete: return "11F10204"
        case .longevity: return "11F10301"
        case .muju: return "11F10302"
        case .jinan: return "11F10303"
        case .namwon: return "11F10401"
        case .imsil: return "11F10402"
        case .sunchang: return "11F10403"
        case .gunsan: return "21F10501"
        case .gimje: return "21F10502"
        case .gochang: return "21F10601"
        case .buan: return "21F10602"
        case .hampyeong: return "21F20101"
        case .glory: return "21F20102"
        case .jindo: return "21F20201"
        case .wando: return "11F20301"
        case .haenam: return "11F20302"
        case .gangjin: return "11F20303"
        case .jangheung: return "11F20304"
        case .yeosu: return "11F20401"
        case .gwangyang: return "11F20402"
        case .goheung: return "11F20403"
        case .bosung: return "11F20404"
        case .suncheonSi: return "11F20405"
        case .gwangjuJeollaDo: return "11F20501"
        case .great: return "11F20502"
        case .naju: return "11F20503"
        case .damyang: return "11F20504"
        case .hwasun: return "11F20505"
        case .gurye: return "11F20601"
        case .gokseong: return "11F20602"
        case .suncheon: return "11F20603"
        case .heuksando: return "11F20701"
        case .mokpo: return "21F20801"
        case .yeongam: return "21F20802"
        case .sinan: return "21F20803"
        case .muan: return "21F20804"
        case .seongsan: return "11G00101"
        case .jeju: return "11G00201"
        case .seongpanak: return "11G00302"
        case .seogwipo: return "11G00401"
        case .alpine: return "11G00501"
        case .ieodo: return "11G00601"
        case .chujado: return "11G00800"
        case .uljin: return "11H10101"
        case .yeongdeok: return "11H10102"
        case .pohang: return "11H10201"
        case .gyeongju: return "11H10202"
        case .mungyeong: return "11H10301"
        case .resident: return "11H10302"
        case .yecheon: return "11H10303"
        case .yeongju: return "11H10401"
        case .beacon: return "11H10402"
        case .yeongYang: return "11H10403"
        case .andong: return "11H10501"
        case .uiseong: return "11H10502"
        case .cheongsong: return "11H10503"
        case .gimcheon: return "11H10601"
        case .gumi: return "11H10602"
        case .gunwi: return "11H10603"
        case .senior: return "11H10604"
        case .seongju: return "11H10605"
        case .daegu: return "11H10701"
        case .yeongcheon: return "11H10702"
        case .gyeongsan: return "11H10703"
        case .qingdao: return "11H10704"
        case .chilgok: return "11H10705"
        case .ulsan: return "11H20101"
        case .parasol: return "11H20102"
        case .busan: return "11H20201"
        case .changwon: return "11H20301"
        case .gimhae: return "11H20304"
        case .tongyeong: return "11H20401"
        case .sichuan: return "11H20402"
        case .geoje: return "11H20403"
        case .goseongGunGyeongsangDo: return "11H20404"
        case .namhae: return "11H20405"
        case .hamyang: return "11H20501"
        case .geochang: return "11H20502"
        case .hapcheon: return "11H20503"
        case .miryang: return "11H20601"
        case .uiryeong: return "11H20602"
        case .haman: return "11H20603"
        case .changnyeong: return "11H20604"
        case .jinju: return "11H20701"
        case .sancheong: return "11H20703"
        case .hadong: return "11H20704"
        case .sariwon: return "11I10001"
        case .singye: return "11I10002"
        case .haeju: return "11I20001"
        case .personality: return "11I20002"
        case .jangyeon: return "11I20003"
        case .sinuiju: return "11J10001"
        case .sakju: return "11J10002"
        case .guseong: return "11J10003"
        case .jaseong: return "11J10004"
        case .kanggye: return "11J10005"
        case .heechun: return "11J10006"
        case .pyongyang: return "11J20001"
        case .jinnampo: return "11J20002"
        case .anju: return "11J20004"
        case .yangdeok: return "11J20005"
        case .cheongjin: return "11K10001"
        case .woonggi: return "11K10002"
        case .seongjin: return "11K10003"
        case .musan: return "11K10004"
        case .hamheung: return "11K20001"
        case .jangjin: return "11K20002"
        case .bukcheong: return "11K20003"
        case .hyesan: return "11K20004"
        case .poongsan: return "11K20005"
        case .wonsan: return "11L10001"
        case .goseongJangjeon: return "11L10002"
        case .pyeonggang: return "11L10003"
        }
    }
    
    var localized: String {
        switch self {
        case .baengnyeongDo: return "백령면"
        case .seoul: return "서울"
        case .gwacheon: return "과천"
        case .gwangmyeong: return "광명"
        case .ganghwa: return "강화군"
        case .gimpo: return "김포"
        case .incheon: return "인천"
        case .siheung: return "시흥"
        case .ansan: return "안산"
        case .bucheon: return "부천"
        case .uijeongbu: return "의정부"
        case .goyang: return "고양"
        case .yangju: return "양주"
        case .paju: return "파주"
        case .dongducheon: return "동두천"
        case .yeoncheon: return "연천"
        case .pocheon: return "포천"
        case .gapyeong: return "가평"
        case .copper: return "구리"
        case .namyangju: return "남양주"
        case .yangpyeong: return "양평"
        case .hanam: return "하남"
        case .suwon: return "수원"
        case .anyang: return "안양"
        case .osan: return "오산"
        case .mars: return "화성"
        case .seongnam: return "성남"
        case .pyeongtaek: return "평택"
        case .uiwang: return "의왕"
        case .gunpo: return "군포"
        case .anseong: return "안성"
        case .yongin: return "용인"
        case .icheon: return "이천"
        case .gwangjuGyeonggiDo: return "경기도 광주"
        case .yeoju: return "여주"
        case .chungju: return "충주"
        case .jincheon: return "진천"
        case .voice: return "음성"
        case .jecheon: return "제천"
        case .danyang: return "단양"
        case .cheongju: return "청주"
        case .boeun: return "보은"
        case .goesan: return "괴산"
        case .jeungpyeong: return "증평"
        case .chupungnyeong: return "추풍령"
        case .yeongdong: return "영동"
        case .okcheon: return "옥천"
        case .seosan: return "서산"
        case .taean: return "태안"
        case .dangjin: return "당진"
        case .hongseong: return "홍성"
        case .boryeong: return "보령"
        case .seocheon: return "서천"
        case .cheonan: return "천안"
        case .asan: return "아산"
        case .budget: return "예산"
        case .daejeon: return "대전"
        case .princess: return "공주"
        case .gyeryong: return "계룡"
        case .sejong: return "세종"
        case .grant: return "부여"
        case .chengyang: return "청양"
        case .geumsan: return "금산"
        case .nonsan: return "논산"
        case .cheorwon: return "철원"
        case .hwacheon: return "화천"
        case .inje: return "인제"
        case .yanggu: return "양구"
        case .chuncheon: return "춘천"
        case .hongcheon: return "홍천"
        case .column: return "원주"
        case .hoengseong: return "횡성"
        case .yeongwol: return "영월"
        case .jeongseon: return "정선"
        case .pyeongchang: return "평창"
        case .daegwallyeong: return "대관령"
        case .taebaek: return "태백"
        case .sokcho: return "속초"
        case .goseonGunGangwonDo: return "강원도 고성군"
        case .yangyang: return "양양"
        case .gangneung: return "강릉"
        case .donghae: return "동해"
        case .samcheok: return "삼척"
        case .ulleungdo: return "울릉도"
        case .dokdo: return "독도"
        case .jeonju: return "전주"
        case .iksan: return "익산"
        case .jeongeup: return "정읍"
        case .complete: return "완주"
        case .longevity: return "장수"
        case .muju: return "무주"
        case .jinan: return "진안"
        case .namwon: return "남원"
        case .imsil: return "임실"
        case .sunchang: return "순창"
        case .gunsan: return "군산"
        case .gimje: return "김제"
        case .gochang: return "고창"
        case .buan: return "부안"
        case .hampyeong: return "함평"
        case .glory: return "영광"
        case .jindo: return "진도"
        case .wando: return "완도"
        case .haenam: return "해남"
        case .gangjin: return "강진"
        case .jangheung: return "장흥"
        case .yeosu: return "여수"
        case .gwangyang: return "광양"
        case .goheung: return "고흥"
        case .bosung: return "보성"
        case .suncheonSi: return "순천시"
        case .gwangjuJeollaDo: return "광주"
        case .great: return "장성"
        case .naju: return "나주"
        case .damyang: return "담양"
        case .hwasun: return "화순"
        case .gurye: return "구례"
        case .gokseong: return "곡성"
        case .suncheon: return "순천"
        case .heuksando: return "흑산도"
        case .mokpo: return "목포"
        case .yeongam: return "영암"
        case .sinan: return "신안"
        case .muan: return "무안"
        case .seongsan: return "성산"
        case .jeju: return "제주"
        case .seongpanak: return "성판악"
        case .seogwipo: return "서귀포"
        case .alpine: return "고산"
        case .ieodo: return "이어도"
        case .chujado: return "추자도"
        case .uljin: return "울진"
        case .yeongdeok: return "영덕"
        case .pohang: return "포항"
        case .gyeongju: return "경주"
        case .mungyeong: return "문경"
        case .resident: return "상주"
        case .yecheon: return "예천"
        case .yeongju: return "영주"
        case .beacon: return "봉화"
        case .yeongYang: return "영양"
        case .andong: return "안동"
        case .uiseong: return "의성"
        case .cheongsong: return "청송"
        case .gimcheon: return "김천"
        case .gumi: return "구미"
        case .gunwi: return "군위"
        case .senior: return "고령"
        case .seongju: return "성주"
        case .daegu: return "대구"
        case .yeongcheon: return "영천"
        case .gyeongsan: return "경산"
        case .qingdao: return "청도"
        case .chilgok: return "칠곡"
        case .ulsan: return "울산"
        case .parasol: return "양산"
        case .busan: return "부산"
        case .changwon: return "창원"
        case .gimhae: return "김해"
        case .tongyeong: return "통영"
        case .sichuan: return "사천"
        case .geoje: return "거제"
        case .goseongGunGyeongsangDo: return "경상도 고성군"
        case .namhae: return "남해"
        case .hamyang: return "함양"
        case .geochang: return "거창"
        case .hapcheon: return "합천"
        case .miryang: return "밀양"
        case .uiryeong: return "의령"
        case .haman: return "함안"
        case .changnyeong: return "창녕"
        case .jinju: return "진주"
        case .sancheong: return "산청"
        case .hadong: return "하동"
        case .sariwon: return "사리원"
        case .singye: return "신계"
        case .haeju: return "해주"
        case .personality: return "개성"
        case .jangyeon: return "장연(용연)"
        case .sinuiju: return "신의주"
        case .sakju: return "삭주(수풍)"
        case .guseong: return "구성"
        case .jaseong: return "자성(중강)"
        case .kanggye: return "강계"
        case .heechun: return "희천"
        case .pyongyang: return "평양"
        case .jinnampo: return "진남포(남포)"
        case .anju: return "안주"
        case .yangdeok: return "양덕"
        case .cheongjin: return "청진"
        case .woonggi: return "웅기(선봉)"
        case .seongjin: return "성진(김책)"
        case .musan: return "무산(삼지연)"
        case .hamheung: return "함흥"
        case .jangjin: return "장진"
        case .bukcheong: return "북청(신포)"
        case .hyesan: return "혜산"
        case .poongsan: return "풍산"
        case .wonsan: return "원산"
        case .goseongJangjeon: return "고성(장전)"
        case .pyeonggang: return "평강"
        }
    }
}

enum MidTermLandForecastZone: CaseIterable {
    case metropolitanArea
    case yeongseoGangwonDo
    case yeongdongGangwonDo
    case daejeonSejongChungcheongnamDo
    case chungcheongbukDo
    case gwangjuJeollanamDo
    case jeollabukDo
    case daeguGyeongsangbukDo
    case busanUlsanGyeongsangnamDo
    case jeju
    
    var code: String {
        switch self {
        case .metropolitanArea: return "11B00000"
        case .yeongseoGangwonDo: return "11D10000"
        case .yeongdongGangwonDo: return "11D20000"
        case .daejeonSejongChungcheongnamDo: return "11C20000"
        case .chungcheongbukDo: return "11C10000"
        case .gwangjuJeollanamDo: return "11F20000"
        case .jeollabukDo: return "11F10000"
        case .daeguGyeongsangbukDo: return "11H10000"
        case .busanUlsanGyeongsangnamDo: return "11H20000"
        case .jeju: return "11G00000"
        }
    }
    
    var localized: [String] {
        switch self {
        case .metropolitanArea: return ["서울", "인천", "경기도"]
        case .yeongseoGangwonDo: return ["강원도", "영서"]
        case .yeongdongGangwonDo: return ["강원도", "영동"]
        case .daejeonSejongChungcheongnamDo: return ["대전", "세종", "충청남도"]
        case .chungcheongbukDo: return ["충청북도"]
        case .gwangjuJeollanamDo: return ["광주", "전라남도"]
        case .jeollabukDo: return ["전라북도"]
        case .daeguGyeongsangbukDo: return ["대구", "경상북도"]
        case .busanUlsanGyeongsangnamDo: return ["부산", "울산", "경상남도"]
        case .jeju: return ["제주"]
        }
    }
}
