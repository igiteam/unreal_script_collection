class UIScene_TPOptionsMenuMP extends UIScene_BaseFrontEnd;

event InitScene()
{
	Super.InitScene();
	if (!GetWorldInfo().IsConsoleBuild())
	{
		// Open up the PC Aud/Vid Options
		MenuItems[1].SceneRef = mySceneRefs[4];
		// Change the input
		MenuItems[3].wMenuButton.SetDatastoreBinding("<Strings:TPGame.OptionsMenu.InputOptions>");
	}
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	local TPGameReplicationInfo GRI;
	
	GRI = TPGameReplicationInfo(WorldInfo.GRI);

	if (GetWorldInfo().NetMode != NM_Standalone && GRI != none && GRI.GameStatus != GS_GameInProgress )
	{
		SceneClient.CloseScene(self);
		return;
	}

	super.UpdateScene(DeltaTime, WorldInfo);
}

