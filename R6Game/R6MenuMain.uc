class R6MenuMain extends R6MenuGameInfo
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

// Export UR6MenuMain::execIsPecMenu(FFrame&, void* const)
native function bool IsPecMenu();

function RestartPlayer(Controller NewPlayer, optional Pawn ForcedPawn)
{
    // End:0x1C
    if(IsPecMenu())
    {
        RestartPlayer(NewPlayer, ForcedPawn);
    }
    return;
}

function bool SetPause(bool bPause, PlayerController P)
{
    return;
}
