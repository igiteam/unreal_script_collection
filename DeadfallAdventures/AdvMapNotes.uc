class AdvMapNotes extends Object;

enum EMapNote
{
    MN_Invalid,                     // 0
    MN_MayanJungleMap_01,           // 1
    MN_MayanJungleMap_02,           // 2
    MN_MayanJungleMap_03,           // 3
    MN_MayanJunglePlace_01,         // 4
    MN_MayanJunglePlace_02,         // 5
    MN_MayanJunglePlace_03,         // 6
    MN_MayanJunglePlace_04,         // 7
    MN_MayanJunglePlace_05,         // 8
    MN_MayanJunglePlace_06,         // 9
    MN_MayanJunglePlace_07,         // 10
    MN_MayanJunglePlace_08,         // 11
    MN_MayanJunglePlace_09,         // 12
    MN_MayanJungleTrap_01,          // 13
    MN_MayanJungleTrap_02,          // 14
    MN_MayanJungleTrap_03,          // 15
    MN_MayanJungleCaptainLog_01,    // 16
    MN_MayanJungleMap_00,           // 17
    MN_ArcticBase_01,               // 18
    MN_ArcticBase_02,               // 19
    MN_ArcticBase_03,               // 20
    MN_ArcticBase_04,               // 21
    MN_ArcticBase_05,               // 22
    MN_ArcticBase_06,               // 23
    MN_ArcticBase_07,               // 24
    MN_ArcticBase_08,               // 25
    MN_ArcticBase_09,               // 26
    MN_ArcticBase_10,               // 27
    MN_ArcticBase_11,               // 28
    MN_ArcticBase_12,               // 29
    MN_ArcticTemple_01,             // 30
    MN_ArcticTemple_02,             // 31
    MN_ArcticTemple_03,             // 32
    MN_ArcticTemple_04,             // 33
    MN_ArcticTemple_05,             // 34
    MN_SaharaIndoor_01,             // 35
    MN_SaharaIndoor_02,             // 36
    MN_SaharaIndoor_03,             // 37
    MN_SaharaIndoor_04,             // 38
    MN_SaharaIndoor_05,             // 39
    MN_SaharaIndoor_06,             // 40
    MN_XibalbaMap_01,               // 41
    MN_XibalbaNote_01,              // 42
    MN_XibalbaNote_02,              // 43
    MN_XibalbaNote_03,              // 44
    MN_XibalbaNote_04,              // 45
    MN_XibalbaNote_05,              // 46
    MN_ArcticMines_01,              // 47
    MN_ArcticMines_02,              // 48
    MN_ArcticMines_03,              // 49
    MN_MayanCity_01,                // 50
    MN_MayanCity_02,                // 51
    MN_MayanCity_03,                // 52
    MN_MayanCity_04,                // 53
    MN_MayanCity_05,                // 54
    MN_MayanTemple_01,              // 55
    MN_MayanTemple_02,              // 56
    MN_MayanTemple_03,              // 57
    MN_MayanTemple_04,              // 58
    MN_MayanTemple_05,              // 59
    MN_SaharaOutdoor_01,            // 60
    MN_SaharaOutdoor_02,            // 61
    MN_ArcticBase2_01,              // 62
    MN_ArcticBase2_02,              // 63
    MN_ArcticBase2_03,              // 64
    MN_ArcticBase2_04,              // 65
    MN_ArcticBase2_05,              // 66
    MN_ArcticBase2_06,              // 67
    MN_ArcticBase2_07,              // 68
    MN_ArcticBase2_08,              // 69
    MN_ArcticBase2_09,              // 70
    MN_SaharaIndoor_07,             // 71
    MN_SaharaIndoor_08,             // 72
    MN_MayanUnderground_01,         // 73
    MN_MayanUnderground_02,         // 74
    MN_MayanUnderground_03,         // 75
    MN_MayanUnderground_04,         // 76
    MN_MayanUnderground_05,         // 77
    MN_MayanUnderground_06,         // 78
    MN_MayanUnderground_07,         // 79
    MN_MayanUnderground_08,         // 80
    MN_MayanUnderground_09,         // 81
    MN_MayanUnderground_10,         // 82
    MN_SaharaIndoor_09,             // 83
    MN_SaharaIndoor_01_h,           // 84
    MN_SaharaIndoor_02_h,           // 85
    MN_SaharaIndoor_03_h,           // 86
    MN_SaharaIndoor_04_h,           // 87
    MN_SaharaIndoor_05_h,           // 88
    MN_SaharaIndoor_06_h,           // 89
    MN_SaharaIndoor_07_h,           // 90
    MN_SaharaIndoor_08_h,           // 91
    MN_SaharaIndoor_09_h,           // 92
    MN_SaharaIndoorMap_01,          // 93
    MN_SaharaOudoorMap_01,          // 94
    MN_MayanTempleMap_01,           // 95
    MN_MayanTemple_01_h,            // 96
    MN_MayanTemple_02_h,            // 97
    MN_MayanTemple_03_h,            // 98
    MN_ArcticTemple_06,             // 99
    MN_ArcticTemple_07,             // 100
    MN_ArcticTemple_08,             // 101
    MN_ArcticTemple_09,             // 102
    MN_ArcticTemple_10,             // 103
    MN_ArcticTemple_11,             // 104
    MN_ArcticTemple_12,             // 105
    MN_ArcticTemple_13,             // 106
    MN_ArcticTemple_14,             // 107
    MN_ArcticTemple_15,             // 108
    MN_MayanUnderground_11,         // 109
    MN_MayanUnderground_12,         // 110
    MN_MayanUnderground_13,         // 111
    MN_MayanUnderground_14,         // 112
    MN_MayanUnderground_15,         // 113
    MN_MayanUnderground_16,         // 114
    MN_MayanUnderground_17,         // 115
    MN_MayanUnderground_18,         // 116
    MN_MayanUnderground_19,         // 117
    MN_MayanUnderground_20,         // 118
    MN_MayanUnderground_21,         // 119
    MN_MayanUnderground_22,         // 120
    MN_MayanUnderground_23,         // 121
    MN_MayanUnderground_24,         // 122
    MN_MayanUnderground_25,         // 123
    MN_MayanUnderground_26,         // 124
    MN_MayanUnderground_27,         // 125
    MN_MayanUnderground_28,         // 126
    MN_MayanUnderground_29,         // 127
    MN_MayanUnderground_30,         // 128
    MN_MayanCity_02h,               // 129
    MN_ArcticMines_04,              // 130
    MN_ArcticMines_05,              // 131
    MN_ArcticMines_06,              // 132
    MN_ArcticMines_07,              // 133
    MN_ArcticMines_08,              // 134
    MN_ArcticMines_09,              // 135
    MN_XibalbaNote_01_h,            // 136
    MN_XibalbaNote_02_h,            // 137
    MN_XibalbaNote_03_h,            // 138
    MN_XibalbaNote_04_h,            // 139
    MN_XibalbaNote_06,              // 140
    MN_XibalbaNote_06_h,            // 141
    MN_DLC_1,                       // 142
    MN_DLC_2,                       // 143
    MN_DLC_3,                       // 144
    MN_DLC_4,                       // 145
    MN_DLC_5,                       // 146
    MN_DLC_6,                       // 147
    MN_DLC_7,                       // 148
    MN_DLC_8,                       // 149
    MN_DLC_9,                       // 150
    MN_DLC_10,                      // 151
    MN_DLC_11,                      // 152
    MN_DLC_12,                      // 153
    MN_DLC_13,                      // 154
    MN_DLC_14,                      // 155
    MN_DLC_15,                      // 156
    MN_DLC_16,                      // 157
    MN_DLC_17,                      // 158
    MN_DLC_18,                      // 159
    MN_DLC_19,                      // 160
    MN_DLC_20,                      // 161
    MN_DLC_21,                      // 162
    MN_DLC_22,                      // 163
    MN_DLC_23,                      // 164
    MN_DLC_24,                      // 165
    MN_DLC_25,                      // 166
    MN_DLC_26,                      // 167
    MN_DLC_27,                      // 168
    MN_DLC_28,                      // 169
    MN_DLC_29,                      // 170
    MN_DLC_30,                      // 171
    MN_DLC_31,                      // 172
    MN_DLC_32,                      // 173
    MN_DLC_33,                      // 174
    MN_DLC_34,                      // 175
    MN_DLC_35,                      // 176
    MN_DLC_36,                      // 177
    MN_DLC_37,                      // 178
    MN_DLC_38,                      // 179
    MN_DLC_39,                      // 180
    MN_DLC_40,                      // 181
    MN_DLC_41,                      // 182
    MN_DLC_42,                      // 183
    MN_DLC_43,                      // 184
    MN_DLC_44,                      // 185
    MN_DLC_45,                      // 186
    MN_DLC_46,                      // 187
    MN_DLC_47,                      // 188
    MN_DLC_48,                      // 189
    MN_DLC_49,                      // 190
    MN_DLC_50,                      // 191
    MN_DLC_51,                      // 192
    MN_DLC_52,                      // 193
    MN_DLC_53,                      // 194
    MN_DLC_54,                      // 195
    MN_DLC_55,                      // 196
    MN_DLC_56,                      // 197
    MN_DLC_57,                      // 198
    MN_DLC_58,                      // 199
    MN_DLC_59,                      // 200
    MN_DLC_60,                      // 201
    MN_DLC_61,                      // 202
    MN_DLC_62,                      // 203
    MN_DLC_63,                      // 204
    MN_DLC_64,                      // 205
    MN_DLC_65,                      // 206
    MN_DLC_66,                      // 207
    MN_DLC_67,                      // 208
    MN_DLC_68,                      // 209
    MN_DLC_69,                      // 210
    MN_DLC_70,                      // 211
    MN_DLC_71,                      // 212
    MN_DLC_72,                      // 213
    MN_DLC_73,                      // 214
    MN_DLC_74,                      // 215
    MN_DLC_75,                      // 216
    MN_DLC_76,                      // 217
    MN_DLC_77,                      // 218
    MN_DLC_78,                      // 219
    MN_DLC_79,                      // 220
    MN_DLC_80,                      // 221
    MN_DLC_81,                      // 222
    MN_DLC_82,                      // 223
    MN_DLC_83,                      // 224
    MN_DLC_84,                      // 225
    MN_DLC_85,                      // 226
    MN_DLC_86,                      // 227
    MN_DLC_87,                      // 228
    MN_DLC_88,                      // 229
    MN_DLC_89,                      // 230
    MN_DLC_90,                      // 231
    MN_DLC_91,                      // 232
    MN_DLC_92,                      // 233
    MN_DLC_93,                      // 234
    MN_DLC_94,                      // 235
    MN_DLC_95,                      // 236
    MN_DLC_96,                      // 237
    MN_DLC_97,                      // 238
    MN_DLC_98,                      // 239
    MN_DLC_99,                      // 240
    MN_DLC_100,                     // 241
    MN_DLC_101,                     // 242
    MN_DLC_102,                     // 243
    MN_DLC_103,                     // 244
    MN_DLC_104,                     // 245
    MN_DLC_105,                     // 246
    MN_DLC_106,                     // 247
    MN_DLC_107,                     // 248
    MN_DLC_108,                     // 249
    MN_DLC_109,                     // 250
    MN_DLC_110,                     // 251
    MN_DLC_111,                     // 252
    MN_DLC_112,                     // 253
    MN_DLC_113,                     // 254
    MN_DLC_114,                     // 255
    MN_MAX                          // 256
};

struct MapNote
{
    var() AdvMapNotes.EMapNote MapNoteID;
    var() Texture NormalMapNoteTexture;
    var() Texture HardMapNoteTexture;
    var() string MapNoteHintLocKey;
    var() bool bMapNoteAvailable;

    structdefaultproperties
    {
        MapNoteID=EMapNote.MN_Invalid
        NormalMapNoteTexture=none
        HardMapNoteTexture=none
        MapNoteHintLocKey=""
        bMapNoteAvailable=false
    }
};

var() array<MapNote> MapNotes;

static function MapNote FindMapNote(AdvMapNotes.EMapNote Id, array<MapNote> arMapNotes)
{
    local int I;
    local MapNote DefaultMapNote;

    I = 0;
    J0x0B:

    // End:0x7D [Loop If]
    if(I < arMapNotes.Length)
    {
        // End:0x6F
        if(int(arMapNotes[I].MapNoteID) == int(Id))
        {
            return arMapNotes[I];
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return DefaultMapNote;
    //return ReturnValue;    
}
