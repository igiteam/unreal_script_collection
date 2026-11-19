/**
 * Locust Naked Ticker
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_LocustNakedTickerBase extends GearPawn_LocustTickerBase
	abstract
	config(Pawn);

/** Type of grenade eaten */
var class<GearProj_Grenade> EatenGrenadeClass;
/** True if a pickup has been eaten */
var bool bEatenPickup;

/** Time that the pickup was eaten */
var transient float PickupEatenTime;
/** The scale that the mesh was before eating a pickup */
var protected transient float PreEatScale;
/** Scale to apply to the mesh after eating a pickup */
var() float PostEatScale;

/** Probability of dropping an ammo pickup if no pickups have been eaten */
var() config float AmmoDropChance;
/** Class of ammo pack to drop if nothing was eaten */
var class<GearAmmoPickup_AmmoCase> AmmoDropClass;

/** Sound to play when doing melee swipe */
var(Sound) SoundCue MeleeSound;
/** Sound to play when eating metal fortifications */
var(Sound) SoundCue ChompMetalSound;
/** Sound to play when eating weapons */
var(Sound) SoundCue ChompWeaponSound;

var ForceFeedbackWaveform MeleeHitRumble;

/** HUD icon for eating grenades */
var ActionInfo EatGrenadeAction;

// No explosions for naked ticker!
simulated function PlayExplodeAnim();
simulated function StopExplodeAnim();
protected function SetupAvoidanceCylinder();

/** Save off the original scale of the naked ticker */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	PreEatScale = Mesh.Scale;

	bNeverAValidEnemy = IsInvisible();
}

