
/**
 * GearPawn_LocustBrumakBase2
 * Script code moved down from GearPawn_LocustBrumak so it's in a native package that can be patched.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_LocustBrumakBase2 extends GearPawn_LocustBrumakBase
	config(Pawn)
	abstract;

//////// EFFECT VARIABLES //////////
// /** Pain vocal **/
// var SoundCue PainSound;
/** List of Roar sound cues */
var array<SoundCue> RoarSound;
/** Sound when side gun is blown off */
var SoundCue ArmBlowSoundCue;

/** Particle effects and template for side gun destruction */
var ParticleSystem PS_Stage1_SGL, PS_Stage2_SGL, PS_Stage3_SGL, PS_Stage4_SGL;
var ParticleSystem PS_Stage1_SGR, PS_Stage2_SGR, PS_Stage3_SGR, PS_Stage4_SGR;
var ParticleSystemComponent PSC_LeftGunDestroyed, PSC_RightGunDestroyed;
/** Explosion template for sidegun explosion */
var() editinline GearExplosion	LeftSideGunExplosionTemplate, RightSideGunExplosionTemplate;
var GearExplosionContent GEC_Stage2_SG, GEC_Stage3_SG, GEC_Stage4_SG;

// Helmet Damage Effects
var config float HeadHealthR, HeadHealthL;
var config repnotify byte HeadLivesR, HeadLivesL;
var ParticleSystem PS_Stage1_Helmet, PS_Stage2_HelmetR, PS_Stage2_HelmetL, PS_Stage3_HelmetR, PS_Stage3_HelmetL;
var ParticleSystemComponent PSC_HeadDamage;

var PrimitiveComponent	LastTakeDamageComponent;

/** Main Gun effect vars */
var ParticleSystem              PS_MainGun_Stage1, PS_MainGun_Stage2, PS_MainGun_Stage3, PS_MainGun_Stage4;
var ParticleSystemComponent     PSC_MainGunDestruction;
var() editinline GearExplosion	MainGunExplosionTemplate;
var GearExplosionContent        GEC_MainGun_Stage2, GEC_MainGun_Stage3, GEC_MainGun_Stage4;
var SoundCue                    MainGunDestructionSoundCue;

/**** Backpack vars ****/

/** Backpack explosion delay */
var config float    BackPackExplosionDelay;
/** backback health */
var config float    BackpackHealth;
/** Amount of damage backpack needs before enabling damage effects */
var config float    BackPackDamageEffectsThresh;
/** Damage to give at explosion epicenter. Duplicated from Explosion template so it can be config. */
var() config float	BackPackExploBaseDamage;
/** Radius to apply damage.  Damage falls off linearly from center to edge of radius.  Duplicated from Explosion template so it can be config. */
var() config float	BackPackExploDamageRadius;
/** Damage falloff exponent (1 = linear).  Duplicated from Explosion template so it can be config. */
var() config float	BackPackExploDamageFalloff;
/** backpack hit bone name */
var Name BackPackBoneName;
/** Socket the tank is attached to */
var Name BackPackSocketName, BackPackDamageSocketName;
/** bool indicating we should play backpack damage effects */
var repnotify bool bBackPackDamaged;
/** bool indicating we should play backpack explosion */
var repnotify bool bBackPackDestroyed;

/** Particle effects for backpack explosion */
var ParticleSystem  BackPackDamagedPSTemplate;
var ParticleSystem  BackPackAboutToExplodePSTemplate;

var ParticleSystemComponent     PSC_BackPackDamagedPS;
var ParticleSystemComponent     PSC_BackPackAboutToExplode;

/** sounds for backpack explosion */
var SoundCue                    BackPackIgnitedCue;
var SoundCue                    BackPackPostExplodeCrackleCue;

/** Explosion template for backpack explosion */
var() editinline GearExplosion	BackPackExplosionTemplate;

/** reference to the person that triggered the backpack explosion */
var Pawn                        BackPackExplosionInstigator;

var class<GearDamageType>       BackPackExplosionDamageType;

/** audio comp for crackling sound after backpack explodes */
var AudioComponent              BackPackFireCracklingSound;

/** Classes to spawn for the side guns and main gun. */
var const class<Inventory>    SideGunInventoryClass, MainGunInventoryClass;

/* Texture used for gore mask material - mutated versions*/
var transient TextureRenderTarget2D ArmLegMaskTexture;
/** HitMask Component - mutated versions **/
var SceneCapture2DHitMaskComponent ArmLegHitMaskComponent;

/** Last Time Brumak focused on an enemy. */
var float LastEnemyFocusTime;

replication
{
	if( Role==ROLE_Authority )
		bBackPackDamaged, bBackPackDestroyed, HeadLivesR, HeadLivesL;
}

simulated function PostBeginPlay()
{
	local GearAI_BrumakDriver	DriverController;
	local GearAI_Brumak_SideGun	RightGunController, LeftGunController;
	local GearPawn				NewDriver;
	local Pawn					NewLeftGun, NewRightGun;

	super.PostBeginPlay();

	if( Role == ROLE_Authority )
	{
		// Spawn Driver and Attach him to the Brumak mesh
		NewDriver = Spawn(DriverClass,,,,,,TRUE); // ignore encroach on spawn
		if( NewDriver != None )
		{
			SetDriver( NewDriver );

			DriverController = Spawn( class'GearAI_BrumakDriver' );
			DriverController.SetTeam( 1 );
			DriverController.Possess( Driver, FALSE );
			// Initialize health & other variables
			WorldInfo.Game.SetPlayerDefaults(NewDriver);
		}

		// Spawn faux pawns for side guns
		NewRightGun = Spawn(SideGunClass,,,,,,TRUE); // ignore encroach on spawn
		if( NewRightGun != None )
		{
			SetGunner( NewRightGun, 1 );

			RightGunController = Spawn( class'GearAI_Brumak_SideGun' );
			RightGunController.SetTeam( 1 );
			RightGunController.Possess( RightGunPawn, FALSE );

			// Initialize health & other variables
			WorldInfo.Game.SetPlayerDefaults(NewRightGun);
		}
		NewLeftGun = Spawn(SideGunClass,,,,,,TRUE); // ignore encroach on spawn
		if( NewLeftGun != None )
		{
			SetGunner( NewLeftGun, -1 );

			LeftGunController = Spawn( class'GearAI_Brumak_SideGun' );
			LeftGunController.SetTeam( 1 );
			LeftGunController.Possess( LeftGunPawn, FALSE );

			// Initialize health & other variables
			WorldInfo.Game.SetPlayerDefaults(NewLeftGun);
		}
	}

	if( LeftGunComponent != None )
	{
		Mesh.AttachComponentToSocket( LeftGunComponent, 'leftgun' );
		LeftGunComponent.SetShadowParent( Mesh );
		LeftGunComponent.SetLightEnvironment( LightEnvironment );
	}

	if( RightGunComponent != None )
	{
		Mesh.AttachComponentToSocket( RightGunComponent, 'rightgun' );
		RightGunComponent.SetShadowParent( Mesh );
		RightGunComponent.SetLightEnvironment( LightEnvironment );
	}

	if (BackpackComponent != None)
	{
		Mesh.AttachComponentToSocket(BackpackComponent, BackPackSocketName);
		BackpackComponent.SetShadowParent(Mesh);
		BackpackComponent.SetLightEnvironment(LightEnvironment);
	}

	if( MaskComponent != None )
	{
		Mesh.AttachComponentToSocket( MaskComponent, 'head' );
		MaskComponent.SetShadowParent( Mesh );
		MaskComponent.SetLightEnvironment( LightEnvironment );
	}
}

