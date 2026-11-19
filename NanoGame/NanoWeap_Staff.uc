/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Staff extends NanoWeap_Melee;

var editinline transient NanoAnimNodeSlot FullBodySlot;

var name BloodOnSwordName;
var transient MaterialInstanceConstant MIC_BloodOnSwordName;

/** Temp data for radial blur fading. */
var protected transient RadialBlurComponent ExplosionRadialBlur;
var protected transient float RadialBlurFadeTime;
var protected transient float RadialBlurFadeTimeRemaining;
var protected transient float RadialBlurMaxBlurAmount;

var protected RadialBlurComponent RadialBlurCompTemplate;


var transient float BloodOnBladeAmount;

var SoundCue BeginSlowMotionBOOMSound;

var transient NanoPawn Hit300Pawn;

var transient float Hack_Next300;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	InitCombatStance();	
}

simulated function InitCombatStance()
{
	local NanoPawn NP;
	if( CustomAnimNode == None )
	{
		SetTimer( 0.1f, FALSE, nameof(InitCombatStance) );
	}
	else
	{
		NP = NanoPawn(Instigator);
		NP.LastWeaponStartFireTime = WorldInfo.TimeSeconds;
		NP.bCombatStanceAnim = !NP.bCombatStanceAnim;
//		ClearTimer( nameof(InitCombatStance) );
//		PlayWeaponAnim( 'Staff_Anim_Retract_Pose', 1.f, 0.f, -1.f, FALSE, TRUE );
	}
}

simulated function UpdateByCombatStance( bool bInCombatStance )
{
	if( CustomAnimNode != None )
	{
		if( bInCombatStance )
		{
			PlayWeaponAnim( 'Staff_Anim_Retract_2_Expand', 1.f, 0.f, -1.f, FALSE, TRUE );
 		}
		else
		{
			PlayWeaponAnim( 'Staff_Anim_Retract_2_Expand', -1.f, 0.f, -1.f, FALSE, TRUE );
		}	
	}
}

function ActivateBloodTrail();


function DamagedTarget( NanoPawn HitNP, vector HitLocation, vector HitNormal  )
{
	WorldInfo.MyEmitterPool.SpawnEmitter( ParticleSystem'REB_Staff.Effects.P_StaffImpact_01', HitLocation,, HitNP );
	
}


