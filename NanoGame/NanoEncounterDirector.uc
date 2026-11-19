/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoEncounterDirector extends Actor
	config(Game);



// this needs to be changed to be:
// threshold in last N seconds
// and then "action" event (e.g. you have been climbing a lot in the last N seconds and now you have been still for ActionThreshold)

struct PlayerAction
{
	var config string ActionName;

	var config int Threshold_Climbing;
	var config int Threshold_Combat;
	var config int Threshold_Escaping;
	var config int Threshold_Hiding;
	var config int Threshold_Moving;
	var config int Threshold_Still;

	var config name ActionThresholdType;
	var config int ActionThreshold;


	// maybe need to add some other restrictions like what chaos tier needs to be at?

};

/** All of the various "actions" that a player can do to cause a proc mission to occur or some other behavior change **/
var config array<PlayerAction> PlayerActions;


/** Allows us to manage how many enemies are spawned at each tier **/
struct ChaosTierNumEnemiesDatum
{
	// maybe have points also here?

	/** How many foes make an "intimate" fight. **/
	var int NumEnemiesForIntimateFighting;

	/** How many foes make an "eviscerate the world" fight. **/
	var int NumEnemiesForEviscerateTheWorldFighting;
};

var config array<ChaosTierNumEnemiesDatum> ChaosTierNumEnemiesData;



/**
 * http://en.wikipedia.org/wiki/Reinforcement
 * So, our "reward" for the player is to spawn an encounter / something for them to do. 
 *
 * 
 * We are going to reward the player for these actions:
 * 
 *  -moving around
 *  -getting to a high position
 *  -camping a metacorp base for some time period
 *  -etc
 * 
 * So based on the above we are "doing" the level pulling and out comes a reward based on some reinforcement schedule.
 * So with that, we can say:  when you go up high you get something based on a reinforcment schedule.  
 * 
 * We have a number of different "rewards"; small and big (heh). 
 *  
 *  
 **/
struct SkinnerReinforcementDatum
{
	var float TimeBetweenSmallRewards;
	var int NumPtsBetweenSmallRewards;

	var float TimeBetweenLargeRewards;
	var int NumPtsBetweenLargeRewards;
};

// prob do this per tier of mindshare?
var config SkinnerReinforcementDatum SkinnerData;


/** Struct to keep track of what player has been doing **/
struct PlayerDoingDatum
{
	var name DoingType;

	var float TimeLastDid;

	var int NumOccurrencesOverLast_10;

	var int NumOccurrencesOverLast_60;
	var array<bool> OccurrencesOverLast_60; // 1 minute

	//var int NumTimesOverLast_120[120]; // 2 minutes

	//var int NumTimesOverLast_300[300]; // 5 minutes
};

var transient array<PlayerDoingDatum> PlayerData;


// some madness here

/** Where the player was last **/
var transient Vector LastLocation;






// the above vars are all of the data for the things we spawn

/** The procedural spawning gets turned on by a kismet action.  So we are not spawning all the time in every map. **/
var transient bool bActive;

/** Whether or not to do NPES logs **/
var config bool bNEDLogging;

/** This is the current state of the director **/
var transient name DirectorState;

/** This is what the director thinks the player is doing. **/
var transient string PlayerIsDoing;
var transient string PlayerIsDoingLong;
var transient string PlayerIsDoingShort;


/** When to update so we are not constantly updating which will probably get expensive **/
var config float TimeBetweenEncounterDirectorTicks;
var transient float TimeToDoEncounterDirector;

/** Threshold for having been doing something **/
var config int ThresholdForConsideredHavingBeenDoingCombat_60;
var config int ThresholdForConsideredHavingBeenDoingClimbing_60;
var config int ThresholdForConsideredHavingBeenStill_60;

var config int ThresholdForConsideredHavingBeenMoving_60;
var config int ThresholdForConsideredHavingBeenEscaping_60;
var config int ThresholdForConsideredHavingBeenHiding_60;

/** If we have just spawned a mission this is the min time we must wait before spawning another Procedural Mission **/
var config float MinTimeBetweenProcMissions;
var transient float LastProcMissionTime;
var transient bool bProcMissionActive;

/** If no proc mission has occurred we want to just fire one off **/
var config float ForceAProcMissionEveryNSeconds;

/** Not certain we need this. **/
var config float ForceAProcMissionNSecondsAfterCombatEnded;

