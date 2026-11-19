class ZombieMPBot extends ZombieBot;

var TheHill	TheHillActor;
var bool	bMovingToTheHill;
var localized string BotNames[14];


// clean up number of players
function PostBeginPlay ( )
{
	Super.PostBeginPlay ( );
	if ( Level.Game != None )
	{
		Level.Game.NumPlayers++;
	}

	IdlePeripheralVision = 0.0;
	AlertPeripheralVision = 0.0;

	foreach AllActors ( class'TheHill', TheHillActor )
		break;
}

event Destroyed ( )
{
	Super.Destroyed ( );
	if ( Level.Game != None )
	{
		Level.Game.NumPlayers--;
	}
}

// pick a random bot name - Intentionally not calling super
function InitPlayerReplicationInfo()
{
	local int		RandName;
	local string	NewName;
	local int Idx, i;
	local int IdxFailed[6];
	local PlayerReplicationInfo temp;

	NewName = "None";
	RandName = Rand ( 14 );
	if( PlayerReplicationInfo.PlayerName == "" )
	{
		while( NewName == "None" )
		{
			NewName = BotNames[RandName];
			foreach DynamicActors( class'PlayerReplicationInfo', temp )
			{
				if( BotNames[RandName] == temp.PlayerName )
					NewName = "None";
			}
			RandName = Rand ( 14 );
		}
		PlayerReplicationInfo.SetPlayerName( NewName );
	}

	//log ( "InitPlayerReplicationInfo - BotName is"@PlayerReplicationInfo.PlayerName );

	if( Level == None || Level.Game.GameReplicationInfo == None )
		return;

	for( i = 0; i < 6; i++ )
		IdxFailed[i] = 0;

	IdxFailed[5] = 1;
	Idx = -1;

	// get our class
	while( Idx == -1 )
	{
		for( i = 0; i < 7; i++ )
		{
			if( i == 6 )
			{
				IdxFailed[5] = 0;
				break;
			}
			if( IdxFailed[i] != 1 )
				break;
		}
		if( IdxFailed[5] == 0 )
			break;
		Idx = Rand( 5 );
		while( IdxFailed[Idx] == 1 )
			Idx = Rand( 5 );

		if( Level.Game.GameReplicationInfo.GetClassCount( Idx + 1, PlayerReplicationInfo ) >= Level.Game.GameReplicationInfo.ClassLimits[Idx] && 
		    Level.Game.GameReplicationInfo.ClassLimits[Idx] != -1 )
		{
			IdxFailed[Idx] = 1;
			Idx = -1;
		}
	}

	PlayerReplicationInfo.ClassIdx = Idx + 1;

	// pick a default team
	PlayerReplicationInfo.NextClassIdx = PlayerReplicationInfo.ClassIdx;
	if( frand() < 0.5 )
	{
		PlayerReplicationInfo.bTerrorist = false;
	}
	else
	{
		PlayerReplicationInfo.bTerrorist = true;
	}
	PlayerReplicationInfo.bNextTerrorist = PlayerReplicationInfo.bTerrorist;

	PlayerReplicationInfo.MPClientStatus = MPCS_Done;
	PlayerReplicationInfo.bReadyToPlay = true;
}

function InitializeBot( )
{
	local class<MPClass> BotClass;

	BotClass = class'MPClass'.static.GetClassFromIdx ( PlayerReplicationInfo.NextClassIdx );

	//PlayerReplicationInfo.ClassIdx = 2;
	// pick a default team
	//PlayerReplicationInfo.NextClassIdx = PlayerReplicationInfo.ClassIdx;

	// get weapons
	MyPawn.BotWeaponClass[0] = class<ZombieWeapon>( DynamicLoadObject ( class'MPLoadoutMgr'.static.GetClassWeaponClassName ( PlayerReplicationInfo.bNextTerrorist, BotClass ), class'Class' ) );
	MyPawn.BotWeaponClass[1] = class<ZombieWeapon>( DynamicLoadObject ( class'MPLoadoutMgr'.static.GetPistolWeaponClassName ( PlayerReplicationInfo.bNextTerrorist ), class'Class' ) );
	MyPawn.BotWeaponClass[2] = class<ZombieWeapon>( DynamicLoadObject ( class'MPLoadoutMgr'.static.GetExplosiveWeaponClassName ( PlayerReplicationInfo.bNextTerrorist, BotClass ), class'Class' ) );
	MyPawn.BotWeaponClass[3] = class<ZombieWeapon>( DynamicLoadObject ( "Weapons.WeapKnife", class'Class' ) );
	// add the loadout
	MyPawn.AddWeaponLoadout( );
	SwitchToBestWeapon( );

	// update meshes, skins, and speed
	MyPawn.UpdateMPPawnClass( );
	MyPawn.beenSearched = true;
}

