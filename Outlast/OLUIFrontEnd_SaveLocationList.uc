class OLUIFrontEnd_SaveLocationList extends OLUIFrontEnd_Screen;

var localized string TitleSaving;
var localized string TitleLoading;
var localized string NewSaveLabel;
var localized string DeleteLabel;

var localized string ConfirmOverwriteTitleText;
var localized string ConfirmOverwriteMsgText;

var localized string ConfirmDeleteTitleText;
var localized string ConfirmDeleteMsgText;

var transient GFxClikWidget BackButton;
var transient GFxClikWidget ButtonBar;
var transient GFxObject TitleLabel;

var transient GFxObject SaveIcon[5];

var transient bool bSaving;
var transient string StartCP;
var transient bool bHasNewSaveOption;
var transient bool bFromPauseMenu;

var transient bool bShowingBadCheckpointMsg;

var transient int OverwritingSaveIdx;
var transient bool bShowingConfirmOverwriteDialog;

var transient int DeleteSaveIdx;
var transient bool bShowingConfirmDeleteDialog;

function bool TrySkipScreen(string StartCPName)
{
	// Skip this screen altogether if there are no previous saves (choose the first by default)
	local OLEngine Engine;

	Engine = OLEngine(class'Engine'.static.GetEngine());
	if (Engine != None)
	{
		Engine.RefreshSaveFiles();

		if (Engine.SaveFiles.length == 0)
		{
			if (MenuManager.MainMenuView.bPendingProfileSaveOnNewGame)
			{
				`log("### Saving pending profile");
				SaveProfile();
			}

			Engine.Dingo_StartNewGameWithNewSave(StartCPName);

			GetOLPC().StopAllSounds();
			Close(true);

			return true;
		}
	}

	return false;
}

function OnViewLoaded()
{
	Super.OnViewLoaded();

	SetFunction("OnConfirmedOverwrite", self, nameof(OnConfirmedOverwrite));
	SetFunction("OnConfirmedDelete", self, nameof(OnConfirmedDelete));
	SetFunction("OnBadCheckpointMsgAcknowledged", self, nameof(OnBadCheckpointMsgAcknowledged));
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
	if (TitleLabel != None)
	{
		if (bSaving)
		{
			TitleLabel.SetString("text", TitleSaving);
		}
		else
		{
			TitleLabel.SetString("text", TitleLoading);
		}
	}
	PopulateSaves();
	
	bShowingBadCheckpointMsg = false;

	Super.OnTopMostView(bPlayOpenAnimation);	

	ASInitButtonFocus();
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

function string GetDifficultyStr(int Difficulty)
{
	if (Difficulty == 0)
	{
		return Localize("Generic", "SaveDifficultyNormal", "OLGame");
	}
	else if (Difficulty == 1)
	{
		return Localize("Generic", "SaveDifficultyHard", "OLGame");
	}
	else if (Difficulty == 2)
	{
		return Localize("Generic", "SaveDifficultyNightmare", "OLGame");
	}
	else if (Difficulty == 3)
	{
		return Localize("Generic", "SaveDifficultyInsane", "OLGame");
	}

	return "";
}

function string GetSaveFileDisplayName(SaveFileInfo SaveFile)
{
	local CheckpointTime SaveFileTime;
	local string DateString, TimeString;
	local int Minutes;
	local string CheckpointTag;
	local OLEngine Engine;

	Engine = OLEngine(class'Engine'.static.GetEngine());
	if (Engine != None)
	{
		CheckpointTag = Engine.Dingo_GetCheckpointTag(SaveFile.CheckpointName);
	}

	SaveFileTime = SaveFile.Time;
	DateString = SaveFileTime.Day $ "/" $ SaveFileTime.Month $ "/" $ SaveFileTime.Year;
	Minutes = FFloor(SaveFileTime.SecondsSinceMidnight/60) % 60;
	TimeString = FFloor(SaveFileTime.SecondsSinceMidnight/3600) $ ":" $ (Minutes < 10 ? "0" : "") $ Minutes;

	if (CheckpointTag != "")
	{
		return Localize("Locations", CheckpointTag, "OLGame") $ "\n" $ DateString $ " " $ TimeString $ "\n" $ GetDifficultyStr(SaveFile.Difficulty);
	}
	else
	{
		return DateString $ " - " $ TimeString;
	}
}

function PopulateSaves()
{
	local OLEngine Engine;
	local int i;
	local int j;
	local GFxObject Obj, DataProvider;

	Engine = OLEngine(class'Engine'.static.GetEngine());
	if (Engine != None)
	{
		Engine.RefreshSaveFiles();

		DataProvider = CreateArray();

		i = 0;
		bHasNewSaveOption = false;

		if (bSaving && Engine.SaveFiles.length < 5)
		{
			Obj = CreateObject("Object");
			Obj.SetString("label", NewSaveLabel);
			DataProvider.SetElementObject(i, Obj);
			SaveIcon[i].GotoAndStop("si00");
			bHasNewSaveOption = true;

			++i;		
		}	
		
		for (j = 0; j < Engine.SaveFiles.length; ++j)
		{
			Obj = CreateObject("Object");
			Obj.SetString("label", "#" $ Engine.SaveFiles[j].SaveFileId $ " - " $ GetSaveFileDisplayName(Engine.SaveFiles[j]));
			DataProvider.SetElementObject(i, Obj);
			SaveIcon[i].GotoAndStop(Engine.Dingo_GetSaveFileIconName(Engine.SaveFiles[j].CheckpointName));
			i++;
		}

		for (i=i; i < 5; i++)
		{
			SaveIcon[i].GotoAndStop("siNone");
		}

		ButtonBar.SetObject("dataProvider", DataProvider);
		ButtonBar.SetFloat("selectedIndex", 0);
	}
}

private final function OnButtonClick(GFxClikWidget.EventData ev)
{
	local OLEngine Engine;
	local int SaveFileIdx;
	local Dingo_LoadGameResult LoadResult;

	Engine = OLEngine(class'Engine'.static.GetEngine());

	if (bHasNewSaveOption && ev.index == 0) // new save
	{
		if (bFromPauseMenu)
		{
			if (Engine.Dingo_SaveGameImmediateToNewSave())
			{
				GetOLPC().HUD.NotifyGameSaved();
				Back();
				ConsoleCommand("HideMenu");
			}
		}
		else
		{
			if (MenuManager.MainMenuView.bPendingProfileSaveOnNewGame)
			{
				`log("### Saving pending profile");
				SaveProfile();
			}

			Engine.Dingo_StartNewGameWithNewSave(StartCP);
			GetOLPC().StopAllSounds();
			Close(true);
		}
	}
	else
	{
		if (bHasNewSaveOption)
		{
			SaveFileIdx = ev.index - 1;
		}
		else
		{
			SaveFileIdx = ev.index;
		}
	
		if (SaveFileIdx >= 0 && SaveFileIdx < Engine.SaveFiles.length)
		{
			if (bSaving)
			{
				bShowingConfirmOverwriteDialog = true;
				OverwritingSaveIdx = SaveFileIdx;
				ASShowConfirmDialog(ConfirmOverwriteTitleText, ConfirmOverwriteMsgText, YesText, NoText, "OnConfirmedOverwrite");	
			}
			else
			{
				LoadResult = Engine.Dingo_LoadSaveGame(Engine.SaveFiles[SaveFileIdx].FileName);

				if (LoadResult == LGR_Success)
				{
					GetOLPC().StopAllSounds();
					Close(true);
				}
				else if (LoadResult == LGR_BadCheckpoint)
				{
					ShowBadCheckpointMsg();
				}
			}
		}
	}
}

