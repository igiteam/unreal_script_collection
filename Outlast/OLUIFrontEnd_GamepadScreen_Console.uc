class OLUIFrontEnd_GamepadScreen_Console extends OLUIFrontEnd_Screen;

var transient GFxClikWidget TabButtons;

var int SelectedTabIndex;

/** Configures the view when it is first loaded. */
function OnViewLoaded()
{
	Super.OnViewLoaded();
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{   		
	Super.OnTopMostView(bPlayOpenAnimation);

	// Set selected tab to current config setting
	TabButtons.SetFloat("selectedIndex", MenuManager.OptionsView.GetGamepadConfig());
}

function bool Back()
{
	Pop();
	return true;
}

function OnViewDeactivated()
{
}

function Pop()
{
	if (MenuManager != none)
	{
		MenuManager.PopView();        
	}
}

function PopulateTabButtons()
{
	local OLProfileSettings MyProfile;
	local GFxObject DataProvider;
	local array<name> OptionValueNames;
	local int Idx;

	MyProfile = GetOLPC().ProfileSettings;
	MyProfile.GetProfileSettingValues(PSI_GamepadConfig, OptionValueNames);

	DataProvider = CreateArray();
	for (Idx = 0; Idx < OptionValueNames.length; Idx++)
	{
		DataProvider.SetElementString(Idx, class'UIRoot'.static.SafeCaps(string(OptionValueNames[Idx])));
	}

	TabButtons.SetObject("dataProvider", DataProvider);
	TabButtons.SetFloat("selectedIndex", MenuManager.OptionsView.GetGamepadConfig());
}

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if (InputEvent == IE_Pressed) 
	{
		if (ButtonName == 'XboxTypeS_A')
		{
			GetOLPC().HUD.PostSoundEventEnter();
			GetOLPC().HUD.MuteSelectSound(0.5);

			MenuManager.OptionsView.SetGamepadConfigExternally(SelectedTabIndex);
			GetOLPC().HUD.GamepadConfigChanged();
			Back();
			return true;
		}
		else if (ButtonName == 'XboxTypeS_B')
		{
			GetOLPC().HUD.PostSoundEventSelect();
			Back();
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
		case ('tabButtons'):
			TabButtons = GFxClikWidget(Widget);
			PopulateTabButtons();
			TabButtons.AddEventListener('CLIK_change', TabChanged);
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

function TabChanged(GFxClikWidget.EventData ev)
{
	SelectedTabIndex = ev.index;
	ASUpdateGamepadLabels(ev.index);
}

private function ASUpdateGamepadLabels(int ConfigType) { ActionScriptVoid("updateGamepadLabels"); }

defaultproperties
{
	SubWidgetBindings.Add((WidgetName="tabButtons",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="acceptBtn",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="backBtn",WidgetClass=class'GFxClikWidget'))
}