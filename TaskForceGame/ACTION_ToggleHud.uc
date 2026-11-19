class ACTION_ToggleHud extends ScriptedAction;

var(Action) bool bShow;		// boolean whether to turn the HUD on or off.

function bool InitActionFor(ScriptedController C)
{
	local PlayerController PC;
	
	ForEach C.DynamicActors(class'PlayerController',PC)
		break;
	
	if(bShow)
	{	
		BasicHud(PC.myHUD).ShowHud(true);
	}
	else
	{
		BasicHud(PC.myHUD).HideHud(true);
	}
	return false;	
}
