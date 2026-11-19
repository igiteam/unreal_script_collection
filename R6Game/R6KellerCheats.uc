class R6KellerCheats extends Interaction
    transient
    native;

enum CheatIDs
{
    CHEAT_GIJOE,                    // 0
    CHEAT_GODMODE,                  // 1
    CHEAT_FULLAMMO,                 // 2
    CHEAT_SUPERRAGDOLL,             // 3
    CHEAT_ONESHOTONEKILL,           // 4
    CHEAT_UNLOCKALLWEAPONS,         // 5
    CHEAT_unused6,                  // 6
    CHEAT_TEAMGODMODE,              // 7
    CHEAT_FPS,                      // 8
    CHEAT_THIRDPERSON,              // 9
    CHEAT_BOBBLEHEAD,               // 10
    CHEAT_UNLOCKALL,                // 11
    CHEAT_MAX                       // 12
};

struct SKellerCheat
{
    var bool m_bAvailableInSPGame;
    var bool m_bAvailableInMPGame;
    var bool m_bAvailableInMenu;
    var array<name> m_KeySequence;
    var int m_iCheatID;
    var transient int m_iCurrentKeyIndex;

    structdefaultproperties
    {
        m_bAvailableInSPGame=false
        m_bAvailableInMPGame=false
        m_bAvailableInMenu=false
        m_KeySequence=none
        m_iCheatID=0
        m_iCurrentKeyIndex=0
    }
};

var array<SKellerCheat> m_Cheats;
var bool m_bHoldingLeftTrigger;

defaultproperties
{
    m_iDesiredIndex=2
}