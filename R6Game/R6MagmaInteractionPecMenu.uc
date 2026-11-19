class R6MagmaInteractionPecMenu extends R6MagmaInteractionInGameBase
    transient
    native;

// Export UR6MagmaInteractionPecMenu::execOnPlayerStatusChanged(FFrame&, void* const)
native function OnPlayerStatusChanged(string szNewStatus);

// Export UR6MagmaInteractionPecMenu::execShowCharacterCreationHud(FFrame&, void* const)
native function ShowCharacterCreationHud(bool bShow);

// Export UR6MagmaInteractionPecMenu::execIsCharacterCreationHudDisplayed(FFrame&, void* const)
native function bool IsCharacterCreationHudDisplayed();

// Export UR6MagmaInteractionPecMenu::execShowOutfittingHud(FFrame&, void* const)
native function ShowOutfittingHud(bool bShow);

// Export UR6MagmaInteractionPecMenu::execIsOutfittingHudDisplayed(FFrame&, void* const)
native function bool IsOutfittingHudDisplayed();

// Export UR6MagmaInteractionPecMenu::execIsMainOnlineHudDisplayed(FFrame&, void* const)
native function bool IsMainOnlineHudDisplayed();

// Export UR6MagmaInteractionPecMenu::execShowMainOnlineHud(FFrame&, void* const)
native function ShowMainOnlineHud(bool bShow);

defaultproperties
{
    m_MenuPackages=/* Array type was not detected. */
}