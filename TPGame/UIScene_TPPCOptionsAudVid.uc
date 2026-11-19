class UIScene_TPPCOptionsAudVid extends UIScene_BaseFrontEnd;

var UILabel wVideoResolutionLabel;
var UILabel wVideoPeformanceLabel;

var array<string> DisplayModes;
var array<string> PerformanceStrings;
var int CurrentDisplayModesIndex;
var int CurrentPerformanceIndex, OldPerformanceSetting;

enum PCAudVidOptions
{
	PCOPTIONS_RESOLUTION,
	PCOPTIONS_PERFORMANCE,
	PCOPTIONS_FULLSCREEN,
	PCOPTIONS_GAMMA,
// 	PCOPTIONS_MIDTONES,
// 	PCOPTIONS_HIGHLIGHTS,
	PCOPTIONS_MASTERVOL,
	PCOPTIONS_MUSIC,
	PCOPTIONS_RESET
};

event InitScene()
{
	wVideoResolutionLabel =  UILabel(FindChild(name("ResolutionLabel"), true));
	wVideoPeformanceLabel =  UILabel(FindChild(name("PerformanceLabel"), true));

	Super.InitScene();
	if (!GetWorldInfo().IsConsoleBuild())
	{
		CurrentDisplayModesIndex = GetCurrentDisplayResolution();
		MenuItems[PCOPTIONS_FULLSCREEN].wCheckbox.SetValue(LocPlayer.ViewportClient.IsFullScreenViewport());
		CurrentPerformanceIndex = myTPC.ProfileSettings.GetVideoPerformance();
		
		wVideoResolutionLabel.SetDatastoreBinding(DisplayModes[CurrentDisplayModesIndex]);
		wVideoPeformanceLabel.SetDatastoreBinding(PerformanceStrings[CurrentPerformanceIndex]);
	}

	if( Caps(myTPC.GetRealCurrentLevelName()) != "ENTRY_MASTER" )
	{
		// let switch the default focus from the first item to the 2nd
		MenuItems[0].wMenuButton.KillFocus(MenuItems[0].wMenuButton.GetOwner());
		MenuItems[3].wMenuButton.SetFocus(MenuItems[1].wMenuButton.GetOwner());
		CurrentSelectedIndex = 3;

		// lets disable and fade out the resolutation "button" and its displayed text
		MenuItems[0].wMenuButton.StringRenderComponent.Fade(1.0f, 0.3f, 0.0f);
		MenuItems[0].bDisabled = true;

		wVideoResolutionLabel.StringRenderComponent.Fade(1.0f, 0.3f, 0.0f);

		// lets disable and fade out the performace "button" and its displayed text
		MenuItems[1].wMenuButton.StringRenderComponent.Fade(1.0f, 0.3f, 0.0f);
		MenuItems[1].bDisabled = true;

		wVideoPeformanceLabel.StringRenderComponent.Fade(1.0f, 0.3f, 0.0f);

		// lets disable and fade out the make full screen "button" and its displayed check box
		MenuItems[2].wMenuButton.StringRenderComponent.Fade(1.0f, 0.3f, 0.0f);
		MenuItems[2].bDisabled = true;
	}

}

function int GetCurrentDisplayResolution()
{
	local Vector2D ViewportSize;
	local string VideoResolutionStr;
	local int i, OptionalResolution;

	myTPC.GetResolutionStrings(DisplayModes);

	// Screen Resolution
	LocPlayer.ViewportClient.GetViewportSize(ViewportSize);
	
	VideoResolutionStr = int(ViewportSize.X)$" x "$int(ViewportSize.Y);
	
	for (i = 0; i < DisplayModes.Length; i++)
	{
		if (DisplayModes[i] == "800 x 600")
		{
			OptionalResolution = i;
		}
		if (DisplayModes[i] == VideoResolutionStr)
		{
			return i;
		}
	}

	return OptionalResolution;
}

function OnOptionsChanged(int PlayerIndex, bool bReturnValue)
{
	if (myTPC != none)
	{
		myTPC.UpdateLocalCacheOfProfileSettings();
		myTPC.WriteProfile(true);
		HandleBack();
	}
}

//function CleanUp()
//{
//	if (myTPC != None)
//	{
//		myTPC.DisplayMessageBox(Localize("UIScene_TPOptionsAudVid", "RestartMessagePC", "TPGame"),Localize("PauseMenu", "BaseConfirmation", "TPGame"), true, OnOptionsChanged);
//		myTPC.UpdateLocalCacheOfProfileSettings();
//		myTPC.WriteProfile(true);
//	}
//
//	super.CleanUp();
//}

