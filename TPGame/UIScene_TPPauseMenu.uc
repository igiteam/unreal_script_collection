class UIScene_TPPauseMenu extends UIScene_BaseFrontEnd;

var int CurrMessageBox;

var localized string QuitMessage, QuitTitle;
var localized string LoadMessage, LoadTitle;
var localized string NoIntelMessage, NoIntelTitle;

var UIScene IntelPickupScene;

var array<UILabel> ObjectiveLabels;

event SceneActivated( bool bInitialActivation )
{
	super.SceneActivated(bInitialActivation);

	if (myTPC != None)
		myTPC.ApplyPausePostProcess();
}

event InitScene()
{
	local int idx;
	super.InitScene();

	ObjectiveLabels.Length = 5;
	ObjectiveLabels[0] = UILabel(FindChild('Objective0', true));
	ObjectiveLabels[0].SetValue("");
	ObjectiveLabels[1] = UILabel(FindChild('Objective1', true));
	ObjectiveLabels[1].SetValue("");
	ObjectiveLabels[2] = UILabel(FindChild('Objective2', true));
	ObjectiveLabels[2].SetValue("");
	ObjectiveLabels[3] = UILabel(FindChild('Objective3', true));
	ObjectiveLabels[3].SetValue("");
	ObjectiveLabels[4] = UILabel(FindChild('Objective4', true));
	ObjectiveLabels[4].SetValue("");

	//`log("Objectives length is"@myTPC.Objectives.Length@"Labels length is"@ObjectiveLabels.Length);
	for (idx = 0; idx < myTPC.Objectives.Length && idx < ObjectiveLabels.Length; idx++)
	{
		//`log("Markup is'"$myTPC.Objectives[idx].ObjectiveMarkup$"'");
		ObjectiveLabels[idx].SetDataStoreBinding(myTPC.Objectives[idx].ObjectiveMarkup);
		if (myTPC.Objectives[idx].bCompleted)
			ObjectiveLabels[idx].StringRenderComponent.SetColor(MakeLinearColor(0.2f, 0.2f, 0.2f, 1.0f));
	}

	if (GetWorldInfo().IsConsoleBuild())
	{
		MenuItems[5].wMenuButton.SetVisibility(false);
		MenuItems.Length = MenuItems.Length - 1;
	}

	if (myTPC != None)
		myTPC.ApplyPausePostProcess();

	if (myTPC.bIsDemoMode)
	{
		MenuItems[3].wMenuButton.StringRenderComponent.Fade(1.0f, 0.5f, 0.0f);
		MenuItems[3].bDisabled = true;
	}
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	super.UpdateScene(DeltaTime, WorldInfo);
	myTPC.ConditionalPause(true);
}

function CleanUp()
{
	if (myTPC != None)
	{
		myTPC.TPExitPauseMenu();
	}

	super.CleanUp();
}

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	if ( (EventParms.InputKeyName == 'XboxTypeS_Start' || (EventParms.InputKeyName == 'Escape' && !GetWorldInfo().IsConsoleBuild())) && EventParms.EventType == IE_Released )
	{
		HandleBack();
	}
	else if ( EventParms.InputKeyName == 'XboxTypeS_B' && !GetWorldinfo().UseCircleToAccept() && EventParms.EventType == IE_Released )
	{
		HandleBack();
	}
	else if ( EventParms.InputKeyName == 'XboxTypeS_A' && GetWorldinfo().UseCircleToAccept() && EventParms.EventType == IE_Released )
	{
		HandleBack();
	}
	else
	{
		return Super.CustomInputKey(EventParms);
	}

	return true;
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	switch (MenuIndex)
	{
		case 0:
			//`log("Resume button hit");
			SceneClient.CloseScene(self);
			break;
		case 2:
			//`log("Options button hit");
			myTPC.ClearPausePostProcess();
			break;

		case 3:
			//`log("LoadCheckpoint button hit");
			CurrMessageBox = 3;
			DisplayMessageBox(LoadMessage, LoadTitle);
			break;
			
		case 4:
			//`log("Quit button hit");
			CurrMessageBox = 4;
			DisplayMessageBox(QuitMessage, QuitTitle);
			break;
		case 5:
			//`log("Exit button hit");
			CurrMessageBox = 5;
			DisplayMessageBox(ExitMessage, ExitTitle);
			break;
	}
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	if (bReturnValue)
	{
		switch (CurrMessageBox)
		{
			case 3: // Load checkpoint
				myTPC.OnLoadLastCheckpoint(None);
				SceneClient.CloseScene(self);
				break;

			case 4: // Quit
				myTPC.LocalTravel("entry_master");
				break;

			case 5: // Exit
				myTPC.ConsoleCommand("exit");
				break;
		}
	}
}

