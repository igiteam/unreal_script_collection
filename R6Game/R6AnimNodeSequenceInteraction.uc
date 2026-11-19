class R6AnimNodeSequenceInteraction extends R6AnimNodeSequenceCustom
    native
    hidecategories(Object,Object,Object,Object);

enum ESequenceInteractType
{
    CLIMB_OVER,                     // 0
    UNUSED10,                       // 1
    UNUSED11,                       // 2
    FASTROPEATTACH_CHOPPERLIKE,     // 3
    UNUSED2,                        // 4
    UNUSED3,                        // 5
    UNUSED4,                        // 6
    UNUSED5,                        // 7
    UNUSED6,                        // 8
    UNUSED7,                        // 9
    UNUSED8,                        // 10
    UNUSED9,                        // 11
    ROPERAPPEL_TO_FASTROPE,         // 12
    ROPEATTACH_UP,                  // 13
    ROPEATTACH_WINDOW,              // 14
    ROPEATTACH_DOWN,                // 15
    ROPEDETTACH_UP,                 // 16
    ROPEDETTACH_DOWN,               // 17
    ROPE_INVERT,                    // 18
    ROPE_DEINVERT,                  // 19
    FASTROPEATTACH_HOOK,            // 20
    UNUSED1,                        // 21
    FASTROPEDETTACH_DOWN,           // 22
    LADDERATTACH_UP,                // 23
    LADDERATTACH_DOWN,              // 24
    LADDERDETTACH_UP,               // 25
    LADDERDETTACH_DOWN,             // 26
    FASTROPE_BRAKE,                 // 27
    LADDERDETTACH_DOWN_SLIDE,       // 28
    LADDERSLIDE_START,              // 29
    ROPEREADY_TO_TC,                // 30
    ROPETC_TO_READY,                // 31
    ROPETC_TO_READYDOWN,            // 32
    ROPETC_TO_BF,                   // 33
    INTERACT_REVIVE,                // 34
    WINDOW_OPEN,                    // 35
    WINDOW_BREAK,                   // 36
    WINDOW_BREAKUNDER,              // 37
    ESequenceInteractType_MAX       // 38
};

var(Interaction) R6AnimNodeSequenceInteraction.ESequenceInteractType m_eType;
var(Interaction) bool m_bAnimRootOnly;
var transient int m_iLastTick;
