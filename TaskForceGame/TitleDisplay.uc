class TitleDisplay extends Actor;

var localized string message;
var float delay;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	SetTimer(delay,false);
}

function Timer()
{
	Super.Timer();
	
	if(Owner.IsA('PlayerController'))
	{
		PlayerController(Owner).ClientMessage( Message, 'ZombieTeleTypeMessage' ); 
	}
	
	Destroy();
}

function string GetLocalMsg()
{
	return message;
}


// Decompiled with UE Explorer.
defaultproperties
{
    Delay=2.0000000
}