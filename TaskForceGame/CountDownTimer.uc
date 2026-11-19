class CountDownTimer extends Info
	placeable;

var()	float	Duration;
var()	float	Step;

var()	Name	TimeUpEvent;

var	float	TimeLeft;
var bool	bActive;

var BasicHUD HUD;

function PostBeginPlay()
{
	Super.PostBeginPlay();
}

function Trigger( actor Other, pawn EventInstigator )
{
	Super.Trigger(Other,EventInstigator);
	
	if(bActive)
	{
		//Hide the timer.
		HUD.ShowTimerDisplay(false);
	
		SetTimer(0.0,false);
		bActive=false;
	}
	else
	{	
		foreach AllActors( class 'ZombieGame.BasicHUD', HUD )
		{
			break;
		}
		
		TimeLeft = Duration;
	
		//Tell the HUD the new time
		HUD.SetNewTime(TimeLeft);
		HUD.ShowTimerDisplay(true);
	
		SetTimer(Step,true);
		bActive=true;
	//	Log(self@"TimeLeft:"@TimeLeft);
	}
}

function Timer()
{
	TimeLeft -= Step;
	if(TimeLeft <= 0.0)
	{
		TimeLeft = 0.0;
		TriggerEvent(TimeUpEvent,Self,None);
		SetTimer(0.0,false);
		bActive=false;
	}
	//Tell the HUD the new time
	HUD.SetNewTime(TimeLeft);
//	Log(self@"TimeLeft:"@TimeLeft);
}


// Decompiled with UE Explorer.
defaultproperties
{
    Step=0.1000000
}