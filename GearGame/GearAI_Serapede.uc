//=============================================================================
// Controller for serapede
//
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================

class GearAI_Serapede extends GearAI
	native(AI);

// roam params
var config float MaxRoamDist;
var config float MinRoamDist;

var config float MinTimeBetweenMelees;

var config int TailSegmentBlownOffInARowBeforeTargetChange;

var GearPawn_LocustSerapedeBase Serapede;

/** ref to last pawn that shot off one of our tail segments */
var transient Pawn LastPawnToBlowOffATailSeg;

/** This is used to trace enemy list when rear up **/
var transient Pawn  LastLookEnemy;
var transient FLOAT EnemyLookTime;
var config FLOAT MaxTraceTime;
var config FLOAT MinTraceTime;

/** Go after attack distance when tail got blown off **/
var config FLOAT AttackDistanceWhenTailSegBlownOff;

/** keep track of how many tail segments in a row were blown off by one person */
var transient int NumTailSegsBlownOffBySameDude;

/** Shock Damage Type **/
var INT             ShockDamage;
var config INT      ShockDamageDistance;

cpptext
{
	virtual void	UpdatePawnRotation();

	// overidden to store off the location the 'pede is at when the move starts
	virtual void MoveTo(const FVector& Dest, AActor* ViewFocus, FLOAT DesiredOffset, UBOOL bShouldWalk);
	virtual void MoveToward(AActor* goal, AActor* viewfocus, FLOAT DesiredOffset, UBOOL bStrafe, UBOOL bShouldWalk);
};

function Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn,bVehicleTransition);
	Serapede = GearPawn_LocustSerapedeBase(NewPawn);

}

function bool ShouldMoveToSquad( optional bool bSkipLastPositionCheck, optional Vector TestLocation )
{
	return FALSE;
}

function bool SelectEnemy()
{
	if (Enemy != None && Enemy.IsHumanControlled())
	{
		return true;
	}
	else
	{
		return Super.SelectEnemy();
	}
}

singular function bool StepAsideFor( Pawn ChkPawn );

function bool CanCharge()
{
	//  during cringe, you can't charge
	return (!Serapede.IsDoingSpecialMove(SM_Serapede_Cringe));
}

function TailSegmentBlownOff(Pawn InstigatedBy)
{
	if(InstigatedBy == LastPawnToBlowOffATailSeg)
	{
		NumTailSegsBlownOffBySameDude++;
	}
	else
	{
		NumTailSegsBlownOffBySameDude=1;
	}

	// if the same guy just blew off two in a row, go after him!
	if(NumTailSegsBlownOffBySameDude >= TailSegmentBlownOffInARowBeforeTargetChange && InstigatedBy != Enemy)
	{
		Serapede.PlayAngrySound();
		SetEnemy(InstigatedBy);
		if(!CanCharge() && !GetActiveCommand().ShouldIgnoreNotifies())
		{
			AbortCommand(none,class'AICmd_Attack_Serapede_Charge');
			AbortCommand(none,class'AICmd_Serapede_LostEnemy');
		}
	}
	// if he's close enough, go after him
	else if (CanCharge() && VSizeSq(InstigatedBy.Location - Location) < AttackDistanceWhenTailSegBlownOff*AttackDistanceWhenTailSegBlownOff)
	{
		SetEnemy(InstigatedBy);
	}

	LastPawnToBlowOffATailSeg = InstigatedBy;
	Serapede.LastTailBlownOffTime = WorldInfo.TimeSeconds;
}

function SetEnemy( Pawn NewEnemy )
{
	// If enemy is changing
	if( NewEnemy != Enemy )
	{
		// save off when we acquired an enemy last
		Serapede.LastTargetAcquisitionTime = WorldInfo.TimeSeconds;
	}

	Super.SetEnemy(NewEnemy);

}

/** If tail got shot off recently, melee him, not other guys 
 * Melee gets triggered by react, and I don't want it to overwrite my enemy I set when tail got blown off **/
