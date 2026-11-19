/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPerchPoint extends Keypoint
	implements( NanoInterface_Attraction, NanoInterface_StabMantle, NanoInterface_Targetable )
	native
	placeable;

/** Name of the special move to do when perching on this point */
var     Name                    PerchSpecialMoveName;

var()   float                   PerchAttractDistance;
var()	float					PerchRotInterpSpeed;
var()	bool					bLockPawnRotation;
var()	bool					bStabTarget;

/** If true, players can city scan from this perch point **/
var()   bool                    bCityScanPoint;

var     transient NanoPawn      LockedPawn;
var		transient bool			bLockedPawnRotationComplete;
var		transient NanoPerchPole_Base	PerchPole;
var     transient NanoFireEscapeBase    FireEscape;

var()	vector					CamOffset;

var bool                        bEnabled;

/** If true, the player's input will be locked while on the pole */
var()   bool            bLockPlayerLook;

var()   float           PerchJumpBoost;

struct native PerchCollisionInfo
{
	var() EPerchType Type;
	var() Vector     Translation;
	Var() Vector     Scale3D;
};
var() array<PerchCollisionInfo> CollisionInfoList;
var() EPerchType                PerchType;


cpptext
{
	virtual void PostNetReceiveBase(AActor* NewBase);
};

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	EnableStabTarget( bStabTarget );
}

simulated function Init()
{
	local int Idx;

	Idx = CollisionInfoList.Find( 'Type', PerchType );
	if( Idx >= 0 && CollisionComponent != None )
	{
		CollisionComponent.SetTranslation( CollisionInfoList[Idx].Translation );
		CollisionComponent.SetScale3D( CollisionInfoList[Idx].Scale3D );
	}
}

simulated function EnableStabTarget( bool bStabEnabled )
{
	bStabTarget = bStabEnabled;
	if( bStabTarget )
	{
		NanoGRI(WorldInfo.GRI).RegisterTargetableActor( self );
	}
}

