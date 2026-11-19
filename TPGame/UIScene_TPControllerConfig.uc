class UIScene_TPControllerConfig extends UIScene_BaseFrontEnd;

var UILabel ConfigText;

var UILabel ALabel, BLabel, XLabel, YLabel;
var UILabel LTLabel, RTLabel, LBLabel, RBLabel;
var UILabel LSLabel, RSLabel, DLRLabel, DULabel;

var localized string ControlTypeDefault, ControlTypeAlt, ControlTypeSouthpaw, ControlTypeAltSouthpaw;

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

	ConfigText = UILabel(FindChild('ConfigText', true));
	ConfigText.SetValue(GetConfigString());

	ALabel = UILabel(FindChild('ALabel', true));
	BLabel = UILabel(FindChild('BLabel', true));
	XLabel = UILabel(FindChild('XLabel', true));
	YLabel = UILabel(FindChild('YLabel', true));
	LTLabel = UILabel(FindChild('LTLabel', true));
	RTLabel = UILabel(FindChild('RTLabel', true));
	LBLabel = UILabel(FindChild('LBLabel', true));
	RBLabel = UILabel(FindChild('RBLabel', true));
	LSLabel = UILabel(FindChild('LSLabel', true));
	RSLabel = UILabel(FindChild('RSLabel', true));
	DLRLabel = UILabel(FindChild('DLRLabel', true));
	DULabel = UILabel(FindChild('DULabel', true));

	DULabel.SetValue("");

	UpdateButtonText();
}

function string GetConfigString()
{
	local int CurrConfig;
	local string NewString;
	myTPC.ProfileSettings.GetProfileSettingValueId(class'TPProfileSettings'.const.ControllerConfigType, CurrConfig);

	switch (CurrConfig)
	{
		case TPCO_Default:
			NewString = ControlTypeDefault;
			break;
		case TPCO_Alternate:
			NewString = ControlTypeAlt;
			break;
		case TPCO_DefaultSouthPaw:
			NewString = ControlTypeSouthpaw;
			break;
		case TPCO_AlternateSouthPaw:
			NewString = ControlTypeAltSouthpaw;
			break;
	}

	//`log("NewString is"@NewString);
	return "\\<" $ NewString $ "\\>";

}

function UpdateButtonText()
{
	local int CurrConfig;
	myTPC.ProfileSettings.GetProfileSettingValueId(class'TPProfileSettings'.const.ControllerConfigType, CurrConfig);

	// First do the joysticks and triggers
	if (CurrConfig == TPCO_Default || CurrConfig == TPCO_Alternate)
	{
		LSLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.MoveRegular>");
		RSLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.LookRegular>");
		LTLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.AimDownRegular>");
		RTLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.FireRegular>");
		LBLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.SprintRegular>");
		RBLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.GrenadeRegular>");
	}
	else // Southpaw
	{
		RSLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.MoveSouthpaw>");
		LSLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.LookSouthpaw>");
		RTLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.AimDownSouthpaw>");
		LTLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.FireSouthpaw>");
		RBLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.SprintSouthpaw>");
		LBLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.GrenadeSouthpaw>");
	}

	// Now configure the other buttons
	if (CurrConfig == TPCO_Default || CurrConfig == TPCO_DefaultSouthPaw)
	{
		ALabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.JumpRegular>");
		BLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.UseRegular>");
	}
	else // Alternate
	{
		BLabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.JumpAlt>");
		ALabel.SetDatastoreBinding("<Strings:TPGame.ControllerConfig.UseAlt>");
	}
}

function OnLeftRight(int MenuIndex, bool bRight)
{
	local int CurrConfig;

	if (MenuIndex == 0)
	{
		//`log("Processing Left/Right...");
		myTPC.ProfileSettings.GetProfileSettingValueId(class'TPProfileSettings'.const.ControllerConfigType, CurrConfig);

		if (bRight)
		{
			switch (CurrConfig)
			{
				case TPCO_Default:
					CurrConfig = TPCO_Alternate;
					break;
				case TPCO_Alternate:
					CurrConfig = TPCO_DefaultSouthPaw;
					break;
				case TPCO_DefaultSouthPaw:
					CurrConfig = TPCO_AlternateSouthPaw;
					break;
				case TPCO_AlternateSouthPaw:
					CurrConfig = TPCO_Default;
					break;
			}
		}
		else
		{
			switch (CurrConfig)
			{
				case TPCO_Default:
					CurrConfig = TPCO_AlternateSouthPaw;
					break;
				case TPCO_Alternate:
					CurrConfig = TPCO_Default;
					break;
				case TPCO_DefaultSouthPaw:
					CurrConfig = TPCO_Alternate;
					break;
				case TPCO_AlternateSouthPaw:
					CurrConfig = TPCO_DefaultSouthPaw;
					break;
			}
		}

		myTPC.ProfileSettings.SetProfileSettingValueId(class'TPProfileSettings'.const.ControllerConfigType, CurrConfig);
		ConfigText.SetValue(GetConfigString());
		UpdateButtonText();
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