/** Interpolate side gun aiming toward respective targets */
simulated function UpdateMeshBoneControllers(float DeltaTime)
{
	local Rotator	DeltaRot;
	local Vector2D	NewAimPct;
	local bool		bUpdateLeftGun, bUpdateRightGun, bUpdateMainGun;

	Super.UpdateMeshBoneControllers(DeltaTime);

	AimOffsetViewLoc = GetAimOffsetViewLocation();

	if( Role == ROLE_Authority )
	{
		if( LeftGunAimController != None )
		{
			if( LeftGunTarget != None )
			{
				LeftGunAimLocation = GetGunLookTargetLocation( LeftGunTarget, LeftGunAimController );
				if( LeftGunPawn != None && IsWithinLeftGunFOV( LeftGunAimLocation ) )
				{
					bUpdateLeftGun = TRUE;
				}
			}

			if( !bUpdateLeftGun )
			{
				LeftGunAimLocation = vect(0,0,0);
			}
		}

		if( RightGunAimController != None )
		{
			if( RightGunTarget != None )
			{
				RightGunAimLocation = GetGunLookTargetLocation( RightGunTarget, RightGunAimController );
				if( RightGunPawn != None && IsWithinRightGunFOV( RightGunAimLocation ) )
				{
					bUpdateRightGun = TRUE;
				}
			}

			if( !bUpdateRightGun )
			{
				RightGunAimLocation = vect(0,0,0);
			}
		}

		if( MainGunAimController1 != None && MainGunAimController2 != None )
		{
			// If there is a target for the main gun
			if( MainGunTarget != None && !IsMainGunDestroyed() )
			{
				MainGunAimLocation = GetGunLookTargetLocation( MainGunTarget, MainGunAimController1 );
				// If target is not in FOV
				if( Driver != None && IsWithinMainGunFOV( MainGunAimLocation ) )
				{
					bUpdateMainGun = TRUE;
				}
			}

			if( !bUpdateMainGun )
			{
				MainGunAimLocation = vect(0,0,0);
			}
		}
	}

///// UPDATE CONTROLLERS ON CLIENT AND SERVER
	if( LeftGunAimController != None )
	{
		if( !IsZero(LeftGunAimLocation) && !bDisableSideGunAimControllers)
		{
			// Target is in FOV ... make sure we are blend tracking it
			if( LeftGunAimController.LookAtAlphaTarget != 1.f )
			{
				LeftGunAimController.SetLookAtAlpha(  1.f, 0.45f );
				LeftArmAimOffsetBlend.SetBlendTarget( 1.f, 0.45f );
			}

			// Update the target location and update gun
			LeftGunAimController.SetTargetLocation( LeftGunAimLocation );
			LeftGunAimController.InterpolateTargetLocation( DeltaTime );

			// Update AimOffset
			DeltaRot = Normalize(rotator(LeftGunAimLocation - AimOffsetViewLoc) - Rotation);
			NewAimPct.X = DeltaRot.Yaw	 / 16384.f;
			NewAimPct.Y = DeltaRot.Pitch / 16384.f;
			LeftGunAimPct.X = AimInterpTo(LeftGunAimPct.X, NewAimPct.X, DeltaTime, float(RotationRate.Yaw) / 16384.0 / 2.0);
			LeftGunAimPct.Y = AimInterpTo(LeftGunAimPct.Y, NewAimPct.Y, DeltaTime, float(RotationRate.Yaw) / 16384.0 / 2.0);

			// Update Recoil Controllers
			IKRecoilCtrl[0].Aim = LeftGunAimPct;
		}
		else
		// Blend out until target is in the FOV
		if( LeftGunAimController.LookAtAlphaTarget != 0.f )
		{
			LeftGunAimController.SetLookAtAlpha(  0.f, 0.45f );
			LeftArmAimOffsetBlend.SetBlendTarget( 0.f, 0.45f );
		}
	}

	if( RightGunAimController != None )
	{
		if( !IsZero(RightGunAimLocation) && !bDisableSideGunAimControllers)
		{
			// Target is in FOV ... make sure we are blend tracking it
			if( RightGunAimController.LookAtAlphaTarget != 1.f )
			{
				RightGunAimController.SetLookAtAlpha(  1.f, 0.45f );
				RightArmAimOffsetBlend.SetBlendTarget( 1.f, 0.45f );
			}

			// Update the target location and update gun
			RightGunAimController.SetTargetLocation( RightGunAimLocation );
			RightGunAimController.InterpolateTargetLocation( DeltaTime );

			// Update AimOffset
			DeltaRot = Normalize(rotator(RightGunAimLocation - AimOffsetViewLoc) - Rotation);
			NewAimPct.X = DeltaRot.Yaw	 / 16384.f;
			NewAimPct.Y = DeltaRot.Pitch / 16384.f;
			RightGunAimPct.X = AimInterpTo(RightGunAimPct.X, NewAimPct.X, DeltaTime, float(RotationRate.Yaw) / 16384.0 / 2.0);
			RightGunAimPct.Y = AimInterpTo(RightGunAimPct.Y, NewAimPct.Y, DeltaTime, float(RotationRate.Yaw) / 16384.0 / 2.0);

			// Update Recoil Controllers
			IKRecoilCtrl[1].Aim = RightGunAimPct;
		}
		else
		// Blend out until target is in the FOV
		if( RightGunAimController.LookAtAlphaTarget != 0.f )
		{
			RightGunAimController.SetLookAtAlpha(  0.f, 0.45f );
			RightArmAimOffsetBlend.SetBlendTarget( 0.f, 0.45f );
		}
	}

	if( MainGunAimController1 != None && MainGunAimController2 != None )
	{
		if( !IsZero(MainGunAimLocation) )
		{
			// Target is in FOV ... make sure we are blend tracking it
			if( MainGunAimController1.LookAtAlphaTarget != 1.f )
			{
				MainGunAimController1.SetLookAtAlpha( 1.f, 0.75f );
				MainGunAimController2.SetLookAtAlpha( 1.f, 0.75f );
			}

			// Update the target location and update gun
			MainGunAimController1.SetTargetLocation( MainGunAimLocation );
			MainGunAimController2.SetTargetLocation( MainGunAimLocation );

			MainGunAimController1.InterpolateTargetLocation( DeltaTime );
			MainGunAimController2.InterpolateTargetLocation( DeltaTime );
		}
		else
		// Blend out until target is in the FOV
		if( MainGunAimController1.LookAtAlphaTarget != 0.f )
		{
			MainGunAimController1.SetLookAtAlpha( 0.f, 0.75f );
			MainGunAimController2.SetLookAtAlpha( 0.f, 0.75f );
		}
	}
}

