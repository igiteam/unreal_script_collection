/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Sword extends NanoWeap_Melee;


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



`define log300(msg) `loginfo('300',WorldInfo.RealTimeSeconds@`msg)


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	ExplosionRadialBlur = new(self) class'RadialBlurComponent' (RadialBlurCompTemplate);
	SkeletalMeshComponent(Mesh).AttachComponentToSocket( ExplosionRadialBlur, TrailSocket[0] );

	SkeletalMeshComponent(Mesh).AttachComponentToSocket(PSC_WallSlideEffect,'StabPoint');
	SkeletalMeshComponent(Mesh).AttachComponentToSocket(PSC_WallStabEffect,'StabPoint');
}



function CreateSwordBladeEffects()
{
	//Attack_Dir_U_E
	MIC_BloodOnSwordName = Mesh.CreateAndSetMaterialInstanceConstant( 0 );
	MIC_BloodOnSwordName.SetScalarParameterValue( BloodOnSwordName, 0.0f );
	BloodOnBladeAmount = 0.0f;
}

function AddSomeBlood()
{
	BloodOnBladeAmount += 0.20f; // tricky here.   we just keep adding so the longer the battle the longer the blood will stay on the sword
	MIC_BloodOnSwordName.SetScalarParameterValue( BloodOnSwordName, BloodOnBladeAmount);
}

function SetBladeFullBlood()
{
	BloodOnBladeAmount = 1.0f; // tricky here.   we just keep adding so the longer the battle the longer the blood will stay on the sword
	MIC_BloodOnSwordName.SetScalarParameterValue( BloodOnSwordName, BloodOnBladeAmount);
}


function DoRadialBlurForDashAttack()
{
//	RadialBlurFadeTime = 1.0f; // ExplosionTemplate.ExploRadialBlurFadeOutTime;
//	RadialBlurFadeTimeRemaining = RadialBlurFadeTime;
//	RadialBlurMaxBlurAmount = 1.0f; // ExplosionTemplate.ExploRadialBlurMaxBlur;
}



simulated function Tick( float DeltaTime )
{
	local float Pct;

	Super.Tick( DeltaTime );

	if( RadialBlurFadeTimeRemaining > 0 )
	{
		Pct = RadialBlurFadeTimeRemaining / RadialBlurFadeTime;
		Pct *= Pct;		// note that fades out as a square
		ExplosionRadialBlur.SetBlurScale(Pct*RadialBlurMaxBlurAmount);
		RadialBlurFadeTimeRemaining -= DeltaTime;
	}
	else
	{
		ExplosionRadialBlur.SetBlurScale(0.0f);
	}

	if( BloodOnBladeAmount > 0 )
	{
		if( (Role == ROLE_Authority && !NanoPC(Instigator.Controller).IsInCombat())        // On the server, check the controller, which does a more thorough check and updates bIsInCombat
			|| (Role < ROLE_Authority && !NanoPawn(Instigator).bIsInCombat) )              // On clients, use the cached replicated version from the server
		{
			BloodOnBladeAmount -= (DeltaTime / 5.0f);
			MIC_BloodOnSwordName.SetScalarParameterValue( BloodOnSwordName, BloodOnBladeAmount );
		}
	}
}






/** Called to enable damage dealing from sword impacts */
simulated function NotifySetSlashDamagingOn()
{
	//`log300( "--------- NotifySetSlashDamaging ON -----------" );
	//if( ( bDo300Slomo == FALSE ) && ( Hack_Next300 < WorldInfo.TimeSeconds ) )
	//{
	//	`log300( "   bDo300Slomo" );
	//	bDo300Slomo = TRUE;
	//	Do300StyleSlomoAttack_SetSlomo();
//
	//	NanoGRI(WorldInfo.GRI).GetNanoPC().SetSoundMode( 'CombatRapidMotion' );
//
	//	Hack_Next300 = WorldInfo.TimeSeconds + 3.0f;
	//}
	//else if( FRand() > 0.50f )
	//{
		//Do300StyleSlomoAttack_SetSlomo();
	//}
}



