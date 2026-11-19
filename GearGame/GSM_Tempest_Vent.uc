
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Tempest_Vent extends GearSpecialMove;

/** Body Stance - releasing pod start/stop - loop is in the animtree**/
var	GearPawn.BodyStance	BS_StartVenting;
var	GearPawn.BodyStance	BS_StopVenting;

var GearPawn.BodyStance BS_HoverStartVenting;
var GearPawn.BodyStance BS_HoverStopVenting;

var GearPawn.BodyStance BS_BalconyStartVenting;
var GearPawn.BodyStance BS_BalconyStopVenting;

var transient GearPawn.BodyStance BS_Opening;
var transient GearPawn.BodyStance BS_Closing;

/** HitReaction variable since we want hit reaction during pod is released only on the ground**/
var Array<BodyStance> HitReactionBSList;
/** Pod released or not **/
var transient bool    PodReleased;    
/** Hit Indexing currently playing. Otherwise it will be INDEX_NONE **/
var transient int     HitIndexPlaying;

/** Cached variable to tempest **/
var GearPawn_LocustTempestBase Tempest;

/** Set up animation depending on ground or air **/
function SetupAnimation()
{
	if ( Tempest.bLanded )
	{
		if ( Tempest.bBalconyMode )
		{
			BS_Opening = BS_BalconyStartVenting;
			BS_Closing = BS_BalconyStopVenting;
		}
		else
		{
			BS_Opening = BS_StartVenting;
			BS_Closing = BS_StopVenting;
		}
	}
	else
	{
		BS_Opening = BS_HoverStartVenting;
		BS_Closing = BS_HoverStopVenting;
	}
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	// switch to relead pod mode in the tempest
	Tempest = GearPawn_LocustTempestBase(PawnOwner);		

	Super.SpecialMoveStarted(bForced,PrevMove);

	// set up animation - depending on land or ground
	SetupAnimation();

	/** play opening**/
	PawnOwner.BS_Play(BS_Opening, 1.0, 0.2, 0.2);
	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Opening, TRUE);

	Tempest.StartVentingSounds();

	// clear variablese 
	PodReleased = FALSE;
	HitIndexPlaying = INDEX_NONE;
}