// overloaded to make sense for MP
event bool ValidEnemy ( Pawn Other )
{
	local ZombiePawn CheckPawn;

	// check for valid pawn
	CheckPawn = ZombiePawn ( Other );
	if ( CheckPawn == None )
		return false;

	//log ( "ValidEnemy - Validpawn" );
	
	// dead - not valid enemy
	if ( CheckPawn.Health <= 0 )
		return false;

	//log ( "ValidEnemy - Alive" );

	// not a team game ( everyone is an enemy )
	if ( Level.Game != None && !Level.Game.bTeamGame )
		return true;

	//log ( "ValidEnemy - Is Team Game" );

	// has no pri?  I have no PRI?
	if ( CheckPawn.PlayerReplicationInfo == None || PlayerReplicationInfo == None )
		return false;

	//log ( "ValidEnemy - Have PRIs" );

	// same team? 
	if ( CheckPawn.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team )
		return false;

	//log ( "ValidEnemy - Different teams" );

	// must be an enemy
	return true;
}

// overloaded to always go back to Idle
function ReachedNode ( )
{
	if ( bMovingToTheHill )
	{
		bMovingToTheHill = false;
		GotoState ( 'KingOfHillIdle', 'OnHill' );
	}
	else
	{
		GotoState ( 'Idle' );
	}
}

//
//	States and related functions
//

//
// Inactive
// Bot will come here initially and later if something goes wrong
auto state Inactive
{
Begin:
	if( Pawn != None )
		SetViewFocus( None );

	Sleep ( 0.1 );

	GotoState ( 'Idle' );
}

// Idle
// Bot will be in this state when idle
// Spends most time sleeping, waiting for something to happen
state Idle
{
Begin:

	if( SFRMDeathmatch( Level.Game ) != None || SFRMTeamDeathmatch( Level.Game ) != None )
	{
		GotoState( 'DeathmatchIdle' );
	}
	else if( GTKOH( Level.Game ) != None || GTTeamKOH( Level.Game ) != None )
	{
		GotoState( 'KingOfHillIdle' );
	}

	Sleep( 10.0 );
}

// Changed RAF 10/21/2004 to use existing movement state code
state DeathmatchIdle
{
	function GetRandomDest( )
	{
		MoveToNode( Level.PathNodes[Rand( Level.PathNodes.Length )], true );
	}

Begin:

	//if( Enemy != None )
	//	GotoState( 'CloseCombat' );
	//if we have a valid pawn find somewhere to go
	if( Pawn != None )
		GetRandomDest( );

	// shouldn't get here if we have a pawn and GetRandomDest succeeds
	Sleep( 2.0 );
	Goto( 'Begin' );
}

// KingOfHillIdle
// Bot will be in this state when playing GTKOH or GTTeamKOH
// Main objective is to reach hill and kill enemies
state KingOfHillIdle 
{
Begin:

	if ( TheHillActor == None )
	{
		Sleep ( 1.0 );
		Goto ( 'Begin' );
	}

	bMovingToTheHill = true;

	MoveToNode( TheHillActor.NodesOnTheHill[Rand( TheHillActor.NodesOnTheHill.Length )], true );

OnHill:
	Sleep( 100.0 );
	Goto( 'OnHill' );
}

//
// Dead
// Bot is in this state when waiting to respawn
state Dead
{

	function BeginState( )
	{
		local int NumSF, NumTR;
		
		// change teams if needed
		if( Level.Game.bTeamGame )
		{
			// keep team balance in team games
			GetTeamSizes ( NumSF, NumTR );
			if( PlayerReplicationInfo.bTerrorist && (NumTR - NumSF) > 1 )
				PlayerReplicationInfo.bNextTerrorist = false;
			else if( !PlayerReplicationInfo.bTerrorist && (NumSF - NumTR) > 1 )
				PlayerReplicationInfo.bNextTerrorist = true;
		}
		else
		{
			// randomly change between terrorist or SF
			if( frand( ) > 0.7 )
			{
				PlayerReplicationInfo.bNextTerrorist = !PlayerReplicationInfo.bTerrorist;
			}
		}

		//// pick a random class - sometimes
		//if( frand( ) > 0.7 )
		//{
		//	PlayerReplicationInfo.NextClassIdx = Rand( 5 ) + 1;
		//}
	}

Begin:

	// in vip, the gameinfo restarts us manually
	if( GTVIP( Level.Game ) == None && !PlayerReplicationInfo.bOutOfLives )
	{
		// we sleep for respawn delay and then ask to be restarted
		Sleep( 6.0 );

MPStart:

		Level.Game.RestartPlayer( Self );
	}

Done:

	// here when waiting for restart
	Sleep( 100.0 );
	Goto( 'Done' );
}

// defaults...

// Decompiled with UE Explorer.
defaultproperties
{
    PawnClass=Class'ZombieBipedPawn'
}