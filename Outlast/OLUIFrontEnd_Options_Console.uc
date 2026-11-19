class OLUIFrontEnd_Options_Console extends OLUIFrontEnd_Options;

var transient GFxObject SquareLabel;

var localized string SettingsText;
var localized string HelpText;

/** Configures the view when it is first loaded. */
function OnViewLoaded()
{
	local int i;

	Super.OnViewLoaded();

	OwningId = GetOLPC().PlayerReplicationInfo.UniqueId;
	MyProfile = GetOLProfile();
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();

	SetFunction("Press_OptionItemButton", self, nameof(Press_OptionItemButton));
	SetFunction("OnSliderChanged", self, nameof(OnSliderChanged));
	// Remove unwanted entries inherited from non-console through localized text
	for (i = 0; i < GeneralOptionsNoDifficulty.Length; i++)
	{
		if (GeneralOptionsNoDifficulty[i].SettingDescription == "")
		{
			GeneralOptionsNoDifficulty.Remove(i, 1);
			i--;
		}
	}

	for (i = 0; i < GeneralOptionsWithDifficulty.Length; i++)
	{
		if (GeneralOptionsWithDifficulty[i].SettingDescription == "")
		{
			GeneralOptionsWithDifficulty.Remove(i, 1);
			i--;
		}
	}
}

function OnViewActivated()
{
	FillOptionValuesFromProfile();

	if (GameplayList != None)
	{
		PopulateGeneralOptions();
	}	
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{   		
	Super.OnTopMostView(bPlayOpenAnimation);
}

function bool Back()
{
	SaveSettingsToProfile();

	if (!bWaitingForPopup)
	{
		ExitOptionsScreen();
	}
	return false;
}

function Press_Gamma(GFxClikWidget.EventData ev)
{
	SaveSettingsToProfile();
	MenuManager.PushViewByName('GammaScreen');
}

function Press_OptionItemButton(int PSID)
{
	SaveSettingsToProfile();

	if (PSID == PSI_GamepadConfig)
	{
		MenuManager.PushViewByName('GamepadScreen');
	}
	else if (PSID == PSI_GammaSetting)
	{
		MenuManager.PushViewByName('GammaScreen');
	}
}


function Press_Apply(GFxClikWidget.EventData ev)
{
	Back();
}

function PopulateTabButtons()
{
	local GFxObject Obj, DataProvider;

	DataProvider = CreateArray();

	Obj = CreateObject("Object");
	Obj.SetString("label", SettingsText);
	Obj.SetString("data", "GameplayView");
	DataProvider.SetElementObject(0, Obj);

	TabButtons.SetObject("dataProvider", DataProvider);
	TabButtons.SetFloat("selectedIndex", 0);
	TabButtons.SetBool("disabled", true);

	CurrentTab = OT_Gameplay;
}

function PopulateControlsOptions()
{	
}

function FillOptionValuesFromProfile()
{
	if (UseGeneralOptionsWithDifficulty())
	{
		FillOptionValuesForList(GeneralOptionsWithDifficulty);
	}
	else
	{
		FillOptionValuesForList(GeneralOptionsNoDifficulty);
	}
}

function Press_Reset(GFxClikWidget.EventData ev)
{
	ResetConsoleOptions();
}

function ResetConsoleOptions()
{
	local int GammaIndex;
	local float GammaValue;
	
	if (UseGeneralOptionsWithDifficulty())
	{
		SetDefaultOptionValuesForList(GeneralOptionsWithDifficulty);
		GammaIndex = GeneralOptionsWithDifficulty.Find('ProfileSettingId', PSI_GammaSetting);		
	}
	else
	{
		SetDefaultOptionValuesForList(GeneralOptionsNoDifficulty);
		GammaIndex = GeneralOptionsNoDifficulty.Find('ProfileSettingId', PSI_GammaSetting);
	}	
	
	// Reset Gamma

	GeneralOptionsNoDifficulty[GammaIndex].CurrentValueFloat = 2.2;
	GammaValue = 2.2;
	
	GetOLPC().SetGamma(GammaValue);
	MyProfile.SetProfileSettingValueFloat(PSI_GammaSetting, GammaValue); 

	if (UseGeneralOptionsWithDifficulty())
	{
		FillOptionValuesForList(GeneralOptionsWithDifficulty);
	}
	else
	{
		FillOptionValuesForList(GeneralOptionsNoDifficulty);
	}	

	PopulateGeneralOptions();
	
	SaveProfile();
}

function float GetCurrentGammaSetting()
{
	local int GammaIndex;

	if (UseGeneralOptionsWithDifficulty())
	{
		GammaIndex = GeneralOptionsWithDifficulty.Find('ProfileSettingId', PSI_GammaSetting);
		return GeneralOptionsWithDifficulty[GammaIndex].CurrentValueFloat;
	}
	else
	{
		GammaIndex = GeneralOptionsNoDifficulty.Find('ProfileSettingId', PSI_GammaSetting);
		return GeneralOptionsNoDifficulty[GammaIndex].CurrentValueFloat;
	}	
}

function SetGammaExternally(float Gamma)
{
	local int GammaOption;

	if (UseGeneralOptionsWithDifficulty())
	{
		GammaOption = GeneralOptionsWithDifficulty.Find('ProfileSettingId', PSI_GammaSetting);
		GeneralOptionsWithDifficulty[GammaOption].CurrentValueFloat = Gamma;
	}
	else
	{
		GammaOption = GeneralOptionsNoDifficulty.Find('ProfileSettingId', PSI_GammaSetting);
		GeneralOptionsNoDifficulty[GammaOption].CurrentValueFloat = Gamma;
	}

	PopulateGeneralOptions();
}


function TabChanged(GFxClikWidget.EventData ev)
{
}

function bool HasResolutionChanged()
{
	return false;
}

function int GetResolutionOptionIndex()
{
	return -1;
}

function int GetFullscreenOptionIndex()
{
	return -1;
}


event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	local OLEngine Engine;

	Engine = OLEngine(class'Engine'.static.GetEngine());

	if (InputEvent != IE_Pressed)
	{
		return false;
	}

	if (ButtonName == 'XboxTypeS_X')
	{
		ResetConsoleOptions();
		return true;
	}
	else if (ButtonName == 'XboxTypeS_Y')
	{
		Engine.Dingo_ShowHelpUI();
		return true;
	}

	return false;
}


