/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSpringPoint extends Keypoint
	implements(NanoInterface_Attraction)
	native
	placeable;

var() float PerchAttractDistance;

/** Need to do trace down to the ground and make certain we are "high" enough off the ground to be a valid spring point **/
var transient bool bValidSpringPoint;


var SpriteComponent ValidSpringPointIcon;


simulated function PostBeginPlay()
{
	local vector	HitLocation, HitNormal, TraceStart, TraceEnd, Extent;
	local Actor		HitActor;

	Super.PostBeginPlay();

	TraceStart = Location;
	TraceEnd = TraceStart - vect(0,0,64);

	HitActor = Trace( HitLocation, HitNormal, TraceEnd, TraceStart, TRUE, Extent );

	if( HitActor == none )
	{
		//`log( "Spring point is in the air enough" );
		bValidSpringPoint = TRUE;
	}
	else
	{
		ValidSpringPointIcon.SetHidden( TRUE );
	}
}



/** Should we allow attraction? */
simulated function bool ShouldAttractActor(Actor TestActor)
{
	if( NanoPawn_RebelsBase(TestActor) != None 
		&& VSize(TestActor.Location - Location) < PerchAttractDistance )
	{
		return TRUE;
	}
	return FALSE;
}

simulated function Actor GetAttractionActor()
{
	return self;
}

simulated event vector GetAttractionLocationOffset();

/** Called each frame that a Pawn is being attracted to this object */
simulated function bool AttractingPawn(NanoPawn NP);

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local NanoSkill_Jump JumpSkill;
	local NanoPawn_RebelsBase Rebel;
	local NSM_Mantle_Base MantleSM;
	
	Rebel = NanoPawn_RebelsBase(Other);
	// If no-one on perch, and this person is falling, lock them
	if( bValidSpringPoint && Rebel != None ) 
	{
		JumpSkill = Rebel.GetSkill(class'NanoSkill_Jump');	
	
		if( JumpSkill != none )
		{
			MantleSM = NSM_Mantle_Base(Rebel.GetSpecialMoveByName('NSM_Mantle_Waist'));
			if( MantleSM != None )
			{
				MantleSM.bDisabled = TRUE;  // trixy to disable scamble
			}
			//`log( "applying spring jump" );
			JumpSkill.PawnOwner = Rebel;
			JumpSkill.ApplyJumpVelocity( JumpSkill.GetMaxJumpLevel( Rebel ), TRUE, FALSE, vect(0,0,0), FALSE, vect(0,0,0) );
		}
	}
	
	super.Touch(Other, OtherComp, HitLocation, HitNormal);	
}


defaultproperties
{
	PerchAttractDistance=256.f

	Components.Remove(Sprite)

	Begin Object Class=SpriteComponent Name=Sprite2
		Sprite=Texture2D'Nano_ProtoHUD_Ingame.T_Perch_Spring'
		Scale=0.35
	End Object
	ValidSpringPointIcon=Sprite2
	Components.Add(Sprite2)

	Begin Object Class=CylinderComponent Name=MyPerchCyl
		CollisionHeight=40.0
		CollisionRadius=120.0
		CollideActors=TRUE
		BlockActors=FALSE
	End Object
	CollisionComponent=MyPerchCyl
	Components.Add(MyPerchCyl)

	bHidden=False

	bCollideActors=true
	bBlockActors=false

	bStatic=False
	bNoDelete=true
	bMovable=True
	
	SupportedEvents.Add(class'SeqEvt_NanoActionPerformed')	
}