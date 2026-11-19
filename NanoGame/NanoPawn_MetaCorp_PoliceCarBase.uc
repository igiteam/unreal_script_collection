/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawn_MetaCorp_PoliceCarBase extends NanoPawnBase
	implements(NanoInterface_Targetable)
	native(Pawn)
	abstract;

/** Handle to the AI that's controlling this car */
var transient NanoAI_PoliceCar      MyAI;

/** Reference to the material instance that controls the light bar */
var transient MaterialInstanceConstant  MIC_Lightbar;

/** Name of the socket to attach the searchlight to */
var name                            SearchlightSocketName;
/** Searchlight dynamic spotlight, used for locking in on player */
var transient SpotLightComponent    Searchlight;
/** Color of the spotlight when the car is not actively targeting the pawn */
var Color                           SearchlightAmbientColor;
/** Color of the spotlight when the car is actively targeting the pawn and aggressive*/
var Color                           SearchlightTargetingColor;
/** Target colour that the searchlight is blending to */
var transient Color                 SearchlightColorTarget;

/** Lens flare to use with the police car */
var transient LensFlareComponent    SearchlightLensFlare;
/** Template to use with the searchlight to blind the player when spotted */
var LensFlare                       SearchlightLensFlareTemplate;
/** Interpolation controls for the police car banking */
var transient Rotator               SearchlightRotationGoal;
var float                           SearchlightNormalInterpSpeed;
var float                           SearchlightTargetingInterpSpeed;

/** Mesh to attach for volumetrics on the searchlight */
var StaticMesh                          SearchlightLightConeMesh;
var transient StaticMeshComponent       SearchlightLightConeMeshComponent;
var transient MaterialInstanceConstant  SearchlightLightConeMatInst;

/** Crowd repulsor to freak out the pedestrians */
var transient NanoCrowd_PanicRepulsor   CrowdRepulsor;

/** Engine sound cues */
var SoundCue                            NormalEngineCue;
var SoundCue                            FastEngineCue;
var SoundCue                            RevvingEngineCue;
var AudioComponent                      EngineAC;

/** Explosion death effect */
var ParticleSystem                      PreDeathEffect;
var transient ParticleSystemComponent   PreDeathEffectPSC;

var ParticleSystem                      DeathEffect;
var transient ParticleSystemComponent   DeathEffectPSC;

var ParticleSystem                      DeathEffectGlass;
var transient ParticleSystemComponent   DeathEffectGlassPSC;

var ParticleSystem                      DeathTrailEffect;
var transient ParticleSystemComponent   DeathTrailEffectPSC;

var ParticleSystem                      PostDeathBurningFlames;
var transient ParticleSystemComponent   PostDeathBurningFlamesPSC;

/** Police AirCar Siren Yelper (Cop car chirp; Play on first sighting of hostile player; play every 5 seconds or so while idling; play when cop car has to move x units to catch up to the player) **/
var SoundCue YelperSound;

/** when we die we switch to this skel mesh **/
var SkeletalMesh DeadSkelMesh;

/** Crashing sound effects */
var SoundCue                        DeathSoundCue;
var SoundCue                        CrashSoundCue;

/** With no banking / speed adjust, this will be the default tilt for the cop car mesh */
var transient Rotator               TargetDefaultTilt;
var transient Rotator               CurrentDefaultTilt; // used for blending to above

/** Maximum adjustment to the pitch based on the forward velocity of the car */
var float                           MaxPitchAdjust;
/** Maximum adjustment to the yaw based on the lateral velocity of the car */
var float                           MaxRollAdjust;

/** Number of yaw samples to store to determine banking */
var int                             YawFilterSize;
/** Yaw angular velocity for the last n ticks */
var transient array<float>          YawFilter;
/** Current index into the yaw filter array */
var transient int                   YawFilterIdx;


var transient bool bTrackingEnemyWithSpotlight;

var() protected class<NanoWeapon> WeaponClass;


cpptext
{
	/** Override this to add in banking effects */
	virtual void performPhysics(FLOAT DeltaSeconds);
};

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	GetGRI().RegisterTargetableActor(self);
	GetGRI().RegisterGrappleActor(self);

	// TEMP:  Spawn them above the cloud layer, so they descend into player view
	SetLocation(Location + vect(0.f,0.f,0.f));

	SearchlightColorTarget = SearchlightAmbientColor;

	if( EngineAC != None )
	{
		EngineAC.SoundCue = NormalEngineCue;
		EngineAC.FadeIn(0.5f, 1.f);
	}

	// Create it and add to inventory chain, only activate if we don't have a weapon currently selected
	InvManager.CreateInventory(WeaponClass);
}

