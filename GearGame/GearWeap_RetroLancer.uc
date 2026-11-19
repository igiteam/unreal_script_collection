/**
 * COG Retro Lancer: Pendulum Era Lancer
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_RetroLancer extends GearWeapon;

/** FOV (in deg) of the zoomed state of this weapon */
var() protected const config float	ZoomFOV;

/** Audiocomponent for looping firing sound. */
var protected AudioComponent	FireLoopAC;

/** How much recoil should the gun reduce at full accuracy */
var protected config float FullAccurateRecoilPct;

/** How much aim error should the gun reduce when there's no heat */
var protected config float FullAccurateAimErrorPct;

/** How long melee needs to be held before the roadie run stab is kicked off */
var protected config float HoldTimeForRoadieRunStab;

/** "schwing!" sound when swinging this for melee attacks */
var protected const SoundCue MeleeSwingSound;

/** texture to draw when replacing ammo bar with stab move time bar */
var CanvasIcon ChargeBarIcon;

/**
 * Raise the aim error when heated up
 *
 * @return the modified aim error
 */
simulated function float GetPlayerAimError()
{
	return Super.GetPlayerAimError() * FMin(1.0f, FMax(CrosshairExpansionFiringTime / CrosshairExpansionTime, GearInventoryManager(InvManager).Accuracy) + FullAccurateAimErrorPct);
}

/**
 * Raise the recoil when heated up
 *
 * @return the modified recoil
 */
simulated function int GetWeaponRecoil()
{
	//`log(`showvar(FMax(CrosshairExpansionFiringTime / CrosshairExpansionTime, GearInventoryManager(InvManager).Accuracy)));

	return Super.GetWeaponRecoil() * FMin(1.0f, FMax(CrosshairExpansionFiringTime / CrosshairExpansionTime, GearInventoryManager(InvManager).Accuracy) + FullAccurateRecoilPct);
}

simulated function Destroyed()
{
	if ( FireLoopAC != None )
	{
		FireLoopAC.FadeOut(0.2f,0.f);
		FireLoopAC = None;
	}

	Super.Destroyed();
}

simulated protected function PlayFireSound()
{
	if (FireLoopAC == None || !FireLoopAC.IsPlaying())
	{
		// start loop
		FireLoopAC = GearWeaponPlaySoundLocalEx(FireSound, FireSound_Player, FireSound_Squad, FireLoopAC);
		if (FireLoopAC != None)
		{
			FireLoopAC.bStopWhenOwnerDestroyed = TRUE;
		}
	}

	// Maybe alert AI of the noise
	if (WorldInfo.Netmode != NM_Client && Instigator != None)
	{
		Instigator.MakeNoise(1.f, 'PlayFireSound');
	}
}

simulated function StopFireEffects(byte FireModeNum)
{
	super.StopFireEffects(FireModeNum);

	if (FireModeNum == 0)
	{
		StopFireLoopingAudio();
	}
}

simulated protected function StopFireLoopingAudio()
{
	if (FireLoopAC != None)
	{
		FireLoopAC.FadeOut(0.1f, 0.f);
		FireLoopAC = None;

		if (IsFiring() || (bSlaveWeapon && !IsInState('WeaponEquipping')))
		{
			GearWeaponPlaySoundLocal(StopFireSound, StopFireSound_Player, StopFireSound_Squad);
		}
	}
}

/**
 * Make AI not fire at very distant targets
 * Delay any melee attacks to see if the player is holding the button for the stab charge
 *
 * @param FireModeNum - the fire mode being started
 */
