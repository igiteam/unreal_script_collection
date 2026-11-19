/**
 * Semi-persistent bits of fire stuck to the world.  Deposited by flamethrower, etc.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_StickyFire extends SpawnedGearEmitter
	native(Weapon)
	config(Weapon);

var() protected const vector2d      RandomizedScaleRange;

/** Burntime is chosen randomly from this range. */
var() protected const config vector2d	TotalBurnTimeRange;
var() protected const config float		DamagePerSecond;

var protected transient float	RandomizedTotalBurnTime;
var protected transient float	CurrentTime;

var() protected float			DamageApplicationInterval;
var protected float				NextDamageTime;


var Actor SpawnedBy;

var() protected bool bDrawDebug;

var protected transient bool bSlaveFiresUpdated;

/** True if this fire has a drip component, false otherwise. */
var protected transient repnotify bool              bDripping;
/** if Facing.Z < this valie, this emitter is eligible to drip. */
var() protected const float                         DrippingZThreshold;
/** Chance that this emitter will drip, if it is eligible. */
var() protected const float                         ChanceToDrip;

/** Active drip particle system */
var protected transient ParticleSystemComponent     PSC_Drip;
/** Drip particle system template */
var protected const ParticleSystem                  DripParticleSystem;

var protected transient vector                      DripLocation;

var transient float                                 LastIgnitionTime;

var protected transient GearDecal                   ScorchDecal;
var protected instanced duplicatetransient MaterialInstanceConstant    MIC_ScorchDecal;

var() protected const float				            DecalFadeCharInTime;
var() protected const float				            DecalFadeCharOutTime;
var() protected const float				            DecalFadeCharDuration;
var() protected const float				            DecalFadeEmbersInTime;
var() protected const float				            DecalFadeEmbersOutTime;

var() class<GearDamageType>                         DamageType;

/** Normal of the surface we're stuck to. */
var transient vector                                SurfaceNormal;

var transient GearFireInfo                          ParentFireInfo;

var Controller InstigatorController;

// Since these cause damage, we want the server to be authoritative about where they spawn.
// So we want them to replicate on creation, but tear off immediately.

replication
{
	if (bNetInitial)
		bDripping, RandomizedTotalBurnTime, DripLocation;
}