simulated event Destroyed()
{
	if( PreDeathEffectPSC != None )
	{
		PreDeathEffectPSC.DeactivateSystem();
		DetachComponent(PreDeathEffectPSC);
		PreDeathEffectPSC = None;
	}

	if( DeathEffectPSC != None )
	{
		DeathEffectPSC.DeactivateSystem();
		DetachComponent(DeathEffectPSC);
		DeathEffectPSC = None;
	}

	if( DeathEffectGlassPSC != None )
	{
		DeathEffectGlassPSC.DeactivateSystem();
		DetachComponent(DeathEffectGlassPSC);
		DeathEffectGlassPSC = None;
	}

	if( DeathTrailEffectPSC != None )
	{
		DeathTrailEffectPSC.DeactivateSystem();
		DetachComponent(DeathTrailEffectPSC);
		DeathTrailEffectPSC = None;
	}

	if( PostDeathBurningFlamesPSC != None )
	{
		PostDeathBurningFlamesPSC.DeactivateSystem();
		DetachComponent(PostDeathBurningFlamesPSC);
		PostDeathBurningFlamesPSC = None;
	}


	if( Searchlight != None )
	{
		Mesh.DetachComponent(Searchlight);
		Searchlight = None;
	}

	if( SearchlightLensFlare != None )
	{
		Mesh.DetachComponent(SearchlightLensFlare);
		SearchlightLensFlare = None;
	}

	if( SearchlightLightConeMeshComponent != None )
	{
		Mesh.DetachComponent(SearchlightLightConeMeshComponent);
		SearchlightLightConeMeshComponent = None;
	}

	if( EngineAC != None )
	{
		EngineAC.FadeOut(0.25f, 0.f);
	}

	if( CrowdRepulsor != None )
	{
		CrowdRepulsor.Destroy();
		CrowdRepulsor = None;
	}

	Super.Destroyed();
}


function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying);
}

function AddVelocity(vector NewVelocity, vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo );

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	UpdateSpotlight( DeltaTime );

	// Handle posturing tilt blending
	if( CurrentDefaultTilt != TargetDefaultTilt )
	{
		CurrentDefaultTilt = RInterpTo(CurrentDefaultTilt, TargetDefaultTilt, DeltaTime, 2.f, FALSE);
	}

	// Update the crowd repulsor location to follow the cop car
	if( CrowdRepulsor != None )
	{
		CrowdRepulsor.SetLocation(Location);
	}

	//DrawDebugStar(Location,10.f,255,255,0,TRUE);
}


simulated function UpdateSpotlight( float DeltaTime )
{
	local vector SocketLocation;
	local Rotator SocketRotation;

	local Rotator CurrentRotation;

	local color BlendColor;
	local LinearColor BlendLinColor;

	if( MyAI != None && Searchlight != None )
	{
		Mesh.GetSocketWorldLocationAndRotation(SearchlightSocketName, SocketLocation, SocketRotation);

		// Have an enemy, try to keep the spotlight on them!
		if( MyAI.FireTarget != None )
		{
			SearchlightRotationGoal = rotator(MyAI.FireTarget.GetTargetedLocation() - SocketLocation) - SocketRotation;
		}


		// Interpolate towards the target
		CurrentRotation = RInterpTo(Searchlight.Rotation, SearchlightRotationGoal, DeltaTime, bTrackingEnemyWithSpotlight ? SearchlightTargetingInterpSpeed: SearchlightNormalInterpSpeed);
		Searchlight.SetRotation( CurrentRotation );

		// NOTE:  When we get a properly rigged cop car, replace these manual rotation settings with a skel control!
		if( SearchlightLightConeMeshComponent != None )
		{
			SearchlightLightConeMeshComponent.SetRotation( CurrentRotation + rot(16384,0,0) );
		}
		if( SearchlightLensFlare != None )
		{
			SearchlightLensFlare.SetRotation( CurrentRotation );
		}

		// If we're not tracking an enemy, and we've reached our goal, start panning back the other way
		if( !bTrackingEnemyWithSpotlight && (CurrentRotation == SearchlightRotationGoal) )
		{
			SearchlightRotationGoal.Yaw = -SearchlightRotationGoal.Yaw;
		}

		// If needed, blend the searchlight colour here
		if( Searchlight.LightColor != SearchlightColorTarget )
		{
			BlendColor.R = FCeil( FInterpTo(Searchlight.LightColor.R, SearchlightColorTarget.R, DeltaTime, 4.f) );
			BlendColor.G = FCeil( FInterpTo(Searchlight.LightColor.G, SearchlightColorTarget.G, DeltaTime, 4.f) );
			BlendColor.B = FCeil( FInterpTo(Searchlight.LightColor.B, SearchlightColorTarget.B, DeltaTime, 4.f) );
			BlendColor.A = 255;

			Searchlight.SetLightProperties( 4.f, BlendColor );

			if( SearchlightLightConeMatInst != None )
			{
				BlendLinColor = ColorToLinearColor(BlendColor);
				SearchlightLightConeMatInst.SetVectorParameterValue( 'Color', BlendLinColor );
			}
		}
	}
}




