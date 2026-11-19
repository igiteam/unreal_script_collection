class UIScene_TPOptionsController extends UIScene_BaseFrontEnd;

var ForceFeedbackWaveform SampleWaveform;
var UILabel SensitivityText;

var localized string ResetToDefaultMsg;

var localized string LowSensitivity, MediumSensitivity, HighSensitivity;

var int CONTROLOPTION_INVERTY;
var int CONTROLOPTION_VIBRATION;
var int CONTROLOPTION_LOOKSENSITIVITY;
var int CONTROLOPTION_AIMASSIST;
var int CONTROLOPTION_CONFIGURE;
var int CONTROLOPTION_DEFAULTS;
var int CONTROLOPTION_BINDKEYS;

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

function OnCheckBoxClick(int MenuIndex)
{
	local bool NewVal;
	super.OnCheckBoxClick(MenuIndex);

	if (MenuIndex == 1)
	{
		NewVal = MenuItems[MenuIndex].wCheckbox.IsChecked();
		if (NewVal)
			myTPC.ClientPlayForceFeedbackWaveform(SampleWaveform);
	}
}

event InitScene()
{
	local UILabel TitleLabel;
	super.InitScene();
	
	CONTROLOPTION_INVERTY = 0;
	CONTROLOPTION_VIBRATION = 1;
	CONTROLOPTION_LOOKSENSITIVITY = 2;
	CONTROLOPTION_AIMASSIST = 3;
	CONTROLOPTION_CONFIGURE = 4;
	CONTROLOPTION_DEFAULTS = 5;
	CONTROLOPTION_BINDKEYS = 6;

	if( GetWorldInfo().IsPS3Build() )
	{
		CONTROLOPTION_INVERTY = 0;
		CONTROLOPTION_VIBRATION = -1; //DISABLING!
		CONTROLOPTION_LOOKSENSITIVITY = 1;
		CONTROLOPTION_AIMASSIST = 2;
		CONTROLOPTION_CONFIGURE = 3;
		CONTROLOPTION_DEFAULTS = 4;
		CONTROLOPTION_BINDKEYS = 5;
		
		MenuItems.Remove(1, 1); //Remove the Vibration option on PS3
	}

	// If we're in multiplayer, remove the aim assist controler option.
	if (GetPC().WorldInfo.NetMode != NM_Standalone)
	{
		MenuItems[CONTROLOPTION_AIMASSIST].wMenuButton.SetVisibility(false);
		MenuItems[CONTROLOPTION_AIMASSIST].bdisabled = true;
		MenuItems[CONTROLOPTION_AIMASSIST].wCheckbox.SetVisibility(false);
	}

	if (!GetWorldInfo().IsConsoleBuild())
	{
		TitleLabel = UILabel(FindChild('TitleLabel', true));
		TitleLabel.SetDataStoreBinding("<Strings:TPGame.OptionsController.TitlePC>");
	}

	SensitivityText = UILabel(FindChild('SensitivityText', true));
	SensitivityText.SetValue(GetSensitivityString());

	// Remove the "bind keys" option on console builds
	if (GetWorldInfo().IsConsoleBuild())
	{
		MenuItems[CONTROLOPTION_BINDKEYS].wMenuButton.SetVisibility(false);
		
		MenuItems.Length = MenuItems.Length - 1;
	}
}

function string GetSensitivityString()
{
	local int CurrSensitivity;
	local string NewString;
	myTPC.ProfileSettings.GetProfileSettingValueId(PSI_ControllerSensitivity, CurrSensitivity);

	//`log("CurrSensitivity is"@CurrSensitivity);
	switch (CurrSensitivity)
	{
		case PCSO_Medium:
			NewString = MediumSensitivity;
			break;
		case PCSO_Low:
			NewString = LowSensitivity;
			break;
		case PCSO_High:
			NewString = HighSensitivity;
			break;
	}

	//`log("NewString is"@NewString);
	return "\\<" $ NewString $ "\\>";

}

function OnLeftRight(int MenuIndex, bool bRight)
{
	local int CurrSensitivity;
	local int MouseSensitivity;

	if (MenuIndex == CONTROLOPTION_LOOKSENSITIVITY)
	{
		//`log("Processing Left/Right...");
		myTPC.ProfileSettings.GetProfileSettingValueId(PSI_ControllerSensitivity, CurrSensitivity);

		if (bRight)
		{
			switch (CurrSensitivity)
			{
				case PCSO_Medium:
					CurrSensitivity = PCSO_High;
					break;
				case PCSO_Low:
					CurrSensitivity = PCSO_Medium;
					break;
				case PCSO_High:
					CurrSensitivity = PCSO_Low;
					break;
			}
		}
		else
		{
			switch (CurrSensitivity)
			{
				case PCSO_Medium:
					CurrSensitivity = PCSO_Low;
					break;
				case PCSO_Low:
					CurrSensitivity = PCSO_High;
					break;
				case PCSO_High:
					CurrSensitivity = PCSO_Medium;
					break;
			}
		}

		if (!GetWorldInfo().IsConsoleBuild())
		{
			switch(CurrSensitivity)
			{
			case PCSO_Low:
				MouseSensitivity = 0;
				break;
			case PCSO_Medium:
				MouseSensitivity = 1;
				break;
			case PCSO_High:
				MouseSensitivity = 2;
				break;
			}
			myTPC.PlayerInput.MouseSensitivity = (MouseSensitivity + 1) * 20;
			myTPC.PlayerInput.SaveConfig();
		}		

		myTPC.ProfileSettings.SetProfileSettingValueId(PSI_ControllerSensitivity, CurrSensitivity);
		SensitivityText.SetValue(GetSensitivityString());
	}
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	if (MenuIndex == CONTROLOPTION_DEFAULTS)
	{
		DisplayMessageBox(ResetToDefaultMsg);
	}
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	if (bReturnValue)
	{
		//Time to reset our settings...
		;

		//First set the profile setting indicies to default
		myTPC.ProfileSettings.SetIndexToDefault(0);
		myTPC.ProfileSettings.SetIndexToDefault(1);
		myTPC.ProfileSettings.SetIndexToDefault(6);
		myTPC.ProfileSettings.SetIndexToDefault(9);
		myTPC.ProfileSettings.SetIndexToDefault(29);

		//Now update the checkbox/toggle
		SensitivityText.SetValue(GetSensitivityString());
		ResetCheckbox(CONTROLOPTION_INVERTY);
		
		if( CONTROLOPTION_VIBRATION != -1 )
			ResetCheckbox(CONTROLOPTION_VIBRATION);
			
		ResetCheckbox(CONTROLOPTION_AIMASSIST);
		if (!GetWorldInfo().IsConsoleBuild())
		{
			myTPC.PlayerInput.ResetConfig();
			myTPC.PlayerInput.SaveConfig();
		}
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