/** Callback when a CLIK widget with enableInitCallback set to TRUE is initialized.  Returns TRUE if the widget was handled, FALSE if not. */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{    
	local bool bWasHandled;
	bWasHandled = TRUE;

	switch(WidgetName)
	{                 
	case ('tabButtons'):
		TabButtons = GFxClikWidget(Widget);
		PopulateTabButtons();
		TabButtons.AddEventListener('CLIK_change', TabChanged);
		break;
	case ('gameplayList'):
		GameplayList = Widget;
		PopulateGeneralOptions();
		break;
	case ('SquareLabel'):
		SquareLabel = Widget;
		SquareLabel.SetText(ResetText);
		break;
	case ('CrossLabel'):
		CrossLabel = Widget;
		CrossLabel.SetText(EnterText);
		break;
	case ('CircleLabel'):
		CircleLabel = Widget;
		CircleLabel.SetText(BackText);
		break;
	case ('TriangleLabel'):
		Widget.SetText(HelpText);
		break;
	default:
		bWasHandled = FALSE;
	}

	return bWasHandled;
}

defaultproperties
{
	SubWidgetBindings.Add((WidgetName="tabButtons",WidgetClass=class'GFxClikWidget'))

	GeneralOptionsWithDifficulty.Empty
	GeneralOptionsWithDifficulty(0) = (bInProfile=FALSE,ProfileSettingId=PSI_Unknown,NonProfileId=NPO_Difficulty,Type=OST_Dropdown)
	GeneralOptionsWithDifficulty(1) = (ProfileSettingId=PSI_Tutorials,Type=OST_CheckBox)
	GeneralOptionsWithDifficulty(2) = (ProfileSettingId=PSI_ShowCrosshair,Type=OST_CheckBox)
	GeneralOptionsWithDifficulty(3) = (ProfileSettingId=PSI_ShowPrompts,Type=OST_CheckBox)
	GeneralOptionsWithDifficulty(4) = (ProfileSettingId=PSI_YInversion,Type=OST_CheckBox)
	GeneralOptionsWithDifficulty(5) = (ProfileSettingId=PSI_Southpaw,Type=OST_CheckBox)
	GeneralOptionsWithDifficulty(6) = (ProfileSettingId=PSI_ControllerSensitivity,Type=OST_Slider,Slider_Minimum=1.f,Slider_Maximum=100.f)
	GeneralOptionsWithDifficulty(7) = (ProfileSettingId=PSI_GamepadConfig,Type=OST_ControllerConfigButton)
	GeneralOptionsWithDifficulty(8) = (ProfileSettingId=PSI_Subtitles,Type=OST_CheckBox)
	GeneralOptionsWithDifficulty(9) = (ProfileSettingId=PSI_Volume,Type=OST_Slider,Slider_Minimum=0.f,Slider_Maximum=1.f)
	GeneralOptionsWithDifficulty(10) = (ProfileSettingId=PSI_GammaSetting,Type=OST_GammaButton)

	GeneralOptionsNoDifficulty.Empty
	GeneralOptionsNoDifficulty(0) = (ProfileSettingId=PSI_Tutorials,Type=OST_CheckBox)
	GeneralOptionsNoDifficulty(1) = (ProfileSettingId=PSI_ShowCrosshair,Type=OST_CheckBox)
	GeneralOptionsNoDifficulty(2) = (ProfileSettingId=PSI_ShowPrompts,Type=OST_CheckBox)
	GeneralOptionsNoDifficulty(3) = (ProfileSettingId=PSI_YInversion,Type=OST_CheckBox)
	GeneralOptionsNoDifficulty(4) = (ProfileSettingId=PSI_Southpaw,Type=OST_CheckBox)
	GeneralOptionsNoDifficulty(5) = (ProfileSettingId=PSI_ControllerSensitivity,Type=OST_Slider,Slider_Minimum=1.f,Slider_Maximum=100.f)
	GeneralOptionsNoDifficulty(6) = (ProfileSettingId=PSI_GamepadConfig,Type=OST_ControllerConfigButton)
	GeneralOptionsNoDifficulty(7) = (ProfileSettingId=PSI_Subtitles,Type=OST_CheckBox)
	GeneralOptionsNoDifficulty(8) = (ProfileSettingId=PSI_Volume,Type=OST_Slider,Slider_Minimum=0.f,Slider_Maximum=1.f)
	GeneralOptionsNoDifficulty(9) = (ProfileSettingId=PSI_GammaSetting,Type=OST_GammaButton)

	GraphicsOptions.Empty
	ControlsOptions.Empty
}