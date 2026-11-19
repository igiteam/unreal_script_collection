class SFRMCinematicGame extends GameInfo;

event PlayerController Login(string Portal,	string Options,	out string Error)
{
	local PlayerController NewPlayer;
	
	NewPlayer = Super.Login(Portal,Options,Error);

	//
	bRestartLevel = false;	// let player spawn once in levels that must be restarted after every death
	RestartPlayer(newPlayer);
	bRestartLevel = Default.bRestartLevel;
	//

	return NewPlayer;
}

event PostLogin( PlayerController NewPlayer )
{
	local bool oldDelayedStart;
//	local Interaction I; 
	
	oldDelayedStart = bDelayedStart; 
	bDelayedStart = false;
//	bDelayedStart = true;
	Super.PostLogin( NewPlayer );
	bDelayedStart = oldDelayedStart;

	ZombieWeapon(NewPlayer.Pawn.Weapon).InitializeWeapon();
}

event RestartPlayer(Controller aPlayer)
{
	Super.RestartPlayer(aPlayer);
	Log("DefaultMapInfo is set to "$Level.DefaultMapInfo); 
	Level.DefaultMapInfo.RestartPlayer(aPlayer.Pawn);

}

function bool PickupQuery( Pawn Other, Pickup item )
{
	local bool PickupQueryRetVal; 
	if ((HealthPickup(item) != none) && (other.Health>=100))
	{
		return false;
	}
	
	PickupQueryRetVal = Super.PickupQuery(Other, item); 
	if (!PickupQueryRetVal) // ??
		item.Destroy(); 
		
	return PickupQueryRetVal; 

}
function Logout(Controller Exiting)
{
	Super.Logout(Exiting);
}

function AddDefaultInventory( pawn PlayerPawn )
{
	Super.AddDefaultInventory(PlayerPawn);
}

//Grenade


// Decompiled with UE Explorer.
defaultproperties
{
    bWaitingToStartMatch=true
    HUDType="ZombieGame.BasicHUD"
    DefaultPlayerName="SFRMPlayer"
    GameMessageClass=Class'Engine.GameMessage'
    PlayerControllerClassName="ZombieGame.SFRMPlayerController"
}