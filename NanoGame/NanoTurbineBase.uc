/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoTurbineBase extends Actor
	native
	abstract
	placeable;

struct native LaunchPointInfo
{
	var() vector LaunchVelocity;
	var() bool bForceMaxLaunchVelocity;
	var() SplineActor LaunchSpline;

	var() bool bReverseSpinDir;
	var() bool bTopLaunch;
};
var() editinline array<LaunchPointInfo> LaunchPointList;
var   int        LaunchIdx;

struct native BladeTipInfo
{
	var Name BoneName;
	var float AnimPositionOffset;

	var transient vector BoneLocation;
};
var array<BladeTipInfo> BladeTips;

var transient bool bWaitingToTransition, bUserWantsRelease;
var transient NanoPawn CurrentUser;
var transient int BladeIdx;
var transient float LastLaunchOpportunity;
var transient int   LastLaunchOpportunityIdx;

/** Replicated position in the animation.  Only sent bNetInitial, so that clients can synch up to the server's position */
var transient repnotify float BladeAnimPosition;

var transient float CooldownTimer;
var SkeletalMeshComponent Mesh;
var AnimNodeSequence SeqNode;

var() SoundCue PlayerGrabbedCue;
var() Name PlayerGrabbedSoundMode;

var() repnotify bool    bReverseDirection;
var() AnimNodeSequence  AnimNode;

/** If this Turbine is active **/
var() bool bIsActive;


// OBSOLETE ... move into array
var() vector LaunchVelocity;
var() bool bForceMaxLaunchVelocity;
var() SplineActor LaunchSpline;

cpptext
{
	virtual void PostLoad();
};

replication
{
	if( bNetInitial && Role == ROLE_Authority )
		BladeAnimPosition, bIsActive, bReverseDirection;
}

