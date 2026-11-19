class R6MagmaInteractionMain extends R6MagmaInteraction
    transient
    native;

var TextureMovie m_pBackgroundMovie;

// Export UR6MagmaInteractionMain::execOnPlayerStatusChanged(FFrame&, void* const)
native function OnPlayerStatusChanged(string szNewStatus);

// Export UR6MagmaInteractionMain::execShowCharacterCreationHud(FFrame&, void* const)
native function ShowCharacterCreationHud(bool bShow);

// Export UR6MagmaInteractionMain::execIsCharacterCreationHudDisplayed(FFrame&, void* const)
native function bool IsCharacterCreationHudDisplayed();

// Export UR6MagmaInteractionMain::execShowOutfittingHud(FFrame&, void* const)
native function ShowOutfittingHud(bool bShow);

// Export UR6MagmaInteractionMain::execIsOutfittingHudDisplayed(FFrame&, void* const)
native function bool IsOutfittingHudDisplayed();

// Export UR6MagmaInteractionMain::execIsMainOnlineHudDisplayed(FFrame&, void* const)
native function bool IsMainOnlineHudDisplayed();

// Export UR6MagmaInteractionMain::execShowMainOnlineHud(FFrame&, void* const)
native function ShowMainOnlineHud(bool bShow);

defaultproperties
{
    m_MenuPackages=/* Array type was not detected. */
}