class OLUIFrontEnd_EvidenceView_Console extends OLUIFrontEnd_Screen;

var name Collectible;

var transient GFxObject ContentsLabel;

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
}

/** Callback when a CLIK widget with enableInitCallback set to TRUE is initialized.  Returns TRUE if the widget was handled, FALSE if not. */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;
	bWasHandled = TRUE;

	switch(WidgetName)
	{
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
	else if (ButtonName == 'XboxTypeS_DPad_Right' || ButtonName == 'Gamepad_LeftStick_Right')
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
	}
	else if (ButtonName == 'XboxTypeS_A')
	{
		return true;
	}
		
	return false;
}

function int GetCurrentPage() { return int(GetFloat("getCurrentPage")); }
function int GetNumPages() { return int(GetFloat("getNumPages")); }
function ASPaginateText() { ActionScriptVoid("PaginateText"); }
function ASNextPage() { ActionScriptVoid("NextPage"); }
function ASPreviousPage() { ActionScriptVoid("PreviousPage"); }

defaultproperties
{
}