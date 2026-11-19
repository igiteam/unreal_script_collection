class InfoTrigger extends Trigger;

var() string InfoMessage;

function Touch( actor Other )
{
	super.Touch(Other);

	if (ZombiePlayerPawn(Other) != none)
	{
		BroadcastLocalizedMessage(class'ZombieGame.ZombieInfoMessage', 0, None, None, self);
	}
}

function UnTouch( actor Other )
{
	super.UnTouch(Other);
	
	if (ZombiePlayerPawn(Other) != none)
	{
		BasicHUD(PlayerController(ZombiePlayerPawn(Other).Controller).myHUD).ClearLocalMessages(class'ZombieGame.ZombieInfoMessage');
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    bHidden=false
}