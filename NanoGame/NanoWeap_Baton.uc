/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Baton extends NanoWeap_Melee;

/** When the tesla coil is wielded as a weapon this is glowing on the head.  (make it easier to see where it is is for the melee system) **/
var ParticleSystem WieldedAsMeleeWeaponGlowEffect, WieldedAsMeleeWeaponSparkEffect;
var transient ParticleSystemComponent PSC_WieldedAsMeleeWeaponGlowEffect, PSC_WieldedAsMeleeWeaponSparkEffect;
var name WieldedAsMeleeWeaponGlowEffectSocketName;

/** When the baton is on it plays the electricty sound **/
var protected SoundCue BatonElectricitySound;
var transient protected AudioComponent AC_BatonElectricitySound;

var LightComponent SparkLC;
var transient float TargetLightBrightness;



/**
 * We need a way for the AICmds to be able to pass back the choices they made for their attacks
 * and then when the various functions are called on the weapon to pass along the data to the melee attack sheet
 * and combos and such, they will get the choices the AI has made.
 **/
enum EHACK_AttackChoice
{
	HAC_BaseRight,
	HAC_BaseLeft,
	HAC_OverHeadSmash,
	HAC_SuperKick,
	HAC_HardPush,
};

// this might need to be an array?  So we can have nice patterns of like A A B  and then A A C and then C A B  or what not
var transient EHACK_AttackChoice CurrAttackChoice;




simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	AC_BatonElectricitySound = new(self) class'AudioComponent';
	if( AC_BatonElectricitySound != none )
	{
		AC_BatonElectricitySound.SoundCue = BatonElectricitySound;
		SkeletalmeshComponent(Mesh).AttachComponentToSocket( AC_BatonElectricitySound, WieldedAsMeleeWeaponGlowEffectSocketName );
	}
	SkeletalMeshComponent(Mesh).AttachComponentToSocket(SparkLC,'Light');
}

state WeaponEquipping
{
	simulated function BeginState(Name PrevStateName)
	{
		Super.BeginState(PrevStateName);
		NanoPawn(Instigator).ActivateSpark = ActivateSpark;
	}
}

state WeaponPuttingDown
{
	simulated function BeginState(Name PrevStateName)
	{
		Super.BeginState(PrevStateName);
		KillGlow();
	}
}

simulated function Tick( float DeltaTime )
{
	local float NewSparkBrightness;
	Super.Tick(DeltaTime);
	if (SparkLC.Brightness != TargetLightBrightness)
	{
		NewSparkBrightness = FInterpTo(SparkLC.Brightness,TargetLightBrightness,DeltaTime,8.f);
		SparkLC.SetLightProperties(NewSparkBrightness);
	}
}

simulated function DeployBaton()
{
	PlayWeaponAnim( 'Extend', 1.f, 0.1f, -1.f, FALSE, TRUE );
}

function ActivateGlow()
{
	//ClearTimer( nameof(DestroySpark) );

	if (PSC_WieldedAsMeleeWeaponGlowEffect == None)
	{
		PSC_WieldedAsMeleeWeaponGlowEffect = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( WieldedAsMeleeWeaponGlowEffect, SkeletalMeshComponent(Mesh), WieldedAsMeleeWeaponGlowEffectSocketName, TRUE );
		PSC_WieldedAsMeleeWeaponGlowEffect.ActivateSystem();
	}

	if( AC_BatonElectricitySound != none )
	{
		AC_BatonElectricitySound.FadeIn( 0.100f, 1.0f );
	}
}

function ActivateSpark()
{
	if (PSC_WieldedAsMeleeWeaponSparkEffect == None)
	{
		PSC_WieldedAsMeleeWeaponSparkEffect = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( WieldedAsMeleeWeaponSparkEffect, SkeletalMeshComponent(Mesh), WieldedAsMeleeWeaponGlowEffectSocketName, TRUE );
		PSC_WieldedAsMeleeWeaponSparkEffect.ActivateSystem();
		SetTimer(0.5f,FALSE,nameof(DestroySpark));
	}
	TargetLightBrightness = default.SparkLC.Brightness + 15;
}

function DestroySpark()
{
	if (PSC_WieldedAsMeleeWeaponSparkEffect != None)
	{
		PSC_WieldedAsMeleeWeaponSparkEffect.DeActivateSystem();
		PSC_WieldedAsMeleeWeaponSparkEffect = None;
	}
	TargetLightBrightness = default.SparkLC.Brightness;
}

function KillGlow()
{
	if (PSC_WieldedAsMeleeWeaponGlowEffect != None)
	{
		PSC_WieldedAsMeleeWeaponGlowEffect.DeActivateSystem();
		PSC_WieldedAsMeleeWeaponGlowEffect = None;
	}

	KillElectricitySound();
}