/** Amount of time that must pass after a chaos event to proc missions to spawn again**/
var config float TimeToStartSpawningProcMissionsAfterChaosOccurs;


// others needed
//
// last proc mission time
// store off which proc missions have been done recently
// if no "action" has occurred recently
//


// we should be able to structure the above into enums
// and then make a "player doing set"
//  so like:  
//       playerclimbed and stood still
//       player just escaped the baddies
//       player has been hiding after a long battle
//
//
//    And then put it in to a list of:   mission types  and then map them to when they should occur based on when the NED says
//      that that type of behavior has just happened.







// types of actions things Director can have


// modify the type of combat occurring
var transient bool bShouldSwitchCombatTypes;
var transient name CurrCombatType;


var config float MinDistanceToSpawnProcMission;


// spawn a mission


// spawn a "start combat hook"





function PostBeginPlay()
{
	Super.PostBeginPlay();

	DirectorState = 'Monitoring';
	CurrCombatType = 'CombatIntimate';
}

function string GetDirectorStateCurr()
{
	return DirectorState @ "Player:" @ PlayerIsDoing @ "TimeSinceLastProcMission:" @ `TimeSince(LastProcMissionTime) @ "ForcingOneIn:" @ (ForceAProcMissionEveryNSeconds-`TimeSince(LastProcMissionTime)) ;
}

function string GetDirectorStateLong()
{
	return " " $ PlayerIsDoingLong;
}

function string GetDirectorStateShort()
{
	return " " $ PlayerIsDoingShort;
}


function NanoPawn GetPlayerPawn()
{
	local NanoPC PC;
	foreach LocalPlayerControllers( class'NanoPC', PC )
	{
        break;
	}

	return NanoPawn(PC.Pawn);
}


function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	// only do this every N seconds
	if( ( bActive == TRUE )
		&& ( TimeToDoEncounterDirector < WorldInfo.TimeSeconds )
		)
	{
		DoEncounterDirector();
		TimeToDoEncounterDirector = WorldInfo.TimeSeconds + TimeBetweenEncounterDirectorTicks;
	}
}



function DoEncounterDirector()
{
	//`NEDLog( "DoEncounterDirector" );

	DetermineWhatPlayerIsDoing();
	UpdateWhatPlayerHasBeenDoingLong();
	UpdateWhatPlayerHasBeenDoingShort();

	// so now we know what the player has been doing so we need to react to this and actually do something

	DetermineActionToTake();

}



/** Looks at each of the AIs and sees if they are actively trying to kill a rebel **/
function int GetNumFoesPlayerIsEngagedWith()
{
	local int Retval;
	local NanoPawn_MetaCorpBase Foe;
	local string StateName;

	// find all of the foes and then add them to our list
	foreach WorldInfo.AllPawns( class'NanoPawn_MetaCorpBase', Foe )
	{
		if( Foe.Controller == none )
		{
			continue;
		}

		StateName = String(Foe.Controller.GetStateName());
		if( ( Foe.bDeleteMe == FALSE ) && ( Left(StateName, 6) ~= "Combat" ) )
		{
			Retval++;
		}
	}

	//`NEDLog( "GetNumFoesPlayerIsEngagedWith:" @ Retval );

	return Retval;
}


/** 
 *  This will look at the player and try to make a determination of what they are doing.
 *  Things we care about:
 *  
 *  -movement / standing still
 *  -in combat
 *  -climbing/descending
 *  -if they are close to certain types of things (metacorp bases)
 * 
 *  We will then record each of these things into a list which we can then do some computation on.
 * 
 **/
