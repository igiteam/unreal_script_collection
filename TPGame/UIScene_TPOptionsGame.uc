class UIScene_TPOptionsGame extends UIScene_BaseFrontEnd;

var localized string ResetToDefaultMsg;
var localized string DifficultyEasy, DifficultyMedium, DifficultyHard, DifficultyInsane;
var UILabel DifficultyText;

function CleanUp()
{
	if (myTPC != None)
	{
		myTPC.UpdateLocalCacheOfProfileSettings();
		if (!IsXboxBuild())
			myTPC.WriteProfile(true);
	}

	super.CleanUp();
}

event InitScene()
{
	super.InitScene();

	//DifficultyText = UILabel(FindChild('DifficultyText', true));
	//DifficultyText.SetValue(GetDifficultyString());

	// Don't allow the player to change the difficulty setting if they aren't in the main menu
	//if (myTPC.GetCurrentLevelName() != "entry_master")
	//	DifficultyText.StringRenderComponent.SetColor(MakeLinearColor(0.2f, 0.2f, 0.2f, 1.0f));

	if (!GetWorldInfo().IsConsoleBuild() || GetWorldInfo().IsPS3Build())
	{
		MenuItems[4].wMenuButton.SetVisibility(false);
		MenuItems.Length = MenuItems.Length - 1;
	}
	else if (myTPC.bIsDemoMode)
	{
		MenuItems[4].wMenuButton.StringRenderComponent.Fade(1.0f, 0.5f, 0.0f);
		MenuItems[4].bDisabled = true;
	}
}

function string GetDifficultyString()
{
	local int CurrDifficulty;
	local string NewString;

    if (!myTPC.bIsDemoMode)
	    myTPC.ProfileSettings.GetProfileSettingValueId(PSI_GameDifficulty, CurrDifficulty);
    else
        myTPC.GetStoreDifficulty(CurrDifficulty, false);

	// Don't allow the player to change the difficulty setting if they aren't in the main menu
	if (myTPC.GetCurrentLevelName() != "entry_master")
	{
		switch (CurrDifficulty)
		{
			case PDO_Normal:
				NewString = DifficultyMedium;
				break;
			case PDO_Easy:
				NewString = DifficultyEasy;
				break;
			case PDO_Hard:
				NewString = DifficultyHard;
				break;
			case PDO_Insane:
				NewString = DifficultyInsane;
				break;
		}
	}
	else
	{
		switch (CurrDifficulty)
		{
			case PDO_Normal:
				NewString = "\\< " $ DifficultyMedium $ " \\>";
				break;
			case PDO_Easy:
				NewString = "\\< " $ DifficultyEasy $ " \\>";
				break;
			case PDO_Hard:
				NewString = "\\< " $ DifficultyHard $ " \\>";
				break;
			case PDO_Insane:
				NewString = "\\< " $ DifficultyInsane $ " \\>";
				break;
		}
	}

	return NewString;

}

//function OnLeftRight(int MenuIndex, bool bRight)
//{
//	local int CurrDifficulty;
//
//	// Don't allow the player to change the difficulty setting if they aren't in the main menu
//	if (myTPC.GetCurrentLevelName() != "entry_master")
//		return;
//
//	if (MenuIndex == 0)
//	{
//		//`log("Processing Left/Right...");
//		myTPC.ProfileSettings.GetProfileSettingValueId(PSI_GameDifficulty, CurrDifficulty);
//
//		if (bRight)
//		{
//			if (!myTPC.bIsDemoMode)
//			{
//				switch (CurrDifficulty)
//				{
//					case PDO_Normal:
//						CurrDifficulty = PDO_Hard;
//						break;
//					case PDO_Easy:
//						CurrDifficulty = PDO_Normal;
//						break;
//					case PDO_Hard:
//						if (myTPC.ProfileSettings.IsInsaneUnlocked())
//							CurrDifficulty = PDO_Insane;
//						else
//							CurrDifficulty = PDO_Easy;
//						break;
//					case PDO_Insane:
//						CurrDifficulty = PDO_Easy;
//						break;
//				}
//			}
//			else
//			{
//				switch (CurrDifficulty)
//				{
//					case PDO_Normal:
//						CurrDifficulty = PDO_Easy;
//						break;
//					case PDO_Easy:
//						CurrDifficulty = PDO_Normal;
//						break;
//				}
//			}
//		}
//		else
//		{
//			if (!myTPC.bIsDemoMode)
//			{
//				switch (CurrDifficulty)
//				{
//					case PDO_Normal:
//						CurrDifficulty = PDO_Easy;
//						break;
//					case PDO_Easy:
//						if (myTPC.ProfileSettings.IsInsaneUnlocked())
//							CurrDifficulty = PDO_Insane;
//						else
//							CurrDifficulty = PDO_Hard;
//						break;
//					case PDO_Hard:
//						CurrDifficulty = PDO_Normal;
//						break;
//					case PDO_Insane:
//						CurrDifficulty = PDO_Hard;
//						break;
//				}
//			}
//			else
//			{
//				switch (CurrDifficulty)
//				{
//					case PDO_Normal:
//						CurrDifficulty = PDO_Easy;
//						break;
//					case PDO_Easy:
//						CurrDifficulty = PDO_Normal;
//						break;
//				}
//			}
//		}
//
//		myTPC.ProfileSettings.SetProfileSettingValueId(PSI_GameDifficulty, CurrDifficulty);
//		DifficultyText.SetValue(GetDifficultyString());
//	}
//}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	if (MenuIndex == 3)
	{
		DisplayMessageBox(ResetToDefaultMsg);
	}
	else if (MenuIndex == 4)
	{
		if (myTPC != None && myTPC.OnlineSub != None && myTPC.OnlineSub.PlayerInterfaceEx != None)
		{
			myTPC.OnlineSub.PlayerInterfaceEx.ShowDeviceSelectionUI(LocalPlayer(myTPC.Player).ControllerId, 6000, TRUE);
		}
	}
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	if (bReturnValue)
	{
		//Time to reset our settings...
		;

		//First set the profile setting indicies to default
		//myTPC.ProfileSettings.SetIndexToDefault(5);
		myTPC.ProfileSettings.SetIndexToDefault(34);
		myTPC.ProfileSettings.SetIndexToDefault(35);
		myTPC.ProfileSettings.SetIndexToDefault(36);

		//Now update the checkbox/toggle
		//DifficultyText.SetValue(GetDifficultyString());
		ResetCheckbox(0);
		ResetCheckbox(1);
		ResetCheckbox(2);
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