/** Should we allow attraction? */
simulated function bool ShouldAttractActor(Actor TestActor)
{
	if( bEnabled && NanoPawn_RebelsBase(TestActor) != None && LockedPawn == None && VSize(TestActor.Location - Location) < PerchAttractDistance )
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

/** Lock a pawn firmly to this perch point */
simulated function LockPawnToPerch(NanoPawn NP)
{
	NP.ServerDictateSpecialMove( PerchSpecialMoveName, TRUE, None, self );
}

simulated function Rotator GetPerchRotation()
{
	local Rotator AttachRot;
	
	AttachRot = Rotation;
	AttachRot.Roll = 0;
	AttachRot.Pitch = 0;

	return AttachRot;
}

/** Release the pawn from this perch point */
simulated function UnlockPawnFromPerch()
{
	if( (LockedPawn != None) && (Role == ROLE_Authority) )
	{
		// tell pawn
		LockedPawn.ServerEndSpecialMove( PerchSpecialMoveName );
	}
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local NanoPawn_RebelsBase Rebel;
	
	if( bEnabled && (Role == ROLE_Authority) )
	{
		Rebel = NanoPawn_RebelsBase(Other);
		// If no-one on perch, and this person is falling, lock them
		if( LockedPawn == None && 
			Rebel != None && 
			Rebel.Physics == PHYS_Falling && 
			Rebel.Base == None && 
			`TimeSince(Rebel.LastPerchReleaseTime) > 0.25f && 
			Rebel.CanDoSpecialMove(PerchSpecialMoveName, TRUE) )
		{
			LockPawnToPerch(Rebel);
		}
	}
	
	super.Touch(Other, OtherComp, HitLocation, HitNormal);	
}

simulated function Tick( float DeltaTime )
{
	local Rotator AttachRot, NewRot, Rot;

	Super.Tick( DeltaTime );

	if( bLockPawnRotation && LockedPawn != None && !bLockedPawnRotationComplete )
	{
		AttachRot = GetPerchRotation();
		Rot = Normalize(LockedPawn.Rotation);
		NewRot = RInterpTo( Rot, AttachRot, DeltaTime, PerchRotInterpSpeed );
		NewRot.Pitch = Rot.Pitch;
		NewRot.Roll = Rot.Roll;


		if( Abs(Rot.Yaw - AttachRot.Yaw) < 10 )
		{
			bLockedPawnRotationComplete = TRUE;
			NewRot.Yaw = AttachRot.Yaw;
		}

		LockedPawn.SetRotation( NewRot );
		if( bLockedPawnRotationComplete )
		{
			LockedPawn.SetHardAttach(TRUE);
		}
	}

	if( LockedPawn != None && LockedPawn.Base != self )
	{
		LockedPawn = None;
	}
}

simulated function vector GetStabAttachOffset()
{
	return vect(0,0,0);
}

simulated function float GetTargetDistanceScaling()
{
	return 1.f;
}

simulated function NotifyFinishedStabMantle( NanoPawn Rider, optional bool bViaLanding )
{
	LockPawnToPerch( Rider );
}

simulated function NotifySomeoneAttached( NanoPawn Rider );

/** Useful for checking to see if the StabMantle target is alive / not destroyed / in some state which makes mantling not valid **/
simulated function bool IsValidStabMantleTarget(optional bool bIsLandingCheck)
{
	if( LockedPawn == None && bStabTarget && bEnabled )
	{
		return TRUE;
	}
	return FALSE;
}

simulated function name GetStabMantleApproachAnim()
{
	return 'Car_Stab_Mantle_Fly';
}

simulated function name GetStabMantleAnim( bool bRightSide )
{
	return bRightSide ? 'Car_Stab_Mantle_Up_B' : 'Car_Stab_Mantle_Up';
}

simulated function float GetStabMantleAnimRate()
{
	return 1.5f;
}

/** Is this object currently targetable */
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return bStabTarget && bEnabled && QT == TQT_None;
}

simulated function bool ShouldRateTarget()
{
	return TRUE;
}

/** Returns the Targetable Octree component */
simulated function TargetableOctreeComponent GetTargetableOctreeComponent()
{
	local TargetableOctreeComponent TargetableComp;

	foreach AllOwnedComponents( class'TargetableOctreeComponent', TargetableComp )
	{
		return TargetableComp;
	}

	return None;
}

simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

/** Returns base priority for targeting this object. */
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	return bEnabled ? 10.f : 0.f;
}

/** Get location that target should be considered */
simulated event vector GetTargetedLocation()
{
	return Location;
}

/** Rotation of the target.  Useful to see if they are facing some dir **/
simulated event rotator GetRotation()
{
	return Rotation;
}

/** How fast the target is currently moving **/
simulated event vector GetVelocity()
{
	return Velocity;
}

/** Pass in a struct and then have the interface fill in a ton of different firing targetable data **/
simulated function GetFiringTargetableDatum( out FiringTargetableDatum Out_FiringTargetableDatum );

simulated event BoxSphereBounds GetTargetableBounds()
{
	return CollisionComponent.Bounds;
}

/** Called when target is struck by thrown sword */
simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );

/** Called when target struck by ricochet moon hook */
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

/** Indicates this object can be dash-attacked with sword */
simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return FALSE;
}

function OnToggle(SeqAct_Toggle inAction)
{
	if (inAction.InputLinks[0].bHasImpulse)
	{
		bEnabled = TRUE;
	}
	else if (inAction.InputLinks[1].bHasImpulse)
	{
		bEnabled = FALSE;
	}
	else
	{
		bEnabled = !bEnabled;
	}
}

defaultproperties
{
	PerchAttractDistance=256.f
	PerchRotInterpSpeed=8.f

	Components.Remove(Sprite)
	Begin Object Class=SpriteComponent Name=Sprite2
		Sprite=Texture2D'Nano_ProtoHUD_Ingame.S_PerchPoint'
		Scale=0.35
		HiddenGame=TRUE
		AlwaysLoadOnClient=FALSE
	End Object
	Components.Add(Sprite2)

	Begin Object Class=StaticMeshComponent Name=MyPerchBox
		StaticMesh=StaticMesh'EngineMeshes.Cube'
		HiddenGame=TRUE
		bAcceptsLights=FALSE
		CastShadow=FALSE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=TRUE
		BlockRigidBody=FALSE
		Scale3D=(X=0.25f,Y=0.25f,Z=0.25f)
	End Object
	Components.Add(MyPerchBox)
	CollisionComponent=MyPerchBox

	CollisionInfoList(0)=(Type=PT_HorzPole,Translation=(X=0,Y=-125,Z=0),Scale3D=(X=0.25f,Y=1.25f,Z=0.25f))
	PerchType=PT_Point


	Begin Object Class=TargetableOctreeComponent Name=TargetableOctreeComp0
	End Object
	Components.Add(TargetableOctreeComp0)


	bEnabled=TRUE

	bHidden=False

	bCollideActors=true
	bBlockActors=false

	bStatic=False
	bNoDelete=true
	bMovable=True

	PerchSpecialMoveName=NSM_PerchOnPoint
	
	SupportedEvents.Add(class'SeqEvt_NanoActionPerformed')	

	CamOffset=(Z=-55)

	bAlwaysRelevant=TRUE
	RemoteRole=ROLE_SimulatedProxy

	TickFrequencyDecreaseDistanceStart=1000
	TickFrequencyDecreaseDistanceEnd=4000
	TickFrequencyAtEndDistance=0.1

	PerchJumpBoost=728
}