class SPAnimNotify_SetWWTackleMiniGameState extends AnimNotify
    native
    editinlinenew
    collapsecategories;

enum NewTackleMinigameStage
{
    NTMGAME_NONE,                   // 0
    NTMGAME_TACKLE_BUTTONMASH,      // 1
    NTMGAME_TACKLE_BIGBITE,         // 2
    NTMGAME_TAKCLE_GETUP,           // 3
    NTMGAME_TACKLE_KILLSHOT_INPROGRESS,// 4
    NTMGAME_TACKLE_KILLSHOT_SUCCESS,// 5
    NTMGAME_TACKLE_KILLSHOT_FAIL,   // 6
    NTMGAME_TACKLE_KILLSHOT_END,    // 7
    NTMGAME_TACKLE_BIGBITE_END,     // 8
    NTMGAME_NUM_ELEMENTS,           // 9
    NTMGAME_MAX                     // 10
};

var() SPAnimNotify_SetWWTackleMiniGameState.NewTackleMinigameStage MiniGameState;

defaultproperties
{
    MiniGameState=NTMGAME_TACKLE_KILLSHOT_END
}