simulated function StartFire(byte FireModeNum)
{
	local Actor Target;
	local GearPawn GP;

	// don't bother firing if the enemy is really far away
	if (GearAIController != None && FireModeNum == 0)
	{
		Target = (GearAIController.FireTarget != None) ? GearAIController.FireTarget : GearAIController.Enemy;
		if (Target != None && VSize(Target.Location - GearAIController.Pawn.Location) > Range_Long * 1.5)
		{
			return;
		}
	}

	GP = GearPawn(Instigator);
	if (GearAIController == None && FireModeNum == MELEE_ATTACK_FIREMODE && !IsInState('MeleeAttacking') && GP != None && GP.IsLocallyControlled())
	{
		// setting the timer again resets it
		if (!IsTimerActive('DoRoadieRunStab'))
		{
			SetTimer(HoldTimeForRoadieRunStab, FALSE, nameof(DoRoadieRunStab));
		}

		return;
	}

	Super.StartFire(FireModeNum);
}

/**
 * End the roadie run stab or melee if we didn't start a roadie run
 *
 * @param FireModeNum - the fire mode being ended
 */
simulated function StopFire(byte FireModeNum)
{
	local GearPawn GP;

	Super.StopFire(FireModeNum);

	if (FireModeNum == MELEE_ATTACK_FIREMODE)
	{
		GP = GearPawn(Instigator);
		if (GP != None)
		{
			if (GP.IsDoingSpecialMove(SM_RoadieRunStab))
			{
				if (GP.IsLocallyControlled())
				{
					GP.LocalEndSpecialMove(SM_RoadieRunStab);
				}
				ClearTimer('CheckMeleeAttackCollision');
			}
			else if (IsTimerActive('DoRoadieRunStab'))
			{
				Super.StartFire(MELEE_ATTACK_FIREMODE);
				ClearTimer('DoRoadieRunStab');
			}
		}

		bHitWallThisAttack = FALSE;
	}
}

/** Start the roadie run stab */
simulated function DoRoadieRunStab()
{
	local GearPawn GP;

	GP = GearPawn(Instigator);
	if (GP != None && GP.IsLocallyControlled())
	{
		if (GP.CanDoSpecialMove(SM_RoadieRunStab))
		{
			ClearTimer(nameof(DoRoadieRunStab));

			GP.DoSpecialMove(SM_RoadieRunStab);
			//Jack up the MeleeImpactCompleteTime so that we can rerun CheckMeleeAttackCollision
			MeleeImpactCompleteTime = WorldInfo.TimeSeconds + 9999;
			//RESTART THE DAMAGE CHECKER! Put a delay on it so that we play a bit of the animation before causing damage.
			SetTimer(0.1, FALSE, nameof(CheckMeleeAttackCollision));
			//MeleeAttack ends when the run ends now!
			ClearTimer('EndOfMeleeAttack');
		}
		else
		{
			// Try again
			SetTimer(0.1f, FALSE, nameof(DoRoadieRunStab));
		}
	}
}

/** notification fired from Pawn animation when clip is released from weapon. */
simulated function Notify_AmmoRelease()
{
	local SkeletalMeshComponent	SkelMesh;
	local Vector				MagLoc;
	local Rotator				MagRot;

	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Hide Ammo part on weapon mesh
	SetWeaponAmmoBoneDisplay( FALSE );

	// Spawn physics magazine instead
	SkelMesh = SkeletalMeshComponent(Mesh);
	SkelMesh.GetSocketWorldLocationAndRotation('Magazine', MagLoc, MagRot);

	// Spawn physics Magazine
	SpawnPhysicsMagazine(MagLoc, MagRot);
}


/** notification fired from Pawn animation when player grabs another magazine. */
simulated function Notify_AmmoGrab()
{
	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Attach magazine mesh to left hand
	SetPawnAmmoAttachment(TRUE);
}


/** notification fired from Pawn animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload()
{
	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Detach magazine mesh from instigator's left
	SetPawnAmmoAttachment(FALSE);

	// Show Ammo part on weapon mesh.
	SetWeaponAmmoBoneDisplay(TRUE);
}

/** forces the server to attempt to do a melee impact */
reliable server function ServerForceMeleeAttackImpact()
{
	if (GearPawn(Instigator) != None && GearPawn(Instigator).IsDoingSpecialMove(SM_RoadieRunStab))
	{
		NumMeleeAttackAttempts = 1;
		MeleeAttackImpact(, , , , 1.2);
	}
}

