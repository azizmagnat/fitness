import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class MockData {
  static const stories = [
    StoryItem(name: "Qo'shish", imageUrl: "", isAdd: true),
    StoryItem(name: "1Fit", imageUrl: "", viewed: false),
    StoryItem(name: "afandi", imageUrl: "", viewed: true),
    StoryItem(name: "ash1228", imageUrl: "", viewed: false),
    StoryItem(name: "dilnoza", imageUrl: "", viewed: true),
    StoryItem(name: "botir_k", imageUrl: "", viewed: false),
  ];

  static const quickActions = [
    QuickAction("1Fit Pro"),
    QuickAction("Aksiyalar", hasBadge: true),
    QuickAction("Yutuqli o'yinlar", hasBadge: true),
    QuickAction("Bonuslar"),
    QuickAction("Do'kon"),
    QuickAction("Mehmon abonementi"),
    QuickAction("Bildirishnomalar"),
    QuickAction("Hamjamiyat"),
  ];

  static const gamePrizes = [
    GamePrize(
      title: "Katta yozgi sovrinli o'yin: avtomobil 🔥",
      subtitle: "BYD Yuan Up avtomobili",
      daysLeft: "32 kun qoldi",
      icon: Icons.directions_car_filled_rounded,
    ),
    GamePrize(
      title: "Katta yozgi sovrinli o'yin: iPhone",
      subtitle: "2 ta iPhone 17 Pro Max smartfoni",
      daysLeft: "24 kun qoldi",
      icon: Icons.phone_iphone_rounded,
    ),
    GamePrize(
      title: "Katta yozgi sovrinli o'yin: 1Fit abonementlari",
      subtitle: "2 ta 12 oylik 1Fit abonementi",
      daysLeft: "10 kun qoldi",
      icon: Icons.fitness_center_rounded,
    ),
  ];

  static const _levelGymSessions = [
    WorkoutSession(
      title: "Trenajyor zalida mustaqil mashg'ulotlar",
      durationMin: 120,
      slots: [
        TimeSlot("07:00", 19),
        TimeSlot("08:00", 20),
        TimeSlot("09:00", 20),
        TimeSlot("10:00", 20),
        TimeSlot("11:00", 20),
        TimeSlot("12:00", 20),
        TimeSlot("13:00", 20),
        TimeSlot("14:00", 20),
        TimeSlot("15:00", 20),
        TimeSlot("16:00", 20),
        TimeSlot("17:00", 20),
        TimeSlot("18:00", 20),
        TimeSlot("19:00", 20),
        TimeSlot("20:00", 20),
        TimeSlot("21:00", 19),
      ],
    ),
    WorkoutSession(
      title: "Trenajyor zalida mustaqil mashg'ulotlar",
      durationMin: 120,
      restriction: "Faqat ayollar uchun",
      slots: [
        TimeSlot("07:00", 20),
        TimeSlot("09:00", 20),
        TimeSlot("10:00", 9),
        TimeSlot("11:00", 10),
        TimeSlot("12:00", 20),
        TimeSlot("13:00", 20),
        TimeSlot("14:00", 20),
        TimeSlot("15:00", 20),
        TimeSlot("16:00", 20),
        TimeSlot("17:00", 20),
        TimeSlot("19:00", 20),
        TimeSlot("20:00", 19),
        TimeSlot("21:00", 20),
        TimeSlot("21:55", 20),
      ],
    ),
    WorkoutSession(
      title: "Trenajyor zalida mustaqil mashg'ulotlar",
      durationMin: 180,
      restriction: "Faqat ayollar uchun",
      slots: [
        TimeSlot("08:00", 20),
      ],
    ),
    WorkoutSession(
      title: "O'zbek milliy raqslari",
      durationMin: 60,
      restriction: "Faqat ayollar uchun",
      slots: [
        TimeSlot("10:30", 19),
      ],
    ),
  ];

  static const _gulkamResortSessions = [
    WorkoutSession(
      title: "Erkin suzish",
      durationMin: 120,
      slots: [
        TimeSlot("00:00 - 02:00", 0, ended: true),
        TimeSlot("02:00 - 04:00", 0, ended: true),
        TimeSlot("04:00 - 06:00", 0, ended: true),
        TimeSlot("06:00 - 08:00", 0, ended: true),
        TimeSlot("08:00 - 10:00", 0, ended: true),
        TimeSlot("10:00 - 12:00", 0, ended: true),
        TimeSlot("12:00 - 14:00", 18),
        TimeSlot("14:00 - 16:00", 20),
        TimeSlot("16:00 - 18:00", 20),
        TimeSlot("18:00 - 20:00", 20),
        TimeSlot("20:00 - 22:00", 20),
        TimeSlot("22:00 - 00:00", 10),
      ],
    ),
  ];

  static const _crocusFitnessSessions = [
    WorkoutSession(
      title: "Trenajyor zalida mustaqil mashg'ulotlar",
      durationMin: 120,
      slots: [
        TimeSlot("00:00", 0, ended: true),
        TimeSlot("01:00", 0, ended: true),
        TimeSlot("02:00", 0, ended: true),
        TimeSlot("03:00", 0, ended: true),
        TimeSlot("04:00", 0, ended: true),
        TimeSlot("05:00", 0, ended: true),
        TimeSlot("06:00", 0, ended: true),
        TimeSlot("07:00", 0, ended: true),
        TimeSlot("08:00", 0, ended: true),
        TimeSlot("09:00", 0, ended: true),
        TimeSlot("10:00", 0, ended: true),
        TimeSlot("11:00", 0, ended: true),
        TimeSlot("12:00", 9),
        TimeSlot("13:00", 18),
        TimeSlot("14:00", 15),
        TimeSlot("15:00", 20),
        TimeSlot("16:00", 43),
        TimeSlot("17:00", 45),
        TimeSlot("18:00", 55),
        TimeSlot("19:00", 43),
        TimeSlot("20:00", 45),
        TimeSlot("21:00", 52),
        TimeSlot("22:00", 55),
        TimeSlot("23:00", 55),
      ],
    ),
  ];

  static const _novaXSessions = [
    WorkoutSession(
      title: "Trenajyor zalida mustaqil mashg'ulotlar",
      durationMin: 120,
      slots: [
        TimeSlot("00:00", 25),
        TimeSlot("01:00", 30),
        TimeSlot("02:00", 30),
        TimeSlot("03:00", 30),
        TimeSlot("04:00", 30),
        TimeSlot("05:00", 30),
        TimeSlot("06:00", 29),
        TimeSlot("07:00", 29),
        TimeSlot("08:00", 30),
        TimeSlot("09:00", 28),
        TimeSlot("10:00", 30),
        TimeSlot("11:00", 30),
        TimeSlot("12:00", 30),
        TimeSlot("13:00", 30),
        TimeSlot("14:00", 30),
        TimeSlot("15:00", 30),
        TimeSlot("16:00", 30),
        TimeSlot("17:00", 30),
        TimeSlot("18:00", 20),
        TimeSlot("19:00", 19),
        TimeSlot("20:00", 19),
        TimeSlot("21:00", 28),
        TimeSlot("22:00", 30),
        TimeSlot("23:00", 30),
      ],
    ),
  ];

  static const _nizamoffGymSessions = [
    WorkoutSession(
      title: "Trenajyor zalida mustaqil mashg'ulotlar",
      durationMin: 120,
      slots: [
        TimeSlot("09:00 - 11:00", 15),
        TimeSlot("10:00 - 12:00", 15),
        TimeSlot("11:00 - 13:00", 15),
        TimeSlot("12:00 - 14:00", 15),
        TimeSlot("13:00 - 15:00", 15),
        TimeSlot("14:00 - 16:00", 15),
        TimeSlot("15:00 - 17:00", 15),
        TimeSlot("16:00 - 18:00", 15),
        TimeSlot("17:00 - 19:00", 15),
        TimeSlot("18:00 - 20:00", 15),
        TimeSlot("19:00 - 21:00", 15),
        TimeSlot("20:00 - 22:00", 15),
        TimeSlot("21:00 - 23:00", 15),
        TimeSlot("22:00 - 00:00", 15),
      ],
    ),
  ];

  static const _weGymSessions = [
    WorkoutSession(
      title: "Trenajyor zalida mustaqil mashg'ulotlar",
      durationMin: 120,
      slots: [
        TimeSlot("10:00 - 12:00", 10),
        TimeSlot("11:00 - 13:00", 10),
        TimeSlot("12:00 - 14:00", 10),
        TimeSlot("13:00 - 15:00", 10),
        TimeSlot("14:00 - 16:00", 10),
        TimeSlot("15:00 - 17:00", 10),
        TimeSlot("16:00 - 18:00", 10),
        TimeSlot("17:00 - 19:00", 10),
        TimeSlot("18:00 - 20:00", 10),
        TimeSlot("19:00 - 21:00", 10),
        TimeSlot("20:00 - 22:00", 10),
      ],
    ),
  ];

  static const _spaceFitnessSessions = [
    WorkoutSession(
      title: "Trenajyor zalida mustaqil mashg'ulotlar",
      durationMin: 120,
      slots: [
        TimeSlot("08:00 - 10:00", 39),
        TimeSlot("10:00 - 12:00", 40),
        TimeSlot("12:00 - 14:00", 39),
        TimeSlot("14:00 - 16:00", 40),
        TimeSlot("16:00 - 18:00", 40),
        TimeSlot("18:00 - 20:00", 40),
        TimeSlot("20:00 - 22:00", 40),
      ],
    ),
  ];

  static const _grandDiorSessions = [
    WorkoutSession(
      title: "Erkin suzish",
      durationMin: 120,
      slots: [
        TimeSlot("07:00 - 09:00", 2, ended: true),
        TimeSlot("09:00 - 11:00", 2, ended: true),
        TimeSlot("11:00 - 13:00", 2),
        TimeSlot("13:00 - 15:00", 2),
        TimeSlot("15:00 - 17:00", 2),
        TimeSlot("17:00 - 19:00", 2),
        TimeSlot("19:00 - 21:00", 2),
      ],
    ),
  ];

  static const _avantWomenGymSlots = [
    TimeSlot("10:00", 0, ended: true),
    TimeSlot("11:00", 0, ended: true),
    TimeSlot("16:00", 0, ended: true),
    TimeSlot("17:00", 0, ended: true),
  ];

  static const _avantWomenPoolSlots = [
    TimeSlot("10:00 - 12:00", 0, ended: true),
    TimeSlot("11:00 - 13:00", 0, ended: true),
    TimeSlot("16:00 - 18:00", 0, ended: true),
    TimeSlot("17:00 - 19:00", 0, ended: true),
  ];

  static const _avantMenGymSlots = [
    TimeSlot("13:00", 0, ended: true),
    TimeSlot("14:00", 0, ended: true),
    TimeSlot("19:00", 1),
    TimeSlot("20:00", 0),
    TimeSlot("21:00", 3),
  ];

  static const _avantMenPoolSlots = [
    TimeSlot("13:00 - 15:00", 0, ended: true),
    TimeSlot("14:00 - 16:00", 0, ended: true),
    TimeSlot("19:00 - 21:00", 0, ended: true),
    TimeSlot("20:00 - 22:00", 1),
    TimeSlot("21:00 - 23:00", 2),
  ];

  static const _avantSessions = [
    WorkoutSession(
      title: "Trenajyor zalida mustaqil mashg'ulotlar",
      durationMin: 120,
      restriction: "Faqat ayollar uchun",
      slots: _avantWomenGymSlots,
    ),
    WorkoutSession(
      title: "Basseyn | Sauna",
      durationMin: 120,
      restriction: "Faqat ayollar uchun",
      slots: _avantWomenPoolSlots,
    ),
    WorkoutSession(
      title: "Trenajyor zalida mustaqil mashg'ulotlar",
      durationMin: 120,
      restriction: "Faqat erkaklar uchun",
      slots: _avantMenGymSlots,
    ),
    WorkoutSession(
      title: "Basseyn | Sauna",
      durationMin: 120,
      restriction: "Faqat erkaklar uchun",
      slots: _avantMenPoolSlots,
    ),
  ];

  static const savedGyms = [
    Gym(
      name: "Avant Wellness Hotel",
      lat: 41.3123,
      lng: 69.253,
      rating: 9.5,
      address: "Kichik halqa yo'li, 41C",
      category: "Trenajor zal",
      tags: ["Trenajor zal", "Sportzal", "Suv mashg'ulotlari", "Basseyn"],
      photoAssets: ["assets/gyms/avant_1.jpg", "assets/gyms/avant_2.jpg", "assets/gyms/avant_3.jpg"],
      description:
          "Avant Wellness Hotel — Toshkentdagi zamonaviy mehmonxona bo'lib, qulay dam olish va sog'lomlashtirish xizmatlarini taklif etadi. Mehmonlar uchun isitiladigan yopiq basseyn, fitnes markazi va sauna mavjud.",
      visitsUsed: 12,
      visitsTotal: 12,
      ratingBreakdown: [
        ("Murabbiyning professionalligi", 9.8),
        ("Xodimlarning samimiyligi", 9.7),
        ("Jihozlarning holati", 9.5),
        ("Xona tozaligi", 9.3),
        ("Kiyinish xonasining tozaligi", 9.2),
      ],
      amenities: [
        ("Zalda musiqa", true),
        ("Avtoturargoh", true),
        ("Dush", true),
        ("Bepul Wi-Fi", true),
        ("Konditsionerlar", true),
        ("Fen", true),
        ("Sauna", true),
        ("Toza suv", false),
        ("Namozxona", false),
        ("Yaqin atrofda metro", false),
        ("Bepul choy", false),
        ("Bepul sochiqlar", false),
      ],
      sessions: _avantSessions,
    ),
    Gym(
      name: "SPACE FITNESS",
      lat: 41.2755,
      lng: 69.2045,
      rating: 9.6,
      address: "3-chi kvartal, 45/1",
      category: "Trenajor zal",
      tags: ["Trenajor zal", "Sportzal"],
      phone: "+998 71 271 22 77",
      photoAssets: [
        "assets/gyms/space_fitness_1.jpg",
        "assets/gyms/space_fitness_2.jpg",
        "assets/gyms/space_fitness_3.jpg",
        "assets/gyms/space_fitness_4.jpg",
        "assets/gyms/space_fitness_5.jpg",
      ],
      description:
          "Bizning trenajor zalimiz fitnes mashg'ulotlari va sog'liqni mustahkamlash uchun zamonaviy uskunalarning to'liq to'plamini taklif etadi. Bizda samarali mashg'ulotlar uchun zarur bo'lgan hamma narsa bor: gantellardan tortib kardio va kuch trenajorlarigacha.",
      visitsUsed: 12,
      visitsTotal: 9,
      ratingBreakdown: [
        ("Murabbiyning professionalligi", 9.8),
        ("Xona tozaligi", 9.8),
        ("Kiyinish xonasining tozaligi", 9.8),
        ("Jihozlarning holati", 9.6),
        ("Xodimlarning samimiyligi", 9.5),
      ],
      amenities: [
        ("Dush", true),
        ("Zalda musiqa", true),
        ("Avtoturargoh", false),
        ("Yaqin atrofda metro", false),
        ("Bepul Wi-Fi", false),
        ("Fen", false),
        ("Bepul choy", false),
        ("Bepul sochiqlar", false),
        ("Fitnes-bar", false),
        ("Bola bilan mumkin", false),
        ("Konditsionerlar", false),
        ("Bepul xalatlar", false),
      ],
      sessions: _spaceFitnessSessions,
    ),
    Gym(
      name: "GRAND DIOR HOTEL",
      lat: 41.2903,
      lng: 69.2456,
      rating: 9.4,
      address: "Bog'ibustan ko'chasi, 45",
      category: "Hovuz",
      tags: ["Hovuz", "Suv mashg'ulotlari"],
      phone: "+998 88 515 00 07",
      photoAssets: [
        "assets/gyms/grand_dior_1.jpg",
        "assets/gyms/grand_dior_2.jpg",
        "assets/gyms/grand_dior_3.jpg",
        "assets/gyms/grand_dior_4.jpg",
        "assets/gyms/grand_dior_5.jpg",
        "assets/gyms/grand_dior_6.jpg",
      ],
      description:
          "Zamonaviy basseyn — dam olish, sport bilan shug'ullanish va kuchni tiklash uchun ideal joy. Keng suzish zonasi, ko'p bosqichli filtrlash tizimiga ega toza suv va qulay harorat har qanday yoshdagi tashrif buyuruvchilar uchun a'lo sharoit yaratadi. Bu yerda faol mashg'ulot o'tkazish, og'ir kundan keyin hordiq chiqarish yoki oila va do'stlar bilan yoqimli vaqt o'tkazish mumkin. Shinam muhit, xizmat ko'rsatishning yuqori darajasi va xavfsizlikka e'tibor basseynra tashrifni qulay va yoqimli qiladi.",
      visitsUsed: 2,
      visitsTotal: 1,
      ratingBreakdown: [
        ("Xodimlarning samimiyligi", 9.9),
        ("Murabbiyning professionalligi", 9.9),
        ("Xona tozaligi", 9.9),
        ("Kiyinish xonasining tozaligi", 9.7),
        ("Jihozlarning holati", 9.7),
      ],
      amenities: [
        ("Dush", true),
        ("Sauna", true),
        ("Bepul Wi-Fi", true),
        ("Fen", true),
        ("Bepul choy", true),
        ("Toza suv", false),
        ("Avtoturargoh", false),
        ("Yaqin atrofda metro", false),
        ("Zalda musiqa", false),
        ("Bepul sochiqlar", false),
        ("Fitnes-bar", false),
        ("Bola bilan mumkin", false),
      ],
      sessions: _grandDiorSessions,
    ),
    Gym(
      name: "Gulkam Resort",
      lat: 41.468,
      lng: 70.035,
      rating: 10,
      address: "Yangikurgan yo'li, 276",
      category: "Hovuz",
      tags: ["Hovuz", "Suv mashg'ulotlari"],
      phone: "+998 55 902 99 99",
      description:
          "Gulkam Resort — Chimyon yaqinidagi manzarali tog'li hududda joylashgan zamonaviy shahar tashqarisidagi kurort. Bu yerda qulay dam olish va tiklanish uchun barcha sharoitlar yaratilgan. Mehmonlar uchun yil bo'yi ishlaydigan yopiq basseyn hamda iliq mavsum uchun juda mos, dam olish zonasi bo'lgan keng ochiq basseyn mavjud. Suzishdan, toza tog' havosidan va go'zal tabiiy manzaralardan bahramand bo'ling. Gulkam Resort — shahar shovqinidan chalg'ish, oila yoki do'stlar bilan vaqt o'tkazish va qulaylik hamda osoyishtalik muhitida energiyaga to'lash uchun a'lo joy.",
      visitsUsed: 2,
      visitsTotal: 2,
      amenities: [
        ("Toza suv", false),
        ("Dush", false),
        ("Sauna", false),
        ("Avtoturargoh", false),
        ("Yaqin atrofda metro", false),
        ("Bepul Wi-Fi", false),
        ("Fen", false),
        ("Bepul choy", false),
        ("Zalda musiqa", false),
        ("Bepul sochiqlar", false),
        ("Fitnes-bar", false),
        ("Bola bilan mumkin", true),
      ],
      sessions: _gulkamResortSessions,
    ),
    Gym(
      name: "Crocus Fitness",
      lat: 41.2846,
      lng: 69.2249,
      rating: 9.5,
      address: "Bunyodkor prospekti, 4",
      category: "Fitnes markazi",
      tags: ["Fitnes markazi", "Sportzal", "Trenajyor zali"],
      phone: "+998 98 301 50 55",
      metro: "Дружбы Народов (бывш. Бунёдкор)",
      description:
          "Crocus Fit — xalqaro darajadagi fitnes-klub bo'lib, sport, faol va sog'lom turmush tarzining ixlosmandlari uchun yuqori sifatli xizmatlarni taqdim etadi. Bizning sport majmuamiz sport bilan shug'ullanishingizni imkon qadar yoqimli va samarali qilish uchun barcha zarur qulayliklarni ta'minlaydi.",
      visitsUsed: 12,
      visitsTotal: 12,
      ratingBreakdown: [
        ("Murabbiyning professionalligi", 9.7),
        ("Jihozlarning holati", 9.6),
        ("Xona tozaligi", 9.6),
        ("Kiyinish xonasining tozaligi", 9.4),
        ("Xodimlarning samimiyligi", 9.4),
      ],
      amenities: [
        ("Zalda musiqa", true),
        ("Yaqin atrofda metro", true),
        ("Fitnes-bar", true),
        ("Bepul Wi-Fi", true),
        ("Konditsionerlar", true),
        ("Fen", true),
        ("Dush", true),
        ("Toza suv", false),
        ("Namozxona", false),
        ("Sauna", false),
        ("Avtoturargoh", false),
        ("Bepul choy", false),
      ],
      sessions: _crocusFitnessSessions,
    ),
    Gym(
      name: "Level GYM",
      lat: 41.2856,
      lng: 69.2034,
      rating: 9.7,
      address: "Bunyodkor prospekti, 64/1",
      category: "Trenajor zal",
      tags: ["Trenajyor zali", "Sportzal"],
      distance: "0.8 km",
      photoAssets: ["assets/gyms/level_gym_1.jpg", "assets/gyms/level_gym_2.jpg"],
      description:
          "Level GYM — bu siz jismoniy formangiz va o'zingizga bo'lgan ishonchingizni yangi bosqichga olib chiqadigan makon. Zamonaviy jihozlar, puxta o'ylangan mashg'ulot zonalari va professional murabbiylar maqsadlaringizga tezroq va xavfsizroq erishishingizga yordam beradi. Bu yerda shunchaki mashq qilishmaydi — bu yerda o'zingizni kuchaytirasiz.",
      visitsUsed: 12,
      visitsTotal: 11,
      ratingBreakdown: [
        ("Murabbiyning professionalligi", 9.9),
        ("Kiyinish xonasining tozaligi", 9.8),
        ("Xona tozaligi", 9.8),
        ("Xodimlarning samimiyligi", 9.8),
        ("Jihozlarning holati", 9.8),
      ],
      amenities: [
        ("Yaqin atrofda metro", true),
        ("Bepul Wi-Fi", true),
        ("Fen", true),
        ("Konditsionerlar", true),
        ("Dush", true),
        ("Avtoturargoh", true),
        ("Bola bilan mumkin", false),
        ("Bepul xalatlar", false),
        ("Toza suv", false),
        ("Namozxona", false),
        ("Sauna", false),
        ("Bepul choy", false),
      ],
      sessions: _levelGymSessions,
    ),
    Gym(
      name: "We Gym",
      lat: 40.0997,
      lng: 64.6494,
      rating: 10,
      address: "G'ijduvon",
      category: "Trenajor zal",
      tags: ["Trenajor zal", "Sportzal"],
      phone: "+998 99 007 20 20",
      photoAssets: [
        "assets/gyms/we_gym_1.jpg",
        "assets/gyms/we_gym_2.jpg",
        "assets/gyms/we_gym_3.jpg",
        "assets/gyms/we_gym_4.jpg",
      ],
      description:
          "Bizning sport zalimiz — sport va fitnes bilan shug'ullanish uchun mo'ljallangan zamonaviy va qulay makon. U yangi boshlovchilar hamda tajribali atletlarning ehtiyojlarini qondirish uchun turli xil jihozlar bilan jihozlangan. Zalning yorug' va keng xonalari yoqimli muhit yaratadi, professional murabbiylar esa har doim individual mashg'ulot dasturini tuzishda yordam berishga va mashqlarni bajarish texnikasi bo'yicha tavsiyalar berishga tayyor.",
      visitsUsed: 12,
      visitsTotal: 12,
      ratingBreakdown: [
        ("Mashg'ulot reytingi", 10),
      ],
      amenities: [
        ("Dush", true),
        ("Avtoturargoh", true),
        ("Zalda musiqa", true),
        ("Bepul Wi-Fi", false),
        ("Fen", false),
        ("Bepul choy", false),
        ("Bepul sochiqlar", false),
        ("Fitnes-bar", false),
        ("Bola bilan mumkin", false),
        ("Konditsionerlar", false),
        ("Bepul xalatlar", false),
        ("Toza suv", false),
      ],
      sessions: _weGymSessions,
    ),
    Gym(
      name: "Nizamoff Gym",
      lat: 40.1035,
      lng: 64.6438,
      rating: 10,
      address: "G'ijduvon",
      category: "Trenajor zal",
      tags: ["Trenajor zal", "Sportzal"],
      photoAssets: [
        "assets/gyms/nizamoff_gym_1.jpg",
        "assets/gyms/nizamoff_gym_2.jpg",
        "assets/gyms/nizamoff_gym_3.jpg",
        "assets/gyms/nizamoff_gym_4.jpg",
        "assets/gyms/nizamoff_gym_5.jpg",
      ],
      description:
          "Trenajyor zali — bu turli xil sog'lomlashtiruvchi va kuch mashqlarini bajarish uchun jihozlangan maxsus xona bo'lib, velotrenajyorda mashg'ulot qilishdan tortib shtangani ko'tarishgacha bo'lgan mashqlarni o'z ichiga oladi. Trenajyor zalida ma'lum bir intensivlikda va jismoniy yuklamalarning alohida yo'nalishi bo'yicha mashg'ulot qilish mumkin.",
      visitsUsed: 12,
      visitsTotal: 12,
      ratingBreakdown: [
        ("Mashg'ulot reytingi", 10),
      ],
      amenities: [
        ("Dush", true),
        ("Avtoturargoh", true),
        ("Zalda musiqa", true),
        ("Bepul Wi-Fi", false),
        ("Fen", false),
        ("Bepul choy", false),
        ("Bepul sochiqlar", false),
        ("Fitnes-bar", false),
        ("Bola bilan mumkin", false),
        ("Konditsionerlar", false),
        ("Bepul xalatlar", false),
        ("Toza suv", false),
      ],
      sessions: _nizamoffGymSessions,
    ),
    Gym(
      name: "NovaX fitness club",
      lat: 41.2811,
      lng: 69.1972,
      rating: 9.7,
      address: "16-kvartal, 24/1",
      category: "Trenajor zal",
      tags: ["Trenajor zal", "Sportzal"],
      metro: "Chilonzor",
      photoAssets: [
        "assets/gyms/nova_x_1.jpg",
        "assets/gyms/nova_x_2.jpg",
        "assets/gyms/nova_x_3.jpg",
        "assets/gyms/nova_x_4.jpg",
        "assets/gyms/nova_x_5.jpg",
        "assets/gyms/nova_x_6.jpg",
        "assets/gyms/nova_x_7.jpg",
        "assets/gyms/nova_x_8.jpg",
        "assets/gyms/nova_x_9.jpg",
        "assets/gyms/nova_x_10.jpg",
      ],
      description:
          "Bu makon — sport hayotingizning bir qismiga aylanadigan, har bir mashg'ulot yangi yutuqlarga yaqinlashtiradigan joy. Biz har qanday tayyorgarlik darajasidagi odamlar uchun — yangi boshlovchilardan tortib tajribali sportchilargacha — qulay muhit yaratdik. Sizning ixtiyoringizda kuch va kardio mashg'ulotlari uchun zamonaviy jihozlar, keng mashg'ulot zonalari va professional murabbiylar bo'lib, ular individual dastur tuzishga va maqsadlaringizga erishishga yordam beradi.",
      visitsUsed: 12,
      visitsTotal: 12,
      ratingBreakdown: [
        ("Murabbiyning professionalligi", 9.9),
        ("Xona tozaligi", 9.8),
        ("Kiyinish xonasining tozaligi", 9.8),
        ("Xodimlarning samimiyligi", 9.8),
        ("Jihozlarning holati", 9.8),
      ],
      amenities: [
        ("Zalda musiqa", true),
        ("Avtoturargoh", true),
        ("Fitnes-bar", true),
        ("Yaqin atrofda metro", true),
        ("Dush", true),
        ("Fen", true),
        ("Toza suv", true),
        ("Sauna", true),
        ("Namozxona", false),
        ("Bepul Wi-Fi", false),
        ("Bepul choy", false),
        ("Bepul sochiqlar", false),
      ],
      sessions: _novaXSessions,
    ),
  ];

  static List<Gym> get allGyms => savedGyms;

  static List<Gym> gymsByCategory(String label) =>
      allGyms.where((g) => g.tags.contains(label)).toList();

  static List<Gym> searchGyms(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return allGyms.where((g) =>
        g.name.toLowerCase().contains(q) ||
        g.address.toLowerCase().contains(q) ||
        g.tags.any((t) => t.toLowerCase().contains(q))).toList();
  }

  static const visitRules = [
    "Kech qolish mumkin emas",
    "Dars trenerisiz o'tkaziladi",
    "Bolalar bilan kelish mumkin emas",
  ];

  static const bringRules = [
    "Qo'shimcha poyabzal",
    "Shortilar yoki losinalar",
    "Sochiq",
  ];

  static const bringRulesExtra = [
    "Suv butilkasi",
    "Fitnes qo'lqop (ixtiyoriy)",
  ];

  static const searchFilters1 = [
    SearchCategory(icon: Icons.map_rounded, label: "Xaritada", count: ""),
    SearchCategory(icon: Icons.star_rounded, label: "Zallar va mashg'ulotlar", count: ""),
    SearchCategory(icon: Icons.bookmark_rounded, label: "Saqlanganlar", count: ""),
  ];

  static const searchFilters2 = [
    SearchCategory(icon: Icons.fiber_new_rounded, label: "Yangi", count: ""),
    SearchCategory(icon: Icons.person_rounded, label: "Siz uchun", count: ""),
    SearchCategory(icon: Icons.home_rounded, label: "Uy yonida", count: ""),
    SearchCategory(icon: Icons.work_rounded, label: "Ishxona yonida", count: ""),
    SearchCategory(icon: Icons.female_rounded, label: "Ayollar uchun", count: ""),
    SearchCategory(icon: Icons.male_rounded, label: "Erkaklar uchun", count: ""),
  ];

  static const workoutTypes = [
    SearchCategory(icon: Icons.fitness_center_rounded, label: "Sportzal", count: "195 zal", emoji: "🏋️"),
    SearchCategory(icon: Icons.pool_rounded, label: "Suv mashg'ulotlari", count: "33 zal", emoji: "🥽"),
    SearchCategory(icon: Icons.self_improvement_rounded, label: "Yoga", count: "54 zal", emoji: "🌸"),
    SearchCategory(icon: Icons.accessibility_new_rounded, label: "Stretching va Pilates", count: "54 zal"),
    SearchCategory(icon: Icons.celebration_rounded, label: "Har xil tadbirlar", count: "7 zal", emoji: "⭐"),
    SearchCategory(icon: Icons.local_fire_department_rounded, label: "Intensiv darslar", count: "106 zal", emoji: "💓"),
    SearchCategory(icon: Icons.music_note_rounded, label: "Raqs", count: "88 zal", emoji: "🎵"),
    SearchCategory(icon: Icons.sports_martial_arts_rounded, label: "Jang san'ati", count: "24 zal"),
    SearchCategory(icon: Icons.park_rounded, label: "Ochiq havoda shug'ullanish", count: "5 zal"),
    SearchCategory(icon: Icons.groups_rounded, label: "Jamoaviy sport turlari", count: "28 zal"),
  ];

  static const bonusWorkoutTypes = [
    SearchCategory(icon: Icons.spa_rounded, label: "Dam olish va tiklanish", count: ""),
    SearchCategory(icon: Icons.handyman_rounded, label: "Uskunani ijaraga olish", count: "3 zal"),
    SearchCategory(icon: Icons.celebration_rounded, label: "Ko'ngilochar mashg'ulotlar", count: "36 zal", emoji: "🎉"),
  ];

  static const subscriptionPlans = [
    SubscriptionPlan(
      title: "12 oylik",
      discountBadge: "-12%",
      price: "640 833 so'm x 12 oy",
      oldPrice: "7 690 000 so'm",
      gradient: [AppColors.primary, AppColors.accentPurple],
    ),
    SubscriptionPlan(
      title: "6 oylik",
      price: "948 333 so'm x 6 oy",
      oldPrice: "5 690 000 so'm",
      gradient: [AppColors.accentPink, Color(0xFFB3122A)],
    ),
    SubscriptionPlan(
      title: "3 oylik",
      price: "4 690 000 so'm",
      gradient: [AppColors.accentGreen, Color(0xFF0EA5A0)],
    ),
  ];

  static const moreMenuItems = [
    (Icons.local_activity_rounded, "Yutuqli o'yinlar", "Ishtirok eting va sovg'alar yuting"),
    (Icons.support_agent_rounded, "Qo'llab-quvvatlash xizmati", "Savollaringizga javob beramiz"),
    (Icons.card_membership_rounded, "Abonement", "Zallar va studiyalarga kirish imkoniyatingiz"),
    (Icons.person_outline_rounded, "Profil", "1Fit'dagi sahifangiz"),
  ];

  static const shopSections = [
    (Icons.ac_unit_rounded, "Muzlatish", "Abonementni muzlatish uchun"),
    (Icons.workspace_premium_rounded, "1Fit Pro", "Mashg'ulot va ovqatlanish rejasi uchun obuna"),
    (Icons.card_membership_rounded, "Abonementlar", "1Fit zallari va studiyalariga kirish"),
  ];
}
