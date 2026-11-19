/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GSM_LambentDrudge_Mutate extends GearSpecialMove;

/** Pre-mutation freakout anim */
var() BodyStance BS_FreakOutAnimation;
/** Store a reference to the Drudge pawn */
var protected transient GearPawn_LambentDroneMutatable Drudge;
/** Time the mutation started */
var protected transient float MutationStartTime;
/** The scale that the Drudge mesh was before mutation */
var protected transient float PreMutationMeshScale;


/**
 * Notification called when body stance animation finished playing.
 * @param	SeqNode		- Node that finished playing. You can get to the SkeletalMeshComponent by looking at SeqNode->SkelComponent
 * @param	PlayedTime	- Time played on this animation. (play rate independant).
 * @param	ExcessTime	- how much time overlapped beyond end of animation. (play rate independant).
 */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if ( PawnOwner.SpecialMoveFlags!=0 )
	{
		PlayTransform();
		PawnOwner.SpecialMoveFlags = 0;
	}
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	Drudge = GearPawn_LambentDroneMutatable(PawnOwner);
	PreMutationMeshScale = Drudge.Mesh.Scale;

	// need to switch tree first so that it can play in the same tree
	if( PawnOwner.SpecialMoveFlags != 0 )
	{
		Drudge = GearPawn_LambentDroneMutatable(PawnOwner);
		Drudge.SwitchAnimTree();
		
		// Update health based on combination of mutations
		if( Drudge.IsLegMutation(PawnOwner.SpecialMoveFlags) )
		{
			Drudge.Health += Drudge.Transforms[ETS_LEGS].Health;
			if( Drudge.IsHeadMutation(PawnOwner.SpecialMoveFlags) )
			{
				Drudge.Health += Drudge.Transforms[ETS_HEAD].Health * 0.5f;
			}
			else if( Drudge.IsArmMutation(PawnOwner.SpecialMoveFlags) )
			{
				Drudge.Health += Drudge.Transforms[ETS_ARMS].Health * 0.5f;
			}
		}
		else if( Drudge.IsHeadMutation(PawnOwner.SpecialMoveFlags) )
		{
			Drudge.Health += Drudge.Transforms[ETS_HEAD].Health;
			if( Drudge.IsArmMutation(PawnOwner.SpecialMoveFlags) )
			{
				Drudge.Health += Drudge.Transforms[ETS_ARMS].Health * 0.35f;
			}
		}
		else if( Drudge.IsArmMutation(PawnOwner.SpecialMoveFlags) )
		{
			Drudge.Health += Drudge.Transforms[ETS_ARMS].Health;
		}

		Drudge.PlaySound(Drudge.MutationStartVocal, true);
	}

	// play build up animation, when that's done, play mutation
	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_Play(BS_FreakOutAnimation, 1.f, 0.25f, 0.0f, FALSE);
	PawnOwner.BS_SetAnimEndNotify(BS_FreakOutAnimation, TRUE);
}

function PlayTransform()
{
	local int TransformRequest;
	local float NewCylinderRadius, NewCylinderHeight;

	// find where enemy is and pick which one to snap with
	if ( PawnOwner!=none && Drudge!=none )
	{
		NewCylinderRadius = Drudge.CylinderComponent.CollisionRadius;
		NewCylinderHeight = Drudge.CylinderComponent.CollisionHeight;

		TransformRequest = PawnOwner.SpecialMoveFlags;
		if ( Drudge.IsHeadMutation(TransformRequest) )
		{
			NewCylinderRadius = FMax(NewCylinderRadius, Drudge.Transforms[ETS_HEAD].CollisionRadius);
			NewCylinderHeight = FMax(NewCylinderHeight, Drudge.Transforms[ETS_HEAD].CollisionHeight);
			Drudge.PrepareMutate(ETS_HEAD);
		}
		if ( Drudge.IsArmMutation(TransformRequest) )
		{
			NewCylinderRadius = FMax(NewCylinderRadius, Drudge.Transforms[ETS_ARMS].CollisionRadius);
			NewCylinderHeight = FMax(NewCylinderHeight, Drudge.Transforms[ETS_ARMS].CollisionHeight);
			Drudge.PrepareMutate(ETS_ARMS);
		}
		if ( Drudge.IsLegMutation(TransformRequest) )
		{
			NewCylinderRadius = FMax(NewCylinderRadius, Drudge.Transforms[ETS_LEGS].CollisionRadius);
			NewCylinderHeight = FMax(NewCylinderHeight, Drudge.Transforms[ETS_LEGS].CollisionHeight);
			Drudge.PrepareMutate(ETS_LEGS);
		}

		// Play sound
		if ( Drudge.IsHeadMutation(PawnOwner.SpecialMoveFlags) )
		{
			Drudge.PlaySound(Drudge.HeadMutationVocal, true);

			if (PawnOwner.Role == ROLE_Authority)
			{
				GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_DrudgeHeadMutating, None);
			}
		}
		else if ( Drudge.IsLegMutation(PawnOwner.SpecialMoveFlags) )
		{
			Drudge.PlaySound(Drudge.LegMutationVocal, true);

			if (PawnOwner.Role == ROLE_Authority)
			{
				GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_DrudgeLegsMutating, None);
			}
		}
		else
		{
			Drudge.PlaySound(Drudge.ArmMutationVocal, true);

			if (PawnOwner.Role == ROLE_Authority)
			{
				GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_DrudgeArmsMutating, None);
			}
		}

		if( Drudge.AdjustPositionForMutation(NewCylinderRadius, Drudge.CylinderComponent.CollisionHeight) )
		{
			// play transform
			Drudge.PlayTransform(TransformRequest);
			MutationStartTime = PawnOwner.WorldInfo.TimeSeconds;
		}
		else
		{
			// end special move - nothing else to do
			PawnOwner.EndSpecialMove();
		}
	}
	else
	{
		// end special move - nothing else to do
		PawnOwner.EndSpecialMove();
	}
}

/**
 * Allow special moves to delay DBNO until they are complete
 *
 * @return true if DBNO should be delayed
 */
function bool CanDelayDBNO()
{
	return TRUE;
}

/**
 * Can a new special move override this one before it is finished?
 * This is only if CanDoSpecialMove() == TRUE && !bForce when starting it.
 */
function bool CanOverrideMoveWith(ESpecialMove NewMove)
{
	return TRUE;
}

/**
 * Can this special move override InMove if it is currently playing?
 */
function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return TRUE;
}

/** Script Tick function. */
function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	if( MutationStartTime > 0.f && PawnOwner.Mesh.Scale > Drudge.PostMutationMeshScale )
	{
		PawnOwner.Mesh.SetScale(Lerp(PreMutationMeshScale, Drudge.PostMutationMeshScale, FClamp(`TimeSinceEx(PawnOwner, MutationStartTime), 0.f, 1.f)));
	}
}

defaultproperties
{
	bLockPawnRotation=TRUE
	bDisableCollision=FALSE
	bDisableMovement=TRUE

	BS_FreakOutAnimation=(Stance=((Slot=BS_FullBody,AnimName="Transform_BuildUp")))
}
