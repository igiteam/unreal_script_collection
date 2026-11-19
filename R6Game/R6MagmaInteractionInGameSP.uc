class R6MagmaInteractionInGameSP extends R6MagmaInteractionInGameBase
    transient
    native;

var TextureMovie m_pMexicoIntro;
var TextureMovie m_pEndCredits;

// Export UR6MagmaInteractionInGameSP::execShowSOLMenu(FFrame&, void* const)
native function ShowSOLMenu(bool bShow);

// Export UR6MagmaInteractionInGameSP::execUpdateROE(FFrame&, void* const)
native function UpdateROE();

// Export UR6MagmaInteractionInGameSP::execToggleTerroristIcons(FFrame&, void* const)
native function ToggleTerroristIcons();

// Export UR6MagmaInteractionInGameSP::execNotifyRainbowTeamChanged(FFrame&, void* const)
native function NotifyRainbowTeamChanged(bool bAdded);

// Export UR6MagmaInteractionInGameSP::execLoadMovie(FFrame&, void* const)
native function TextureMovie LoadMovie(R6MagmaInteractionInGameBase.EMoviesToLoad eMovie);

// Export UR6MagmaInteractionInGameSP::execUnloadMovie(FFrame&, void* const)
native function UnloadMovie(R6MagmaInteractionInGameBase.EMoviesToLoad eMovie);

defaultproperties
{
    m_MenuPackages=/* Array type was not detected. */
}