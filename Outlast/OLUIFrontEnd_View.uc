class OLUIFrontEnd_View extends GFxObject within OLUIFrontEnd;

/** Reference to the manager which drives the front end. */
var OLUIFrontEnd MenuManager;

/** A unique name for this view which can be used to discern it from others. */
var name ViewName;

/** Configures the view when it is first loaded. */
function OnViewLoaded();

/** 
 *  Update the view.  
 *  Called whenever the view becomes the topmost view on the view stack. 
 */
function OnTopMostView(optional bool bPlayOpenAnimation = false)
{
	//`log("Play Open Animation");
}

/** Fired when a view is pushed on to the stack. */
function OnViewActivated();

/** Fired when a view is popped off the stack. */
function OnViewDeactivated();

/** Fired when escape is pressed */
function bool Back()
{
	if (MenuManager != none)
	{
		if (MenuManager.ViewStack.length > 1)
		{
			MenuManager.PopView();
		}
		else
		{
			ConsoleCommand("HideMenu");
		}
	}

	return true;
}

/** Callback when a CLIK widget with enableInitCallback set to TRUE is initialized.  Returns TRUE if the widget was handled, FALSE if not. */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget) 
{
    return false;
}

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	return false;
}

function OnKeyBindingCaptured(name KeyName);
function ASHideDialogs() { ActionScriptVoid("HideAllDialogs"); }

defaultproperties
{  
}