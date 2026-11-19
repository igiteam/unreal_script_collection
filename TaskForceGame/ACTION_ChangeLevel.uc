class ACTION_ChangeLevel extends ScriptedAction;

var(Action) string URL;
var(Action) bool bShowLoadingMessage;

function bool InitActionFor(ScriptedController C)
{
	local PlayerController pc;
	local Array<ScriptedAction> sa;

	pc = C.Level.GetLocalPlayerController();
	sa = C.SequenceScript.Actions;

	if(pc.Pawn.Health <= 0)
	{
		return true;
	}

	C.Level.DefaultMapInfo.ClearCheckpoints();

	if( !IsDemo() && ( C.ActionNum == 0 || ACTION_NoFade( sa[C.ActionNum-1] ) == none ))
	{
		if( !pc.myHUD.Fading )
		{
			pc.SetLastLevelCompleted();
			pc.myHUD.LevelChangeURL = URL;
			pc.myHUD.OnFadeDone = pc.myHUD.FadeDoneChangeLevel;
			pc.myHUD.Fading = true;
			pc.myHUD.DoneFading = false;
			pc.myHUD.FadeTime = 0;
			pc.GotoState('PlayerFrozen');
		}
	}
	else
	{
		if( Left( URL, 10 ) ~= "S_Menu_Map" )
		{
			// HACK: Play credits before returning to the menu from the last map
			pc.ClientOpenMenu("Credits");
		}
		else if( bShowLoadingMessage )
		pc.SetLastLevelCompleted();
	
		if( bShowLoadingMessage )
			C.Level.ServerTravel(URL, false);
		else
			C.Level.ServerTravel(URL$"?quiet", false);
	}
	return true;	
}

function string GetActionString()
{
	return ActionString;
}



// Decompiled with UE Explorer.
defaultproperties
{
    ActionString="Change level"
}