simulated function bool CheckMeleeAttackCollision()
{
	local bool bResult;
	local GearPawn GP;
	local GearPC GPC;

	// make sure timer didn't get left on when weapon got disabled
	if (!IsInState('Active') && !IsMeleeing())
	{
		ClearTimer(nameof(CheckMeleeAttackCollision));
	}
	else
	{
		bResult = Super.CheckMeleeAttackCollision();

		GP = GearPawn(Instigator);
		if (GP != None && (GP.Role == ROLE_Authority || GP.IsLocallyControlled()))
		{
			if (GP.IsDoingSpecialMove(SM_RoadieRunStab))
			{
				//If you are already running and you have hit something, STOP!
				if (bResult || bHitWallThisAttack)
				{
					ClearTimer('CheckMeleeAttackCollision');
					//If it was a wall, stop it for both server and client
					//otherwise, let the server stop it in ApplyMeleeDamage or MeleeAttackDestructibles and just stop it locally
					if (bHitWallThisAttack)
					{
						GP.SoundGroup.PlayEffort(GP, GearEffort_BayonetChargeInterrupted, true);

						GP.LocalEndSpecialMove(SM_RoadieRunStab);
					}
					else if (GP.Role == ROLE_Authority)
					{
						// high ping clients can't be trusted to hit dynamic objects
						GP.EndSpecialMove(SM_RoadieRunStab);
					}

					GPC = GearPC(GetWeaponController());
					if (GPC != None && GPC.Role < ROLE_Authority)
					{
						ServerForceMeleeAttackImpact();
					}
				}
			}
			else if (!IsMeleeing())
			{
				ClearTimer(nameof(CheckMeleeAttackCollision));
			}
		}

		// None of this limiting number of attempts, because we could be running for awhile here
		NumMeleeAttackAttempts = 0;
	}

	return bResult;
}


//Overridden to stop the roadie run stab
function bool MeleeAttackDestructibles()
{
	local bool bResult;
	local GearPawn GP;

	GP = GearPawn(Instigator);

	bResult = Super.MeleeAttackDestructibles();

	if (bResult && GP.IsDoingSpecialMove(SM_RoadieRunStab))
	{
		GP.ServerEndSpecialMove(SM_RoadieRunStab);
	}

	return bResult;
}


