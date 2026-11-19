class UIScene_TPSelectDifficulty extends UIScene_BaseFrontEnd;

var UILabelButton HardLabel, InsaneLabel;


struct UI_Enum_Menu_Map
{
	var int EnumVal;
	var int MenuVal;
};

var array<UI_Enum_Menu_Map>Map;

event InitScene()
{
	local int CurrDifficulty;
	
	if( myTPC==None )
		myTPC = GetPC();
	
    CurrDifficulty = TPGameInfo(GetWorldInfo().Game).CurrentDifficulty;
    
	if (myTPC.bIsDemoMode)
		CurrDifficulty = Clamp(CurrentSelectedIndex, PDO_Normal, PDO_Easy);

	CurrentSelectedIndex = MapEnumToMenu(CurrDifficulty);//Seed the current menu index with our current difficulty


	super.InitScene();


	HardLabel = UILabelButton(FindChild('Hard', true));
	InsaneLabel = UILabelButton(FindChild('Insane', true));
	if (myTPC.bIsDemoMode)
	{
		// In demo mode, disable Hard/Insane
		HardLabel.StringRenderComponent.SetColor(MakeLinearColor(0.2f, 0.2f, 0.2f, 1.0f));
		InsaneLabel.StringRenderComponent.SetColor(MakeLinearColor(0.2f, 0.2f, 0.2f, 1.0f));

		MenuItems[MapEnumToMenu(PDO_Hard)].bDisabled = true;
		MenuItems[MapEnumToMenu(PDO_Insane)].bDisabled = true;
	}
	else if (!myTPC.ProfileSettings.IsInsaneUnlocked())
	{
		InsaneLabel.StringRenderComponent.SetColor(MakeLinearColor(0.2f, 0.2f, 0.2f, 1.0f));
		MenuItems[MapEnumToMenu(PDO_Insane)].bDisabled = true;
	}
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	local int CurrDifficulty;
	local DataStoreClient DataStoreManager;
	local UIDataStore_TPGameSettings TPGameSettings;
	local string NextMapName;

	super.OnClick(OpenedScene, MenuIndex);

// 	switch (MenuIndex)
// 	{
// 		case 0:
// 			CurrDifficulty = PDO_Normal;
// 			break;
// 		case 1:
// 			CurrDifficulty = PDO_Hard;
// 			break;
// 		case 2:
// 			CurrDifficulty = PDO_Insane;
// 			break;
// 		case 3:
// 			CurrDifficulty = PDO_Easy;
// 			break;
// 	}
	CurrDifficulty = MapMenuToEnum(MenuIndex);

	myTPC.ProfileSettings.SetProfileSettingValueId(PSI_GameDifficulty, CurrDifficulty);
    myTPC.GetStoreDifficulty(CurrDifficulty, true);

	DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
	if ( DataStoreManager != None )
	{
		TPGameSettings = UIDataStore_TPGameSettings(DataStoreManager.FindDataStore('TPGameSettings',none));
		if ( TPGameSettings != None )
		{
			NextMapName = TPGameSettings.CurrentMapName;
		}
	}

    TPGameInfo(GetWorldInfo().Game).SetDifficultyLevel(CurrDifficulty);
    
	myTPC.PlayLevelIntroMovie(NextMapName);

	;
	myTPC.LocalTravel(NextMapName);//"entry_nyss_intro_hack");
}

function int MapEnumToMenu(int EnumVal)
{
	local int i;
	
	for(i=0; i<Map.Length; i++)
	{
		if( Map[i].EnumVal==EnumVal )
			return Map[i].MenuVal;
	}
	return -1;
}

function int MapMenuToEnum(int MenuVal)
{
	local int i;
	
	for(i=0; i<Map.Length; i++)
	{
		if( Map[i].MenuVal==MenuVal )
			return Map[i].EnumVal;
	}
	return -1;
}