function KillElectricitySound()
{
	if( AC_BatonElectricitySound != None )
	{
		AC_BatonElectricitySound.FadeOut( 0.100f, 0.0f );
	}
}


simulated event vector GetMuzzleLoc()
{
    local NanoPawn NP;
    local vector MuzzleLoc;
    local rotator SocketRot;
    NP = NanoPawn(Instigator);
    if (NP != None)
    {
    	NP.Mesh.GetSocketWorldLocationAndRotation( NP.RightHandSocketName, MuzzleLoc, SocketRot );
        return MuzzleLoc;
    }
	return Super(Weapon).GetMuzzleLoc();
}

simulated event vector GetPhysicalFireStartLoc(optional vector AimDir)
{
	return Super(Weapon).GetMuzzleLoc();
}




// disable these for the time being for batons
function ActivateBloodTrail();
function PossiblyChopOffBone( const out NanoPawn NP, const out name BoneName, const out vector HitLocation );

/** Called when an attack fails to hit an enemy */
simulated function Whiffed()
{
	if( bTargetDodgedDuringHit )
	{
		// If the target dodged and we missed, play the whiff dialogue
		NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_Combat_MeleeCircle_DodgeWhiff, Instigator);
	}
}


// This is our temp "let the ai do more than one attack"
// depends on the BaseAttack Combo Attack Name list being N long
// and the first N being attacks that we want to be able to do
// right now there should just be a baseright and baseleft in there
function int GetDoingBaseAttackComboIndex()
{

	// nicely the EHACK_AttackChoice matches the order of the baton attacks
	// once we get more attacks we will need to add in some switch / case statement action
	return CurrAttackChoice;
}


defaultproperties
{
	WeaponSheetClass=class'NanoMeleeWeaponSheet_Baton'
	bMeleeWeapon=TRUE

	// Weapon SkeletalMesh
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'MET_TeslaStick.SK_MET_TeslaStick'
		PhysicsAsset=PhysicsAsset'MET_TeslaStick.SK_MET_TeslaStick_Physics'

		AnimTreeTemplate=AnimTree'MET_TeslaStick.AT_MET_TeslaStick'
		AnimSets.Add(AnimSet'MET_TeslaStick.SK_MET_TeslaStick_Anims')
	End Object
	Mesh=WeaponMeshComp

	DamageCollisionDamageType=class'NDT_TeslaMeleeStick'
	InstantHitDamageTypes(0)=class'NDT_TeslaMeleeStick'

	FiringStatesArray(FIREMODE_Attacking)=Attacking
	WeaponFireTypes(FIREMODE_Attacking)=EWFT_Custom
	FireInterval(FIREMODE_Attacking)=0.0



	WeaponRange=196

	NumSwordLineChecks=4
	SwordCheckLen=25.0

//	SwordSwingCue=SoundCue'Weapon_Sword.Sword.Sword_Swing_Fast_Cue'
//	SwordMissCue=None
	SwordHitPawnCue=SoundCue'Weapon_Tesla.Stick.Tesla_Shock_StereoCue'
	SwordHitNonPawnCue=SoundCue'Weapon_Sword.Sword.Sword_Impact_Concrete_Cue'

	PS_Blocked=ParticleSystem'REB_Staff.Effects.P_StaffBlocked_01'

	WieldedAsMeleeWeaponGlowEffectSocketName="MeleeGlowSpark"
	WieldedAsMeleeWeaponGlowEffect=ParticleSystem'Nano_WeaponFX2.Tesla.Effects.P_FX_Nano_Tesla_MeleeWeapon_Glow'
	WieldedAsMeleeWeaponSparkEffect=ParticleSystem'Nano_WeaponFX2.Tesla.Effects.P_FX_Nano_Tesla_MeleeWeapon_Glow_PreStrike'

	BatonElectricitySound=SoundCue'Weapon_Tesla.Stick.Tesla_PoweredOn_01Cue'

	EquipTime=0.33f
	EquipAnimName=WeaponSwitch_SMG_to_Baton

	WeaponDropSound=SoundCue'Weapon_Tesla.Stick.Tesla_BatonLand_01_Cue'
	SoundToPlayWhileFlyingThroughAirBeforeImpactGround=SoundCue'Weapon_Tesla.Stick.Tesla_PoweredOn_01Cue'

	Begin Object Class=PointLightComponent Name=SparkLightcomp
		LightColor=(R=118,G=194,B=235)
		Radius=400
		FalloffExponent=3
		Brightness=0
		CastShadows=FALSE
		bAffectCompositeShadowDirection=FALSE
	End Object
	SparkLC=SparkLightcomp
}