function DetermineWhatPlayerIsDoing()
{
	local NanoPawn NP;
	local name DoingType;
	local bool bIsDoing;
	local NanoSkill_Jump JumpSkill;
	local int NumFoesFightingWith;
	//local int ChaosTier;
	local bool bPlayerIsInsideHotZone;


	NP = GetPlayerPawn();

	if( NP == none )
	{
		return;
	}

	PlayerIsDoing = ""; // clear the old string as we are about to recreate it

	// so now we determine things!
	JumpSkill = NP.GetSkill(class'NanoSkill_Jump');


	DoingType = 'Climbing';
	bIsDoing = FALSE;
	if( ( NP.Location.Z > LastLocation.Z )
		&& ( JumpSkill.bActive == FALSE )
		)
	{
	    bIsDoing = TRUE;
        PlayerIsDoing $= DoingType $ " ";
	}
	UpdatePlayerData( DoingType, WorldInfo.TimeSeconds, bIsDoing );
	

	DoingType = 'Still';
	bIsDoing = FALSE;
	if( ( VSize(NP.Location - LastLocation) < 16 )
		&& ( JumpSkill.bActive == FALSE )
		)
	{
	    bIsDoing = TRUE;
        PlayerIsDoing $= DoingType $ " ";
	}
	UpdatePlayerData( DoingType, WorldInfo.TimeSeconds, bIsDoing );


	DoingType = 'Moving';
	bIsDoing = FALSE;
	if( ( VSize(NP.Velocity) > 100.0f )
		//&& ( JumpSkill.bActive == FALSE )
		)
	{
	    bIsDoing = TRUE;
		PlayerIsDoing $= DoingType $ " ";
	}
	UpdatePlayerData( DoingType, WorldInfo.TimeSeconds, bIsDoing );


	DoingType = 'Combat';
	bIsDoing = FALSE;
	if( NP.bIsInCombat == TRUE )
	{
	    bIsDoing = TRUE;
        PlayerIsDoing $= DoingType $ " ";
	}
	UpdatePlayerData( DoingType, WorldInfo.TimeSeconds, bIsDoing );


	//ChaosTier = NanoGRI(WorldInfo.GRI).NPES.CurrChaosTier;
	NumFoesFightingWith = GetNumFoesPlayerIsEngagedWith();
	
	DoingType = 'Combat';
	bIsDoing = FALSE;
	if( ( NumFoesFightingWith != 0 ) 
		//&& ( NumFoesFightingWith <= ChaosTierNumEnemiesData[ChaosTier].NumEnemiesForIntimateFighting )
		)
	{
	    bIsDoing = TRUE;
        PlayerIsDoing $= DoingType $ " ";
	}
	UpdatePlayerData( DoingType, WorldInfo.TimeSeconds, bIsDoing );


// 	DoingType = 'CombatMany';
// 	bIsDoing = FALSE;
// 	if( NumFoesFightingWith >= ChaosTierNumEnemiesData[ChaosTier].NumEnemiesForEviscerateTheWorldFighting )
// 	{
// 	    bIsDoing = TRUE;
//         PlayerIsDoing $= DoingType $ " ";
// 	}
// 	UpdatePlayerData( DoingType, WorldInfo.TimeSeconds, bIsDoing );
// 



	if( ( VSize(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn.Location-NanoGRI(WorldInfo.GRI).NPES.Cloud_PacManCenter) < NanoGRI(WorldInfo.GRI).NPES.GetHotZoneRadius() ) )
	{
		bPlayerIsInsideHotZone = TRUE;
	}

	DoingType = 'Hiding';
	bIsDoing = FALSE;
	// if there is chaos
	// and we are out of the hotzone
	// and we are not moving that much
	if( ( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
		&& ( VSize(NP.Location-NanoGRI(WorldInfo.GRI).NPES.Cloud_PacManCenter) > NanoGRI(WorldInfo.GRI).NPES.GetHotZoneRadius() )
		&& ( VSize(LastLocation-NP.Location) < 256.0f )
		&& ( bPlayerIsInsideHotZone == FALSE )
		)
	{
		bIsDoing = TRUE;
		PlayerIsDoing $= DoingType $ " ";
	}
	UpdatePlayerData( DoingType, WorldInfo.TimeSeconds, bIsDoing );


	DoingType = 'Escaping';
	bIsDoing = FALSE;
	// if there is chaos
	// and further away from the pacman center than before
	if( ( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
		&& ( VSize(LastLocation-NanoGRI(WorldInfo.GRI).NPES.Cloud_PacManCenter) < VSize(NP.Location-NanoGRI(WorldInfo.GRI).NPES.Cloud_PacManCenter) )
		&& ( bPlayerIsInsideHotZone == FALSE )
		)
	{
		bIsDoing = TRUE;
		PlayerIsDoing $= DoingType $ " ";
	}
	UpdatePlayerData( DoingType, WorldInfo.TimeSeconds, bIsDoing );



	LastLocation = NP.Location;
	// need to check to see if we are standing near a metacorp base
}


function UpdatePlayerData( const name InDoingType, const float InTime, const bool bWasDoing )
{
	local int Idx;
	local PlayerDoingDatum PDD;


	// find our DoingType and say we were were doing
	for( Idx = 0; Idx < PlayerData.Length; ++Idx )
	{
		// if we are the correct type then go ahead and update the history list
		if( PlayerData[Idx].DoingType == InDoingType )
		{
			//`log( "setting" @ `showvar(InDoingType) @ `showvar(bWasDoing) );
			PDD = PlayerData[Idx];
			UpdatePlayerData_Worker( PDD, InDoingType, InTime, bWasDoing );
			PlayerData[Idx] = PDD;
			return;
		}
	}

// 	// update everyone else to have and added zero
// 	for( Idx = 0; Idx < PlayerData.Length; ++Idx )
// 	{
// 		if( PlayerData[Idx].DoingType != InDoingType )
// 		{
// 			PDD = PlayerData[Idx];
// 			UpdatePlayerData_Worker( PDD, 'null', InTime, FALSE );
// 			PlayerData[Idx] = PDD;
// 		}
// 	}

// 
// 	// weak
// 	for( Idx = 0; Idx < PlayerData.Length; ++Idx )
// 	{
// 		if( PlayerData[Idx].DoingType == InDoingType )
// 		{
// 			return;
// 		}
// 	}

	// so if we get here we did not find the DoingType so we need to add one
	//`log( "fail fest let's add" @ InDoingType );

	PDD.DoingType = InDoingType;
	PDD.OccurrencesOverLast_60.Length = 60;

	// weak
	//`log( `showvar(InDoingType) @ `showvar(PlayerData.Length) );
	for( Idx = 0; Idx < 60; ++Idx )
	{
		UpdatePlayerData_Worker( PDD, InDoingType, InTime, FALSE );
		//`log( `showvar(PDD.OccurrencesOverLast_60[Idx]) );
	}

	UpdatePlayerData_Worker( PDD, InDoingType, InTime, bWasDoing );
	PlayerData.AddItem( PDD );

//	for( Idx = 0; Idx < PlayerData.Length; ++Idx )
//	{
//		`log( `showvar(PDD.OccurrencesOverLast_60[Idx]) );
//	}
}


function UpdatePlayerData_Worker( out PlayerDoingDatum PDD, const name InDoingType, const float InTime, const bool bWasDoing )
{
//	local int idx;

	PDD.NumOccurrencesOverLast_10 -= (PDD.OccurrencesOverLast_60[50] == TRUE) ? 1 : 0;
    PDD.NumOccurrencesOverLast_60 -= (PDD.OccurrencesOverLast_60[0] == TRUE) ? 1 : 0;
	PDD.OccurrencesOverLast_60.Remove( 0, 1 );

	PDD.NumOccurrencesOverLast_10 += (bWasDoing == TRUE) ? 1 : 0;
	PDD.NumOccurrencesOverLast_60 += (bWasDoing == TRUE) ? 1 : 0;
	PDD.OccurrencesOverLast_60.AddItem( bWasDoing );



	//if( InDoingType == 'Still' )
	//{
		//`log( "UpdatePlayerData_Worker" @ `showvar(InDoingType) @ `showvar(PDD.NumOccurrencesOverLast_60) @ `showvar(PDD.NumOccurrencesOverLast_10) @ `showvar(bWasDoing) );
		//for( Idx = 0; Idx < PDD.OccurrencesOverLast_60.Length; ++Idx )
		//{
		//	`log( `showvar(Idx) @ `showvar(PDD.OccurrencesOverLast_60[Idx]) );
		//}
	//}


}


/** So this will update our string with the num seconds that the player has been doing those things in the last 60 seconds **/
function UpdateWhatPlayerHasBeenDoingLong()
{
	local int Idx;

	PlayerIsDoingLong = "";

	// find our DoingType
	for( Idx = 0; Idx < PlayerData.Length; ++Idx )
	{
		PlayerIsDoingLong $= PlayerData[Idx].DoingType $ ":" @ PlayerData[Idx].NumOccurrencesOverLast_60 $ " ";
	}
}

/** So this will update our string with the num seconds that the player has been doing those things in the last 60 seconds **/
function UpdateWhatPlayerHasBeenDoingShort()
{
	local int Idx;

	PlayerIsDoingShort = "";

	// find our DoingType
	for( Idx = 0; Idx < PlayerData.Length; ++Idx )
	{
		PlayerIsDoingShort $= PlayerData[Idx].DoingType $ ":" @ PlayerData[Idx].NumOccurrencesOverLast_10 $ " ";
	}
}



function int GetValueOfDoingType( const name InDoingType, const int InDuration )
{
	local int Idx;
	local int SumOfNonCachedDuration;
	local int PlayerDataIdx;;

	// find our DoingType
	for( Idx = 0; Idx < PlayerData.Length; ++Idx )
	{
		// if we are the correct type then go ahead and update the history list
		if( PlayerData[Idx].DoingType == InDoingType )
		{
			if( InDuration == 60 )
			{
				return PlayerData[Idx].NumOccurrencesOverLast_60;
			}
			
			// so no we need to look back from the end InDuration and sum

			for( PlayerDataIdx = PlayerData[Idx].OccurrencesOverLast_60.Length; PlayerDataIdx > (PlayerData[Idx].OccurrencesOverLast_60.Length-InDuration); PlayerDataIdx-- )
			{
				if( PlayerData[Idx].OccurrencesOverLast_60[PlayerDataIdx-1] == TRUE )
				{
					SumOfNonCachedDuration++;
				}
			}

			return SumOfNonCachedDuration;

		}
	}

	return 0;
}


function DetermineActionToTake()
{
	DetermineActionToTake_Combat();
	DetermineActionToTake_Mission();
	DetermineActionToTake_CombatHook();
}


function bool DetermineActionToTake_Mission()
{
	local bool bShouldSpawnProcMission;
	local NanoProceduralMissionHint Hint;
	local class<NanoProceduralMissionBase> MissionClass;
	local PlayerAction AnAction;
	local NanoGRI NGRI;
	

	if( bProcMissionActive == TRUE )
	{
		return FALSE;
	}

	// if we are not allowed to spawn a proc mission just return here
	if( ( `TimeSince(LastProcMissionTime) < MinTimeBetweenProcMissions )
		)
	{
		return FALSE;
	}

	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);

	// don't spawn a proc mission if chaos is up
	if( NGRI.GetCurrentChaosLevel() > 0 )
	{
		return FALSE;
	}

	// don't spawn a proc mission immediately after chaos ends
	if( `TimeSince(NGRI.GetCurrentChaosManager().TimeChaosLevelLastWasThreatLevelZero) < TimeToStartSpawningProcMissionsAfterChaosOccurs )
	{
		return FALSE;
	}


	// this will break for really small ForceAProcMissionEveryNSeconds
	if( `TimeSince(LastProcMissionTime) > ForceAProcMissionEveryNSeconds )
	{
		bShouldSpawnProcMission = TRUE;
		`NEDLog( "PlayerActionSatisfied" @ "ForceAProcMissionEveryNSeconds" @ `showvar(`TimeSince(LastProcMissionTime)) @ `showvar(ForceAProcMissionEveryNSeconds) );
	}


	if( ( `TimeSince(NGRI.GetCurrentChaosManager().TimeChaosLevelLastWasThreatLevelZero) > ForceAProcMissionNSecondsAfterCombatEnded )
		&& ( NGRI.GetCurrentChaosLevel() == 0 )
		)
	{
		bShouldSpawnProcMission = TRUE;
		`NEDLog( "PlayerActionSatisfied" @ "ForceAProcMissionNSecondsAfterCombatEnded" @ `showvar(`TimeSince(NGRI.GetCurrentChaosManager().TimeChaosLevelLastWasThreatLevelZero)) @ `showvar(ForceAProcMissionNSecondsAfterCombatEnded) );
	}



	if( NanoGRI(WorldInfo.GRI).bTestProcMissions == TRUE )
	{
		bShouldSpawnProcMission = TRUE;
		`NEDLog( "PlayerActionSatisfied" @ "bTestProcMissions" );
	}


	foreach PlayerActions( AnAction )
	{
		if( PlayerActionSatisfied( AnAction ) == TRUE )
		{
			bShouldSpawnProcMission = TRUE;
			`NEDLog( "PlayerActionSatisfied" @ AnAction.ActionName );
			break;
		}
	}

	

	if( bShouldSpawnProcMission == TRUE )
	{
		`NEDLog( GetFuncName() @ `showvar(bShouldSpawnProcMission) );

		Hint = FindClosestProcMissionHint();

		if( Hint != None )
		{
			MissionClass = FindAvailMission( Hint );

			`NEDLog( "DetermineActionToTake_Mission2 SPAWNING" @`showvar(MissionClass) @ `showvar(Hint) );

			NGRI.NPMM.AddMissionToBeSpawned( MissionClass, Hint );

			bProcMissionActive = TRUE;
			Hint.LastMissionTime = WorldInfo.TimeSeconds;
		}
	}


	return TRUE;
}




function NanoProceduralMissionHint FindClosestProcMissionHint()
{
	local NanoProceduralMissionHint Hint;
	local array<NanoProceduralMissionHint> Hints;
	local NanoPawn PlayerPawn;
	local float Dist;
	local NanoProceduralMissionHint BestHint;
	local float BestDist;

	BestDist = 9999999999;

	PlayerPawn = NanoPawn(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn);

	Hints = NanoGRI(WorldInfo.GRI).FindAllProceduralMissionHintsAroundPlayerPawn( PlayerPawn, 4096 );

	`NEDLog( "FindClosestProcMissionHint" @ `showvar(Hints.Length) );

	foreach Hints( Hint )
	{
		if( ( Hint.bIsActive == TRUE )
			&& ( Hint.bProcMissionActive == FALSE )
			)
		{
			Dist = VSize(Hint.Location - PlayerPawn.Location );
			if( ( Dist < BestDist )
				&& ( ( BestHint == None ) || ( Hint.LastMissionTime <= BestHint.LastMissionTime ) )
				&& ( Dist > MinDistanceToSpawnProcMission )
				)
			{
				BestDist = Dist;
				BestHint = Hint;
			}
		}
	}

	return BestHint;
}


function class<NanoProceduralMissionBase> FindAvailMission( const out NanoProceduralMissionHint Hint )
{
	local class<NanoProceduralMissionBase> NPMB;
	local class<NanoProceduralMissionBase> MissionClass;
	local array<String> AllMisisons;
	local string MissionName;


	//// okie we have a number of cases

	// avail missions ALL
	// exclude missions None
	if( ( Hint.WhichMissionsCanSpawnNearHere.Length == 0 )
		&& ( Hint.WhichMissionsCanNotSpawnNearHere.Length == 0 )
		)
	{
		MissionClass = RandomlyChooseAMission();
	}
	else

	// avail missions N
	// exclude missions N / None   (if it is in both lists too bad.  Just spawn from the include)
	if( ( Hint.WhichMissionsCanSpawnNearHere.Length > 0 )
		)
	{
		MissionClass = Hint.WhichMissionsCanSpawnNearHere[Rand(Hint.WhichMissionsCanSpawnNearHere.Length)];
	}

	else


	// avail mission ALL
	// exclude missions N
	if( ( Hint.WhichMissionsCanSpawnNearHere.Length == 0 )
		&& ( Hint.WhichMissionsCanNotSpawnNearHere.Length > 0 )
		)
	{
		AllMisisons = class'NanoProceduralMissionManager'.default.AvailMissions;

		foreach Hint.WhichMissionsCanNotSpawnNearHere( NPMB )
		{
			`NEDLog( "FindAvailMission Removing" @ `showvar(NPMB.Name ) );
			AllMisisons.RemoveItem( String(NPMB.Name) );
		}


		MissionName = "NanoGameContent." $ AllMisisons[Rand(AllMisisons.Length)];
		
		MissionClass = class<NanoProceduralMissionBase>(DynamicLoadObject(MissionName,class'class'));

		`NEDLog( "FindAvailMission Loaded" @ `showvar(MissionName) @ `showvar(MissionClass) );
	}


	return MissionClass;
}




function bool FindMissionLocation( class<NanoProceduralMissionBase> MissionClass )
{
	local WorldInfo WI;
	local NanoGRI NGRI;
	local NanoProceduralMissionHint NMH;
	local class<NanoProceduralMissionBase> NPMB;
	local Vector PossibleSpawnLoc;

	`NEDLog( " FindStartingPoint" @ self );

	WI = class'WorldInfo'.static.GetWorldInfo();
	NGRI = NanoGRI(WI.GRI);

	// lets find a starting spot that works for us
	foreach WI.AllActors( class'NanoProceduralMissionHint', NMH )
	{
		foreach NMH.WhichMissionsCanSpawnNearHere( NPMB )
		{
			if( NPMB == MissionClass )
			{
				PossibleSpawnLoc = NMH.Location;

				// so now we need to check that the player can see us
				if( NGRI.CanPlayerSeeThisLocation( PossibleSpawnLoc ) == TRUE )
				{
					`NEDLog( " FindStartingPoint SUCCESS" @ PossibleSpawnLoc );
					return TRUE;
				}
			}
		}
	}

	`NEDLog( " FindStartingPoint FAILED Perhaps no valid NanoProceduralMissionHint?" );
	return FALSE;
}





// so here for now let's just look at the
function class<NanoProceduralMissionBase> RandomlyChooseAMission()
{
	local string MissionName;
	local int RandIdx;
	local class<NanoProceduralMissionBase> MissionClass;


	RandIdx = Rand(class'NanoProceduralMissionManager'.default.AvailMissions.Length);

	MissionName = "NanoGameContent." $ class'NanoProceduralMissionManager'.default.AvailMissions[RandIdx];


	//MissionClass = class<NanoProceduralMissionBase>(DynamicLoadObject("NanoGameContent.NPM_Messenger",class'class'));
	MissionClass = class<NanoProceduralMissionBase>(DynamicLoadObject(MissionName,class'class'));

	`NEDLog( "RandomlyChooseAMission:" @ `showvar(MissionName) @ `showvar(MissionClass) );

	//NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NPMM.AddMissionToBeSpawned( MissionClass );

	return MissionClass;
}





