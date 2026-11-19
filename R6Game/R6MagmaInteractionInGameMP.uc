class R6MagmaInteractionInGameMP extends R6MagmaInteractionInGameBase
    transient
    native;

var TextureMovie m_pRadarJamMovie;

// Export UR6MagmaInteractionInGameMP::execOpenChat(FFrame&, void* const)
native function OpenChat();

// Export UR6MagmaInteractionInGameMP::execOpenTeamChat(FFrame&, void* const)
native function OpenTeamChat();

// Export UR6MagmaInteractionInGameMP::execDisplayChatMessage(FFrame&, void* const)
native function DisplayChatMessage(string Msg, bool bTeam);

defaultproperties
{
    m_MenuPackages=/* Array type was not detected. */
}