function SetDriver(GearPawn NewDriver, optional Controller AttachController)
{
		//debug
	`log( GetFuncName()@Driver@NewDriver,bDebug );

	MainGunTarget = None;

	Super.SetDriver(NewDriver, AttachController);
}

/** Event called when new Driver is Set. Called on server only. */
function OnDriverSet()
{
	Super.OnDriverSet();
	Health = DefaultHealth;

	Driver.CreateInventory( MainGunInventoryClass );
	MainGunAimController1.SetLookAtAlpha( 0.f, 0.1f );
	MainGunAimController2.SetLookAtAlpha( 0.f, 0.1f );
	Driver.SetHidden(true);
}

function OnDriverUnset(GearPawn OldDriver)
{
	LeftGunAimController.SetLookAtAlpha(  0.f, 0.1f );
	RightGunAimController.SetLookAtAlpha( 0.f, 0.1f );
}

function SetGunner( Pawn NewGunner, optional int Side )
{
	//debug
	`log( GetFuncName()@LeftGunPawn@RightGunPawn@NewGunner@Side,bDebug );

	if( Side == 0 )
		return;

	if( Side < 0 ) // Left side
	{
		LeftGunTarget	= None;
		if( LeftGunPawn != None && !LeftGunPawn.IsHumanControlled() )
		{
			LeftGunPawn.Controller.PawnDied( LeftGunPawn );
			LeftGunPawn.Destroy();
		}
		LeftGunPawn = NewGunner;
		if( LeftGunPawn != None )
		{
			LeftGunPawn.SetPhysics( PHYS_None );
			LeftGunPawn.SetOwner( self );
			LeftGunPawn.SetBase( self,, Mesh, DriverSocket );
			GearPawn_LocustBrumak_SideGun(LeftGunPawn).bIsLeftGun = TRUE;

			LeftGunPawn.CreateInventory( SideGunInventoryClass );

			LeftGunAimController.SetLookAtAlpha( 0.f, 0.1f );
		}
	}
	else
	if( Side > 0 ) // Right side
	{
		RightGunTarget	= None;
		if( RightGunPawn != None && !RightGunPawn.IsHumanControlled() )
		{
			RightGunPawn.Controller.PawnDied( RightGunPawn );
			RightGunPawn.Destroy();
		}
		RightGunPawn = NewGunner;
		if( RightGunPawn != None )
		{
			RightGunPawn.SetPhysics( PHYS_None );
			RightGunPawn.SetOwner( self );
			RightGunPawn.SetBase( self,, Mesh, DriverSocket );
			RightGunPawn.CreateInventory( SideGunInventoryClass );

			RightGunAimController.SetLookAtAlpha( 0.f, 0.1f );
		}
	}
	SetHumanGunner( None );
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	// Show live debugging information
	if( bDebug )
	{
		WorldInfo.AddOnScreenDebugMessage(0, 1.f, MakeColor(255, 255, 255, 255), `showvar(Health) );
		WorldInfo.AddOnScreenDebugMessage(1, 1.f, MakeColor(255, 255, 255, 255), `showvar(MainGunHealth) @ `showvar(MainGunLives) );
		WorldInfo.AddOnScreenDebugMessage(2, 1.f, MakeColor(255, 255, 255, 255), `showvar(LeftGunHealth) @ `showvar(LeftGunLives) @ `showvar(SideGunDestroyedHitPointPenalty) );
		WorldInfo.AddOnScreenDebugMessage(3, 1.f, MakeColor(255, 255, 255, 255), `showvar(RightGunHealth) @ `showvar(RightGunLives) );
		WorldInfo.AddOnScreenDebugMessage(4, 1.f, MakeColor(255, 255, 255, 255), `showvar(BackpackHealth) @ `showvar(BackpackDestroyedHitPointPenalty) );
		WorldInfo.AddOnScreenDebugMessage(5, 1.f, MakeColor(255, 255, 255, 255), `showvar(HeadHealthL) @ `showvar(HeadHealthR) @ `showvar(HeadLivesL) @ `showvar(HeadLivesR) );
	}
}

function PruneDamagedBoneList( out array<Name> Bones )
{
	local bool	bLegs, bUsed;
	local int	Idx;

	for( Idx = 0; Idx < Bones.Length; Idx++ )
	{
		bUsed = FALSE;
		if( !bLegs && IsLegBone( Bones[Idx] ) )
		{
			bUsed = TRUE;
			bLegs = TRUE;
		}

		if( !bUsed )
		{
			Bones.Remove(Idx--, 1);
		}
	}
}

simulated event ReplicatedEvent( Name VarName )
{
	if( VarName == nameof(HeadLivesR) )
	{
		PlayHeadDamageR();
	}
	else if( VarName == nameof(HeadLivesL) )
	{
		PlayHeadDamageL();
	}
	else if( VarName == nameof(LeftGunLives) )
	{
		PlaySideGunDestroyed(LeftGunComponent, (LeftGunLives == 0));

	}
	else if (VarName == nameof(RightGunLives))
	{
		PlaySideGunDestroyed(RightGunComponent, (RightGunLives ==0));
	}
	else if (VarName == nameof(bBackPackDamaged))
	{
		if (bBackPackDamaged && !bBackPackDestroyed)
		{
			PlayBackPackDamageEffects();
		}
	}
	else if (VarName == nameof(bBackPackDestroyed))
	{
		if (bBackPackDestroyed)
		{
			PlayBackPackDestroyed();
		}
	}
	else if( VarName == nameof(MainGunLives) )
	{
		PlayMainGunDestruction();
	}
	else
	{
		Super.ReplicatedEvent( VarName );
	}
}

/**
* Overridden for GoW's specific damage taking needs, whee!
*
* @see Actor::TakeDamage
*/
function TakeDamage
(
	int					Damage,
	Controller			InstigatedBy,
	Vector				HitLocation,
	Vector				Momentum,
	class<DamageType>	DamageType,
	optional	TraceHitInfo		HitInfo,
	optional	Actor				DamageCauser
)
{
	// We will modify damage by AdjustPawnDamage function
	SetDontModifyDamage(false);

	LastTakeDamageComponent = HitInfo.HitComponent;

	// call Actor's version to handle any SeqEvent_TakeDamage for scripting
	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );

	if (InGodMode())
	{
		PlayTakeHit(Damage, (InstigatedBy != None) ? InstigatedBy.Pawn : None, HitLocation, DamageType, Momentum, HitInfo);
	}
}

/** Different from GearPawn - don't want to stop ticking because of gore */
simulated function StopAllAnimations()
{
	local AnimNodeSequence	SeqNode;

	foreach Mesh.AllAnimNodes(class'AnimNodeSequence', SeqNode)
	{
		SeqNode.bPlaying = FALSE;
	}
}


//////////////////////////////////////////////////////////////////////////
// Backpack stuff
//////////////////////////////////////////////////////////////////////////

simulated function bool IsBackPackDamgedEnoughForEffects()
{
	return (BackpackHealth <= BackPackDamageEffectsThresh);
}

final function bool IsBackPackDestroyed()
{
	return (BackpackHealth <= 0);
}

// function responsible for playing backpack explosion effects only
simulated function PlayBackPackDestroyed()
{
	bBackPackDestroyed = TRUE;
	GotoState('BackPackExploding');
}

simulated function ParticleSystemComponent SetUpAndStartParticleSystemComponent( ParticleSystem Template, name BoneAttachName, Vector BoneAttachOffset, optional bool bIsSocket )
{
	local ParticleSystemComponent PSC;

	PSC = new(self) class'ParticleSystemComponent';
	PSC.SetTemplate( Template );
	PSC.SetScale( DrawScale );
	PSC.bAutoActivate = FALSE;

	if( bIsSocket )
	{
		Mesh.AttachComponentToSocket(PSC, BoneAttachName);
		PSC.SetTranslation( PSC.Translation + BoneAttachOffset );
	}
	else
	{
		Mesh.AttachComponent(PSC, BoneAttachName, BoneAttachOffset,,);
	}

	PSC.SetHidden( FALSE );
	PSC.ActivateSystem();
	return PSC;
}

// function responsible for starting backpack damage effects only
simulated function PlayBackPackDamageEffects()
{
	if( PSC_BackPackDamagedPS == None )
	{
		bBackPackDamaged = TRUE;

		// damaged!
		PSC_BackPackDamagedPS = SetUpAndStartParticleSystemComponent(BackPackDamagedPSTemplate, BackPackDamageSocketName, vect(-150,50,0), TRUE);
		PSC_BackPackDamagedPS.SetScale(4.0f);
	}
}

