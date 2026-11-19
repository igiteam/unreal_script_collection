class TurokFELoadProgressMenu extends TurokUISceneController
    native;

var bool bBlockInput;
var @NULL mFEAudio;
var @NULL TheSaveTable;
var @NULL TheBackground;
var array LevelsNeedingImages;
var array Backgrounds;
var int LastLevelIndexRequestedToBeLoaded;

// Export UTurokFELoadProgressMenu::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFELoadProgressMenu::execFetchSaves(FFrame&, void* const)
native function FetchSaves();

event SCCleanUpOnExit()
{
    mFEAudio = none;
    TheSaveTable.Deinitialize();
    TheSaveTable = none;
    SceneClient = none;
    //return;    
}

event CloseMenu()
{
    SceneClient.GoBackSceneController(0);
    //return;    
}

defaultproperties
{
    SceneName="TurokFEStoryModeFlow.LoadProgress.LoadProgressMenu"
}