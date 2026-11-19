class SkyUIScene_Hud extends SkyUIScene
    native
    config(UI);

// Export USkyUIScene_Hud::execGetSkyPlayerOwner(FFrame&, void* const)
native function SkyPlayerController GetSkyPlayerOwner();

// Export USkyUIScene_Hud::execGetPawnOwner(FFrame&, void* const)
native function Pawn GetPawnOwner();

// Export USkyUIScene_Hud::execGetPlayerHud(FFrame&, void* const)
native function SkyHUD GetPlayerHud();