simulated protected function BackPackExplode()
{
// 	local GearExplosionActor ExplosionActor;
// // 	local GearPRI InstigatorPRI, MyPRI;
// 
// 	// Turn off the damage effects on the tank
// 	if( PSC_BackPackDamagedPS != None )
// 	{
// 		PSC_BackPackDamagedPS.DeactivateSystem();
// 		PSC_BackPackDamagedPS = None;
// 	}
// 
// 	// spawn explosion
// 	ExplosionActor = Spawn(class'GearExplosionActor', self,, Mesh.GetBoneLocation(BackPackBoneName,0), rot(16384,0,0));
// 	ExplosionActor.Instigator = BackPackExplosionInstigator;
// 	ExplosionActor.InstigatorController = BackPackExplosionInstigator.Controller;
// 	BackPackExplosionTemplate.InitFromContentTemplate();
// 	BackPackExplosionTemplate.Damage = BackPackExploBaseDamage;
// 	BackPackExplosionTemplate.DamageRadius = BackPackExploDamageRadius;
// 	BackPackExplosionTemplate.DamageFalloffExponent = BackPackExploDamageFalloff;
// 	BackPackExplosionTemplate.CamShakeOuterRadius = BackPackExploDamageRadius;
// 	BackPackExplosionTemplate.MomentumTransferScale = 1.0;
// 	ExplosionActor.Explode(BackPackExplosionTemplate);

// 	// chalk one up for the instigator
// 	if(BackPackExplosionInstigator != none)
// 	{
// 		InstigatorPRI = GearPRI(BackPackExplosionInstigator.Controller.PlayerReplicationInfo);
// 		MyPRI = GearPRI(PlayerReplicationInfo);
// 		if (InstigatorPRI != None && MyPRI != none)
// 		{
// 			// track the kill for the instigator
// 			InstigatorPRI.ScoreInstantKill(MyPRI, BackPackExplosionDamageType, GDT_NORMAL);
// 		}
// 	}
	// Kill creature.
	Died(BackPackExplosionInstigator.Controller, BackPackExplosionDamageType, Location);

// 	PlayMainGunDestruction();
}

/** Called from Death animation ANIM_NOTIFY */
simulated function Brumak_Exploded()
{
	// Hide Brumak Mesh and attachments
	Mesh.SetHidden(TRUE);
	RightGunComponent.SetHidden(TRUE);
	LeftGunComponent.SetHidden(TRUE);
	BackpackComponent.SetHidden(TRUE);
	MaskComponent.SetHidden(TRUE);

	// Turn off the damage effects on the tank
	if( PSC_BackPackDamagedPS != None )
	{
		PSC_BackPackDamagedPS.DeactivateSystem();
		PSC_BackPackDamagedPS = None;
	}

	// Kill in 3 seconds...
	LifeSpan = 3.f;
}