//Overridden to transition into instadeath stab when running and screaming
//Also can modify the damage when running but not screaming
function ApplyMeleeDamage(GearPawn Victim, optional int InDamage)
{
	local GearPawn GP;
	local int NewDamage;
	local float MutuallyAssuredDestructionFacingDotAngle;
	local vector LookDir;
	local vector PlayerDir;
	local bool bNormalMeleeAttack;
	local GearPRI MyPRI, VictimPRI;

	NewDamage = InDamage;
	GP = GearPawn(Instigator);

	if (Victim != None && GP != None && GP.Role == ROLE_Authority)
	{
		if (GP.IsDoingSpecialMove(SM_RoadieRunStab))
		{
			if( ClassIsChildOf(Victim.Class, class'GearPawn_LambentHumanBase') || ClassIsChildOf(Victim.Class, class'GearPawn_Chicken_Base') )
			{
				MyPRI = GearPRI(GP.PlayerReplicationInfo);
				VictimPRI = GearPRI(Victim.PlayerReplicationInfo);
				if( VictimPRI != None )
				{
					// translate the remaining health as damage done
					VictimPRI.ScoreHit(MyPRI, Victim.DefaultHealth, Victim.Health, Victim.Health, class'GDT_Bayonet', GP);
				}
				// and insta kill
				MyPRI.ScoreInstantKill(VictimPRI, class'GDT_Bayonet', GDT_NORMAL);

				Victim.Died(GP.Controller, class'GDT_Bayonet', Victim.Location);
			}
			else if (ClassIsChildOf(Victim.Class, class'GearPawn_LocustTickerBase') || ClassIsChildOf(Victim.Class, class'GearPawn_LambentPolypBase'))
			{
				// We want the player to keep going after doing normal melee damage
				Super.ApplyMeleeDamage(Victim, NewDamage);
				return;
			}
			else
			{
				if (!GSM_RoadieRunStab(GP.SpecialMoves[SM_RoadieRunStab]).bIsScreaming)
				{
					bNormalMeleeAttack = true;
				}
				else if (!GP.CanDoSpecialMovePawnInteraction(SM_BayonetAttack, Victim))
				{
					if (Victim.IsAKidnapper())
					{
						Victim = Victim.InteractionPawn;
						if (!GP.CanDoSpecialMovePawnInteraction(SM_BayonetAttack, Victim))
						{
							bNormalMeleeAttack = true;
						}
					}
					else
					{
						bNormalMeleeAttack = true;
					}
				}
				if (bNormalMeleeAttack)
				{
					GP.ServerEndSpecialMove(SM_RoadieRunStab);
				}
				else
				{
					//Modify damage for running and screaming
					if (Victim.IsDoingSpecialMove(SM_RoadieRunStab) && GSM_RoadieRunStab(Victim.SpecialMoves[Victim.SpecialMove]).bIsScreaming)
					{
						if ( GP.CanDoSpecialMovePawnInteraction(SM_BayonetDraw_Leader, Victim) )
						{
							// Players facing each other test. Turn angle in degrees to the result of a dot product.
							//@note: set to 0.0 to match chainsaw from behind animation angle for consistency
							//	(i.e. so that in any case you cannot duel, you get the "from behind" anim and thus understand the reason for your failure)
							MutuallyAssuredDestructionFacingDotAngle = 0.0f;

							// Test if we're facing the Other Pawn
							LookDir = vector(GP.Rotation);
							LookDir.Z = 0.0;
							PlayerDir = Victim.Location - GP.Location;
							PlayerDir.Z = 0.0;
							if ((Normal(PlayerDir) dot Normal(LookDir)) >= MutuallyAssuredDestructionFacingDotAngle)
							{
								// Test if the Other Pawn is facing us
								LookDir = vector(Victim.Rotation);
								LookDir.Z = 0.0;
								PlayerDir = GP.Location - Victim.Location;
								PlayerDir.Z = 0.f;
								if ((Normal(PlayerDir) dot Normal(LookDir)) >= MutuallyAssuredDestructionFacingDotAngle)
								{
									GP.ServerDoSpecialMove(SM_BayonetDraw_Leader, TRUE, Victim);
									return;
								}
							}
						}
					}

					Victim.KickPawnOffTurret();
					GP.ServerDoSpecialMove(SM_BayonetAttack, , Victim, class'GSM_BayonetAttack'.static.PackBayonetAttackFlags(GP, Victim));
					return;
				}
			}
		}
	}
	Super.ApplyMeleeDamage(Victim, NewDamage);
}

/**
 * If we hit a lambent human, pretend we didn't. Tell the server to kill it though.
 *
 * @param InDamage - how much damage to do
 *
 * @param OutVictimPawn - the pawn that was hit
 *
 * @param OutHitInfo - misc info about the melee trace
 *
 * @param bTest - whether this is a real melee hit
 *
 * @param RangeMultiplier - how much to extend melee range by
 *
 * @return TRUE to indicate if the melee was successful in hitting something
 */
