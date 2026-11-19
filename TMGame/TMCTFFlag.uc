/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMCTFFlag extends TMCarriedObject
	native
	abstract;

/** particle system to play when the flag respawns at home base */
var ParticleSystem RespawnEffect;
/** if true the flag is just starting to res out and needs its bright param ramped up*/
var bool bBringUpBright;
/** if true the bright param has peaked and now we need to phase the flag out */
var bool bBringDownFromBright;
/** The Skeletal Mesh of the flag */
var SkeletalMeshComponent SkelMesh;

var repnotify bool  bFadingOut;
var repnotify bool  bRespawning;
var array<MaterialInstanceConstant> MICArray;
var bool bWasClothEnabled;

var	vector	RunningClothVelClamp;
var	vector	HoverboardingClothVelClamp;

var ParticleSystemComponent SuccessfulCaptureSystem;

/** The Flags's light environment */
var DynamicLightEnvironmentComponent LightEnvironment;

var float LastLocationPingTime;

replication
{
	if(Role == ROLE_AUTHORITY)
		bFadingOut, bRespawning;
}
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


simulated event ReplicatedEvent(name VarName)
{
	if(VarName=='bFadingOut')
	{
		if(bFadingOut)
		{
			CustomFadeOutEffects();
		}
	}
	else if(VarName=='bRespawning')
	{
		if(bRespawning)
		{
			CustomRespawnEffects();
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}


simulated function PostBeginPlay()
{
	local int i;
	super.PostBeginPlay();
	for(i=0;i<SkelMesh.Materials.Length;++i)
	{
		MICArray.Insert(i,1);
		MICArray[i] = SkelMesh.CreateAndSetMaterialInstanceConstant(i);
	}
}


// @TODO: Make this native
simulated function Tick(float DeltaTime)
{
	local int i;
	local name TimerInUse;
	if(WorldInfo.NetMode != NM_DEDICATEDSERVER)
	{
		if(bFadingOut)
		{
			TimerInUse='CustomFadeOutEffects';
		}
		else if(bRespawning)
		{
			TimerInUse='bringUpBrightOff';
		}
		if(bBringUpBright)
		{
			for(i=0;i<MICArray.Length;++i)
			{
				MICArray[i].setScalarParameterValue('FlagBrightness',1 - (GetTimerRate(TimerInUse)-GetTimerCount(TimerInUse))/0.5);
			}
		}
		else if(bBringDownFromBright)
		{
			for(i=0;i<MICArray.Length;++i)
			{
				MICArray[i].setScalarParameterValue('FlagOpacity',(GetTimerRate(TimerInUse)-GetTimerCount(TimerInUse))/0.5);
			}
		}
	}
}


/** Update damping on the cloth sim based on what we are doing. */
simulated event OnBaseChainChanged()
{
	local TMPawn TMP;
	TMP = TMPawn(Base);

	if (TMP != None)
	{
//		if(TMVehicle_Hoverboard(Base.Base) != None)
//		{
//			SkelMesh.bClothBaseVelClamp = TRUE;
//			SkelMesh.ClothBaseVelClampRange = HoverboardingClothVelClamp;
//			//`log("HOVERBOARD---------");
//		}
//		else if(TMVehicle_Hoverboard(OldBaseBase) != None)
//		{
//			SkelMesh.bClothBaseVelClamp = TRUE;
//			SkelMesh.ClothBaseVelClampRange = RunningClothVelClamp;
//			SkelMesh.SetAttachClothVertsToBaseBody(FALSE);
//			//`log("RUNNING------");
//		}

		// When pawn is holding flag, make sure attachments are updated in tick
		TMP.Mesh.bForceUpdateAttachmentsInTick = TRUE;
		SkelMesh.SetShadowParent(TMP.Mesh);
		ClearTimer( 'SetFlagDynamicLightToNotBeDynamic' );
		LightEnvironment.bDynamic = TRUE;
		//`log("PARENTING TO PAWN------");
	}
	else
	{
		SkelMesh.bClothBaseVelClamp = FALSE;
		SkelMesh.SetAttachClothVertsToBaseBody(FALSE);
		SkelMesh.SetShadowParent(None);
		LightEnvironment.bDynamic = TRUE;
		SetTimer( 5.0f, FALSE, 'SetFlagDynamicLightToNotBeDynamic' );
		//`log("DROPPED PARENTING TO SELF------");

		// When pawn is no longer holding flag, reset 'force update attachments' flag
		if (TMPawn(OldBase) != None)
		{
			TMPawn(OldBase).Mesh.bForceUpdateAttachmentsInTick = FALSE;
		}
	}
}


/** returns true if should be rendered for passed in player */
simulated function bool ShouldMinimapRenderFor(PlayerController PC)
{
	return bHome || (PC.PlayerReplicationInfo.Team != Team) || (WorldInfo.TimeSeconds - LastLocationPingTime < 5.0);
}


simulated function ClientReturnedHome()
{
	Super.ClientReturnedHome();

	if (HomeBase != None)
	{
		SetBase(HomeBase);
	}
}


// State transitions
function SetHolder(Controller C)
{
	local TMCTFSquadAI S;
	local TMPawn TMP;
	local TMBot B;

	// when the flag is picked up we need to set the flag translation so it doesn't stick in the ground
	SkelMesh.SetTranslation( vect(0.0,0.0,0.0) );
	TMP = TMPawn(C.Pawn);
	LightEnvironment.bDynamic = TRUE;
	SkelMesh.SetShadowParent( TMP.Mesh );

	ClearTimer( 'SetFlagDynamicLightToNotBeDynamic' );

	// AI Related
	B = TMBot(C);
	if ( B != None )
	{
		S = TMCTFSquadAI(B.Squad);
	}
	else if ( PlayerController(C) != None )
	{
		S = TMCTFSquadAI(TMTeamInfo(C.PlayerReplicationInfo.Team).AI.FindHumanSquad());
	}

	if ( S != None )
	{
		S.EnemyFlagTakenBy(C);
	}

	Super.SetHolder(C);
	if ( B != None )
	{
		B.SetMaxDesiredSpeed();
	}
}

function bool ValidHolder(Actor Other)
{
    local Controller C;

    if ( !Super.ValidHolder(Other) )
	{
		return false;
	}

    C = Pawn(Other).Controller;

	if ( WorldInfo.GRI.OnSameTeam(self,C) )
	{
		SameTeamTouch(c);
		return false;
	}

    return true;
}

function SameTeamTouch(Controller C)
{
}

/** Intended to have different flags override if they need custom effects such as material params set on a respawn */
simulated function CustomRespawnEffects()
{
	local int i;

	bRespawning = true;
	bFadingOut = false;
	ClearTimer('CustomFadeOutEffects');
	setTimer(1.0,false,'BringUpBrightOff');

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (RespawnEffect != None)
		{
			WorldInfo.MyEmitterPool.SpawnEmitter(RespawnEffect, Location, Rotation, self);
		}

		bBringUpBright = true;
		bBringDownFromBright = false;
		for(i = 0;i < MICArray.Length; i++)
		{
			MICArray[i].setScalarParameterValue('FlagOpacity', 1.0f);
		}

		bWasClothEnabled = SkelMesh.bEnableClothSimulation;
		SkelMesh.SetEnableClothSimulation(false); // to prevent cloth flag from going nutty due to teleport
	}
}
simulated function bringUpBrightOff()
{
	local int i;

	if(WorldInfo.NetMode != NM_DEDICATEDSERVER)
	{
		bBringUpBright = false;

		for(i=0;i<MICArray.Length;++i)
		{
			MICArray[i].setScalarParameterValue('FlagBrightness',0.0f);
		}

		SkelMesh.SetEnableClothSimulation(bWasClothEnabled); // re-enable from above.
	}

	bRespawning = false;
}

/** intended to have different flags override if they need custom effects just before a flag is returned to it's base */
simulated function CustomFadeOutEffects()
{
	local int i;

	if(WorldInfo.NetMode != NM_DEDICATEDSERVER)
	{
		if(bBringUpBright) // we've been brought up to bright, so now fade down
		{
			bBringUpBright=false;
			bBringDownFromBright=true;
			for(i=0;i<MICArray.Length;++i)
			{
				MICArray[i].setScalarParameterValue('FlagBrightness',0.0f);
			}
		}
		else if(bBringDownFromBright) // we've done the whole sequence, so call super and don't do this any more
		{
			for(i=0;i<MICArray.Length;++i)
			{
				MICArray[i].setScalarParameterValue('FlagOpacity',1.0f);
			}
			bBringDownFromBright = false;
			return;
		}
		else // we haven't done anything, so bring up brights.
		{
			bBringUpBright=true;
		}

		setTimer(0.5,false,'CustomFadeOutEffects');
	}
}

// States
auto state Home
{
	ignores SendHome, Score, Drop;

	function BeginState(Name PreviousStateName)
	{
		// need to reset the flag skel mesh translation
		SetFlagPropertiesToStationaryFlagState();

		CustomRespawnEffects();
		Super.BeginState(PreviousStateName);

		if ( Team != None )
		{
			// note team is none at start of match, but flagstate is already correctly set
			TMGameReplicationInfo(WorldInfo.GRI).SetFlagHome(Team.TeamIndex);
		}

		HomeBase.SetAlarm(false);
		HomeBase.bForceNetUpdate = TRUE;
		bForceNetUpdate = TRUE;
		SetBase(HomeBase);
		HomeBase.ObjectiveChanged();
	}

	function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
		HomeBase.SetAlarm(true);
		HomeBase.bForceNetUpdate = TRUE;
	}

	function SameTeamTouch(Controller C)
	{
		local TMCTFFlag flag;

		if (TMPlayerReplicationInfo(C.PlayerReplicationInfo).bHasFlag)
		{
			// Score!
			flag = TMCTFFlag(TMPlayerReplicationInfo(C.PlayerReplicationInfo).GetFlag());
			TMCTFGame(WorldInfo.Game).ScoreFlag(C, flag);
			SuccessfulCaptureSystem.SetActive(true);
			flag.Score();

			if (C.Pawn != None && TMBot(C) != None && TMBot(C).Squad.GetOrders() == 'Attack')
			{
				TMBot(C).Pawn.SetAnchor(HomeBase);
				TMBot(C).Squad.SetAlternatePathTo(TMCTFSquadAI(TMBot(C).Squad).EnemyFlag.HomeBase, TMBot(C));
			}
		}
	}
}

