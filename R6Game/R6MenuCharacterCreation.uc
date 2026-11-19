class R6MenuCharacterCreation extends R6MenuGameInfo
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

function RestartPlayer(Controller NewPlayer, optional Pawn ForcedPawn)
{
    local R6PlayerController PlayerCtrl;

    RestartPlayer(NewPlayer, ForcedPawn);
    PlayerCtrl = R6PlayerController(NewPlayer);
    // End:0x5B
    if(PlayerCtrl.m_MagmaInteraction.IsHudDisplayed() == true)
    {
        PlayerCtrl.m_MagmaInteraction.ShowHud(false);
    }
    // End:0x94
    if(PlayerCtrl.m_MagmaInteraction.IsCharacterCreationHudDisplayed() == false)
    {
        PlayerCtrl.m_MagmaInteraction.ShowCharacterCreationHud(true);
    }
    return;
}
