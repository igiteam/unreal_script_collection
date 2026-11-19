class OLUIFrontEnd_EvidenceView extends OLUIFrontEnd_Screen;

var name Collectible;

var transient GFxObject ContentsLabel;
var transient GFxClikWidget BackButton;
var transient GFxClikWidget CloseButton;
var transient GFxClikWidget PreviousButton;
var transient GFxClikWidget NextButton;

var bool bActivatedWithShortcut;

function OnViewLoaded()
{
	Super.OnViewLoaded();
	GetOLPC().HUD.MuteSelectSound();
}

function OnViewActivated()
{
	ContentsLabel.SetString("text", LocalizeNarrative("Documents", Collectible $ ""));
	ASPaginateText();

	if (GetOLPC().HUD.LatestDocumentName == Collectible && GetOLPC().HUD.LatestDocumentTimer > 0.f)
	{
		GetOLPC().HUD.LatestDocumentTimer = 0.f;
		bActivatedWithShortcut = true;
	}
	else
	{
		bActivatedWithShortcut = false;
	}

	// Mark item as read
	GetOLPC().InventoryManager.UnreadDocuments.RemoveItem(Collectible);

	SetFunction("GoBeforeFirstPage", self, nameof(GoBeforeFirstPage));
	SetFunction("GoAfterLastPage", self, nameof(GoAfterLastPage));
}

function Press_Previous(GFxClikWidget.EventData ev)
{
	ASPreviousPage();
}

function Press_Next(GFxClikWidget.EventData ev)
{
	ASNextPage();
}

function Press_Back(GFxClikWidget.EventData ev)
{
	Back();
}

function Press_Close(GFxClikWidget.EventData ev)
{
	ConsoleCommand("HideMenu");
}

function GoBeforeFirstPage()
{
	/*if (bActivatedWithShortcut) {
		ConsoleCommand("HideMenu");
	} else {
		Back();
	}*/
}

function GoAfterLastPage()
{
	//ConsoleCommand("HideMenu");
}

/** Callback when a CLIK widget with enableInitCallback set to TRUE is initialized.  Returns TRUE if the widget was handled, FALSE if not. */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;
	bWasHandled = TRUE;

	switch(WidgetName)
	{
		case ('backBtn'):
			BackButton = GFxClikWidget(Widget);
			BackButton.AddEventListener('CLIK_press', Press_Back);
			BackButton.SetString("label", BackText);
			BackButton.SetVisible(!bActivatedWithShortcut);
			break;
		case ('closeBtn'):
			CloseButton = GFxClikWidget(Widget);
			CloseButton.AddEventListener('CLIK_press', Press_Close);
			CloseButton.SetString("label", CloseText);
			CloseButton.SetVisible(bActivatedWithShortcut);
			break;
		case ('previousBtn'):
			PreviousButton = GFxClikWidget(Widget);
			PreviousButton.AddEventListener('CLIK_press', Press_Previous);
			break;
		case ('nextBtn'):
			NextButton = GFxClikWidget(Widget);
			NextButton.AddEventListener('CLIK_press', Press_Next);
			break;
		case ('contentsLabel'):
			ContentsLabel = Widget;
			if (Collectible != '')
			{
				ContentsLabel.SetString("text", LocalizeNarrative("Documents", Collectible $ ""));
				ASPaginateText();
			}
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

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if (InputEvent != IE_Pressed)
	{
		return false;
	}

	if (ButtonName == 'Escape' || ButtonName == 'XboxTypeS_B')
	{		
		if (bActivatedWithShortcut)
		{
			ConsoleCommand("HideMenu");
		}
		else
		{
			GetOLPC().HUD.PostSoundEventSelect();
			Back();
		}
		return true;
	}
	/*else if (ButtonName == 'XboxTypeS_DPad_Right' || ButtonName == 'Gamepad_LeftStick_Right')
	{
		if (GetCurrentPage() + 1 < GetNumPages())
		{
			ASNextPage();
			GetOLPC().HUD.PostSoundEventSelect();
		}
		return true;
	}
	else if (ButtonName == 'XboxTypeS_DPad_Left' || ButtonName == 'Gamepad_LeftStick_Left')
	{
		if (GetCurrentPage() > 0)
		{
			ASPreviousPage();
			GetOLPC().HUD.PostSoundEventSelect();
		}
		return true;
	}*/
	else if (ButtonName == 'XboxTypeS_A')
	{
		return true;
	}
	else if (ButtonName == TabMenuKey)
	{
		if (InputEvent == IE_Pressed)
		{
			if (bActivatedWithShortcut)
			{
				ASNextPage();
			}
			else
			{
				MenuManager.PopView();
				MenuManager.PopView();
			}
			return true;
		}
	}
	else if (ButtonName == EvidenceMenuKey)
	{
		if (InputEvent == IE_Pressed)
		{
			ASNextPage();
			return true;
		}
	}
	else if (ButtonName == RecordingMenuKey && MenuManager.MenuType == EMT_TabMenu)
	{
		if (InputEvent == IE_Pressed)
		{
			MenuManager.PopView();
			MenuManager.PopView();
			MenuManager.PushViewByName('RecordingList');
			return true;
		}
	}
		
	return false;
}

//function int GetCurrentPage() { return GetInt("getCurrentPage"); }
//function int GetNumPages() { return GetInt("getNumPages"); }
function ASPaginateText() { ActionScriptVoid("PaginateText"); }
function ASNextPage() { ActionScriptVoid("NextPage"); }
function ASPreviousPage() { ActionScriptVoid("PreviousPage"); }

defaultproperties
{
	SubWidgetBindings.Add((WidgetName="backBtn",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="closeBtn",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="previousBtn",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="nextBtn",WidgetClass=class'GFxClikWidget'))
}