event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// Don't take friendly fire
	if( WorldInfo.GRI.OnSameTeam(InstigatedBy, MyAI) )
	{
		return;
	}

	Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_PoliceCar_ShotAt, self);
}

//==========================================================
// Effects
//==========================================================

simulated function ActivateLightBar()
{
	if( MIC_Lightbar != None )
	{
		MIC_Lightbar.SetScalarParameterValue('flashingLightBlend', 1.f);
	}
}

simulated function DeactivateLightBar()
{
	if( MIC_Lightbar != None )
	{
		MIC_Lightbar.SetScalarParameterValue('flashingLightBlend', 0.f);
	}
}


/** This is how you possibly activate spotlight **/
simulated function PossiblyActivateSpotLight()
{
	// if there is more than one light on the player then don't do this
	if( ( NanoGRI(WorldInfo.GRI).AIBlackboard.NumSpotlightsOnPlayer >= 1 ) 
		|| ( ( MyAI.FireTarget == None ) || ( VSize( MyAI.FireTarget.GetTargetedLocation() - Location ) > 3048.0f ) ) // player is too far away
		)
	{
		return;
	}

	ActivateSpotLight();

}


private simulated function ActivateSpotLight()
{
	if( Searchlight == None )
	{
		Searchlight = new(self) class'SpotLightComponent';
		Mesh.AttachComponentToSocket(Searchlight, SearchlightSocketName);

		Searchlight.InnerConeAngle = 0;
		Searchlight.OuterConeAngle = 20;
		Searchlight.Radius = 12000;

		Searchlight.SetLightProperties(4, SearchlightAmbientColor);
		Searchlight.SetEnabled(TRUE);

		if( (SearchlightLightConeMeshComponent == None) && (SearchlightLightConeMesh != None) )
		{
			SearchlightLightConeMeshComponent = new(self) class'StaticMeshComponent'; // why do we not just have this be part of the car?
			SearchlightLightConeMeshComponent.SetActorCollision( FALSE, FALSE, FALSE );
			SearchlightLightConeMeshComponent.SetStaticMesh(SearchlightLightConeMesh);
			SearchlightLightConeMeshComponent.SetScale3D( vect(5.f,5.f,10.f) );

			Mesh.AttachComponentToSocket(SearchlightLightConeMeshComponent, SearchlightSocketName);

			SearchlightLightConeMatInst = SearchlightLightConeMeshComponent.CreateAndSetMaterialInstanceConstant(0);
		}

		if( (SearchlightLensFlare == None) && (SearchlightLensFlareTemplate != None) )
		{
			SearchlightLensFlare = new(self) class'LensFlareComponent';
			SearchlightLensFlare.SetTemplate(SearchlightLensFlareTemplate);

			Mesh.AttachComponentToSocket(SearchlightLensFlare, SearchlightSocketName);
		}

		SearchlightRotationGoal = rot(-8192, -8192, 0);
	}


	// if I was not tracking someone then increment the count
	if( bTrackingEnemyWithSpotlight == FALSE )
	{
		NanoGRI(WorldInfo.GRI).AIBlackboard.NumSpotlightsOnPlayer++;
		bTrackingEnemyWithSpotlight = TRUE;
	}

}

