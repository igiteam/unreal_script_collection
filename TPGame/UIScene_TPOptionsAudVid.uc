class UIScene_TPOptionsAudVid extends UIScene_BaseFrontEnd;

var localized string ResetToDefaultMsg;

enum AudVidOptions
{
	OPTIONS_GAMMA,
// 	OPTIONS_MIDTONES,
// 	OPTIONS_HIGHLIGHTS,
	OPTIONS_MASTERVOL,
	OPTIONS_MUSIC,
	OPTIONS_RESET
};

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

function OnSliderChange(int MenuIndex, bool Positive)
{
	super.OnSliderChange(MenuIndex, Positive);

	switch (MenuIndex)
	{
		case OPTIONS_GAMMA:
			myTPC.SetDisplayGamma(MenuItems[MenuIndex].wSlider.GetValue() / 10.0f);
			break;
// 		case OPTIONS_MIDTONES:
// 			myTPC.SetMidTonesMultiplier(MenuItems[MenuIndex].wSlider.GetValue() / 10.0f);
// 			break;
// 		case OPTIONS_HIGHLIGHTS:
// 			myTPC.SetHighlightsMultiplier(MenuItems[MenuIndex].wSlider.GetValue() / 10.0f);
// 			break;
		case OPTIONS_MASTERVOL:
			myTPC.SetMasterVolume( MenuItems[MenuIndex].wSlider.GetValue() / 10.0f );
			break;
	}
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	if (MenuIndex == OPTIONS_RESET)
	{
		DisplayMessageBox(ResetToDefaultMsg);
	}
}

function OnCheckBoxClick(int MenuIndex)
{
	super.OnCheckBoxClick(MenuIndex);

	if (MenuIndex == OPTIONS_MUSIC)
	{
		myTPC.ToggleMusic( MenuItems[MenuIndex].wCheckbox.IsChecked() );
	}
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	if (bReturnValue)
	{
		//Time to reset our settings...
		;

		//First set those profile setting indicies to default
		myTPC.ProfileSettings.SetIndexToDefault(26);
		myTPC.ProfileSettings.SetIndexToDefault(27);
		myTPC.ProfileSettings.SetIndexToDefault(28);
		myTPC.ProfileSettings.SetIndexToDefault(30);
		myTPC.ProfileSettings.SetIndexToDefault(31);
		myTPC.ProfileSettings.SetIndexToDefault(32);
		myTPC.ProfileSettings.SetIndexToDefault(33);
		myTPC.ProfileSettings.SetIndexToDefault(47);

		//Now update the sliders
		ResetSlider(OPTIONS_GAMMA);
		//ResetSlider(OPTIONS_MIDTONES);
		//ResetSlider(OPTIONS_HIGHLIGHTS);
		ResetSlider(OPTIONS_MASTERVOL);
		ResetCheckbox(OPTIONS_MUSIC);

		myTPC.UpdateLocalCacheOfProfileSettings();
		if (!IsXboxBuild())
			myTPC.WriteProfile(true);
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