simulated state BackPackExploding
{
	function AdjustPawnDamage( out int Damage, Pawn InstigatedBy, vector HitLocation, out vector Momentum,
					class<GearDamageType> GearDamageType, Actor DamageCauser, optional out TraceHitInfo HitInfo )
	{
		// zero out damage because we want th explosion sequence to finish
		if(InstigatedBy != self)
		{
			Damage=0;
		}
		PlayTakeHit(Damage, InstigatedBy, HitLocation, GearDamageType, Momentum, HitInfo);
	}

	function BeginState(Name PreviousStateName)
	{
		if( PSC_BackPackDamagedPS != None )
		{
			PSC_BackPackDamagedPS.DeactivateSystem();
			Mesh.DetachComponent(PSC_BackPackDamagedPS);
			PSC_BackPackDamagedPS = None;
		}

// 		PSC_BackPackAboutToExplode = SetUpAndStartParticleSystemComponent(BackPackAboutToExplodePSTemplate,BackPackSocketName,vect(0,0,0), true);

		// play explosion start sound
		PlaySound(BackPackIgnitedCue, TRUE);
	}

	function StopFiringWeapons()
	{
		local GearAI_Brumak BrumakAI;
		BrumakAI = GearAI_Brumak(Controller);
		if( BrumakAI != None )
		{
			BrumakAI.DriverAI.StopFiring();
			BrumakAI.LeftGunAI.StopFiring();
			BrumakAI.RightGunAI.StopFiring();
		}
	}

Begin:
	// start crackling sound
	if( BackPackFireCracklingSound == None )
	{
		BackPackFireCracklingSound = CreateAudioComponent(BackPackPostExplodeCrackleCue,false,true);
		if( BackPackFireCracklingSound != none )
		{
			BackPackFireCracklingSound.bUseOwnerLocation = true;
			BackPackFireCracklingSound.bAutoDestroy = true;
			BackPackFireCracklingSound.Location = location;
			AttachComponent(BackPackFireCracklingSound);
		}
		else
		{
			`log(self@"Brumak couldn't create backpack fire crackling sound.. :(");
		}
	}
	if(BackPackFireCracklingSound != none)
	{
		BackPackFireCracklingSound.FadeIn(0.2f,1.0f);
	}

	StopFiringWeapons();
	// trigger explosion
	BackPackExplode();
	Sleep(BackPackExplosionDelay);

	// play angry roar
	PlayRoar();
	GotoState('');
};
// End backpack
//////////////////////////////////////////////////////////////////////////


/** Both side guns have to be destroyed before we can shoot the main gun. Because until then, driver is immortal. */
simulated final function bool CanShootMainGun()
{
	return TRUE;
}

simulated final function bool CanShootLeftGun()
{
	return !IsDoingSpecialMove(GSM_Brumak_LtGunHit) && !IsDoingSpecialMove(GSM_Brumak_LtGunPain);
}

simulated final function bool CanShootRightGun()
{
	return !IsDoingSpecialMove(GSM_Brumak_RtGunHit) && !IsDoingSpecialMove(GSM_Brumak_RtGunPain);
}

/**
 * Reticle plus for guns and backpack.
 */
simulated function bool ShouldDisplayCrosshairPlus(GearPC PC, vector HitLocation, Name HitBone, PrimitiveComponent HitComponent)
{
	if( HitLeftGunBone(HitComponent) || HitRightGunBone(HitComponent) || HitBackpack(HitComponent) || (MainGunHealth > 0 && IsRocketPackBone(HitBone)) )
	{
		return TRUE;
	}

	return Super.ShouldDisplayCrosshairPlus(PC, HitLocation, HitBone, HitComponent);
}


/** Handle taking damage in various body locations */
function AdjustPawnDamage( out int Damage, Pawn InstigatedBy, vector HitLocation, out vector Momentum,
				class<GearDamageType> GearDamageType, Actor DamageCauser, optional out TraceHitInfo HitInfo )
{
	local bool bHitLeftGun, bHitRightGun, bHitBackpack, bHitMainGun;
	local vector HeadSocketLoc, X, Y, Z;
	local rotator HeadSocketRot;

	if( InGodMode() )
	{
		Damage = 0;
		return;
	}

	// See if we hit any of our attachments
	bHitLeftGun = (LeftGunHealth > 0) && HitLeftGunBone(LastTakeDamageComponent);
	bHitRightGun = (RightGunHealth > 0) && HitRightGunBone(LastTakeDamageComponent);
	bHitBackpack = (BackpackHealth > 0) && HitBackpack(LastTakeDamageComponent);
	bHitMainGun = (MainGunHealth > 0) && IsRocketPackBone(HitInfo.BoneName);

	// Hit Head - break down helmet.
	if( (HeadLivesR > 0 || HeadLivesL > 0) && HitHead(HitInfo.BoneName) )
	{
		// Figure out if we hit left or right side.
		Mesh.GetSocketWorldLocationAndRotation('head', HeadSocketLoc, HeadSocketRot);
		GetAxes(HeadSocketRot, X, Y, Z);
		// On the Head Socket, X is pointing Right.
		if( ((HitLocation - HeadSocketLoc) dot X) >= 0 )
		{
			// Hit Right
			if( HeadLivesR > 0 )
			{
				// Only let players finish off the guns, not AI
				// Don't trigger state when already doing a special move, it would not be triggered.
				if( (HeadHealthR > Damage) || (!IsDoingASpecialMove() && InstigatedBy.IsHumanControlled()) )
				{
					HeadHealthR -= Damage;

					// Shooting the head grabs the Brumak's attention.
					if( `TimeSince(LastEnemyFocusTime) > 10 )
					{
						LastEnemyFocusTime = WorldInfo.TimeSeconds;
						GearAI_Brumak(Controller).FocusOnEnemy(InstigatedBy, 5.f);
					}

					if( HeadHealthR <= 0 )
					{
						HeadLivesR--;
						if( HeadLivesR > 0 )
						{
							HeadHealthR = default.HeadHealthR;
						}

						PlayHeadDamageR();
					}
				}
			}
		}
		else
		{
			// Hit Left
			if( HeadLivesL > 0 )
			{
				// Only let players finish off the guns, not AI
				// Don't trigger state when already doing a special move, it would not be triggered.
				if( (HeadHealthL > Damage) || (!IsDoingASpecialMove() && InstigatedBy.IsHumanControlled()) )
				{
					HeadHealthL -= Damage;

					// Shooting the head grabs the Brumak's attention.
					if( `TimeSince(LastEnemyFocusTime) > 10 )
					{
						LastEnemyFocusTime = WorldInfo.TimeSeconds;
						GearAI_Brumak(Controller).FocusOnEnemy(InstigatedBy, 5.f);
					}

					if( HeadHealthL <= 0 )
					{
						HeadLivesL--;
						if( HeadLivesL > 0 )
						{
							HeadHealthL = default.HeadHealthR;
						}

						PlayHeadDamageL();
					}
				}
			}
		}
	}

	// If shot in the left arm gun and gun is not destroyed and not doing hit reaction
	if( bHitLeftGun )
	{
		// Only let players finish off the guns, not AI
		// Don't trigger state when already doing a special move, it would not be triggered.
		if( LeftGunHealth > Damage || (!IsDoingASpecialMove() && InstigatedBy.IsHumanControlled()) )
		{
			LeftGunHealth -= Damage;
			if( LeftGunHealth <= 0 )
			{
				LeftGunLives--;
				if( LeftGunLives == 0 )
				{
					Damage += SideGunDestroyedHitPointPenalty;
					LeftGunPawn.Destroy();
					LeftGunPawn = None;
				}
				else
				{
					LeftGunHealth = default.LeftGunHealth;
				}

				PlaySideGunDestroyed(LastTakeDamageComponent, (LeftGunLives == 0));
			}
		}
	}
	// Otherwise, if shot in the right arm gun and gun is not destroyed and not doing hit reaction
	else if( bHitRightGun )
	{
		// Only let players finish off the guns, not AI
		// Don't trigger state when already doing a special move, it would not be triggered.
		if( RightGunHealth > Damage || (!IsDoingASpecialMove() && InstigatedBy.IsHumanControlled()) )
		{
			RightGunHealth -= Damage;

			if( RightGunHealth <= 0 )
			{
				RightGunLives--;
				if( RightGunLives == 0 )
				{
					Damage += SideGunDestroyedHitPointPenalty;
					RightGunPawn.Destroy();
					RightGunPawn = None;
				}
				else
				{
					RightGunHealth = default.RightGunHealth;
				}

				PlaySideGunDestroyed(LastTakeDamageComponent, (RightGunLives == 0));
			}
		}
	}
	else if( bHitMainGun )
	{
		// Only let players finish off the guns, not AI
		// Don't trigger state when already doing a special move, it would not be triggered.
		if( MainGunHealth > Damage || (!IsDoingASpecialMove() && InstigatedBy.IsHumanControlled()) )
		{
			MainGunHealth -= Damage;

			if( MainGunHealth <= 0 )
			{
				MainGunLives--;
				if( MainGunLives == 0 )
				{
					Damage += BackpackDestroyedHitPointPenalty;
				}
				else
				{
					MainGunHealth = default.MainGunHealth;
				}

				PlayMainGunDestruction();
			}
		}
	}
	else if( bHitBackpack )
	{
		// Only let players finish off the guns, not AI
		// Don't trigger state when already doing a special move, it would not be triggered.
		if( BackpackHealth > Damage || (!IsDoingASpecialMove() && InstigatedBy.IsHumanControlled()) )
		{
			BackpackHealth -= Damage;

			// If we haven't focused on an enemy for a while, and someone is shooting our backpack, turn around and target him instead.
			if( `TimeSince(LastEnemyFocusTime) > 10 )
			{
				LastEnemyFocusTime = WorldInfo.TimeSeconds;
				GearAI_Brumak(Controller).FocusOnEnemy(InstigatedBy, 5.f);
			}

			if( BackpackHealth <= 0 )
			{
				BackPackExplosionInstigator = InstigatedBy;
				PlayBackPackDestroyed();
			}
			else if( IsBackPackDamgedEnoughForEffects() )
			{
				PlayBackPackDamageEffects();
			}
		}
	}
	// Didn't hit any special areas, so main body.
	// Transfer some damage to backpack so the death is always backpack explosion
	else
	{
		// If main health gets below default backpack level, then transfer everything onto it.
		if( (Health - Damage) <= default.BackpackHealth )
		{
			// Only let players finish off the guns, not AI
			// Don't trigger state when already doing a special move, it would not be triggered.
			if( BackpackHealth > Damage || (!IsDoingASpecialMove() && InstigatedBy.IsHumanControlled()) )
			{
				BackpackHealth -= Damage;
				if( BackpackHealth <= 0 )
				{
					BackPackExplosionInstigator = InstigatedBy;
					PlayBackPackDestroyed();
				}
				else if( IsBackPackDamgedEnoughForEffects() )
				{
					PlayBackPackDamageEffects();
				}
			}

			// Block damage, we want to handle death here.
			Damage = 0;
		}
	}

	PlayTakeHit(Damage, InstigatedBy, HitLocation, GearDamageType, Momentum, HitInfo);
}

/**
 *  Impact Effects are handled in TakeDamage->DoDamageEffects. But only if there damage done.
 *  If there is no damage done, but you still want an impact effect to be played, return TRUE here.
 */
simulated function bool ShouldPlayNonDamageHitEffects(const out ImpactInfo Impact, Pawn InstigatedBy, class<DamageType> InDamageType)
{
	return (IsRocketPackBone(Impact.HitInfo.BoneName) && !HitBackpack(Impact.HitInfo.HitComponent));
}

simulated function bool TookHeadShot(Name BoneName, vector HitLocation, vector Momentum, optional out byte out_bHasHelmet)
{
	// set the flag correctly for the mutator that only allows headshot damage, but don't do any special effects (bonus damage, etc)
	bLastHitWasHeadshot = Super.TookHeadShot(BoneName, HitLocation, Momentum, out_bHasHelmet);
	return false;
}

