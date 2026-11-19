class LevelLoadInteraction extends SFRMInteraction;

var bool IsMP;

/*event Initialized()
{

}
*/

/*
function PostRender( canvas c )
{
	
}
*/

function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	if (Action == EInputAction.IST_Release)
	{
		if ((Key == EInputKey.IK_JOY1) || 
			(Key == EInputKey.IK_Enter) || 
			(Key == EInputKey.IK_Joy13) )
		{
			// check for linear load
			//if( !ViewportOwner.Actor.Level.NoLoadScreen )
			//{
				log("ViewportOwner: " $ ViewportOwner);
				ViewportOwner.Actor.Level.Game.bRestartLevel = false;
				ViewportOwner.Actor.Level.Game.RestartPlayer(ViewportOwner.Actor);
			//}
		
			DeActivate();
			return true;
		}
	}
	
	//eat all input...
	return true;
}


event Activate()
{
	bVisible = true;
	bActive = true; 
	
	//force HUD to draw load screen...
	if (!IsMP)
	{
		BasicHUD(ViewportOwner.Actor.myHUD).ForceLoadScreen = true;
		BasicHUD(ViewportOwner.Actor.myHUD).LoadDone = true;
		//	log("Ac ForceLoadScreen: " $ BasicHUD(ViewportOwner.Actor.myHUD).ForceLoadScreen);
		if (!IsDemo())
		{
			ViewportOwner.bWaitingForController = true;
		}
	}
}

event DeActivate()
{
//	local Actor a;
	bVisible = false;
	bActive = false;
	
	BasicHUD(ViewportOwner.Actor.myHUD).ForceLoadScreen = false;

	/*if(ViewportOwner.Actor.Level.LevelEnterText != "")
	{
		a = ViewportOwner.Actor.spawn(class'TitleDisplay',ViewportOwner.Actor);
		TitleDisplay(a).Message = ViewportOwner.Actor.Level.LevelEnterText;
	}*/
			
//	log("DeAc ForceLoadScreen: " $ BasicHUD(ViewportOwner.Actor.myHUD).ForceLoadScreen);
	Master.RemoveInteraction(self);
}