simulated function DeactivateSpotLight()
{
	if( Searchlight != None )
	{
		Searchlight.SetEnabled(FALSE);

		Mesh.DetachComponent(Searchlight);
		Searchlight = None;
	}

	if( SearchlightLightConeMeshComponent != None )
	{
		Mesh.DetachComponent(SearchlightLightConeMeshComponent);
		SearchlightLightConeMeshComponent = None;
	}

	if( SearchlightLensFlare != None )
	{
		Mesh.DetachComponent(SearchlightLensFlare);
		SearchlightLensFlare = None;
	}


	// if I was tracking and now I am not
	if( bTrackingEnemyWithSpotlight == TRUE )
	{
		NanoGRI(WorldInfo.GRI).AIBlackboard.NumSpotlightsOnPlayer--;
		bTrackingEnemyWithSpotlight = FALSE; 
	}

}

simulated function SetSearchLightActiveColor( bool bNewActive )
{
	SearchlightColorTarget = bNewActive ? SearchlightTargetingColor : SearchlightAmbientColor;
}


simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	//local class<NanoAbsorbOrb> DroppedOrbClass;

	// don't do any sound and fury if we were killed by NPES
	if( class'NDT_KilledByProceduralSpawner' == DamageType )
	{
		Super.PlayDying(DamageType, HitLoc);
		return;
	}

	if( DeadSkelMesh != None )
	{
		Mesh.SetSkeletalMesh( DeadSkelMesh );
		CollisionComponent=Mesh;
		SetCollision( TRUE, TRUE );
	}

	//// The sound and the fury
	if( PreDeathEffect != None )
	{
		PreDeathEffectPSC = WorldInfo.MyEmitterPool.SpawnEmitter(PreDeathEffect, Location, Rotation, self);
		PreDeathEffectPSC.SetScale( 1.0f );
	}

	if( DeathEffect != None )
	{
		DeathEffectPSC = WorldInfo.MyEmitterPool.SpawnEmitter(DeathEffect, Location, Rotation, self);
		DeathEffectPSC.SetScale( 3.0f );
	}

	if( DeathEffectGlass != None )
	{
		DeathEffectGlassPSC = WorldInfo.MyEmitterPool.SpawnEmitter(DeathEffectGlass, Location, Rotation, self);
		DeathEffectGlassPSC.SetScale( 1.0f );
	}

	if( DeathTrailEffect != None )
	{
		DeathTrailEffectPSC = WorldInfo.MyEmitterPool.SpawnEmitter(DeathTrailEffect, Location, Rotation, self);
		DeathTrailEffectPSC.SetScale( 1.0f );
	}

	if( PostDeathBurningFlames != None )
	{
		PostDeathBurningFlamesPSC = WorldInfo.MyEmitterPool.SpawnEmitter(PostDeathBurningFlames, Location, Rotation, self);
		PostDeathBurningFlamesPSC.SetScale( 3.0f );
	}

	if( DeathSoundCue != None )
	{
		PlaySound( DeathSoundCue, TRUE, TRUE, TRUE, Location );
	}


// 	foreach DroppedOrbClasses( DroppedOrbClass )
// 	{
// 		Orbs.AddItem( NanoGRI(WorldInfo.GRI).SpawnANanoOrb( DroppedOrbClass, self, FALSE ) );
// 	}


	// Disable lights
	DeactivateSpotLight();
	DeactivateLightBar();

	// Disable crowd repulsors
	PanicCrowds(FALSE);

	// Turn off engine sound
	if( EngineAC != None )
	{
		EngineAC.FadeOut(0.5f, 0.f);
	}

	// Ragdoll death effect
	InitRagdoll();
	Mesh.SetRBAngularVelocity(VRand(), TRUE);

	Super.PlayDying(DamageType, HitLoc);
}

/**  When car hits the ground play a sound and then turn off the RB collision notifications **/
event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
						 const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	Super.RigidBodyCollision( HitComponent, OtherComponent, RigidCollisionData, ContactIndex );

	if( CrashSoundCue != None )
	{
		PlaySound( CrashSoundCue, TRUE, TRUE, TRUE, Location );
	}
}