simulated function bool MeleeAttackImpact(optional int InDamage, optional out GearPawn OutVictimPawn, optional out TraceHitInfo OutHitInfo, optional bool bTest, optional float RangeMultiplier=1.0)
{
	local bool bResult;
	local GearPawn GP;

	GP = GearPawn(Instigator);

	bResult = Super.MeleeAttackImpact(InDamage, OutVictimPawn, OutHitInfo, bTest, RangeMultiplier);
	if (bResult && GP != None && GP.IsDoingSpecialMove(SM_RoadieRunStab) &&
		(ClassIsChildOf(OutVictimPawn.Class, class'GearPawn_LambentHumanBase') || ClassIsChildOf(OutVictimPawn.Class, class'GearPawn_Chicken_Base') || ClassIsChildOf(OutVictimPawn.Class, class'GearPawn_LambentPolypBase') || ClassIsChildOf(OutVictimPawn.Class, class'GearPawn_LocustTickerBase')))
	{
		if (Role < ROLE_Authority)
		{
			ServerForceMeleeAttackImpact();
		}

		return FALSE;
	}

	return bResult;
}

simulated function vector GetMeleeStartTraceLocation()
{
	// a little higher than the default so the charge doesn't get hung up on stairs and such
	return Instigator.Location;
}

simulated function PlayMeleeAttack()
{
	super.PlayMeleeAttack();
	GearWeaponPlaySoundLocal(MeleeSwingSound);
}

