
class SFRMSinglePlayer extends GameInfo
native;

var globalconfig bool bStartInvincible;
var int RestartCount;
var class<Interaction> LevelLoadInteractionClass;

event PlayerController Login(string Portal,	string Options,	out string Error)
{
	local PlayerController NewPlayer;
	
	//log("SFRMSinglePlayer Login");
	//log(Portal);
	//log(Options);
	
	NewPlayer = Super.Login(Portal,Options,Error);
	NewPlayer.ProfileName = ReSpace( ParseOption( Options, "Name" ) );
	log( "Set profile name to" @ NewPlayer.ProfileName );

//	NewPlayer.UpdatePlayer(NewPlayer.ProfileName);

	RestartCount = 0;

	return NewPlayer;
}

function bool CanSpectate( PlayerController Viewer, bool bOnlySpectator, actor ViewTarget )
{
	return Viewer == ViewTarget;
}

event PostLogin( PlayerController NewPlayer )
{
	local bool oldDelayedStart;
	//local Interaction I; 
	
	oldDelayedStart = bDelayedStart;
//	bDelayedStart = false;
	bDelayedStart = true;
	Super.PostLogin( NewPlayer );
	bDelayedStart = oldDelayedStart;

//	if( NewPlayer.Level.DefaultMapInfo.GetCPI() <= 0 )
//	{
		NewPlayer.Player.GUIController.OpenMenu( "MissionInfo" );
//	}
//	else
//	{
//		bRestartLevel = false;
//		RestartPlayer( NewPlayer );
//	}
//	I = NewPlayer.Player.InteractionMaster.AddInteractionByClass(LevelLoadInteractionClass, NewPlayer.Player);
//	NewPlayer.Player.InteractionMaster.SetFocusTo(I, NewPlayer.Player);
//	
//	if ( SFRMInteraction(I) != None )
//	{
//		SFRMInteraction(I).Activate();
//	}

	if(bStartInvincible)
	{
		NewPlayer.bGodMode = true;
	}

	if ( NewPlayer.Pawn != None && ZombieWeapon(NewPlayer.Pawn.Weapon) != None )
	{
		ZombieWeapon(NewPlayer.Pawn.Weapon).InitializeWeapon();
	}
}

function float RatePlayerStart(NavigationPoint N, byte Team, Controller Player)
{
	local int cpi;
	local CheckpointPlayerStart cps;
	
	cpi = level.DefaultMapInfo.GetCPI();

	cps = CheckpointPlayerStart(N);

	if ((cpi == -1) && (cps != none))
	{
		//if we don't have a saved checkpoint, and we're looking at a checkpoint start, don't pick it
		return 0;
	}
	
	if ((cpi != -1) && (cps != none))
	{
		if (cps.CheckpointNumber == cpi)
		{
			//if we have a saved checkpoint, and it's number matches the checkpoint we're looking at, return BIGNUM
			return 10000;
		}
		else
		{
			//if the numbers don't match, don't pick it
			return 0;
		}
	}
	
	return super.RatePlayerStart(N, Team, Player);
}