function bool ShouldDealDamageToEnemy(Actor Target)
{
	local vector VectToEnemy;
	local float Radius, Height;

	if (Target == None)
	{
		return false;
	}
	else
	{
		VectToEnemy = Target.Location - Location;

		// Enemy must not be too far
		Target.GetBoundingCylinder(Radius, Height);
		if (VSize(VectToEnemy) > (CylinderComponent.CollisionRadius + Radius) * 2.0)
		{
			return false;
		}
		// Ticker must be somewhat facing enemy
		else if (Normal(VectToEnemy) dot vector(Rotation) < 0.0)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
}

simulated function StartMeleeAttack()
{
	if (IsLocallyControlled() && GearPC(Controller) != None && CanDoSpecialMove(GSM_SwipeAttack))
	{
		GearPC(Controller).DoSpecialMove(GSM_SwipeAttack);
	}

	// If this was a b button melee, set the repeat flag
	if (!bool(Controller.bFire))
	{
		bWantsToMelee = TRUE;
	}
}

/**
 * When B button is released stop the melee repeat
 * 
 * @param bForcedByDamage - if the melee stop was forced by damage
 */
simulated function StopMeleeAttack(optional bool bForcedByDamage)
{
	bWantsToMelee = FALSE;
}

function ANIM_NOTIFY_DoMeleeDamage()
{
	local GearWeap_TickerMelee Wpn;
	local Actor Target;

	if (MyGearAI != None)
	{
		Target = MyGearAI.FireTarget;
	}
	else
	{
		foreach VisibleCollidingActors(class'Actor', Target, 24.0, Location + vector(Rotation) * 64.0,,, true)
		{
			if (!Target.bWorldGeometry && !Target.bTearOff && !WorldInfo.GRI.OnSameTeam(Target, self))
			{
				break;
			}
		}
	}
	if (IsDoingSpecialMove(GSM_SwipeAttack) && ShouldDealDamageToEnemy(Target))
	{
		Wpn = GearWeap_TickerMelee(Weapon);
		if (Wpn != None)
		{
			Wpn.DoMeleeDamage(Target, Target.Location, 1.0);
		}
		if (GearPC(Controller) != None)
		{
			GearPC(Controller).ClientPlayForceFeedbackWaveform(MeleeHitRumble);
		}

		if (GearFortification(Target) != None)
		{
			PlaySound(ChompMetalSound);
		}
		else if (GearPawn(Target) != None)
		{
			PlaySound(MeleeSound);
		}
	}
}

/**
 * If we're not showing gore, the naked ticker should just ragdoll
 * 
 * @param GearDamageType - the damage type we were hit by
 * 
 * @param HitLoc - where the damage occurred
 * 
 * @param bShowGore - whether we're showing gore
 */
simulated function PlayRagDollDeath(class<GearDamageType> GearDamageType, vector HitLoc, bool bShowGore)
{
	if (bShowGore)
	{
		Super.PlayRagDollDeath(GearDamageType, HitLoc, bShowGore);
	}
	else
	{
		Super(GearPawn_LocustCreatureBase).PlayRagDollDeath(GearDamageType, HitLoc, bShowGore);
	}	
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local GearWeapon EatenWeapon;
	local GearProj_Grenade DeathGrenade;
	local GearDroppedPickup_Ammo DroppedAmmo;
	local Controller OldController;

	OldController = Controller;

	Super(GearPawn).PlayDying(DamageType,HitLoc);

	StopTickerSounds();

	if( WorldInfo.GRI.ShouldShowGore() )
	{
		// delay by a tick to spread out the cost a bit
		SetTimer(WorldInfo.DeltaSeconds + 0.01, false, nameof(Explode));
	}

	// The pawn has already torn off at this point so can't do an authority check
	if (WorldInfo.NetMode != NM_Client)
	{
		if( bEatenPickup )
		{
			foreach InvManager.InventoryActors(class'GearWeapon', EatenWeapon)
			{
				if( !EatenWeapon.IsA('GearWeap_TickerMelee') )
				{
					if (EatenWeapon != None)
					{
						TossInventory(EatenWeapon);
					}
				}
			}

			if (EatenGrenadeClass != None)
			{
				DeathGrenade = Spawn(EatenGrenadeClass, self,, Location, Rotation,,true);
				DeathGrenade.InstigatorController = OldController;
				if (DeathGrenade != None && !DeathGrenade.bDeleteMe)
				{
					DeathGrenade.MartyrInit(self);
				}
			}
		}
		else if (FRand() < AmmoDropChance && PlayerController(OldController) == None)
		{
			DroppedAmmo = Spawn(class'GearDroppedPickup_Ammo');
			if( DroppedAmmo != None )
			{
				DroppedAmmo.BackingClass = AmmoDropClass;
				DroppedAmmo.SetPickupMesh(AmmoDropClass.default.PickupMesh);
				DroppedAmmo.SetPhysics(PHYS_Falling);
			}
		}
	}
}

simulated function Explode()
{
	local GearExplosionActor ExplosionActor;
	local Vector ExplosionLoc;
	local rotator ExplosionRot;

	if(!bPopped)
	{
		bPopped = TRUE;
		Mesh.GetSocketWorldLocationAndRotation(ExplosionBoneName, ExplosionLoc, ExplosionRot);

		// Spawn explosion
		ExplosionActor = Spawn(class'GearExplosionActor', self,, ExplosionLoc, ExplosionRot);
		ExplosionTemplate.InitFromContentTemplate();
		ExplosionActor.Explode(ExplosionTemplate);

		// Gibs
		SetTimer(WorldInfo.DeltaSeconds + 0.01, false, nameof(SpawnABloodTrail_GibExplode_360));
		if ( EffectIsRelevant(Location, false) )
		{
			SpawnHeadChunks();
		}
	}
}

/** Tell Pawn to pick up weapon A */
reliable server function PickupWeapon(Actor A)
{
	if( ( CanPickUpActor(A) || GearProj_Grenade(A) != None ) && CanDoSpecialMove(SM_WeaponPickup) )
	{
		// Claim pickup so noone else can pick it up
		ClaimPickup(A);

		if( A.Physics == PHYS_None &&
			A.Location.Z - Location.Z > 30.f )
		{
			VerifySMHasBeenInstanced(GSM_Ticker_LeapToPlantedGrenade);
			GSM_Ticker_LeapToPlantedGrenade(SpecialMoves[GSM_Ticker_LeapToPlantedGrenade]).PickupActor = A;
			ServerDoSpecialMove(GSM_Ticker_LeapToPlantedGrenade, TRUE, None);
		}
		else
		{
			VerifySMHasBeenInstanced(SM_WeaponPickup);
			GSM_Ticker_EatPickup(SpecialMoves[SM_WeaponPickup]).PickupActor = A;
			ServerDoSpecialMove(SM_WeaponPickup, TRUE, None);
		}
	}
}

function GrabPickup(Actor Pickup)
{
	local GearDroppedPickup	DP;
	local GearWeaponPickupFactory Factory;
	local GearProj_Grenade Grenade;

	// make sure that the pickup is still valid
	if( Pickup != None && !Pickup.bDeleteMe )
	{
		Grenade = GearProj_Grenade(Pickup);
		DP = GearDroppedPickup(Pickup);
		Factory = GearWeaponPickupFactory(Pickup);

		if( Grenade != None )
		{
			bEatenPickup = true;
			EatenGrenadeClass = Grenade.Class;
			Grenade.Destroy();
			PickupEatenTime = WorldInfo.TimeSeconds;
		}
		else if( DP != None )
		{
			// Grenades are treated differently, because they explode when the ticker is killed instead of being dropped
			if( ClassIsChildOf(DP.InventoryClass, class'GearWeap_GrenadeBase') )
			{
				EatenGrenadeClass = GearWeap_GrenadeBase(DP.Inventory).GetGrenadeClass();
			}
			else if( DP.Inventory != None )
			{
				DP.SpawnCopyFor(self);
			}

			bEatenPickup = true;
			PickupEatenTime = WorldInfo.TimeSeconds;
			DP.PickedUpBy(self);
		}
		else if( Factory != None )
		{
			// Grenades are treated differently, because they explode when the ticker is killed instead of being dropped
			if( ClassIsChildOf(Factory.WeaponPickupClass, class'GearWeap_GrenadeBase') )
			{
				EatenGrenadeClass = class<GearProj_Grenade>(Factory.WeaponPickupClass.default.WeaponProjectiles[0]);
			}
			else if( Factory.WeaponPickupClass != None )
			{
				Factory.GiveTo(self);
			}

			bEatenPickup = true;
			PickupEatenTime = WorldInfo.TimeSeconds;
			Factory.PickedUpBy(self);
		}

		PlaySound(ChompWeaponSound);
	}
}

function TakeDamage( int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType,
			optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	// naked tickers are immune to direct damage from fortifications
	if (GearFortification(DamageCauser) == None)
	{
		Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	}
}

function GetSpecialPickupAction(out Actor FoundActor, out ActionInfo FoundAction, optional bool bHidePurchaseItems, optional bool bHideFreeItems)
{
	local GearProj_Grenade Grenade;

	if (!bHideFreeItems)
	{
		foreach CollidingActors(class'GearProj_Grenade', Grenade, class'GearAI_NakedTicker'.default.PickupLeapRangeMax)
		{
			if (!Grenade.bIsSimulating && FastTrace(Grenade.Location, Location,, true))
			{
				FoundActor = Grenade;
				FoundAction = EatGrenadeAction;

				if (Grenade.OwningWeaponClass != None)
				{
					FoundAction.ActionIconDatas[2].ActionIcons[0] = Grenade.OwningWeaponClass.default.WeaponIcon;
				}
				return;
			}
		}
	}
}

/** Lerp up the scale of the naked ticker if it has eaten a pickup */
simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if (bEatenPickup && Mesh.Scale < PostEatScale)
	{
		Mesh.SetScale(Lerp(PreEatScale, PostEatScale, FClamp(`TimeSince(PickupEatenTime), 0.f, 1.f)));
	}

	// allow melee button to repeatedly melee
	if (IsHumanControlled() && IsLocallyControlled() && bWantsToMelee)
	{
		StartMeleeAttack();
	}
}

defaultproperties
{
	InventoryManagerClass=class'GearInventoryManager'
	bCanPickupInventory=true

	DefaultInventory.Empty()
	DefaultInventory(0)=class'GearGame.GearWeap_TickerMelee'

	ControllerClass=class'GearGame.GearAI_NakedTicker'

	ExplosionBoneName=Explode

	bCanBeBaseForPawns=false
	bCanTriggerGrenadeTrap=false
	bInvisibleInSP=true
	bIgnoredByFortifications=true

	MeleeDamageBoneName="pelvis"
	RightHandSocketName=""

	DustCloudSocketName=Ground_Dust

	bCanStrafe=true
	PeripheralVision=-0.75f
	RotationRate=(Pitch=20000,Yaw=65535,Roll=20000)

	SightBoneName=none
	PelvisBoneName=none

	SpecialMoveClasses(GSM_SwipeAttack)=class'GSM_Ticker_Melee'
	SpecialMoveClasses(SM_WeaponPickup)=class'GSM_Ticker_EatPickup'
	SpecialMoveClasses(GSM_Ticker_LeapToPickup)=class'GSM_Ticker_LeapForward'
	SpecialMoveClasses(GSM_Ticker_LeapToPlantedGrenade)=class'GSM_Ticker_LeapToPlantedGrenade'

	PostEatScale=1.05

	Begin Object Name=GearPawnMesh
		Scale=0.9
		Translation=(z=-44)
		Rotation=(Yaw=-16384)  // fix this up for gears3 meshes should NOT be imported flipped like this.  Content MUST fix it
	End Object

	Begin Object Name=CollisionCylinder
		CollisionHeight=+0044.000000
	End Object

	// Override the explosion template
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=None
		MomentumTransferScale=0.0
		FractureMeshRadius=0.0
		FracturePartVel=0.0
	End Object
	ExplosionTemplate=ExploTemplate0

	NoticedGUDSEvent=GUDEvent_NoticedNakedTicker

	SiegeTutorialType=GEARTUT_SIEGE_NakedTicker

	AimAttractors(0)=(OuterRadius=96.f,InnerRadius=32.f,BoneName="chest")

	bNeverAValidEnemy=TRUE

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformMelee
		Samples(0)=(LeftAmplitude=40,RightAmplitude=40,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.200)
	End Object
	MeleeHitRumble=ForceFeedbackWaveformMelee
}