function ShowBadCheckpointMsg()
{
	ShowMessageDialog("", Localize("Generic", "DLCUninstalled", "OLGame"), Localize("OLUIFrontEnd_Options", "OKText", "OLGame"), "OnBadCheckpointMsgAcknowledged");
	bShowingBadCheckpointMsg = true;
}

function OnBadCheckpointMsgAcknowledged()
{
	bShowingBadCheckpointMsg = false;
}

function OnConfirmedOverwrite(bool bOk)
{
	local OLEngine Engine;
	
	Engine = OLEngine(class'Engine'.static.GetEngine());
	bShowingConfirmOverwriteDialog = false;

	if (bOk)
	{
		if (bFromPauseMenu)
		{
			if (Engine.Dingo_SaveGameImmediate(Engine.SaveFiles[OverwritingSaveIdx].FileName))
			{
				GetOLPC().HUD.NotifyGameSaved();
				Back();
				ConsoleCommand("HideMenu");
			}
		}
		else
		{
			if (MenuManager.MainMenuView.bPendingProfileSaveOnNewGame)
			{
				`log("### Saving pending profile");
				SaveProfile();
			}

			Engine.Dingo_StartNewGameWithSave(StartCP, Engine.SaveFiles[OverwritingSaveIdx].FileName);
			GetOLPC().StopAllSounds();
			Close(true);
		}
	}
	else
	{
		ReloadScreen();
	}
}

function OnConfirmedDelete(bool bOk)
{
	local OLEngine Engine;

	Engine = OLEngine(class'Engine'.static.GetEngine());
	bShowingConfirmDeleteDialog = false;

	if (bOk)
	{
		`log("## Deleting save game " $ DeleteSaveIdx);
		Engine.Dingo_DeleteSaveGame(Engine.SaveFiles[DeleteSaveIdx].FileName);		
	}

	ReloadScreen();
}

function ReloadScreen()
{
	//Back();
	//MenuManager.PushViewByName('SaveLocationList'); 
	MenuManager.PushViewByName('SaveLocationList'); 
	MenuManager.PopView();
}


event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	local int SelectedIdx;

	if (InputEvent != IE_Pressed)
	{
		return false;
	}

	if (bShowingBadCheckpointMsg)
	{
		if ((ButtonName == 'XboxTypeS_A' || ButtonName == 'XboxTypeS_B'))
		{
			ASHideDialogs();
			bShowingBadCheckpointMsg = false;
			ReloadScreen();
			return true;
		}
	} 
	else
	{
		if (ButtonName == 'XboxTypeS_Y')
		{
			SelectedIdx = int(ButtonBar.GetFloat("selectedIndex"));

			if (!bHasNewSaveOption || SelectedIdx > 0) // new save, ignore
			{
				if (bHasNewSaveOption)
				{
					DeleteSaveIdx = SelectedIdx - 1;
				}
				else
				{
					DeleteSaveIdx = SelectedIdx;
				}

				if (DeleteSaveIdx >= 0)
				{
					`log("## Pressed delete for game " $ DeleteSaveIdx);		
					bShowingConfirmDeleteDialog = true;
					ASShowConfirmDialog(ConfirmDeleteTitleText, ConfirmDeleteMsgText, YesText, NoText, "OnConfirmedDelete");							
				}			
			}

			return true;
		}
	}

	return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
}


function Press_Back(GFxClikWidget.EventData ev)
{
	if (!bShowingBadCheckpointMsg && !bShowingConfirmDeleteDialog && !bShowingConfirmOverwriteDialog)
	{
		Back();
	}
}

private function ShowMessageDialog(string title, string message, string okButtonLabel, string callbackName) { ActionScriptVoid("ShowMessageDialog"); }
private function ASShowConfirmDialog(string title, string message, string okButtonLabel, string cancelButtonLabel, string callbackName) { ActionScriptVoid("ShowConfirmDialog"); }
function ASInitButtonFocus() { ActionScriptVoid("InitButtonFocus"); }
function ASTraceFocus() { ActionScriptVoid("TraceFocus"); }

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{    
	local bool bWasHandled;
	bWasHandled = false;

	switch(WidgetName)
	{
	case ('backBtn'):
		BackButton = GFxClikWidget(Widget);
		BackButton.AddEventListener('CLIK_press', Press_Back);
		BackButton.SetString("label", BackText);
		bWasHandled = true;
		break;
	case ('ChapButtons'):
		ButtonBar = GFxClikWidget(Widget);
		PopulateSaves();
		ButtonBar.AddEventListener('CLIK_itemClick', OnButtonClick);
		bWasHandled = true;
		break;
	case ('ChaptersTitle'):
		TitleLabel = Widget;
		TitleLabel.SetString("text", TitleLoading);
		bWasHandled = true;
		break;
	case ('SaveIcon01'):
		SaveIcon[0] = Widget;
		bWasHandled = true;
		break;
	case ('SaveIcon02'):
		SaveIcon[1] = Widget;
		bWasHandled = true;
		break;
	case ('SaveIcon03'):
		SaveIcon[2] = Widget;
		bWasHandled = true;
		break;
	case ('SaveIcon04'):
		SaveIcon[3] = Widget;
		bWasHandled = true;
		break;
	case ('SaveIcon05'):
		SaveIcon[4] = Widget;
		bWasHandled = true;
		break;
	case ('TriangleLabel'):
		Widget.SetText(DeleteLabel);
		bWasHandled = true;
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

defaultproperties
{
	SubWidgetBindings.Add((WidgetName="ChapButtons",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="backBtn",WidgetClass=class'GFxClikWidget'))
}
