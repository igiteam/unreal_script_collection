class OLUIFrontEnd_PauseMenu extends OLUIFrontEnd_Screen;

var localized string ReturnText;
var localized string OptionsText;
var localized string ExitToMenuText;
var localized string SaveAndExitText;
var localized string SaveText;
var localized string ConfirmExitText;
var localized string ConfirmExitInsaneText;
var localized string ConfirmExitTitle;
var localized string ExitToWindowsText;

var transient GFxClikWidget ButtonBar;
var transient bool bHasSaveOption;
var transient bool bShowingConfirmExitDialog;

function OnViewLoaded()
{
	Super.OnViewLoaded();

	SetFunction("OnExitConfirmed", self, nameof(OnExitConfirmed));
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
	Super.OnTopMostView(bPlayOpenAnimation);		
	PopulateButtons();
}

function PopulateButtons()
{
	local int i;
	local GFxObject Obj, DataProvider;
	local OLGame TheGame;
	
	DataProvider = CreateArray();

	i = 0;
	Obj = CreateObject("Object");
	Obj.SetString("label", ReturnText);
	DataProvider.SetElementObject(i, Obj);

	i++;
	Obj = CreateObject("Object");
	Obj.SetString("label", OptionsText);
	DataProvider.SetElementObject(i, Obj);

	TheGame = OLGame(class'WorldInfo'.static.GetWorldInfo().Game);
	if (TheGame != None && TheGame.DifficultyMode != EDM_Insane && class'OLUtils'.static.IsConsole())
	{
		i++;
		Obj = CreateObject("Object");
		Obj.SetString("label", SaveText);
		DataProvider.SetElementObject(i, Obj);

		bHasSaveOption = true;
	}
	else
	{
		bHasSaveOption = false;
	}
	
	i++;
	Obj = CreateObject("Object");
	if (class'OLUtils'.static.IsConsole() || (TheGame != None && TheGame.DifficultyMode == EDM_Insane))
	{
		Obj.SetString("label", ExitToMenuText);
	}
	else
	{
		Obj.SetString("label", SaveAndExitText);
	}
	DataProvider.SetElementObject(i, Obj);

	ButtonBar.SetObject("dataProvider", DataProvider);
	ButtonBar.SetFloat("selectedIndex", 0);
}

private final function OnButtonClick(GFxClikWidget.EventData ev)
{	
	if (ev.index == 0)
	{
		OnReturnButtonPress(ev);
	}
	else if (ev.index == 1)
	{
		OnOptionsButtonPress(ev);
	}
	else if (bHasSaveOption && ev.index == 2)
	{
		OnSaveButtonPress(ev);
	}
	else if ((bHasSaveOption && ev.index == 3) || (!bHasSaveOption && ev.index == 2))
	{
		OnExitToMenuButtonPress(ev);
	}
}

private final function OnReturnButtonPress(GFxClikWidget.EventData ev)
{
	Back();
}

private final function OnOptionsButtonPress(GFxClikWidget.EventData ev)
{
	// don't freak out, this makes perfect sense and is obviously great programming
	MenuManager.PushViewByName('Options');
	MenuManager.PushViewByName('Options');
	MenuManager.PopView();
}

private final function OnSaveButtonPress(GFxClikWidget.EventData ev)
{
	local OLEngine Engine;
	local OLGame TheGame;

	Engine = OLEngine(class'Engine'.static.GetEngine());
	TheGame = OLGame(class'WorldInfo'.static.GetWorldInfo().Game);
	
	if (class'OLUtils'.static.IsDingo() && GetGame().DifficultyMode != EDM_Insane)
	{
		GetOLPC().SavePersistentState();
		MenuManager.SaveLocationList.bSaving = true;
		MenuManager.SaveLocationList.bFromPauseMenu = true;
		MenuManager.SaveLocationList.StartCP = "";
		MenuManager.PushViewByName('SaveLocationList'); 
		MenuManager.PushViewByName('SaveLocationList'); // on purpose: this is not a bad copy-paste
		MenuManager.PopView();
	}
	else if (TheGame != None && Engine != None)
	{
		GetOLPC().SavePersistentState();
		Engine.SelectSaveLocation(string(TheGame.CurrentCheckpointName), OnSaveCompleted);
	}
}

function OnSaveCompleted(bool bSuccess)
{
	if (bSuccess)
	{
		// User saved in a selected save location, back to game
		GetOLPC().HUD.NotifyGameSaved();
		Back();
	}
}

private final function OnExitToMenuButtonPress(GFxClikWidget.EventData ev)
{
	local OLGame TheGame;

	// PIE doesn't ask for confirmation
	if (class'Engine'.static.GetCurrentWorldInfo().IsPlayInEditor())
	{
		ConsoleCommand("quit");
		return;
	}

	TheGame = OLGame(class'WorldInfo'.static.GetWorldInfo().Game);
	if (TheGame != None && TheGame.DifficultyMode == EDM_Insane)
	{
		ASShowConfirmExitDialog(ConfirmExitTitle, ConfirmExitInsaneText, YesText, NoText, "OnExitConfirmed");	
	}
	else
	{
		ASShowConfirmExitDialog(ConfirmExitTitle, ConfirmExitText, YesText, NoText, "OnExitConfirmed");	
	}

	bShowingConfirmExitDialog = true;
}

function OnExitConfirmed(bool bOk)
{
	local OLGame TheGame;

	bShowingConfirmExitDialog = false;

	if (bOk)
	{		
		GetOLPC().SaveBeforeQuitting();

		TheGame = OLGame(class'WorldInfo'.static.GetWorldInfo().Game);
		TheGame.TravelToStartupMap();
	}
	else
	{
		Back();
	}
}


private function ASShowConfirmExitDialog(string title, string message, string okButtonLabel, string cancelButtonLabel, string callbackName) { ActionScriptVoid("ShowConfirmExitDialog"); }

/** Callback when a CLIK widget with enableInitCallback set to TRUE is initialized.  Returns TRUE if the widget was handled, FALSE if not. */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{    
	local bool bWasHandled;
	bWasHandled = true;

	switch(WidgetName)
	{
	case ('buttonBar'):
		ButtonBar = GFxClikWidget(Widget);
		PopulateButtons();
		ButtonBar.AddEventListener('CLIK_itemClick', OnButtonClick);
		break;
	default:
		bWasHandled = false;
	}

	if (!bWasHandled)
	{
		bWasHandled = Super.WidgetInitialized(WidgetName, WidgetPath, Widget);  
	}
	return bWasHandled;
}

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if (ButtonName == EscapeMenuKey && InputEvent == IE_Pressed && !bShowingConfirmExitDialog)
	{
		ConsoleCommand("HideMenu");
		return true;
	}

	return false;
}

defaultproperties
{
	SubWidgetBindings.Add((WidgetName="buttonBar",WidgetClass=class'GFxClikWidget'))
}