function DamagedTarget( NanoPawn HitNP, vector HitLocation, vector HitNormal  )
{
	//local AnimNodeSequence ANS;
	WorldInfo.MyEmitterPool.SpawnEmitter( ParticleSystem'REB_Staff.Effects.P_StaffImpact_01', HitLocation,, HitNP );


	if( bDo300Slomo == FALSE ) return;

	`log300( " ********* DamagedTarget" );

	Hit300Pawn = HitNP;
	//ANS = Hit300Pawn.FullBodySlot.GetCustomAnimNodeSeq();
	//ANS.Rate = 0.01;


	DismemberAI( HitNP, HitLocation, HitNormal );
	//Do300StyleSlomoAttack_SetFast();

	SetTimer( 0.250f, FALSE, nameof(Do300StyleSlomoAttack_SetNormalSpeed) );

}

simulated function Whiffed()
{
	if( bDo300Slomo == FALSE ) return;

	`log300( "WHIFFED!!" );
	bDo300Slomo = FALSE;
	Do300StyleSlomoAttack_SetNormalSpeed();
	NanoGRI(WorldInfo.GRI).GetNanoPC().SetSoundMode( 'Default' );
}


simulated function NotifySetSlashDamagingOff()
{
	if( bDo300Slomo == FALSE ) return;

	`log300( "  -- NotifySetSlashDamaging OFF" );

	bDo300Slomo = FALSE;

	ClearTimer( nameof(Do300StyleSlomoAttack_SetFast) );

	SetTimer( 0.250f, FALSE, nameof(Do300StyleSlomoAttack_SetNormalSpeed) );
}




/** Delegates to the weapon determine if it should do a 300 style slomo attack. **/
protected function bool ShouldDo300StyleSlomoAttack()
{
// 	if( bDo300Slomo == TRUE )
// 	{
// 		return SlomoCurve.Points.Length > 0;
// 	}

	return FALSE;
}


protected function Do300StyleSlomoAttack_SetSlomo()
{
	SetFOVAndFocusPoint( 35.0f, 'b_MF_Hand_R' );

	ModifyPlayerAnimationSpeed( 0.05f );

	Instigator.PlaySound( BeginSlowMotionBOOMSound );
}

protected function Do300StyleSlomoAttack_SetFast()
{
	SetFOVAndFocusPoint( 60.0f, 'b_MF_Head' );

	ModifyPlayerAnimationSpeed( 1.0f );
}

protected function Do300StyleSlomoAttack_SetNormalSpeed()
{
	//local AnimNodeSequence ANS;

	RestoreFOVAndFocusPoint();

	//ANS = Hit300Pawn.FullBodySlot.GetCustomAnimNodeSeq();
	//ANS.Rate = 1.0;

	ModifyPlayerAnimationSpeed( 1.0f );
}




protected function DismemberAI( NanoPawn HitNP, vector HitLocation, vector HitNormal  )
{
	local Name OverrideDeathAnimName;

	NanoGRI(WorldInfo.GRI).NGM.ShouldPlayNanoGoreEffect( TRUE, WeaponSheet.MeleeAttacks[AttackIdx].OnDeathGoreType, HitNP, HitLocation, HitNormal, TRUE, OverrideDeathAnimName );
	HitNP.bDismemberedAndDying = TRUE;
}


protected function SetFOVAndFocusPoint( const float InFOV, const name InFocusBone )
{
	local NanoGRI NGRI;
	local NanoPC NPC;
	local Actor FocusActor;

	NGRI = NanoGRI(WorldInfo.GRI);

	NGRI.SetOverrideFOV( InFOV );

	NPC = NanoPC(Instigator.Controller);

	// so lame since we don't attach the weapon actor we can't nicely use this
	if( NPC != None )
	{
		FocusActor = (NPC.TargetedActor != None) ? NPC.TargetedActor : None;
		//NGRI.GetNanoPC().SetFocusPoint( FALSE, FocusActor, vect2d(3.f, 3.f), vect2d(1.f, 1.f), NGRI.GetDesiredFOV(), TRUE, TRUE, FALSE, InFocusBone, FALSE );

		NPC.SetGoreCameraTarget( NanoPawn(FocusActor) );
		SetTimer( 2.0f, FALSE, nameof(RestoreFOVAndFocusPoint));
	}
}


protected function RestoreFOVAndFocusPoint()
{
	local NanoPC NPC;

	//local NanoGRI NGRI;

	//NGRI = NanoGRI(WorldInfo.GRI);

	//NGRI.ResetFOV();
	//NGRI.GetNanoPC().ClearFocusPoint_LeaveRotation();

	NPC = NanoPC(Instigator.Controller);
	if( NPC != None )
	{
		NPC.ClearGoreCameraTarget();
	}
}


protected function ModifyPlayerAnimationSpeed( const float DesiredSpeed )
{
	local AnimNodeSequence ANS;

	`log300( " ModifyPlayerAnimationSpeed" @ DesiredSpeed );

	ANS = NanoPawn(Instigator).FullBodySlot.GetCustomAnimNodeSeq();

	ANS.Rate = DesiredSpeed;

	ModifyTimerTimeDilation( nameof(WeaponSheet.UpdateAttackAnimState), DesiredSpeed, WeaponSheet );
}