simulated event ReplicatedEvent( name VarName )
{
	if( VarName == nameof(BladeAnimPosition) )
	{
		// Synch the blade position on the bNetInitial replication
		if (SeqNode == None)
		{
			SeqNode = AnimNodeSequence(Mesh.FindAnimNode('AnimSeq'));
		}
		SeqNode.SetPosition( BladeAnimPosition, FALSE );
	}
	else if( VarName == nameof(bIsActive) )
	{
		TurnTurbineOnOff( bIsActive );
	}
	else if( VarName == nameof(bReverseDirection) )
	{
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// Find the anim seq node that will play the turbine animation
	SeqNode = AnimNodeSequence(Mesh.FindAnimNode('AnimSeq'));
	UpdateSpinDirection();

	TurnTurbineOnOff( bIsActive );
}

simulated function UpdateSpinDirection()
{
	if( SeqNode == None )
	{
		SeqNode = AnimNodeSequence(Mesh.FindAnimNode('AnimSeq'));
	}
	SeqNode.Rate = bReverseDirection ? -1.f : 1.f;
}

simulated function AnimNotify_TurbineLooped()
{
	//`log(`location);
	if( CurrentUser != None && bWaitingToTransition )
	{
		bWaitingToTransition = FALSE;
	}
}

simulated function UserWantsLaunch()
{
	//`log(`location);
	bUserWantsRelease = TRUE;

	if (`TimeSince(LastLaunchOpportunity) < 0.2f)
	{
		LaunchUser( BladeIdx, LaunchPointList[LastLaunchOpportunityIdx].bTopLaunch, LaunchPointList[LastLaunchOpportunityIdx].bReverseSpinDir );
	}
}

simulated function LaunchUser( int Blade, bool bTopLaunch, bool bForReverseSpinDir )
{
	local int Idx, SelectIdx;

	if( BladeIdx == Blade && !bWaitingToTransition )
	{
		SelectIdx = -1;
		for( Idx = 0; Idx < LaunchPointList.Length; Idx++ )
		{
			if( LaunchPointList[Idx].bReverseSpinDir == bForReverseSpinDir &&
				LaunchPointList[Idx].bTopLaunch == bTopLaunch )
			{
				SelectIdx = Idx;
				break;
			}
		}

		if( SelectIdx >= 0 )
		{
			if( CurrentUser != None && bUserWantsRelease && bReverseDirection == bForReverseSpinDir && LaunchIdx < 0 )
			{
				LaunchIdx = SelectIdx;
				CurrentUser.LocalEndSpecialMove('NSM_Turbine');

				CooldownTimer = WorldInfo.TimeSeconds + 5.f;
				TriggerEventClass(class'SeqEvt_NanoTurbine', CurrentUser, 1);
			}
			else
			{
				LastLaunchOpportunity = WorldInfo.TimeSeconds;
				LastLaunchOpportunityIdx = LaunchIdx;
			}
		}
	}
}

simulated function ReleaseUser()
{
	if( CurrentUser != None )
	{
		BladeIdx = -1;
		CurrentUser.LocalEndSpecialMove('NSM_Turbine');

		CooldownTimer = WorldInfo.TimeSeconds + 5.f;
		//TriggerEventClass(class'SeqEvt_NanoTurbine', CurrentUser, 1);
	}
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	TryToAttach( Other );
}

simulated function bool TryToAttach( Actor Other )
{
	local NanoPawn NP;
	local float BestDist, Dist;
	local int Idx;

	if( bIsActive == FALSE )
	{
		return FALSE;
	}

	if( Role == ROLE_Authority )
	{
		if (WorldInfo.TimeSeconds < CooldownTimer)
		{
			return FALSE;
		}
		NP = NanoPawn(Other);
		if( NP != None && NP.bWantsToDash && CurrentUser == None )
		{

			if( SeqNode == None )
			{
				`warn("turbine's animtree is busted, plzfix");
				return FALSE;
			}
			
			// figure out the closest tip
			for (Idx = 0; Idx < BladeTips.Length; Idx++)
			{
				BladeTips[Idx].BoneLocation = Mesh.GetBoneLocation(BladeTips[Idx].BoneName);
			}
			BladeIdx = 0;
			Dist = 0.f;
			BestDist = 0.f;
			for (Idx = 0; Idx < BladeTips.Length; Idx++)
			{
				Dist = VSize(BladeTips[Idx].BoneLocation - NP.Location);
				if (Dist < BestDist || BestDist == 0.f)
				{
					BestDist = Dist;
					BladeIdx = Idx;
				}
			}

			NP.ServerDictateSpecialMove('NSM_Turbine', TRUE, None, self, BladeIdx);
			bWaitingToTransition = TRUE;
			bUserWantsRelease = FALSE;

			TriggerEventClass(class'SeqEvt_NanoTurbine', NP, 0);

			return TRUE;
		}
	}
	return FALSE;
}

simulated event Tick(float DeltaTime)
{
	local NanoPawn NP;

	if( Role == ROLE_Authority )
	{
		if( bIsActive == TRUE )
		{
			// Update the replicated position that will be sent to clients on the initial replication, so they can synch up
			BladeAnimPosition = SeqNode.GetNormalizedPosition() * SeqNode.GetAnimPlaybackLength();

			if( CurrentUser == None )
			{
				foreach TouchingActors( class'NanoPawn', NP )
				{
					TryToAttach( NP );
				}
			}
		}

		if( CurrentUser != None )
		{
			if( !CurrentUser.bWantsToDash && !bUserWantsRelease )
			{
				UserWantsLaunch();
			}			
		}
	}

	UpdateSpinDirection();
}


simulated function OnModifyTurbine( SeqAct_ModifyTurbine InAction )
{
	//`log( `showvar(InAction.bIsActive) );
	TurnTurbineOnOff( InAction.bIsActive );
}


simulated function TurnTurbineOnOff( bool bInActive )
{
	bIsActive = bInActive;
	SeqNode.bPlaying = bIsActive;
}



defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
}