simulated function SetDefaultTilt( rotator NewTilt )
{
	// NOTE:  Since we do some rotation to the mesh because it was exported wrong, adjust here.  This can be undone once we get a new mesh when art has some free cycles
	TargetDefaultTilt.Roll  = NewTilt.Pitch;
	TargetDefaultTilt.Yaw   = NewTilt.Yaw;
	TargetDefaultTilt.Pitch = NewTilt.Roll;

}

simulated function PanicCrowds( bool bNewPanicCrowds )
{
	if( bNewPanicCrowds && (CrowdRepulsor == None) )
	{
		CrowdRepulsor = Spawn(class'NanoGame.NanoCrowd_PanicRepulsor', self,,Location,Rotation,,TRUE);
		CrowdRepulsor.CylinderComponent.SetCylinderSize(1024.f, 1024.f);
	}
	else if( !bNewPanicCrowds && (CrowdRepulsor != None) )
	{
		CrowdRepulsor.Destroy();
		CrowdRepulsor = None;
	}
}

simulated function SetEngineSpeedSound( bool bPlayFastSound )
{
	if( EngineAC != None )
	{
		if( bPlayFastSound && (EngineAC.SoundCue != FastEngineCue) )
		{
			PlaySound(RevvingEngineCue);
			EngineAC.SoundCue = FastEngineCue;
		}
		else if( !bPlayFastSound && (EngineAC.SoundCue != NormalEngineCue) )
		{
			EngineAC.SoundCue = NormalEngineCue;
		}
	}
}

//==========================================================
// NanoInterface_Targetable
//==========================================================

/** Is this object currently targetable */
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return (Health > 0.f);
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

/** Should this targetable actor ignore distance checks in rating calculations (caution...use with care!) */
simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

/** Returns base priority for targeting this object. */
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	return 10.f;
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

/** Called when target is struck by thrown sword */
simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );

/** Called when target struck by ricochet moon hook */
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

/** Indicates this object can be dash-attacked with sword */
simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return TRUE;
}

//==========================================================
// NanoInterface_Grapple
//==========================================================

/** Is this actor currently able to be grappled? */
simulated function bool	IsGrapplable()
{
	return IsTargetable();
}

/** Location to grapple to, in world space */
simulated function vector GetGrappleLocation( NanoPawn Grappler )
{
	return Location;
}

/** If this returns TRUE, then NewRotation will be the target's desired rotation for the pawn */
simulated function bool ShouldOverrideDesiredRotation( NanoPawn Grappler, out rotator NewRotation, float DistanceToTarget );

/** Whether or not this location can be grapple to from above */
simulated function bool CanGrappleFromAbove()
{
	return TRUE;
}

/** Returns the start, sustain, and ending animations for this grapple interface (if empty, assumes the defaults) */
simulated function GetGrappleAnims(bool bAboveTargetPoint, out name StartAnim, out name LoopAnim, out name EndAnim);

/** Called when someone begins grappling this actor */
simulated function NotifyBeginGrappled( NanoPawn Grappler );

/** Called when someone finishes grappling this actor */
simulated function NotifyEndGrappled( NanoPawn Grappler );

/** Does this grapple target support active mantling at the top? */
simulated function bool SupportsActiveGrapple()
{
	return FALSE;
}

/** If SupportsActiveGrapple() returns TRUE, this function should return the velocity we should launch the player up at */
simulated function vector GetActiveGrappleVelocity();

/** If non-zero, the pawn will be stuck at this distance from the grapple object */
simulated function float GetMinimumGrappleDistance();


simulated event BoxSphereBounds GetTargetableBounds()
{
	return Mesh.Bounds;
}


simulated function PlayYelperSound()
{
	PlaySound( YelperSound );
}

/** This will return the struct that holds all of the values for this specific pawn **/
simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.PoliceCarKilled;
}

simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	return Weapon.GetMuzzleLoc();
}



defaultproperties
{
	InventoryManagerClass=class'NanoInventoryManager'

	bCanBeBaseForPawns=TRUE
	bCanFly=TRUE

	RotationRate=(Pitch=15000,Yaw=15000,Roll=15000)

	LandMovementState=PlayerFlying

	SearchlightAmbientColor=(B=255,G=242,R=175,A=255)
	SearchlightTargetingColor=(B=239,G=255,R=246,A=255)

	SearchlightNormalInterpSpeed=2.f
	SearchlightTargetingInterpSpeed=8.f

	MaxPitchAdjust=0
	MaxRollAdjust=4096

	YawFilterSize=15
}
