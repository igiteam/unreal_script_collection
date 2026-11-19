class TurokFEEndGameCredits extends TurokUISceneController
    native;

var @NULL mCredits;

// Export UTurokFEEndGameCredits::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEEndGameCredits::execClose(FFrame&, void* const)
native function Close();

event DisablePauseMenu()
{
    GetEngine().GamePlayers[0].ViewportClient.SetPauseMenuEnabledEvent(false);
    //return;    
}

event SCCleanUpOnExit()
{
    mCredits = none;
    SceneClient = none;
    //return;    
}

defaultproperties
{
    SceneName="TurokEndGameCredits.Scene"
}