simulated function bool DrawSpecialAmmoInfo(GearHUD_Base HUD, float DrawX, float DrawY, float Alpha, float Scale, bool bHighlight)
{
	local float ChargePct;
	local GearPawn GP;
	local GSM_RoadieRunStab StabMove;

	GP = GearPawn(Instigator);
	if (GP != None && GP.IsDoingSpecialMove(SM_RoadieRunStab))
	{
		// this puts us in the ammo bar
		DrawX += 60.0;
		DrawY += 45.0 * Scale;

		HUD.Canvas.SetPos(DrawX, DrawY) ;
		HUD.Canvas.SetDrawColor(47, 47, 47, Alpha);
		HUD.Canvas.DrawTile(ChargeBarIcon.Texture, ChargeBarIcon.UL * Scale, ChargeBarIcon.VL * Scale, ChargeBarIcon.U, ChargeBarIcon.V, ChargeBarIcon.UL, ChargeBarIcon.VL);

		StabMove = GSM_RoadieRunStab(GP.SpecialMoves[GP.SpecialMove]);
		ChargePct = (StabMove.TimeTillScream + StabMove.TimeTillScreamEnd - StabMove.RunTime) / (StabMove.TimeTillScream + StabMove.TimeTillScreamEnd);

		// Determine the color to draw
		`SetHUDDrawColorExt(HUD, HUD.HudColors[StabMove.bIsScreaming ? eWARHUDCOLOR_RED : eWARHUDCOLOR_WHITE], Alpha);

		HUD.Canvas.SetPos(DrawX, DrawY);
		HUD.Canvas.DrawTile(ChargeBarIcon.Texture, ChargeBarIcon.UL * Scale * ChargePct, ChargeBarIcon.VL * Scale, ChargeBarIcon.U, ChargeBarIcon.V, ChargeBarIcon.UL * ChargePct, ChargeBarIcon.VL);

		return true;
	}
	else
	{
		return false;
	}
}

defaultproperties
{
	WeaponStatName="RetroLancer"

	bWeaponCanBeReloaded=TRUE

	InstantHitDamageTypes(0)=class'GDT_RetroLancer'
	InstantHitDamageTypes(MELEE_ATTACK_FIREMODE)=class'GDT_MeleeBlade'
	AmmoTypeClass=class'GearAmmoType_RetroLancer'

	FireSound=SoundCue'Weapon_AssaultRifle.Pendulum.LancerPendulum_FireLoopMono_Cue'			// looping
	FireSound_Player=SoundCue'Weapon_AssaultRifle.Pendulum.LancerPendulum_FireLoopStereo_Cue'	// looping
	FireSound_Squad=SoundCue'Weapon_AssaultRifle.Pendulum.LancerPendulum_FireLoopSquad_Cue' 	// looping
	StopFireSound=SoundCue'Weapon_AssaultRifle.Pendulum.LancerPendulum_FireEndMono_Cue'
	StopFireSound_Player=SoundCue'Weapon_AssaultRifle.Pendulum.LancerPendulum_FireEndStereo_Cue'
	StopFireSound_Squad=SoundCue'Weapon_AssaultRifle.Pendulum.LancerPendulum_FireEndSquad_Cue'

	FireNoAmmoSound=SoundCue'Weapon_AssaultRifle.Firing.CogRifleFireEmptyCue'

	WeaponReloadSound=None

	BulletWhipArchetype=GearBulletWhip'GearSoundGroupArchetypes.BulletWhips.AssaultRifle'

	WeaponEquipSound=SoundCue'Weapon_AssaultRifle.Actions.CogRiflePickupCue'
	WeaponDeEquipSound=SoundCue'Weapon_AssaultRifle.Actions.CogRifleLowerCue'

	PickupSound=SoundCue'Weapon_AssaultRifle.Actions.CogRiflePickupCue'
	WeaponDropSound=SoundCue'Weapon_AssaultRifle.Actions.CogRifleDropCue'

	AIRating=1.f

	FireOffset=(X=44,Y=-1,Z=11)

	// Weapon Mesh
	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'COG_RetroLancer.Mesh.COG_RetroLancer'
		PhysicsAsset=PhysicsAsset'COG_RetroLancer.Mesh.COGRetroLancer_Physics'
		AnimTreeTemplate=AnimTree'COG_AssaultRifle.AT_COG_AssaultRifle'
		AnimSets(0)=AnimSet'COG_AssaultRifle.Animations.COG_AssaultRifle'
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	// shell case ejection emitter
	Begin Object Name=PSC_WeaponShellCaseComp
	    Template=ParticleSystem'COG_RetroLancer.Effects.P_GOG_RetroRifle_Shells'
		Translation=(X=16,Z=6)
	End Object
	PSC_ShellEject=PSC_WeaponShellCaseComp

	// reload barrel smoke
	Begin Object Name=PSC_WeaponReloadBarrelSmokeComp
		Template=ParticleSystem'COG_RetroLancer.Effects.P_COG_RetroRifle_Smoke'
	End Object
	PSC_ReloadBarrelSmoke=PSC_WeaponReloadBarrelSmokeComp

	Begin Object Class=StaticMeshComponent Name=MagazineMesh0
		StaticMesh=StaticMesh'COG_AssaultRifle.Assault_Rifle_Magazine'
		CollideActors=FALSE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=FALSE
	End Object
	MagazineMesh=MagazineMesh0

	bCanDisplayReloadTutorial=TRUE
	DamageTypeClassForUI=class'GDT_RetroLancer'
	WeaponIcon=(Texture=Texture2D'Warfare_HUD.Gears3_WeaponIcons',U=0,V=0,UL=143,VL=46)
	AnnexWeaponIcon=(U=0,V=0,UL=128,VL=40)

	bInstantHit=true

	TracerType=WTT_RetroLancer
	TracerTypeAR=WTT_RetroLancer_AR

	NeedReloadNotifyThreshold=3

	// Weapon anim set
	CustomAnimSets(0)=AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel_Hammerburst'

	// Weapon Animation
	WeaponFireAnim="AR_Fire"
	WeaponReloadAnim="AR_Reload"
	WeaponReloadAnimFail="AR_Reload_Fumble"

	MeleeImpactSound=SoundCue'Weapon_AssaultRifle.Reloads.CogRifleHitCue'
	ZoomActivatedSound=SoundCue'Interface_Audio.Interface.WeaponZoomIn_Cue'
	ZoomDeActivatedSound=SoundCue'Interface_Audio.Interface.WeaponZoomOut_Cue'

	LC_EmisDefaultCOG=(R=0.5,G=8.0,B=50.0,A=1.0)
	LC_EmisDefaultLocust=(R=40.0,G=1.4,B=0.0,A=1.0)


	Recoil_Hand={(
				LocAmplitude=(X=-8,Y=0,Z=0),
				LocFrequency=(X=10,Y=0,Z=0),
				LocParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				RotAmplitude=(X=4000,Y=250,Z=0),
				RotFrequency=(X=5,Y=20,Z=0),
				RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				TimeDuration=0.2f
				)}

	Recoil_Spine={(
				RotAmplitude=(X=2500,Y=500,Z=0),
				RotFrequency=(X=5,Y=5,Z=0),
				RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				TimeDuration=0.25f
				)}

	Begin Object Class=GearCameraShake Name=FireCameraShake0
		OscillationDuration=0.5f
		RotOscillation={(Pitch=(Amplitude=25.f,Frequency=80.f),
						Yaw=(Amplitude=25.f,Frequency=80.f),
						Roll=(Amplitude=12.f,Frequency=200.f))}
		bOverrideTargetingDampening=TRUE
		TargetingDampening=0.6
	End Object
	FireCameraShake=FireCameraShake0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=50,RightAmplitude=50,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.300)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	WeaponID=WC_RetroLancer

	bAllowTracers=TRUE

	bSupportsBarrelHeat=TRUE
	BarrelHeatInterpSpeed=6.f
	BarrelHeatPerShot=0.3f
	BarrelHeatCooldownTime=1.25f
	MaxBarrelHeat=2.f
	BarrelHeatMaterialParameterName="AssaultRifle_Heat"

	bShouldRunMelee=true
	MeleeSwingSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_MeleeCue'

	bCanDoIronSights=false		// enable with "ironsights" console command
	IronSightsCameraOffset=(x=20,z=-19)
	IronSightsCameraRotOffset=(Pitch=0)

	MuzzleFlashArchetype=GearMuzzleFlash'GearMuzzleFlashes.GearWeap_RetroLancer_MuzFlash'

	// CQC Long Executions
	LongExecutions(3)={(CQC_Long_KillerAnim="CTRL_RetroLancer",
						CQC_Long_KillerAnim_Loop="",
						CQC_Long_KillerAnim_End="",
						CQC_Long_VictimAnim="DBNO_RetroLancer",
						CQC_Long_VictimAnim_Loop="",
						CQC_Long_VictimAnim_End="",
						CQC_Long_bHolsterWeapon=FALSE,
						CQC_Long_VictimDeathTime=3.7f,
						CQC_Long_VictimRotStartTime=0.0f,
						CQC_Long_VictimRotInterpSpeed=8.f,
						CQC_Long_CameraAnims=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_RetroLancer_Cam01', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_RetroLancer_Cam02', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_RetroLancer_Cam03', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_RetroLancer_Cam04'),
						CQC_Long_DamageType=class'GDT_LongExecution_RetroLancer',
						CQC_Long_EffortID=GearEffort_None,
						MarkerRelOffset=(X=85.350,Y=-0.400,Z=0),
						AwardRequired="RetroLancerExecution",
						CameraLensEffect=class'Emit_CameraBlood_LongExecution_RetroLancer')}

	bCrosshairExpanding=TRUE
	CrosshairIcon=Texture2D'Warfare_HUD.HUD.HUD_Xhair_COG_RetroLancer'
	ChargeBarIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=494,UL=106,VL=7)

	// These are the player's bling skin options
	WeaponSkins(0)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_Gold'
	WeaponSkins(1)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_CHROME'
	WeaponSkins(2)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_OMEN'
	WeaponSkins(3)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_TRIBALMASKED'
	WeaponSkins(4)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_CAMO'
	WeaponSkins(5)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_DIGITAL'
	WeaponSkins(6)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_PINK'
	WeaponSkins(7)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_GARISH'
	WeaponSkins(8)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_BLOOD'
	WeaponSkins(9)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_CRACKLE'
	WeaponSkins(10)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_FLOWER'
	WeaponSkins(11)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_PAISLEY'
	WeaponSkins(12)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_TRIBAL'
	WeaponSkins(13)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_URBAN'
	WeaponSkins(14)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.RetroLancer.COG_WeaponShader_RetroLancer_XBOX'
}
