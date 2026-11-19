class SeqAct_UnlockAchievement extends SequenceAction;

enum EPangameAchievements
{
    PAN_INVALIDACHIEVEMENT,         // 0
    Achievement_12,                 // 1
    Achievement_13,                 // 2
    Achievement_14,                 // 3
    Achievement_15,                 // 4
    COMPLETED_EPISODE_1,            // 5
    Achievement_16,                 // 6
    Achievement_17,                 // 7
    COMPLETED_EPISODE_2,            // 8
    Achievement_18,                 // 9
    Achievement_19,                 // 10
    Achievement_20,                 // 11
    Achievement_21,                 // 12
    COMPLETED_EPISODE_3,            // 13
    Achievement_22,                 // 14
    Achievement_23,                 // 15
    Achievement_24,                 // 16
    COMPLETED_EPISODE_4,            // 17
    Achievement_25,                 // 18
    Achievement_26,                 // 19
    Achievement_27,                 // 20
    COMPLETED_EPISODE_5,            // 21
    Achievement_28,                 // 22
    Achievement_30,                 // 23
    COMPLETED_EPISODE_6,            // 24
    Achievement_31,                 // 25
    Achievement_32,                 // 26
    COMPLETED_EPISODE_7,            // 27
    Achievement_33,                 // 28
    Achievement_29,                 // 29
    Achievement_34,                 // 30
    COMPLETED_EPISODE_8,            // 31
    COMPLETED_GAME_ON_EASY_DIFFICULTY,// 32
    COMPLETED_GAME_ON_NORMAL_DIFFICULTY,// 33
    COMPLETED_GAME_ON_HARD_DIFFICULTY,// 34
    Achievement_35,                 // 35
    Achievement_36,                 // 36
    Achievement_37,                 // 37
    Achievement_38,                 // 38
    Achievement_39,                 // 39
    Achievement_40,                 // 40
    Achievement_41,                 // 41
    Achievement_42,                 // 42
    Achievement_43,                 // 43
    Achievement_45,                 // 44
    Achievement_46,                 // 45
    Achievement_44,                 // 46
    Achievement_47,                 // 47
    Achievement_48,                 // 48
    Achievement_49,                 // 49
    Achievement_50,                 // 50
    EPangameAchievements_MAX        // 51
};

/** The achievement to unlock */
var() SeqAct_UnlockAchievement.EPangameAchievements AchievementId;