simulated final function bool IsMainGunBone(Name InBoneName)
{
	return (InBoneName == 'MachinGun');
}

simulated final function bool HitRightGunBone( PrimitiveComponent HitComponent )
{
	return (HitComponent == RightGunComponent);
}

simulated final function bool HitLeftGunBone( PrimitiveComponent HitComponent )
{
	return (HitComponent == LeftGunComponent);
}

simulated final function bool HitBackpack(PrimitiveComponent HitComponent)
{
	return (HitComponent == BackpackComponent);
}

simulated final function bool IsRocketPackBone(Name InBoneName)
{
	return (RocketPackBoneNames.Find(InBoneName) != INDEX_NONE);
}

simulated final function bool IsLegBone(Name InBoneName)
{
	switch( InBoneName )
	{
	case 'LeftKnee':
	case 'LeftAnkle':
	case 'LeftBall':
	case 'LeftThigh':
	case 'RightKnee':
	case 'RightAnkle':
	case 'RightBall':
	case 'RightThigh':
		return TRUE;
	}

	return FALSE;
}

simulated final function bool IsBackPackBone(Name InBoneName)
{
	return (InBoneName == BackPackBoneName);
}

/** Util to see if a bone it relevant to a particular damage bone */
simulated function bool BoneForDamage(name Bone, name Parent)
{
	if (Bone != '')
	{
		return (Bone == Parent || Mesh.BoneIsChildOf(Bone, Parent));
	}
	return false;
}

simulated final function bool HitHead( name BoneName )
{
	return BoneForDamage(BoneName, 'Head');
}


