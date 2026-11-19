class OLUIFrontEnd_TabMenu extends OLUIFrontEnd_Screen;

var localized string ObjectiveText;
var localized string RecordingText;
var localized string EvidenceText;

var transient GFxClikWidget ButtonBar;
var transient GFxObject ObjLabel;
var transient GFxObject InventoryLabel;
var transient GFxClikWidget CloseButton;

function OnViewLoaded()
{
	Super.OnViewLoaded();
	GetOLPC().HUD.MuteSelectSound();
}

function OnViewActivated()
{
	if (GetOLPC().HUD.NewObjectiveTimer > 0.f)
	{
		GetOLPC().HUD.NewObjectiveTimer = 0.f;
	}
}

function PopulateButtons()
{
	local int i;
	local GFxObject Obj, DataProvider;

	DataProvider = CreateArray();

	i = 0;
	Obj = CreateObject("Object");
	Obj.SetString("label", RecordingText);
	DataProvider.SetElementObject(i, Obj);
	
	i++;
	Obj = CreateObject("Object");
	Obj.SetString("label", EvidenceText);
	DataProvider.SetElementObject(i, Obj);

	ButtonBar.SetObject("dataProvider", DataProvider);
	ButtonBar.SetFloat("selectedIndex", 0);
}

private final function OnButtonClick(GFxClikWidget.EventData ev)
{
	switch (ev.index)
	{
	case 0:
		OnRecordingButtonPress(ev);
		break;
	case 1:
		OnEvidenceButtonPress(ev);
		break;
	}
}

private final function OnRecordingButtonPress(GFxClikWidget.EventData ev)
{
	MenuManager.PushViewByName('RecordingList');
}

private final function OnEvidenceButtonPress(GFxClikWidget.EventData ev)
{
	MenuManager.PushViewByName('EvidenceList');
}

private final function OnCloseButtonPress(GFxClikWidget.EventData ev)
{
	Back();
}

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
	case ('objLabel'):
		ObjLabel = Widget;
		if (GetOLPC().CurrentObjective == '')
		{
			ObjLabel.SetString("text", "");
		}
		else
		{
			ObjLabel.SetString("text", ObjectiveText @ Localize("Objectives", "" $ GetOLPC().CurrentObjective, "OLGame"));
		}
		break;
	case ('inventoryLabel'):
		InventoryLabel = Widget;
		InventoryLabel.SetString("text", GetInventoryText());
		break;
	case ('CloseButton'):
		CloseButton = GFxClikWidget(Widget);
		CloseButton.AddEventListener('CLIK_press', OnCloseButtonPress);
		CloseButton.SetString("label", CloseText);
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

function string GetInventoryText()
{
	local string InventoryText;
	local int i, Count;
	local array<string> InventoryNames;
	local string ItemName;

	// Build array of item names
	for (i = 0; i < GetOLPC().InventoryManager.OwnedInventory.length; i++)
	{
		InventoryNames.AddItem(Localize("GameplayItems", string(GetOLPC().InventoryManager.OwnedInventory[i]), "OLGame"));
	}

	// Create comma-separated list, collapsing identical names into one entry with a count
	if (InventoryNames.length > 0)
	{
		// "Inventory: " heading
		InventoryText $= Localize("GameplayItems", "InventoryHeading", "OLGame") $ " ";

		i = 0;
		while (i < InventoryNames.length)
		{
			ItemName = InventoryNames[i];
			if (i > 0)
			{
				InventoryText $= ", ";
			}
			InventoryText $= ItemName;

			// Count duplicates and move to next unique item
			Count = 0;
			while (InventoryNames[i] == ItemName && i < InventoryNames.length) {
				Count++;
				i++;
			}

			// Add multiplier (eg. "Fuse for the Laundry Chute (x2)")
			if (Count > 1)
			{
				InventoryText $= " (x" $ Count $ ")";
			}
		}
	}
	
	return InventoryText;
}

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if (ButtonName == TabMenuKey)
	{
		if (InputEvent == IE_Pressed)
		{
			ConsoleCommand("HideMenu");

			return true;
		}
	}
	else if (ButtonName == RecordingMenuKey)
	{
		if (InputEvent == IE_Pressed)
		{
			MenuManager.PushViewByName('RecordingList');
			return true;
		}
	}
	else if (ButtonName == EvidenceMenuKey)
	{
		if (InputEvent == IE_Pressed)
		{
			MenuManager.PushViewByName('EvidenceList');
			return true;
		}
	}

	return false;
}

defaultproperties
{
	SubWidgetBindings.Add((WidgetName="buttonBar",WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="CloseButton",WidgetClass=class'GFxClikWidget'))
}