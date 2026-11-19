class OLUIFrontEnd_GamepadScreen extends OLUIFrontEnd_Screen;

var transient GFxClikWidget TabButtons;
var transient GFxClikWidget AcceptButton;
var transient GFxClikWidget BackButton;

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

function Press_Accept(GFxClikWidget.EventData ev)
{
	MenuManager.OptionsView.SetGamepadConfigExternally(SelectedTabIndex);
	Pop();
}

function Press_Back(GFxClikWidget.EventData ev)
{
	Back();
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
		case ('acceptBtn'):
			AcceptButton = GFxClikWidget(Widget);
			AcceptButton.AddEventListener('CLIK_press', Press_Accept);
			AcceptButton.SetString("label", AcceptText);
			break;
		case ('backBtn'):
			BackButton = GFxClikWidget(Widget);
			BackButton.AddEventListener('CLIK_press', Press_Back);
			BackButton.SetString("label", BackText);
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