defaultproperties
{
	WeaponSheetClass=class'NanoMeleeWeaponSheet_Staff'

	bMeleeWeapon=TRUE

	// Weapon SkeletalMesh
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'REB_Staff.SK_Staff'
		PhysicsAsset=PhysicsAsset'REB_Staff.SK_Staff_Physics'

		AnimTreeTemplate=AnimTree'REB_Staff.AT_Staff'

		AnimSets.Add(AnimSet'REB_Staff.REB_Staff_Anim')
		
		Translation=(X=0.f,Y=0.f,Z=0.f)
		Rotation=(Pitch=0,Yaw=0,Roll=0)
		Scale=1.f
	End Object
	Mesh=WeaponMeshComp

	DamageCollisionDamageType=class'NDT_NanoStaff'
	InstantHitDamageTypes(0)=class'NDT_NanoStaff'
	
	FiringStatesArray(FIREMODE_Attacking)=Attacking
	WeaponFireTypes(FIREMODE_Attacking)=EWFT_Custom
	FireInterval(FIREMODE_Attacking)=0.0
	FiringStatesArray(FIREMODE_Throwing)=SwordThrow
	WeaponFireTypes(FIREMODE_Throwing)=EWFT_Projectile
	FireInterval(FIREMODE_Throwing)=0.900

	WeaponRange=176

	ElbowHitPawnCue=SoundCue'Foley_Flesh.Flesh.Kick_Impact_Cue'
	FootHitPawnCue=SoundCue'Foley_Flesh.Flesh.Kick_Impact_Cue'

	//SwordHitPawnCue=SoundCue'Weapon_Sword.Sword.Sword_Impact_Body_Cue'
	SwordHitNonPawnCue=SoundCue'Weapon_Sword.Sword.Sword_Impact_Concrete_Cue'
	SwordDashAttackCue=SoundCue'Foley_Body.Player.Body_LungeAttack_Cue'

	Begin Object Class=NanoParticleSystemComponent Name=SlideEffect0
		Template=ParticleSystem'Nano_FX.Effects.P_FX_SwordSlice_Simple'
		bAutoActivate=FALSE
		TickGroup=TG_PostAsyncWork
	End Object
	PSC_WallSlideEffect=SlideEffect0

	Begin Object Class=NanoParticleSystemComponent Name=StabEffect0
		Template=ParticleSystem'Nano_FX.Effects.P_FX_SwordStab'
		bAutoActivate=FALSE
		TickGroup=TG_PostAsyncWork
	End Object
	PSC_WallStabEffect=StabEffect0

	Begin Object Class=NanoParticleSystemComponent Name=TrailEffectComp2
		bAutoActivate=FALSE
		TickGroup=TG_PostAsyncWork
	End Object
	PSC_Trail(1)=TrailEffectComp2


	MI_BloodSplatterDecal1=MaterialInstanceConstant'Nano_FX.Materials.M_Nano_BloodStreak_01'
	MI_BloodSplatterDecal2=MaterialInstanceConstant'Nano_FX.Materials.M_Nano_BloodStreak_02'

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformSuperMove
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.500)
	End Object
	SuperMoveImpactWaveForm=ForceFeedbackWaveformSuperMove

	SuperMoveImpactSound=SoundCue'Weapon_Sword.Sword.Sword_Melee_Swing_Cue'
	SuperMoveImpactEffect=ParticleSystem'Nano_FX.Effects.P_FX_Nano_GroundImpact'

	bAllowTargeting=TRUE

	//This is no longer used as we do a fade in SummonEffect=ParticleSystem'Nano_FX.Effects.P_Nano_SwordSpawn_5'
	SummonEffectSocketName="RightHand"
	SummonAnimName="NW_Summon_Sword"
	ThrowAwayAnimName="SMG_Throw_Away"
	TimeToSummonWeapon=0.0f// 1.3
	SummonCue=None
	DismissCue=SoundCue'Weapon_Sword.Sword.Sword_Stow_Cue'
	UnholsterCue=SoundCue'Weapon_Sword.Sword.Sword_UnStow_Cue'

	//SummonSlomoCurve=(Points=((InVal=0.0f,OutVal=1.f),(InVal=1.3f,OutVal=0.1f),(InVal=2.f,OutVal=0.1f),(InVal=2.3f,OutVal=1.0f)))
	

	BlockingSwordShatterSocketName="ShatterEffect"
	BlockingSwordShatterPS=ParticleSystem'Nano_WeaponFX2.Sword.P_Sword_Shatter'
	BlockingSwordShatterSound=SoundCue'Weapon_Sword.Sword.Sword_Shatter_Cue'

	

	PS_Trail(0)=ParticleSystem'REB_Sword.Effects.P_REB_Sword_TipTrail'
	PS_Trail(1)=ParticleSystem'REB_Sword.Effects.P_REB_Sword_TipTrail'
	TrailSocket(0)="LeftTip"
	TrailSocket(1)="RightTip"


	PS_SwordBloodTrailSocketName="SwordTip"
	PS_ElbowBloodTrailSocketName="ElbowTip"
	PS_FootBloodTrailSocketName="FootTip"

	PS_ElbowLeftBloodTrailSocketName="ElbowTipLeft"
	PS_FootLeftBloodTrailSocketName="FootTipLeft"

	BloodOnSwordName="Blood"
	BloodSpraySound=SoundCue'Foley_Body.MetaCorps.Gore_Spurt_Cue'

	SwingEffort=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_Swing_Cue'


	Begin Object Class=RadialBlurComponent Name=RadialBlurComp
		BlurFalloffExponent=0.01
		BlurOpacity=0.9
		DistanceFalloffExponent=1.4
		MaxCullDistance=1400
		bRenderAsVelocity=TRUE
	End Object
	RadialBlurCompTemplate=RadialBlurComp

	MI_WeaponDense=MaterialInstanceConstant'REB_Talon.Materials.M_Talon_Densing_INST'
	MI_WeaponGhost=MaterialInstanceConstant'REB_Talon.Materials.M_Talon_Ghosting_INST'


	BeginSlowMotionBOOMSound=SoundCue'Weapon_Sword.Sword_Movement.Combat_SlomoBOOM_Cue'
}