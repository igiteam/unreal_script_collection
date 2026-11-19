
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MomCorpser_Stomp extends GearSpecialMove;


var()	GearPawn.BodyStance	BS_Animation;

var() GearPawn_LocustMomCorpserBase Corpser;
var() GearAI_MomCorpser             CorpserAI;


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	Corpser = GearPawn_LocustMomCorpserBase(PawnOwner);
	CorpserAI = GearAI_MomCorpser(PawnOwner.Controller);

	SpeedModifier = 2.0f;

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);

	GearPawn_LocustMomCorpserBase(PawnOwner).PlayStompAttackStartSound();

	Corpser.SetTimer( 0.5f, TRUE, nameof(StompWarnAI), self );
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	Corpser.ResetEncroachers();

	// Disable end of animation notification. 
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);

	Corpser.FullBodyNode.StopCustomAnim( 0.5f );

	Corpser.ClearTimer( nameof(StompWarnAI), self );
}

function StompWarnAI()
{
	Corpser.WarnAttackIncoming( Corpser.Location + Vector(Corpser.Rotation) * 800.f );
}

/** Stomp happens */
simulated function AnimNotify( AnimNodeSequence SeqNode, GearAnimNotify_SpecialMove NotifyObject )
{
	local Vector HitLocation, HitNormal, TraceStart, TraceEnd;
	local Actor	 HitActor;
	local float	 HitZ;

	if( Corpser != None )
	{
		Corpser.PlayStompEffect();

		// Only do one leg trace... assume all other legs are at equal height on the ground
		TraceStart	  = Corpser.Mesh.GetBoneLocation( 'Lft_Clawtip2' );
		TraceEnd	  = TraceStart;
		TraceStart.Z += 250;
		HitActor = Corpser.Trace( HitLocation, HitNormal, TraceEnd, TraceStart );
		if( HitActor == None )
		{
			HitLocation = TraceEnd;
		}
		HitZ = HitLocation.Z + 50.f;
		
		// Have all claws do stab damage too
		HitLocation = Corpser.Mesh.GetBoneLocation( 'Lft_Clawtip2' );
		HitLocation.Z = HitZ;
		Corpser.DoStabDamage( HitLocation );
		Corpser.PlayStabImpactEffect( HitLocation );
		HitLocation = Corpser.Mesh.GetBoneLocation( 'Lft_Clawtip3' );
		HitLocation.Z = HitZ;
		Corpser.DoStabDamage( HitLocation );
		Corpser.PlayStabImpactEffect( HitLocation );
		HitLocation = Corpser.Mesh.GetBoneLocation( 'Lft_Clawtip4' );
		HitLocation.Z = HitZ;
		Corpser.DoStabDamage( HitLocation );
		Corpser.PlayStabImpactEffect( HitLocation );
		HitLocation = Corpser.Mesh.GetBoneLocation( 'Rt_Clawtip4' );
		HitLocation.Z = HitZ;
		Corpser.DoStabDamage( HitLocation );
		Corpser.PlayStabImpactEffect( HitLocation );
		HitLocation = Corpser.Mesh.GetBoneLocation( 'Rt_Clawtip3' );
		HitLocation.Z = HitZ;
		Corpser.DoStabDamage( HitLocation );
		Corpser.PlayStabImpactEffect( HitLocation );
		HitLocation = Corpser.Mesh.GetBoneLocation( 'Rt_Clawtip2' );
		HitLocation.Z = HitZ;
		Corpser.DoStabDamage( HitLocation );
		Corpser.PlayStabImpactEffect( HitLocation );
	}
}


defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_Std_Idle_Lower,AnimName="Cavern_Groundpound")))

	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableCollision=FALSE
	bDisableMovement=TRUE
	bDisablePhysics=TRUE
}