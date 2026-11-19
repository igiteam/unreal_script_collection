class OLUIFrontEnd_GammaScreen_Console extends OLUIFrontEnd_Screen;

/** A cached reference to the profile of the player that owns this menu.  All affected settings will be changed here */
var transient OLProfileSettings   MyProfile;

var localized string GammaLabelText;

var transient GFxClikWidget AcceptButtonCentred;
var transient GFxClikWidget AcceptButton;
var transient GFxClikWidget BackButton;
var transient GFxClikWidget GammaSlider;

var transient GFxObject GammaLabel;

/** Configures the view when it is first loaded. */
function OnViewLoaded()
{
	Super.OnViewLoaded();

	MyProfile = GetOLPC().ProfileSettings;
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
	local float CurrentGammaValue;

	Super.OnTopMostView(bPlayOpenAnimation);

	GetOLPC().HUD.SetGammaCalibrationActive(TRUE);

	// Refresh gamma slider value
	if (GammaSlider != None)
	{
		CurrentGammaValue = GetCurrentGammaSetting();
		GammaSlider.SetFloat("value", CurrentGammaValue);
		GetOLPC().SetGamma(CurrentGammaValue);
	}

	ASDisableBackButton(IsGammaInitialized() == false);
}

function Press_Accept(GFxClikWidget.EventData ev)
{
	OnAccept();
}

function OnAccept()
{
	local float GammaValue;

	GetOLPC().HUD.PostSoundEventEnter();
	GetOLPC().HUD.MuteSelectSound(0.5);

	if (!IsGammaInitialized())
	{
		// Save gamma to profile
		GammaValue = GetOLPC().GetGamma();
		MyProfile.SetProfileSettingValueFloat(PSI_GammaSetting, GammaValue);

		// Remember that gamma has been initialized (so we don't show the screen every time at startup)
		MyProfile.SetProfileSettingValueId(PSI_GammaInitialized, PSB_On);

		//SaveProfile(); // XR-113, no access to account name & account picker yet
	}

	MenuManager.OptionsView.SetGammaExternally(GetOLPC().GetGamma());

	Pop();
}

function Press_Back(GFxClikWidget.EventData ev)
{
	Back();
}

function bool Back()
{
	// Reset Gamma to previous setting
	GetOLPC().SetGamma(GetCurrentGammaSetting());

	Pop();

	return true;
}

function OnViewDeactivated()
{
	GetOLPC().HUD.SetGammaCalibrationActive(FALSE);
}

function Pop()
{
	if (MenuManager != none)
	{
		MenuManager.PopView();        
	}
}

function Change_Slider(GFxClikWidget.EventData ev)
{
	local float FloatValue;

	FloatValue = GammaSlider.GetFloat("value");
	GetOLPC().SetGamma(FloatValue);
}

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if (InputEvent == IE_Pressed)
	{
		if (ButtonName == 'XboxTypeS_B')
		{
			if (IsGammaInitialized())
			{
				GetOLPC().HUD.PostSoundEventSelect();
				Back();
			}

			return true;
		}
		else if (ButtonName == 'XboxTypeS_Y')
		{
			return true;
		}
		else if (ButtonName == 'XboxTypeS_A')
		{
			OnAccept();
			return true;
		}
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
		case ('CrossLabel'):
			CrossLabel = Widget;
			CrossLabel.SetText(AcceptText);
			break;
		case ('CircleLabel'):
			CircleLabel = Widget;
			CircleLabel.SetText(BackText);
			break;
		case ('gammaSld'):
			GammaSlider = GFxClikWidget(Widget);
			GammaSlider.AddEventListener('CLIK_change', Change_Slider);
			GammaSlider.SetFloat("value", GetCurrentGammaSetting());
			break;
		case ('gammaLbl'):
			GammaLabel = Widget;
			GammaLabel.SetText(GammaLabelText);
			break;
		default:
			bWasHandled = FALSE;
	}

	if (!bWasHandled)
	{
		bWasHandled = Super.WidgetInitialized(WidgetName, WidgetPath, Widget);  
	}
	return bWasHandled;
}

function bool IsGammaInitialized()
{
	local int Initialized;
	MyProfile.GetProfileSettingValueId(PSI_GammaInitialized, Initialized);
	
	return (Initialized == PSB_On);
}

function float GetCurrentGammaSetting()
{
	local float GammaSetting;

	if (IsGammaInitialized())
	{
		// Get from Options screen
		return MenuManager.OptionsView.GetCurrentGammaSetting();
	}
	else
	{
		// Get from profile
		MyProfile.GetProfileSettingValueFloat(PSI_GammaSetting, GammaSetting);
		return GammaSetting;
	}
}

private function ASDisableBackButton(bool bDisable) { ActionScriptVoid("DisableBackButton"); }

defaultproperties
{
	SubWidgetBindings.Add((WidgetName="gammaSld",WidgetClass=class'GFxClikWidget'))
}