event RestartPlayer( Controller aPlayer )
{
	local NavigationPoint startSpot;
	local int TeamNum;
	local class<Pawn> DefaultPlayerClass;
	
	++ReStartCount;
	
	//log("RestartCount == "$ReStartCount);
	//log("MySAInteractionAtbegining of restartPlayer = "@SFRMPlayerController (aPlayer).MySAInteraction);
	if(RestartCount == 1)
	{
		if( bRestartLevel && Level.NetMode!=NM_DedicatedServer && Level.NetMode!=NM_ListenServer )
			return;

		if ( (aPlayer.PlayerReplicationInfo == None) || (aPlayer.PlayerReplicationInfo.Team == None) )
			TeamNum = 255;
		else
			TeamNum = aPlayer.PlayerReplicationInfo.Team.TeamIndex;

		startSpot = FindPlayerStart(aPlayer, TeamNum);
		if( startSpot == None )
		{
			log(" Player start not found!!!");
			return;
		}	
		
		if (aPlayer.PreviousPawnClass!=None && aPlayer.PawnClass != aPlayer.PreviousPawnClass)
			BaseMutator.PlayerChangedClass(aPlayer);			
				
		if ( aPlayer.PawnClass != None )
			aPlayer.Pawn = Spawn(aPlayer.PawnClass,,,StartSpot.Location,StartSpot.Rotation);

		if( aPlayer.Pawn==None )
		{
			DefaultPlayerClass = GetDefaultPlayerClass(aPlayer);
			aPlayer.Pawn = Spawn(DefaultPlayerClass,,,StartSpot.Location,StartSpot.Rotation);
		}
		if ( aPlayer.Pawn == None )
		{
			log("Couldn't spawn player of type "$aPlayer.PawnClass$" at "$StartSpot);
			aPlayer.GotoState('Dead');
			return;
		}
		aPlayer.Pawn.Anchor = startSpot;
		aPlayer.Pawn.LastStartSpot = PlayerStart(startSpot);
		aPlayer.Pawn.LastStartTime = Level.TimeSeconds;
		aPlayer.PreviousPawnClass = aPlayer.Pawn.Class;
		aPlayer.Possess(aPlayer.Pawn);
		aPlayer.PawnClass = aPlayer.Pawn.Class;

		aPlayer.Pawn.PlayTeleportEffect(true, true);
		aPlayer.ClientSetRotation(aPlayer.Pawn.Rotation);
		
		AddDefaultInventory(aPlayer.Pawn);
		//Clean out inventory Brett
		
		TriggerEvent( StartSpot.Event, StartSpot, aPlayer.Pawn);
	}
	
	if(!IsXBox() || RestartCount == 2)
	{
		TriggerEvent( aPlayer.Pawn.LastStartSpot.Event, aPlayer.Pawn.LastStartSpot, aPlayer.Pawn);

		if ( SFRMPlayerController(aPlayer) != None && SFRMPlayerController ( aPlayer ).StatMgr != None )
		{
			SFRMPlayerController(aPlayer).StatMgr.MapStart();
		}
	}	
}

function class<Pawn> GetDefaultPlayerClass(Controller C)
{
	log("GetDefaultPlayerClass SFRMSinglePlayer: no PC" $ DefaultPlayerClassName);
	
    return( class<Pawn>( DynamicLoadObject( DefaultPlayerClassName, class'Class' ) ) );
}

/* Send a player to a URL.
	Override to hook in stats code
*/
function SendPlayer( PlayerController aPlayer, string URL )
{
//FIXME_OLDMENUS
//	local MenuManager MM;
//
//	MM = MenuManager(aPlayer.Player.BasePlayerMenu);
//	if (MM != none)
//	{
//		MM.ShowStats(URL, false);
//	}
//	else
//	{
		Level.DefaultMapInfo.ClearCheckpoints();
		SFRMPlayerController(aPlayer).SetLastLevelCompleted();
		super.SendPlayer( aPlayer, URL );
//	}
}

/* Send a player to a URL.
	Override to hook in stats code
*/
event ProcessServerTravel( string URL, bool bItems )
{
//FIXME_OLDMENUS
//	local MenuManager MM;
	local PlayerController P;
	
	foreach DynamicActors( class'PlayerController', P )
	{
		break;
	}

//FIXME_OLDMENUS
//	MM = MenuManager(P.Player.BasePlayerMenu);
//	if (MM != none)
//	{
//		Level.NextURL = "";
//		MM.ShowStats(URL, true);
//	}
//	else
//	{
		DoProcessServerTravel( URL, bItems );
//	}
}

function DoProcessServerTravel( string URL, bool bItems )
{
	Level.NextURL = URL;
	Super.ProcessServerTravel(URL, bItems);
}

//
// Return whether an item should respawn.
//
function bool ShouldRespawn( Pickup Other )
{
	return Other.ReSpawnTime!=0.0;
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


/* Use reduce damage for team modifications, etc.
*/
event int ReduceDamage( int Damage, pawn injured, pawn instigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
	return Damage;
}



// Decompiled with UE Explorer.
defaultproperties
{
    LevelLoadInteractionClass=Class'LevelLoadInteraction'
    bWaitingToStartMatch=true
    DefaultPlayerClassName="ZombieGame.ZombiePlayerPawn"
    HUDType="ZombieGame.BasicHUD"
    DefaultPlayerName="SFRMPlayer"
    GameMessageClass=Class'Engine.GameMessage'
    PlayerControllerClassName="ZombieGame.SFRMPlayerController"
}