state Dropped
{
	ignores Drop;

	function SameTeamTouch(Controller c)
	{
		// returned flag
		TMCTFGame(WorldInfo.Game).ScoreFlag(C, self);
		SendHome(C);
	}

	function Timer() // TODO: Look into resetting scalars on endstate too, just in case picked up mid-fade
	{
		if(bFadingOut)
		{
			super.Timer();
			bFadingOut=false;
		}
		else
		{
			bFadingOut = true;
			CustomFadeOutEffects();
			SetTimer(1.0f);
		}

	}
}

/** need to reset the flag skel mesh translation **/
function Drop(optional Controller Killer)
{
	SetFlagPropertiesToStationaryFlagState();

	Super.Drop(Killer);
}


/**
 * This function will set the flag properties back to what they should be when the flag is stationary.  (i.e. dropped or at a flag base
 **/
function SetFlagPropertiesToStationaryFlagState()
{
	SkelMesh.SetTranslation( vect(0.0,0.0,-40.0) );
	LightEnvironment.bDynamic = TRUE;
	SkelMesh.SetShadowParent( None );
	SetTimer( 5.0f, FALSE, 'SetFlagDynamicLightToNotBeDynamic' );
}

/**
 * This is used to set the LightEnvironment to not be dynamic.
 * Basically when a flag is dropped we need to update the LightEnvironment and then set it to not update anymore.
 **/
function SetFlagDynamicLightToNotBeDynamic()
{
	ClearTimer( 'SetFlagDynamicLightToNotBeDynamic' );
	LightEnvironment.bDynamic = FALSE;
}