function float GetAnimationRate()
{
	local AnimNodeSequence ANS;

	ANS = NanoPawn(Instigator).FullBodySlot.GetCustomAnimNodeSeq();

	if( ANS != none )
	{
		return ANS.Rate;
	}

	return 1.0f;

}

//NanoGRI(WorldInfo.GRI).GlobalAttackSpeedScalar = 1.0f;


// so I think we want to have some sort of 300 mode whereby if you end a 3 combo melee attack
// and then hit Y or B and this flag is set then we will keep the combo string going and you will continue to get
// crazy sloow then speed ups.
// 
//

// for some melee attacks we need to have on the actual attack a notify (maybe on damage start?) to 
// go into slomo AND fov the camera AND focus point the camera
// 


// soooo for "slomo" < 1.0f everything works well.  The animations look correct and it works out nicely
// for slomo > 1.0f we have issues as the "attack" animations look decent enough, but the "hit" anims can look really goofy as they play all
// cartoony fast (especially the dance dance dancey one)

	
defaultproperties
{
	WeaponSheetClass=class'NanoMeleeWeaponSheet_Sword'

	bMeleeWeapon=TRUE

	// Weapon SkeletalMesh
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'REB_Sword.SK_REB_Sword'
		PhysicsAsset=PhysicsAsset'REB_Sword.SK_REB_Sword_Physics'
//		AnimTreeTemplate=AnimTree'REB_Talon.AT_REB_Talon'
		//AnimSets(0)=
	End Object
	Mesh=WeaponMeshComp

	DamageCollisionDamageType=class'NDT_NanoSword'
	InstantHitDamageTypes(0)=class'NDT_NanoSword'
	
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
	TimeToSummonWeapon=0.0f // 1.3
	SummonCue=None
	DismissCue=SoundCue'Weapon_Sword.Sword.Sword_Stow_Cue'
	UnholsterCue=SoundCue'Weapon_Sword.Sword.Sword_UnStow_Cue'

	//SummonSlomoCurve=(Points=((InVal=0.0f,OutVal=1.f),(InVal=1.3f,OutVal=0.1f),(InVal=2.f,OutVal=0.1f),(InVal=2.3f,OutVal=1.0f)))
	

	BlockingSwordShatterSocketName="ShatterEffect"
	BlockingSwordShatterPS=ParticleSystem'Nano_WeaponFX2.Sword.P_Sword_Shatter'
	BlockingSwordShatterSound=SoundCue'Weapon_Sword.Sword.Sword_Shatter_Cue'

	PS_Trail(0)=ParticleSystem'REB_Sword.Effects.P_REB_Sword_TipTrail'
	TrailSocket(0)="SwordTip"

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