simulated function ReplicatedEvent(name VarName)
{
	if (VarName == nameof(bDripping))
	{
		StartDripping();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// Guarantee that dedicated server doesn't shorten the lifespan of these emitters
	// since they cause TakeDamage()
	Lifespan = default.LifeSpan;

	NextDamageTime = WorldInfo.TimeSeconds + DamageApplicationInterval;
	SetDrawScale(RandRange(RandomizedScaleRange.X, RandomizedScaleRange.Y));

	// burn time
	RandomizedTotalBurnTime = RandRange(TotalBurnTimeRange.X, TotalBurnTimeRange.Y);

	// drip?
	if (Role == ROLE_Authority)
	{
		if ( (vector(Rotation).Z < DrippingZThreshold) && (FRand() < ChanceToDrip) )
		{
			StartDripping();
		}
	}

	LeaveScorchDecal();

	if (bDrawDebug)
	{
		// turn particles off during debug rendering
		ParticleSystemComponent.OnSystemFinished = None;
		ParticleSystemComponent.SetActive(false);

		DrawDebugCoordinateSystem(Location, Rotation, 36.f, TRUE);
	}
}

simulated function StartDripping()
{
	local vector HitLoc, HitNorm, EndTrace;
	local CylinderComponent C;

	if (!bDripping)
	{
		if (ROLE == ROLE_Authority)
		{
			bDripping = TRUE;

			DripLocation = Location;

 			// trace down to find ground to set up damage cylinder properly
 			EndTrace = Location + vect(0,0,-2000);
 			if (Trace(HitLoc, HitNorm, EndTrace, Location, FALSE) == None)
 			{
				HitLoc = EndTrace;
 			}

			SetLocation((Location + HitLoc) * 0.5f);
		}

		// set up effects
		PSC_Drip = new(self) class'ParticleSystemComponent';
		PSC_Drip.SetTemplate( DripParticleSystem );
		PSC_Drip.SetAbsolute(true, true, true);
		PSC_Drip.SetTranslation(DripLocation);
		PSC_Drip.SetRotation(Rotation);
		AttachComponent(PSC_Drip);

		// move
 		ParticleSystemComponent.SetAbsolute(true, true, true);
		ParticleSystemComponent.SetTranslation(DripLocation);

		C = CylinderComponent(CollisionComponent);
		// HitLoc is bottom of cylinder.
		C.SetCylinderSize(C.CollisionRadius*0.5f, (DripLocation.Z-Location.Z)*2.f);
	}
}

/**
 * Destroy the avoidance cylinder
 */
simulated event Destroyed()
{
	Super.Destroyed();

	TellParentWeAreDead();
}

/** Tell the fire info that we're no longer burning so it can stop playing sounds */
simulated function TellParentWeAreDead()
{
	if (ParentFireInfo != None)
	{
		ParentFireInfo.RemoveStickyFire(self);
		ParentFireInfo = None;
	}
}

simulated function Tick(float DeltaTime)
{
	local float CharFade, EmberFade;
	local Actor A;
	local GearPawn GP;
	local GearDestructibleObject GDO;

	super.Tick(DeltaTime);

	CurrentTime += DeltaTime;

	CharFade = 1.0;
	EmberFade = 1.0;
	if ( CurrentTime - DeltaTime < DecalFadeCharInTime )
	{
		CharFade = FMin(CurrentTime/DecalFadeCharInTime, 1.0);
	}
	
	if (CurrentTime > DecalFadeCharDuration)
	{
		CharFade = FMax(0.0f, 1.0f - ((CurrentTime - DecalFadeCharDuration) / DecalFadeCharOutTime));
	}
	
	MIC_ScorchDecal.SetScalarParameterValue('Fade', CharFade);

	if (CurrentTime < DecalFadeEmbersInTime)
	{
		EmberFade = FMin(CurrentTime/DecalFadeEmbersInTime, 1.0);
	}

	if (CurrentTime > RandomizedTotalBurnTime)
	{
		if (bCurrentlyActive)
		{
			// turn off emitter and set lifespan to destroy us
			ParticleSystemComponent.DeactivateSystem();
			if (PSC_Drip != None)
			{
				PSC_Drip.DeactivateSystem();
			}
		}

		LifeSpan = (LifeSpan <= 0.0) ? 6.0 : FMin(LifeSpan, 6.0);

		EmberFade = 1.0 - FMin((CurrentTime - RandomizedTotalBurnTime) / DecalFadeEmbersOutTime, 1.0);

		TellParentWeAreDead();
	}

	MIC_ScorchDecal.SetScalarParameterValue('FadeGlow', EmberFade);

	if (bDrawDebug)
	{
		DrawDebugBox(Location, vect(8,8,8)*DrawScale, 255, 100, 0, FALSE);
	}

	// do damage!
	if ( WorldInfo.TimeSeconds > NextDamageTime && Role == ROLE_Authority && DamagePerSecond > 0.0 && CurrentTime < RandomizedTotalBurnTime + 1.5)
	{
		ForEach TouchingActors(class'Actor', A)
		{
			GP = GearPawn(A);
			if (GP != none)
			{
				// Properly credit damage type (check tag victim, check planted)
				if (ParentFireInfo != None && ParentFireInfo.TagVictim != None)
				{
					if (GP == ParentFireInfo.TagVictim)
					{
						GP.TakeDamage(DamagePerSecond*DamageApplicationInterval, InstigatorController, GP.Location, vect(0,0,1), ParentFireInfo.PawnTaggedDamageType);
					}
					else
					{
						GP.TakeDamage(DamagePerSecond*DamageApplicationInterval, InstigatorController, GP.Location, vect(0,0,1), ParentFireInfo.TaggedDamageType);
					}
				}
				else
				{
				   GP.TakeDamage(DamagePerSecond*DamageApplicationInterval, InstigatorController, GP.Location, vect(0,0,1), DamageType);
				}
			}
			else
			{
				GDO = GearDestructibleObject(A);
				if (GDO != none)
				{
					GDO.TakeDamage(DamagePerSecond*DamageApplicationInterval, InstigatorController, GDO.Location, vect(0,0,1), DamageType);
				}
			}
		}

		NextDamageTime = WorldInfo.TimeSeconds + DamageApplicationInterval;
	}
}

// Decal stuff is a test, mostly copied from FlamethrowerSprayBase
simulated protected function ScorchDecalTraceFunc_StickyFire( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector TraceDir;
	TraceDir = vector(Rotation);
	out_TraceStart = Location + TraceDir * 16.f;
	out_TraceDest = out_TraceStart - TraceDir * 40.f;
}
simulated protected function ScorchDecalChoiceFunc_StickyFire( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDDT_StickyFire, WorldInfo );
	out_DecalData.ClipDecalsUsingFastPath = false;

	if( out_DecalData.bRandomizeRotation == TRUE )
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

/** Internal.  Call once to drop a scorch decal under the sticky fire. */
simulated protected function LeaveScorchDecal()
{
	local GearGRI GRI;

	if ( ScorchDecal == None && EffectIsRelevant(Location, false) )
	{
		GRI = GearGRI(WorldInfo.GRI);
		if (GRI != None)
		{
			ScorchDecal = GRI.LeaveADecal(ScorchDecalTraceFunc_StickyFire, ScorchDecalChoiceFunc_StickyFire);
			if (ScorchDecal != None)
			{
				MIC_ScorchDecal.SetParent( ScorchDecal.GetDecalMaterial() );
				MIC_ScorchDecal.SetScalarParameterValue('Scale1', FRand());
				MIC_ScorchDecal.SetScalarParameterValue('Scale2', FRand());
				ScorchDecal.SetDecalMaterial(MIC_ScorchDecal);
			}
		}
	}
}

defaultproperties
{
	Sound=None
	ParticleSystem=ParticleSystem'COG_IncendiaryGrenade.Effects.P_Incendiary_Base'

	LifeSpan=0.0

	bDestroyOnSystemFinish=false
	bReplicateInstigator=TRUE
	bNetTemporary=TRUE
	RemoteRole=ROLE_SimulatedProxy
	TickGroup=TG_PreAsyncWork // pre because it causes damage

	bCollideActors=true
	Begin Object Class=CylinderComponent Name=CollisionCylinder0
		CollisionRadius=+0032.000000
		CollisionHeight=+0032.00000
		CollideActors=TRUE
	End Object
	CollisionComponent=CollisionCylinder0
	Components.Add(CollisionCylinder0)

	RandomizedScaleRange=(X=0.5,Y=1.8)

	DamageApplicationInterval=0.25f

	DripParticleSystem=ParticleSystem'COG_IncendiaryGrenade.Effects.P_Incendiary_Drip'
	ChanceToDrip=0.5f
	DrippingZThreshold=-0.9

	Begin Object Class=MaterialInstanceConstant Name=MIC_ScorchDecal0
	End Object
	MIC_ScorchDecal=MIC_ScorchDecal0

	DecalFadeCharInTime=0.4f
	DecalFadeEmbersInTime=0.6f
	DecalFadeEmbersOutTime=1.f
	DecalFadeCharOutTime=1.f
	DecalFadeCharDuration=14.0f

	DamageType=class'GDT_StickyFireGeneric'

	bDrawDebug=0
}

