class OLUIFrontEnd_RecordingList extends OLUIFrontEnd_Screen;

var localized string Title;

var transient GFxObject TitleLabel;

var transient GFxClikWidget ItemList;
var transient GFxClikWidget BackButton;

function Press_Back(GFxClikWidget.EventData ev)
{
	if (MenuManager.MenuType == EMT_TabMenu)
	{
		GetOLPC().HUD.PostSoundEventSelect();
		Back();
	}
	else
	{
		ConsoleCommand("HideMenu");
	}
}

function OnTopMostView(optional bool bPlayOpenAnimation = false)
{   		
	Super.OnTopMostView(bPlayOpenAnimation);

	PopulateItemList();
}

function PopulateItemList()
{
	local int i;
	local GFxObject Obj, DataProvider;
	local array<name> Recordings;
	local array<name> UnreadRecordings;

	DataProvider = CreateArray();

	Recordings = GetOLPC().CompletedRecordingMoments;
	UnreadRecordings = GetOLPC().UnreadRecordingMoments;
	for (i = 0; i < Recordings.length; ++i)
	{
		Obj = CreateObject("Object");
		Obj.SetString("label", LocalizeNarrative("Recordings", Recordings[i] $ "_Title"));
		Obj.SetBool("Unread", UnreadRecordings.Find(Recordings[i]) != -1);
		DataProvider.SetElementObject(i, Obj);
	}

	ItemList.SetObject("dataProvider", DataProvider);
	if (Recordings.length == 0)
	{
		ItemList.SetFloat("selectedIndex", -1);
	}
	else
	{
		ItemList.SetFloat("selectedIndex", 0);
	}
}

function OnItemClick(GFxClikWidget.EventData ev)
{
	if (ev.index < 0 || ev.index >= GetOLPC().CompletedRecordingMoments.length)
	{
		return;
	}

	if (!IsTopMostView())
	{
		`log("## Recording List: OnItemClick but not top-most view - ignoring");
		return;
	}

	GetOLPC().HUD.PostSoundEventEnter();
	GetOLPC().HUD.MuteSelectSound();

	if (class'OLUtils'.static.IsConsole())
	{
		OLUIFrontEnd_RecordingView_Console(MenuManager.RecordingView).Recording = GetOLPC().CompletedRecordingMoments[ev.index];
	}
	else
	{
		OLUIFrontEnd_RecordingView(MenuManager.RecordingView).Recording = GetOLPC().CompletedRecordingMoments[ev.index];
	}
	MenuManager.PushViewByName('RecordingView');
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
			break;
		case ('itemList'):
			ItemList = GFxClikWidget(Widget);
			PopulateItemList();
			ItemList.AddEventListener('CLIK_itemPress', OnItemClick);
			break;
		case ('titleLabel'):
			TitleLabel = Widget;
			TitleLabel.SetText(Title);
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

	if (ButtonName == TabMenuKey)
	{
		MenuManager.PopView();
		return true;
	}
	else if (ButtonName == RecordingMenuKey)
	{
		ConsoleCommand("HideMenu");
		return true;
	}
	else if (ButtonName == EvidenceMenuKey)
	{
		MenuManager.PopView();
		MenuManager.PushViewByName('EvidenceList');
		return true;
	}

	if (ButtonName == 'XboxTypeS_B')
	{	
		if (MenuManager.MenuType == EMT_TabMenu)
		{
			GetOLPC().HUD.PostSoundEventSelect();
			Back();
		}
		else
		{
			ConsoleCommand("HideMenu");
		}

		return true;
	}

	return false;
}

defaultproperties
{
	SubWidgetBindings.Add((WidgetName="backBtn",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="itemList",WidgetClass=class'GFxClikWidget'))
}