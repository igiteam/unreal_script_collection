class MOHAGameViewportClient extends GameViewportClient within Engine
    transient
    native
    config(Game);

var UIScene MainMenuScene;
var bool bPreviouslyOpenedMainMenu;
var bool bOpenMatchMenuNow;
var config bool bSkipFrontEndUI;
var string SceneToOpen;

// Export UMOHAGameViewportClient::execGetGIsGame(FFrame&, void* const)
native event bool GetGIsGame();

event GameSessionEnded()
{
    CleanupGameSession();
    super.GameSessionEnded();
    //return;    
}

// Export UMOHAGameViewportClient::execCleanupGameSession(FFrame&, void* const)
native function CleanupGameSession();

defaultproperties
{
    MainMenuScene=UIScene'MP_UI_InGameMenu.UIScene.ChangeWeaponMenu'
    UIControllerClass=Class'MOHAUIInteraction'
}