function bool DetermineActionToTake_CombatHook();


/** This can be possibly used to modify the "difficulty" of the NPES!! **/
function bool DetermineActionToTake_Combat()
{
	local int NumCombatIntimate;
	local int NumCombatMany;
	local name ActiveCombatType;
	local NanoGRI NGRI;

	NumCombatIntimate = GetValueOfDoingType( 'CombatIntimate', 60 );
	NumCombatMany = GetValueOfDoingType( 'CombatMany', 60 );
	

	// if we are not actually in a specific type of combat just bail out
	if( ( NumCombatIntimate < ThresholdForConsideredHavingBeenDoingCombat_60 )
		&& ( NumCombatMany < ThresholdForConsideredHavingBeenDoingCombat_60 )
		)
	{
		return FALSE;
	}

	// Right now the  ThresholdForConsideredHavingBeenDoingCombat_60 is pretty high so we can just use that for switching things up

	bShouldSwitchCombatTypes = TRUE;



	if( NumCombatIntimate > NumCombatMany )
	{
		ActiveCombatType = 'CombatIntimate';
	}
	else if( NumCombatMany > NumCombatIntimate )
	{
		ActiveCombatType = 'CombatMany';
	}


	NGRI = NanoGRI(WorldInfo.GRI);
	// switch them up
	if( ActiveCombatType == 'CombatIntimate' )
	{
		CurrCombatType = 'CombatMany';
		DirectorState = CurrCombatType; 
		NGRI.NPES.MaxNumEnemies = ChaosTierNumEnemiesData[NGRI.NPES.CurrChaosTier].NumEnemiesForIntimateFighting;
	}
	else if( ActiveCombatType == 'CombatMany' )
	{
		CurrCombatType = 'CombatIntimate';
		DirectorState = CurrCombatType; 
		NGRI.NPES.MaxNumEnemies = ChaosTierNumEnemiesData[NGRI.NPES.CurrChaosTier].NumEnemiesForEviscerateTheWorldFighting;
	}



	`NEDLog( "Switched combat types! From" @ ActiveCombatType @ " to " @ CurrCombatType );





	return TRUE;

}


/** When the chaos tier changes we need to update our pts totals and such.  And then over time we will adjust our enemies up/down to match that number. **/
function NotifyChaosTierChange( int NewChaosTier )
{

// do not do this for now.  This should affect the AIBlackBoard instead of modifying NPES

// 	local NanoGRI NGRI;
// 
// 	NGRI = NanoGRI(WorldInfo.GRI);
// 
// 	if( CurrCombatType == 'CombatIntimate' )
// 	{
// 		NGRI.NPES.MaxNumEnemies = ChaosTierNumEnemiesData[NGRI.NPES.CurrChaosTier].NumEnemiesForIntimateFighting;
// 	}
// 	else if( CurrCombatType == 'CombatMany' )
// 	{
// 		NGRI.NPES.MaxNumEnemies = ChaosTierNumEnemiesData[NGRI.NPES.CurrChaosTier].NumEnemiesForEviscerateTheWorldFighting;
// 	}
 }


function bool IsPlayerDoing( const name InQuery )
{
	local bool bPlayerIsInsideHotZone;
	local int NumOfQuery;

	local NanoPC NPC;

	NPC = NanoGRI(WorldInfo.GRI).GetNanoPC();

	
	if( NPC.Pawn == None )
	{
		return FALSE;
	}


	if( ( VSize(NPC.Pawn.Location-NanoGRI(WorldInfo.GRI).NPES.Cloud_PacManCenter) < NanoGRI(WorldInfo.GRI).NPES.GetHotZoneRadius() ) )
	{
		bPlayerIsInsideHotZone = TRUE;
	}

	
	NumOfQuery = GetValueOfDoingType( InQuery, 60 );

	
	if( InQuery == 'Escaping' )
	{
		if( ( InStr( PlayerIsDoing, InQuery ) != INDEX_NONE ) &&( NumOfQuery > ThresholdForConsideredHavingBeenEscaping_60 ) && ( bPlayerIsInsideHotZone == FALSE ) )
		{
			return TRUE;
		}
	}
	else if( InQuery == 'Hiding' )
	{
		if( ( InStr( PlayerIsDoing, InQuery ) != INDEX_NONE ) && ( NumOfQuery > ThresholdForConsideredHavingBeenHiding_60 )  && ( bPlayerIsInsideHotZone == FALSE ) )
		{
			return TRUE;
		}
	}
	else if( InQuery == 'Moving' )
	{
		if( ( InStr( PlayerIsDoing, InQuery ) != INDEX_NONE ) && ( NumOfQuery > ThresholdForConsideredHavingBeenMoving_60 ) )
		{
			return TRUE;
		}

	}
	else if( InStr( PlayerIsDoing, InQuery ) != INDEX_NONE )
	{
		return TRUE;
	}

	return FALSE;
}




function bool PlayerActionSatisfied( const out PlayerAction InPlayerAction )
{
	local bool Retval;

	local int DurationToLook;

	local int NumActionThreshold;

	local int NumClimbing;
	local int NumCombat;
	local int NumEscaping;
	local int NumHiding;
	local int NumMoving;
	local int NumStill;

	Retval = TRUE;

	DurationToLook = 60;

	NumActionThreshold = GetValueOfDoingType( InPlayerAction.ActionThresholdType, InPlayerAction.ActionThreshold );

	NumClimbing = GetValueOfDoingType( 'Climbing', DurationToLook );
	NumCombat = GetValueOfDoingType( 'Combat', DurationToLook );
	NumEscaping = GetValueOfDoingType( 'Escaping', DurationToLook );
	NumHiding = GetValueOfDoingType( 'Hiding', DurationToLook );
	NumMoving = GetValueOfDoingType( 'Moving', DurationToLook );
	NumStill = GetValueOfDoingType( 'Still', DurationToLook );


	//`log( `showvar(InPlayerAction.ActionThresholdType) @ `showvar(NumActionThreshold) );
	if( NumActionThreshold < InPlayerAction.ActionThreshold )
	{
		Retval = FALSE;
		return Retval;
	}


	if( NumClimbing < InPlayerAction.Threshold_Climbing )
	{
		Retval = FALSE;
	}

	if( NumCombat < InPlayerAction.Threshold_Combat )
	{
		Retval = FALSE;
	}

	if( NumEscaping < InPlayerAction.Threshold_Escaping )
	{
		Retval = FALSE;
	}

	if( NumHiding < InPlayerAction.Threshold_Hiding )
	{
		Retval = FALSE;
	}

	if( NumMoving < InPlayerAction.Threshold_Moving )
	{
		Retval = FALSE;
	}

	if( NumStill < InPlayerAction.Threshold_Still )
	{
		Retval = FALSE;
	}



	return Retval;
}




defaultproperties
{
}


/**

next up is to now have this Look at what has spawned and what you have fought recently and change it up

definitely need some longer durations it seems  so like every 5 minutes if you have not had a cool thing spawn that!!!!!


that spawn a cool thing can tell our mission manager stub to spawn something for us to test with!




**/