function bool IsValidMeleeTarget(GearPawn WP, optional bool bSkipZCheck)
{
	if (Super.IsValidMeleeTarget(WP, bSkipZCheck))
	{
		if (`TimeSince(Serapede.LastTailBlownOffTime) < Serapede.TailBlownOffSpeedBoostTime )
		{
			return (LastPawnToBlowOffATailSeg == WP);
		}

		return TRUE;
	}

	return FALSE;
}

function BeginMeleeCommand( Pawn TargetPawn, optional coerce String Reason )
{
	`AILog(GetFuncName());
	if (TargetPawn != None)
	{
		ProcessStimulus(TargetPawn, PT_Force, 'BeginMeleeCommand');
		SetEnemy(TargetPawn);
	}

	if (FindCommandOfClass(class'AICmd_Attack_Serapede_Melee') == None)
	{
		class'AICmd_Attack_Serapede_Melee'.static.Melee(self, TargetPawn);
	}
}

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{
	if (CachedAICommandList == None || CachedAICommandList.IsAllowedToFireWeapon())
	{
		if (NewEnemy != None)
		{
			SetEnemy(NewEnemy);
		}

		if (FindCommandOfClass(class'AICmd_Attack_Serapede_Melee') == None)
		{
			class'AICmd_Attack_Serapede_Melee'.static.Melee(self, InTarget);
		}
	}
}

function StartMeleeAttack()
{
	NotifyDidSomethingInteresting();
}


event bool HandlePathObstruction( Actor BlockedBy )
{
	return TRUE;
}


function bool ShouldAllowWalk()
{
	return false;
}

function React_face_shot(Actor EventInstigator, AIReactChannel OrigChannel)
{
	Serapede.PlayAngrySound();
	MyGearPawn.DoSpecialMove(SM_Serapede_Cringe, TRUE);
}

event SetSquadName( Name NewSquadName, optional bool bLeader )
{
	// I'm in my own squad dag-nabit!
	Super.SetSquadname(name,true);
}

function LostEnemy(Actor EventInstigator, AIReactChannel OrigChannel)
{
	AbortMovementCommands();
	`AILog("LostEnemy!!!");
	class'AICmd_Serapede_LostEnemy'.static.InitCommand(self);
}

function BanzaiAttack()
{
	AutoAcquireEnemy();
}

state Action_Idle
{
Begin:
	// make sure we have a squad
	if (Squad == None)
	{
		SetSquadName('Alpha');
	}

	Sleep(1);
	DefaultCommand.static.InitCommand(self);
}

// these trace functions are for antenna and aimoffset
// whenever rearing up, it clears up trace enemy cache
function ClearUpLookEnemy()
{
	LastLookEnemy = none;
	EnemyLookTime = 0.f;
}

// returns trace point
function vector GetLookPosition()
{
	if (LastLookEnemy != none)
	{
		return LastLookEnemy.Location;
	}
	else if ( Enemy != none )
	{
		return Enemy.Location;
	}

	// any other good position when no enemy is around?
	return Pawn.Location + vector(Pawn.Rotation)*200;
}

simulated function Tick(float DeltaTime)
{
	Super.Tick( DeltaTime );

	// if serapede is rear up
	if (Serapede != none && Serapede.bRearUp )
	{
		if ( LocalEnemyList.Length > 0 )
		{
			if ( LastLookEnemy == none )
			{
				// first one is the best rating
				LastLookEnemy = LocalEnemyList[0].Pawn;
				EnemyLookTime = 0.f;
				Serapede.OffsetLookTime = 0.f;
			}
			else if ( LastLookEnemy != none )
			{
				EnemyLookTime += DeltaTime;
				// if time is expired
				if (EnemyLookTime > MinTraceTime + FRand()*(MaxTraceTime - MinTraceTime))
				{
					// look for somebody else if possible
					if ( LocalEnemyList[0].Pawn!=LastLookEnemy )
					{
						// first one is the best rating
						LastLookEnemy = LocalEnemyList[0].Pawn;
						EnemyLookTime = 0.f;
						Serapede.OffsetLookTime = 0.f;
					}
					else // still same
					{
						// pick somebody else if possible
						// still respect the rating
						if ( LocalEnemyList.Length > 1 )
						{
							// first one is the best rating
							LastLookEnemy = LocalEnemyList[1].Pawn;
							EnemyLookTime = 0.f;
							Serapede.OffsetLookTime = 0.f;
						}
					}
				}
			}
		}

	}
}

/** Shock Damage Wrapper **/
function ShockCommandWrapper( Actor Inst, AIReactChannel OriginatingChannel )
{
	local GearPawn InstigatedBy;
	local FLOAT DistanceToBoneSq, MinDistanceSq, CurDistanceSq;
	local vector VectToEnemy, SocketLoc, MinVectToEnemy;
	local int Index;
	// allow only one closest due to replication limit 
	local name SocketName;

	InstigatedBy = GearPawn(Inst);

	DistanceToBoneSq = ShockDamageDistance*ShockDamageDistance;
	MinDistanceSq = DistanceToBoneSq+1;

	for ( Index = 0; Index<Serapede.ShockSocketNames.Length; ++Index )
	{
		Serapede.Mesh.GetSocketWorldLocationAndRotation(Serapede.ShockSocketNames[Index], SocketLoc);
		VectToEnemy = InstigatedBy.Location - SocketLoc;
		CurDistanceSq = VSizeSq2D(VectToEnemy);
		if ( CurDistanceSq < DistanceToBoneSq && CurDistanceSq < MinDistanceSq && FastTrace(SocketLoc, InstigatedBy.Location) )
		{
			MinDistanceSq = CurDistanceSq;
			SocketName = Serapede.ShockSocketNames[Index];
			MinVectToEnemy = VectToEnemy;
		}
	}

	Serapede.ShockSocketName = SocketName;
	if (SocketName != '')
	{
		Serapede.ShockDir= Normal(MinVectToEnemy);
		// Do damage
		InstigatedBy.TakeDamage( ShockDamage, self, InstigatedBy.Location, MinVectToEnemy, Serapede.ShockDamageType,, Serapede );
		Serapede.AttachShockEffect(SocketName, Serapede.ShockDir);
	}
}

defaultproperties
{
	//MeleeCommand=class'AICmd_Attack_Serapede_Melee'
	DefaultCommand=class'AICmd_Base_Serapede'

	DefaultReactConditions.Empty
	DefaultReactConditionClasses.Empty

	DefaultReactConditionClasses.Add(class'AIReactCond_Grenade')
	DefaultReactConditionClasses.Add(class'AIReactCond_EnteredAvoidanceZone')

	// melee reaction
	Begin Object Class=AIReactCond_EnemyCanBeMeleed Name=EnemyInMeleeRangeReaction0
		bAlwaysNotify=true
		OutputFunction=BeginMeleeCommandWrapper
	End Object
	DefaultReactConditions.Add(EnemyInMeleeRangeReaction0)

	// execute enemy
	Begin Object Class=AIReactCond_GenericCallDelegate Name=ExecutEnemyReaction0
		AutoSubscribeChannels(0)=HaveEnemyToExecute
		OutputFunction=HandleExecuteReactionAndPushExecuteCommand
	End Object
	DefaultReactConditions.Add(ExecutEnemyReaction0)

	// New enemy
	Begin Object class=AIReactCond_NewEnemy Name=NewEnemySerapede0
		bAlwaysNotify=true
	End Object
	DefaultReactConditions.Add(NewEnemySerapede0)

	// shot in the face a bunch
	Begin Object class=AIReactCond_DmgThreshold Name=DmgReact0
		DamageThreshold=500
		MinTimeBetweenActivations=10
		OutputFunction=React_Face_Shot
	End Object
	DefaultReactConditions.Add(DmgReact0)


	// if we lose sight of an enemy move to LKP and look around instead of following there
	Begin Object class=AIReactCond_GenericCallDelegate Name=LKP0
		bAlwaysNotify=true
		OutputFunction=LostEnemy
		AutoSubscribeChannels(0)=LostEnemyVisibility
	End Object
	DefaultReactConditions.Add(LKP0)

	Begin Object Class=AIReactCond_EnemyCloseAndVisible Name=EnemyInShockRangeReaction0
		AutoSubscribeChannels(1)=Hearing
		AutoSubscribeChannels(2)=Force
		DistanceThreshold=1500
		MinTimeBetweenActivations=0.5f
		OutputFunction=ShockCommandWrapper
	End Object
	DefaultReactConditions.Add(EnemyInShockRangeReaction0)

	bCanRevive=false

	bForceHasValidTarget=true
	bIgnoreSquadPosition=true
	bPreferMelee=true

	ShockDamage = 100
}
