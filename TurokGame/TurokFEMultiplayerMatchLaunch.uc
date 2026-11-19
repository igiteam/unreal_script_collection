class TurokFEMultiplayerMatchLaunch extends TurokFEMultiplayerMatchDetails
    native;

var float mFadeMusicDelay;
var float mFadeMusicDelayTimer;
var bool mIsExitFlow;

// Export UTurokFEMultiplayerMatchLaunch::execHasValidGameSession(FFrame&, void* const)
protected native function bool HasValidGameSession();

// Export UTurokFEMultiplayerMatchLaunch::execGetMatchTypeHash(FFrame&, void* const)
protected native function int GetMatchTypeHash();

// Export UTurokFEMultiplayerMatchLaunch::execOnLoadImagesComplete(FFrame&, void* const)
protected native function OnLoadImagesComplete();

// Export UTurokFEMultiplayerMatchLaunch::execOnGameDestroyed(FFrame&, void* const)
native function OnGameDestroyed(byte Reason);

// Export UTurokFEMultiplayerMatchLaunch::execOnPartyDestroyed(FFrame&, void* const)
native function OnPartyDestroyed(byte Reason);

defaultproperties
{
    mFadeMusicDelay=0.5000000
}