/**
*	Handle driver being killed and disabling the main gun
*	Check to see if stage should progress
*/
function NotifyDriverDied( Pawn DeadPawn, Controller Killer )
{
	//debug
	`log( GetFuncName()@DeadPawn@Killer,bDebug );

	// Play driver killed animation
	if( CanDoSpecialMove(GSM_Brumak_CannonHit) )
	{
		ServerDoSpecialMove(GSM_Brumak_CannonHit, TRUE);
	}

	// Trigger kismet event
//	TriggerEventClass( class'SeqEvent_BrumakDriverKilled', self );
}

// function PlayHurtSound()
// {
// 	PlaySound( PainSound );
// }

// Brumak should never gib.
function bool ShouldGib(class<GearDamageType> GearDmgType, Pawn InstigatedBy)
{
	return FALSE;
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	local Pawn SavedDriver;

	SavedDriver = Driver;

	if( Super.Died(Killer,DamageType,HitLocation))
	{
		SavedDriver.Controller.PawnDied(SavedDriver);
		SavedDriver.Destroy();

		if(RightGunPawn != none)
		{
			RightGunPawn.Controller.Destroy();
			RightGunPawn.Destroy();
			RightGunPawn=none;
		}

		if(LeftGunPawn != none)
		{
			LeftGunPawn.Controller.Destroy();
			LeftGunPawn.Destroy();
			LeftGunPawn=none;
		}
		return true;
	}

	return false;
}

//
// Main Gun
//

/** Handle Spawning the proper explosion effect for the main gun damage stages */
simulated function SetMainGunExplosion(GearExplosionContent InGearExplosionContent)
{
	local GearExplosionActor ExplosionActor;
	local vector SpawnLoc;
	local Rotator SpawnRot;

	Mesh.GetSocketWorldLocationAndRotation('Top_Gun_Damage', SpawnLoc, SpawnRot);

	ExplosionActor = Spawn(class'GearExplosionActor', Self,, SpawnLoc, SpawnRot);
	ExplosionActor.Instigator = Self;
	ExplosionActor.InstigatorController = Controller;

	MainGunExplosionTemplate.ContentTemplate = InGearExplosionContent;
	MainGunExplosionTemplate.InitFromContentTemplate();
	ExplosionActor.Explode(MainGunExplosionTemplate);
}

simulated function PlayMainGunDestruction()
{
	// If default value, skip. we can get that through replication.
	if( MainGunLives == default.MainGunLives )
	{
		return;
	}

	// Create a new particle system comp for the smoke
	if( PSC_MainGunDestruction == None )
	{
		PSC_MainGunDestruction = new(self) class'ParticleSystemComponent';
		PSC_MainGunDestruction.bAutoActivate = FALSE;
		Mesh.AttachComponentToSocket(PSC_MainGunDestruction, 'Top_Gun_Damage');
	}

	// Destruction
	if( MainGunLives == 0 )
	{
		PSC_MainGunDestruction.DeactivateSystem();
		PSC_MainGunDestruction.SetTemplate(PS_MainGun_Stage4);
		PSC_MainGunDestruction.ActivateSystem();

		SetMainGunExplosion( GEC_MainGun_Stage4 );

// 		PSC_MainGunDestruction = SetUpAndStartParticleSystemComponent(MainGunDestructionPSTemplate, 'MachinGun', vect(0,0,0));
// 		PlaySound(MainGunDestructionSoundCue, TRUE);

		// Hide main gun
		if( MainGunScaleController != None )
		{
			MainGunScaleController.SetSkelControlStrength(1.f,0.f);
		}

		if( Role == ROLE_Authority )
		{
			ServerDoSpecialMove(GSM_Brumak_CannonHit, TRUE);
		}
	}
	else if( MainGunLives == 1 )
	{
		PSC_MainGunDestruction.DeactivateSystem();
		PSC_MainGunDestruction.SetTemplate(PS_MainGun_Stage3);
		PSC_MainGunDestruction.ActivateSystem();

		SetMainGunExplosion( GEC_MainGun_Stage3 );
	}
	else if( MainGunLives == 2 )
	{
		PSC_MainGunDestruction.DeactivateSystem();
		PSC_MainGunDestruction.SetTemplate(PS_MainGun_Stage2);
		PSC_MainGunDestruction.ActivateSystem();

		SetMainGunExplosion( GEC_MainGun_Stage2 );
	}
	else if( MainGunLives == 3 )
	{
		PSC_MainGunDestruction.DeactivateSystem();
		PSC_MainGunDestruction.SetTemplate(PS_MainGun_Stage1);
		PSC_MainGunDestruction.ActivateSystem();
	}
}

//
// Head Damage
//

simulated function PlayHeadDamageR()
{
	// Skip if we get initial event for default value.
	if( HeadLivesR == default.HeadLivesR )
	{
		return;
	}

	// Create a new particle system comp for the smoke
	if( PSC_HeadDamage == None )
	{
		PSC_HeadDamage = new(self) class'ParticleSystemComponent';
		PSC_HeadDamage.bAutoActivate = FALSE;
		Mesh.AttachComponentToSocket(PSC_HeadDamage, 'Head');
	}

	if( HeadLivesR == 0 && HeadLivesL == 0 )
	{
		MaskComponent.SetHidden( TRUE );
		PSC_HeadDamage.DeactivateSystem();
		PSC_HeadDamage.SetTemplate(PS_Stage3_HelmetR);
		PSC_HeadDamage.ActivateSystem();
	}
	else if( HeadLivesR == 0 && HeadLivesL > 0 )
	{
		MaskComponent.SetHidden( TRUE );
		PSC_HeadDamage.DeactivateSystem();
		PSC_HeadDamage.SetTemplate(PS_Stage2_HelmetR);
		PSC_HeadDamage.ActivateSystem();
	}
	else if( HeadLivesR > 0 && HeadLivesL > 0 )
	{
		PSC_HeadDamage.DeactivateSystem();
		PSC_HeadDamage.SetTemplate(PS_Stage1_Helmet);
		PSC_HeadDamage.ActivateSystem();
	}
}

simulated function PlayHeadDamageL()
{
	// Skip if we get initial event for default value.
	if( HeadLivesL == default.HeadLivesL )
	{
		return;
	}

	// Create a new particle system comp for the smoke
	if( PSC_HeadDamage == None )
	{
		PSC_HeadDamage = new(self) class'ParticleSystemComponent';
		PSC_HeadDamage.bAutoActivate = FALSE;
		Mesh.AttachComponentToSocket(PSC_HeadDamage, 'Head');
	}

	if( HeadLivesL == 0 && HeadLivesR == 0 )
	{
		MaskComponent.SetHidden( TRUE );
		PSC_HeadDamage.DeactivateSystem();
		PSC_HeadDamage.SetTemplate(PS_Stage3_HelmetL);
		PSC_HeadDamage.ActivateSystem();
	}
	else if( HeadLivesL == 0 && HeadLivesR > 0 )
	{
		MaskComponent.SetHidden( TRUE );
		PSC_HeadDamage.DeactivateSystem();
		PSC_HeadDamage.SetTemplate(PS_Stage2_HelmetL);
		PSC_HeadDamage.ActivateSystem();
	}
	else if( HeadLivesL > 0 && HeadLivesR > 0 )
	{
		PSC_HeadDamage.DeactivateSystem();
		PSC_HeadDamage.SetTemplate(PS_Stage1_Helmet);
		PSC_HeadDamage.ActivateSystem();
	}
}

//
// Side Guns
//

/** Handle Spawning the proper explosion effect for the left side gun damage stages */
simulated function SetLeftSideGunExplosion(GearExplosionContent InGearExplosionContent)
{
	local GearExplosionActor ExplosionActor;
	local vector SpawnLoc;
	local Rotator SpawnRot;

	Mesh.GetSocketWorldLocationAndRotation('LeftDamage', SpawnLoc, SpawnRot);

	ExplosionActor = Spawn(class'GearExplosionActor', Self,, SpawnLoc, SpawnRot);
	ExplosionActor.Instigator = Self;
	ExplosionActor.InstigatorController = Controller;

	LeftSideGunExplosionTemplate.ContentTemplate = InGearExplosionContent;
	LeftSideGunExplosionTemplate.InitFromContentTemplate();
	ExplosionActor.Explode(LeftSideGunExplosionTemplate);
}

/** Handle Spawning the proper explosion effect for the left side gun damage stages */
simulated function SetRightSideGunExplosion(GearExplosionContent InGearExplosionContent)
{
	local GearExplosionActor ExplosionActor;
	local vector SpawnLoc;
	local Rotator SpawnRot;

	Mesh.GetSocketWorldLocationAndRotation('RightDamage', SpawnLoc, SpawnRot);

	ExplosionActor = Spawn(class'GearExplosionActor', Self,, SpawnLoc, SpawnRot);
	ExplosionActor.Instigator = Self;
	ExplosionActor.InstigatorController = Controller;

	RightSideGunExplosionTemplate.ContentTemplate = InGearExplosionContent;
	RightSideGunExplosionTemplate.InitFromContentTemplate();
	ExplosionActor.Explode(RightSideGunExplosionTemplate);
}


/** Play side gun damage stages effects */
simulated function PlaySideGunDestroyed( PrimitiveComponent HitComponent, bool bDestroyed )
{
	// If left gun was destroyed
	if( HitLeftGunBone(HitComponent) && (LeftGunLives != default.LeftGunLives) )
	{
		// If was previously playing a particle system, stop it.
		if( PSC_LeftGunDestroyed != None )
		{
			PSC_LeftGunDestroyed.DeactivateSystem();
			PSC_LeftGunDestroyed.DetachFromAny();
			PSC_LeftGunDestroyed = None;
		}

		// Create a new particle system comp for the smoke
		if( PSC_LeftGunDestroyed == None )
		{
			PSC_LeftGunDestroyed = new(self) class'ParticleSystemComponent';
			PSC_LeftGunDestroyed.bAutoActivate = FALSE;
			Mesh.AttachComponentToSocket(PSC_LeftGunDestroyed, 'LeftDamage');
		}

		if( PSC_LeftGunDestroyed != None )
		{
			// Show/start the new particle effect
			switch( LeftGunLives )
			{
				case 0 : PSC_LeftGunDestroyed.SetTemplate(PS_Stage4_SGL); SetLeftSideGunExplosion(GEC_Stage4_SG); break;
				case 1 : PSC_LeftGunDestroyed.SetTemplate(PS_Stage3_SGL); SetLeftSideGunExplosion(GEC_Stage3_SG); break;
				case 2 : PSC_LeftGunDestroyed.SetTemplate(PS_Stage2_SGL); SetLeftSideGunExplosion(GEC_Stage2_SG); break;
				case 3 : 
				default : PSC_LeftGunDestroyed.SetTemplate(PS_Stage1_SGL); break;
			}

			PSC_LeftGunDestroyed.SetHidden( FALSE );
			PSC_LeftGunDestroyed.ActivateSystem();
		}

		// Disable aiming of left gun
		SetSideGunAimTarget( None, TRUE );

		// Play animation through special move
		if( Role == ROLE_Authority )
		{
			if( bDestroyed )
			{
				ServerDoSpecialMove(GSM_Brumak_LtGunHit, TRUE);
			}
			else if( LeftGunLives < 3 )
			{
				ServerDoSpecialMove(GSM_Brumak_LtGunPain, TRUE);
			}
		}

		if( bDestroyed )
		{
			if( LeftGunComponent != None )
			{
				LeftGunComponent.SetHidden( TRUE );
			}
		}
	}
	else
	// Otherwise, if right gun was destroyed
	if( HitRightGunBone( HitComponent ) && RightGunLives != default.RightGunLives )
	{
		// If was previously playing a particle system, stop it.
		if( PSC_RightGunDestroyed != None )
		{
			PSC_RightGunDestroyed.DeactivateSystem();
			PSC_RightGunDestroyed.DetachFromAny();
			PSC_RightGunDestroyed = None;
		}

		// Create a new particle system comp for the smoke
		if( PSC_RightGunDestroyed == None )
		{
			PSC_RightGunDestroyed = new(self) class'ParticleSystemComponent';
			PSC_RightGunDestroyed.bAutoActivate = FALSE;
			Mesh.AttachComponentToSocket(PSC_RightGunDestroyed, 'RightDamage');
		}

		if( PSC_RightGunDestroyed != None )
		{
			// Show/start the new particle effect
			switch( RightGunLives )
			{
				case 0 : PSC_RightGunDestroyed.SetTemplate(PS_Stage4_SGR); SetRightSideGunExplosion(GEC_Stage4_SG); break;
				case 1 : PSC_RightGunDestroyed.SetTemplate(PS_Stage3_SGR); SetRightSideGunExplosion(GEC_Stage3_SG); break;
				case 2 : PSC_RightGunDestroyed.SetTemplate(PS_Stage2_SGR); SetRightSideGunExplosion(GEC_Stage2_SG); break;
				case 3 :
				default: PSC_RightGunDestroyed.SetTemplate(PS_Stage1_SGR); break;
			}

			PSC_RightGunDestroyed.SetHidden( FALSE );
			PSC_RightGunDestroyed.ActivateSystem();
		}

		// Disable aiming of right gun
		SetSideGunAimTarget( None, FALSE );

		// Play animation through special move
		if( Role == ROLE_Authority )
		{
			if( bDestroyed )
			{
				ServerDoSpecialMove(GSM_Brumak_RtGunHit, TRUE);
			}
			else if( RightGunLives < 3 )
			{
				ServerDoSpecialMove(GSM_Brumak_RtGunPain, TRUE);
			}
		}

		if ( bDestroyed )
		{
			if( RightGunComponent != None )
			{
				RightGunComponent.SetHidden( TRUE );
			}
		}
	}

	// If both side guns are destroyed, then driver can be killed now.
	if( IsRightGunDestroyed() && IsLeftGunDestroyed() && Driver != None && Driver.Controller != None )
	{
		// Make driver vulnerable now for PHASE 2
		Driver.Controller.bGodMode = FALSE;

		// Show leg POI after guns killed
		//SetTimer( 3.f, FALSE, nameof(EnableLegPOI) );
	}
}

// Get the enemy of the gun on the other side
function Pawn GetOtherGunEnemy( GearPawn_LocustBrumak_SideGun ThisGun )
{
	if( ThisGun == LeftGunPawn )
	{
		if( RightGunPawn != None )
		{
			return RightGunPawn.Controller.Enemy;
		}
	}
	else
	if( ThisGun == RightGunPawn )
	{
		if( LeftGunPawn != None )
		{
			return LeftGunPawn.Controller.Enemy;
		}
	}

	return None;
}

function PlayExposeDriver()
{
// 	local GearAI_Brumak AI;
//
// 	// trigger roar animation.
// 	if( CanDoSpecialMove(GSM_Brumak_ExposeDriver) )
// 	{
// 		AI = GearAI_Brumak(Controller);
// 		if( AI != None )
// 		{
// 			AI.DoExposeDriver();
// 		}
// 		else
// 		{
// 			ServerDoSpecialMove(GSM_Brumak_ExposeDriver, TRUE);
// 		}
//
// 		// enables the driver poi, but only once
// 		//EnableDriverPOI();
// 	}
}

simulated function PlayRoar()
{
	local GearAI_Brumak AI;

	// trigger roar animation.
	if( CanDoSpecialMove(GSM_Brumak_Roar) )
	{
		if( PSC_BreathEffect == None )
		{
			PSC_BreathEffect = new(self) class'ParticleSystemComponent';
			PSC_BreathEffect.SetTemplate( PS_BreathEffect );
			PSC_BreathEffect.SetScale( DrawScale );
			PSC_BreathEffect.bAutoActivate = FALSE;
			Mesh.AttachComponent( PSC_BreathEffect, 'head', vect(0,0,0),,);
		}
		PSC_BreathEffect.SetHidden( FALSE );
		PSC_BreathEffect.ActivateSystem();

		PlaySound( RoarSound[Rand(RoarSound.Length)], TRUE );

		AI = GearAI_Brumak(Controller);
		if( AI != None )
		{
			AI.DoRoar();
		}
	}
}

/** Enable the Driver POI */
function EnableDriverPOI()
{
	// enable the poi, but only after leg has been shown
	if( bLegPOIEnabled && !IsTimerActive('DisableDriverPOI', self) )
	{
		DriverPOI.bEnabled = TRUE;
		DriverPOI.EnablePOI();
		SetTimer( 8.0f, FALSE, nameof(self.DisableDriverPOI), self );
	}
}

/** Disable the Driver POI */
function DisableDriverPOI()
{
	// disable the poi
	bDriverPOIEnabled	= TRUE;
	DriverPOI.bEnabled	= FALSE;
	DriverPOI.DisablePOI();
}


/** Enable the legs POI */
function EnableLegPOI()
{
	// enable the poi, but only the first time
	if( !bLegPOIEnabled && !IsTimerActive('DisableLegPOI', self) )
	{
		LegPOI.bEnabled = TRUE;
		LegPOI.EnablePOI();
		SetTimer( 5.0f, FALSE, nameof(self.DisableLegPOI), self );
	}
}

/** Disable the legs POI */
function DisableLegPOI()
{
	// disable the poi
	if( !bLegPOIEnabled )
	{
		bLegPOIEnabled	= TRUE;
		LegPOI.bEnabled = FALSE;
		LegPOI.DisablePOI();
	}
}

event BaseChange()
{
	local GearAI_Brumak AI;

	Super.BaseChange();

	AI = GearAI_Brumak(Controller);
	if( AI != None && Base == None && Physics == PHYS_Falling )
	{
		if( AI.LeftGunAI != None )
		{
			AI.LeftGunAI.StopFiring();
		}
		if( AI.RightGunAI != None )
		{
			AI.RightGunAI.StopFiring();
		}
		if( AI.DriverAI != None )
		{
			AI.DriverAI.StopFiring();
		}
	}
}

function bool DoMantle(GearAI AI, INT Dir, vector MoveStart, vector MoveDest, CoverInfo Info)
{
	return class'AICmd_Brumak_Move_Mantle'.static.MantleEdge( MyGearAI, MoveStart, MoveDest, Info );
}

/** This function gets called when material changes when it turns to gore
 *  Since it will need to update parameters, refresh gore mask texture parameter
 */
event simulated RefreshMaterialTextureParameterForGoreMask(bool DisableFading = FALSE)
{
	Super.RefreshMaterialTextureParameterForGoreMask(DisableFading);

	// overwriting disable fading
	HitMaskComponent.SetFadingStartTimeSinceHit(-1.f);

	if (ArmLegHitMaskComponent != none)
	{
		ArmLegHitMaskComponent.SetFadingStartTimeSinceHit(-1.f);
	}
}

/** Add Hit Mask : Add hit location information to HitMaskComponent for texture update **/
simulated function AddHitMask(vector HitLocation, vector HitStartLocation, float Radius, bool bGore=FALSE)
{
	if ( bAllowGoreHitMask )
	{
		// if mutated, update mtuated hit components
		if (ArmLegHitMaskComponent != none)
		{
			// if gore, don't worry about facing, and just draw sphere around it
			if ( bGore )
			{
				ArmLegHitMaskComponent.SetCaptureParameters(HitLocation, Radius*HitMaskMultiplier, HitStartLocation, FALSE);
			}
			else
			{
				ArmLegHitMaskComponent.SetCaptureParameters(HitLocation, Radius*HitMaskMultiplier, HitStartLocation, TRUE);
			}
		}
	}

	Super.AddHitMask(HitLocation, HitStartLocation, Radius, bGore);
}

/** Create Gore hit mask texture **/
/** this is to make it easy to create custom size of texture per different pawn **/
simulated protected function TextureRenderTarget2D CreateGoreMaskTexture()
{
	// need to create arm/leg texture
	local MaterialInstanceConstant MIC;

	if ( bAllowGoreHitMask )
	{
		// Material 1 is arm/leg texture
		MIC = Mesh.CreateAndSetMaterialInstanceConstant(1);
		ArmLegHitMaskComponent = new(self) class'SceneCapture2DHitMaskComponent';
		ArmLegHitMaskComponent.MaterialIndex = 1;

		ArmLegMaskTexture = class'TextureRenderTarget2D'.static.Create(64, 64, PF_G8, MakeLinearColor(0, 0, 0, 1));
		MIC.SetTextureParameterValue('GoreMask', ArmLegMaskTexture);
		// Update HitMaskComponent with this texture
		ArmLegHitMaskComponent.SetCaptureTargetTexture(  ArmLegMaskTexture );
		AttachComponent(ArmLegHitMaskComponent);
	}

	return Super.CreateGoreMaskTexture();
}

defaultproperties
{
	MPHeadRadius=90.0
	HitMaskMultiplier=3.f
}
