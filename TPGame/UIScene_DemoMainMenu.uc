class UIScene_DemoMainMenu extends UIScene_BaseFrontEnd;

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	local TPGameViewportClient viewport;
	local DataStoreClient DataStoreManager;
	local UIDataStore_TPGameSettings TPGameSettings;

	viewport = TPGameViewportClient(LocPlayer.ViewportClient);

	// Set the starting map name
	if (MenuIndex == 0)
	{
		DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
		if ( DataStoreManager != None )
		{
			TPGameSettings = UIDataStore_TPGameSettings(DataStoreManager.FindDataStore('TPGameSettings',none));
			if ( TPGameSettings != None )
			{
				TPGameSettings.CurrentMapName = "NYSS1_MASTER";
			}
		}
	}
	
	super.OnClick(OpenedScene, MenuIndex);

	// exit
	if (MenuIndex == 1)
	{
		// put exit code here
		myTPC.ConsoleCommand("blackscreen 1");
		SceneClient.CloseScene(self);
		viewport.FullScreenPlayMovie('DemoSlideShow', PLAYMOVIE_StreamBlock);
		myTPC.ConsoleCommand("exit");
	}
}