function OnSliderChange(int MenuIndex, bool Positive)
{
	super.OnSliderChange(MenuIndex, Positive);

	switch (MenuIndex)
	{
		case PCOPTIONS_GAMMA:
			myTPC.SetDisplayGamma(MenuItems[MenuIndex].wSlider.GetValue() / 10.0f);
			break;
// 		case PCOPTIONS_MIDTONES:
// 			myTPC.SetMidTonesMultiplier(MenuItems[MenuIndex].wSlider.GetValue() / 10.0f);
// 			break;
// 		case PCOPTIONS_HIGHLIGHTS:
// 			myTPC.SetHighlightsMultiplier(MenuItems[MenuIndex].wSlider.GetValue() / 10.0f);
// 			break;
		case PCOPTIONS_MASTERVOL:
			myTPC.SetMasterVolume( MenuItems[MenuIndex].wSlider.GetValue() / 10.0f );
			break;
	}
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	if (MenuIndex == PCOPTIONS_RESET)
	{
		DisplayMessageBox("<Strings:TPGame.UIScene_TPOptionsAudVid.ResetToDefaultMsg>");
	}
}

function OnCheckBoxClick(int MenuIndex)
{
	super.OnCheckBoxClick(MenuIndex);

	if (MenuIndex == PCOPTIONS_FULLSCREEN)
	{

	}
	if (MenuIndex == PCOPTIONS_MUSIC)
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
		myTPC.ProfileSettings.SetIndexToDefault(58);
		myTPC.ProfileSettings.SetIndexToDefault(59);
		myTPC.ProfileSettings.SetIndexToDefault(60);

		//Now update the sliders
		ResetSlider(PCOPTIONS_GAMMA);
// 		ResetSlider(PCOPTIONS_MIDTONES);
// 		ResetSlider(PCOPTIONS_HIGHLIGHTS);
		ResetSlider(PCOPTIONS_MASTERVOL);
		ResetCheckbox(PCOPTIONS_MUSIC);
		ResetCheckbox(PCOPTIONS_FULLSCREEN);
	}
}

function bool CustomInputKey( const out InputEventParameters EventParms )
{
	if (CurrentSelectedIndex <= 1)
	{
		if ( ((EventParms.InputKeyName == 'XboxTypeS_DPad_Left' || EventParms.InputKeyName == 'Gamepad_LeftStick_Left') 
				|| (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Left')) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat))
		{
			// Display Modes
			if (CurrentSelectedIndex == 0)
			{
				CurrentDisplayModesIndex--;

				if (CurrentDisplayModesIndex < 0)
					CurrentDisplayModesIndex = DisplayModes.Length - 1;

				myTPC.ProfileSettings.SetProfileSettingValueInt( class'TPProfileSettings'.const.VideoResolution, CurrentDisplayModesIndex); 
				wVideoResolutionLabel.SetDatastoreBinding(DisplayModes[CurrentDisplayModesIndex]);
			}
			// Performance
			else
			{
				CurrentPerformanceIndex--;

				if (CurrentPerformanceIndex < 0)
					CurrentPerformanceIndex = PerformanceStrings.Length - 1;
				
				myTPC.ProfileSettings.SetProfileSettingValueInt( class'TPProfileSettings'.const.VideoPerformance, CurrentPerformanceIndex); 
				wVideoPeformanceLabel.SetDatastoreBinding(PerformanceStrings[CurrentPerformanceIndex]);
			}
			return true;
		}
		else if ( ((EventParms.InputKeyName == 'XboxTypeS_DPad_Right' || EventParms.InputKeyName == 'Gamepad_LeftStick_Right')
				|| (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Right')) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat))
		{
			// Display Modes
			if (CurrentSelectedIndex == 0)
			{
				CurrentDisplayModesIndex++;

				if (CurrentDisplayModesIndex >= DisplayModes.Length)
					CurrentDisplayModesIndex = 0;

				myTPC.ProfileSettings.SetProfileSettingValueInt( class'TPProfileSettings'.const.VideoResolution, CurrentDisplayModesIndex); 
				wVideoResolutionLabel.SetDatastoreBinding(DisplayModes[CurrentDisplayModesIndex]);
			}
			// Performance
			else
			{
				CurrentPerformanceIndex++;

				if (CurrentPerformanceIndex >= PerformanceStrings.Length)
					CurrentPerformanceIndex = 0;

				myTPC.ProfileSettings.SetProfileSettingValueInt( class'TPProfileSettings'.const.VideoPerformance, CurrentPerformanceIndex); 
				wVideoPeformanceLabel.SetDatastoreBinding(PerformanceStrings[CurrentPerformanceIndex]);
			}
			return true;
		}
	}

	if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Escape') ||  EventParms.InputKeyName == 'XboxTypeS_B' ) && EventParms.EventType == IE_Released)
	{
		FadeInactive();
		//if (OldPerformanceSetting == CurrentPerformanceIndex)
		//{
			myTPC.UpdateLocalCacheOfProfileSettings();
			myTPC.SelectScreenRes(CurrentDisplayModesIndex, MenuItems[2].wCheckbox.IsChecked());
			myTPC.WriteProfile(true);
			HandleBack();
		//}
		/*else
		{
			myTPC.DisplayMessageBox(Localize("UIScene_TPOptionsAudVid", "RestartMessagePC", "TPGame"),Localize("PauseMenu", "BaseConfirmation", "TPGame"), true, OnOptionsChanged);
		}*/
		return true;
	}

	return super.CustomInputKey(EventParms);
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