/**
 * Notification called when body stance animation finished playing.
 * @param	SeqNode		- Node that finished playing. You can get to the SkeletalMeshComponent by looking at SeqNode->SkelComponent
 * @param	PlayedTime	- Time played on this animation. (play rate independant).
 * @param	ExcessTime	- how much time overlapped beyond end of animation. (play rate independant).
 */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if (PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_Opening))
	{
		// release pod
		Tempest.ReleasePod(TRUE);	
		PodReleased = TRUE;
	}
	// if currently hit reaction is playing, stop this 
	else if (HitIndexPlaying!=INDEX_NONE)
	{
		StopHitReaction();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// if hit reaction is still playing stop hit reaction
	StopHitReaction();

	// clear variable
	PodReleased = FALSE;

	// Disable end of animation notification.
	PawnOwner.BS_SetAnimEndNotify(BS_Opening, FALSE);

	Tempest.StopVentingSounds();

	// Play stopping animation
	PawnOwner.BS_Play(BS_Closing, 1.0, 0.2, 0.2);

	// Disable releadpod
	Tempest.ReleasePod(FALSE);	

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

function bool CanOverrideMoveWith( ESpecialMove NewMove )
{
	if (NewMove == SM_Tempest_TakeOff)
	{
		return TRUE;
	}
	return Super.CanOverrideMoveWith(NewMove);
}

/** Pick what to play for hit reaction - depending on right or left. Fullbody is random **/
function INT PickHitReactionAnim(GearPawn Victim, class<GearDamageType> DamageType, vector Momentum, vector HitLocation)
{
	local Vector			HitNormal, LookDir, RightDir;
	local FLOAT				DotRight;

	// Try to figure out shot direction.
	// don't use momentum. We just care if hit location is right or left, direction of momentum does not say it was right or left
	HitNormal	= Normal(HitLocation - Victim.Location);
	HitNormal.Z = 0.f;
	HitNormal	= Normal(HitNormal);

	LookDir		= vector(Victim.Rotation);
	RightDir	= vect(0,0,1) cross LookDir;
	RightDir    = Normal(RightDir);
	DotRight	= HitNormal dot RightDir;

	// if tempest
	// since tempest only has right/left animation, it will be just checking dot 
	if( Tempest != None )
	{
		// If right
		if( DotRight >= 0.f )
		{
			if ( FRand() > 0.6777 )
			{
				return 3;
			}
			else
			{
				return 1;
			}
		}
		else
		{
			if ( FRand() > 0.6777 )
			{
				return 2;
			}
			else
			{
				return 0;
			}
		}
	}

	return INDEX_NONE;
}

/** Can it perform Hit Reaction **/
function bool CanPerformFullBodyHitReaction(class<GearDamageType> GDT)
{
	// only can do when pod is released - during loop
	// Also when it's not already playing one
	// check timer, but other than that, let it play every time because
	// otherwise, you have very slim chance to see it.
	// also make sure he's landed - don't do that on the air
	return ( HitIndexPlaying == INDEX_NONE && PodReleased && Tempest.bLanded && PawnOwner.WorldInfo.TimeSeconds - PawnOwner.LastFullBodyHitReactionTime > PawnOwner.MyGearAI.MinFullBodyHitReactionInterval );
}

/** Play Hit Reaction during podrelease - this should happen only during pod is release **/
function PlayHitReaction(const out TakeHitInfo  LastTakeHitInfo)
{
	local class<GearDamageType> GDT;
	local BodyStance BSAnim;

	GDT = class<GearDamageType>(LastTakeHitInfo.DamageType);
	if (CanPerformFullBodyHitReaction(GDT))
	{
		if (LastTakeHitInfo.InstigatedBy!=none)
		{
			HitIndexPlaying = PickHitReactionAnim( PawnOwner, GDT, LastTakeHitInfo.Momentum, LastTakeHitInfo.HitLocation );
			if (HitIndexPlaying!=INDEX_NONE)
			{
				PawnOwner.LastFullBodyHitReactionTime = PawnOwner.WorldInfo.TimeSeconds;

				//`log( "Playing Hit reaction of tempest : "@HitIndexPlaying );
				BSAnim = HitReactionBSList[HitIndexPlaying];
				// time to play
				PawnOwner.BS_Play(BSAnim, 1.0, 0.2, 0.2);
				PawnOwner.BS_SetAnimEndNotify(BSAnim, TRUE);
			}
		}
	}
}

/** Stop Hit Reaction if it is being played **/
function StopHitReaction()
{
	local BodyStance BSAnim;

	if (HitIndexPlaying!=INDEX_NONE)
	{
		BSAnim = HitReactionBSList[HitIndexPlaying];
		PawnOwner.BS_Stop(BSAnim, 0.25f);
		PawnOwner.BS_SetAnimEndNotify(BSAnim, FALSE);
		HitIndexPlaying = INDEX_NONE;
	}
}

defaultproperties
{
	BS_StartVenting=(Stance=((Slot=BS_FullBody,AnimName="PodRelease_Start")))
	BS_StopVenting=(Stance=((Slot=BS_FullBody,AnimName="PodRelease_End")))

	BS_HoverStartVenting=(Stance=((Slot=BS_FullBody,AnimName="PodRelease_Hover_Start")))
	BS_HoverStopVenting=(Stance=((Slot=BS_FullBody,AnimName="PodRelease_Hover_End")))

	BS_BalconyStartVenting=(Stance=((Slot=BS_FullBody,AnimName="PodRelease_Balcony_Start")))
	BS_BalconyStopVenting=(Stance=((Slot=BS_FullBody,AnimName="PodRelease_Balcony_End")))

	HitReactionBSList(0)=(Stance=((Slot=BS_FullBody,AnimName="HitReaction_BackLeft")))
	HitReactionBSList(1)=(Stance=((Slot=BS_FullBody,AnimName="HitReaction_BackRight")))
	HitReactionBSList(2)=(Stance=((Slot=BS_FullBody,AnimName="HitReaction_Large_BackLeft")))
	HitReactionBSList(3)=(Stance=((Slot=BS_FullBody,AnimName="HitReaction_Large_BackRight")))

	bRestoreMovementAfterMove=TRUE
}