/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Vehicle_Submarine_Base extends GearVehicle
	native(Vehicle)
	config(Pawn)
	abstract;


// Define all of the variables needed for the turrets
var repnotify	vector 	FLTurretFlashLocation;
var repnotify	byte	FLTurretFlashCount;
var repnotify 	Rotator FLTurretWeaponRotation;

var repnotify	vector 	FRTurretFlashLocation;
var repnotify	byte	FRTurretFlashCount;
var repnotify 	Rotator FRTurretWeaponRotation;

var repnotify	vector 	BLTurretFlashLocation;
var repnotify	byte	BLTurretFlashCount;
var repnotify 	Rotator BLTurretWeaponRotation;

var repnotify	vector 	BRTurretFlashLocation;
var repnotify	byte	BRTurretFlashCount;
var repnotify 	Rotator BRTurretWeaponRotation;

/** Skeletal mesh component for the front-left turret */
var() editconst SkeletalMeshComponent TurretFLComp;
/** Skeletal mesh component for the front-right turret */
var() editconst SkeletalMeshComponent TurretFRComp;
/** Skeletal mesh component for the back-left turret */
var() editconst SkeletalMeshComponent TurretBLComp;
/** Skeletal mesh component for the back-right turret */
var() editconst SkeletalMeshComponent TurretBRComp;

/** Weapon effects instance data */
struct native TurretEffectsInstance
{
	var GearMuzzleFlash MuzzleFlashLeft;
	var GearMuzzleFlash MuzzleFlashRight;
};

var(MuzzleEffects) TurretEffectsInstance TurretEffects[4];

/** MICs for damage effects on the pods */
var transient MaterialInstanceConstant MIC_Pod[4];
var transient MaterialInstanceConstant MIC_Screen[4];
var transient MaterialInstanceConstant MIC_Glass[4];

/** Skeletal mesh components for the first-person pod view */
var() editconst SkeletalMeshComponent HighResPod1;

/** Spotlights to attach to the turrets */
var() editconst SpotLightComponent Spotlight;

/** Color to use for HUD warning of nearby dangerous objects */
var() LinearColor HUDSonarColor;

/** FOV to use when targetting on the submarine turret */
var config float TargetingFOV;

/** Struct to hold turret height SkelControls */
struct native TurretHeightControl
{
	var SkelControlSingleBone SkelCtrl_PodElbow;
	var SkelControlSingleBone SkelCtrl_PodBase;
};
/** Array of cached skelcontrols for the pod height */
var transient TurretHeightControl TurretHeightSkelCtrl[4];
/** Pitch offset to apply to pod skel controls */
var() vector2d PodSkelCtrlPitchRange;

/** Struct to store the gunner animations data */
struct native SubPodGunnerAnimData
{
	var	AnimTree GunnerAnimTree;
	var	array<AnimSet> GunnerAnimSets;
};
/** Animation data for the pod gunners */
var array<SubPodGunnerAnimData> GunnerAnimData;

/** Replicated array of healths for the pods */
var() repnotify float PodHealth[4];
/** Previous value for the above PodHealth */
var() float PrevPodHealth[4];
/** Time that the pod was last damaged */
var transient float PodDamageTime[4];

/** Replicated array of whether the spotlights are disabled on the pods */
var repnotify bool bSpotlightEnabled;

/** Total health a pod will begin with */
var config int PodStartHealth;
/** Delay after taking damage before a pod starts regenerating its health */
var config float PodHealthRegenDelay;
/** Amount of health pods regenerate per second after PodHealthRegenDelay has elapsed */
var config float PodHealthRegenPerSec;

/** Health to take first damage threshold */
var config int FirstDamageThreshold;
/** Health to take second damage threshold */
var config int SecondDamageThreshold;
/** Health to take third damage threshold */
var config int ThirdDamageThreshold;
/** Health to take fourth damage threshold */
var config int FourthDamageThreshold;
/** Health to make sub retract */
var config int RetractDamageThreshold;

/** Difficulty-based damage scaling for human players in sub pods */
var() protected config float DamageScale_Casual;
var() protected config float DamageScale_Hardcore;
var() protected config float DamageScale_Insane;

/** Amount of time a pod is down before coming back into the fight when the health runs out */
var config float TimeUntilExtract;

/** Camera effect to play when an explosion hits the turret */
var class<Emit_CameraLensEffectBase> WaterCameraEffectClass;

/** Player turning rate scale */
var(Camera) config float TurretTurnRateScale;
/** Player turning rate scale when aiming */
var(Camera) config float AimingTurretTurnRateScale;

/** CameraShake to play on a pod when it is damaged */
var(Camera) const editinline CameraShake    CamShakeDirectDamage;
/** CameraShake to play on a pod when a different part of the sub is damaged */
var(Camera) const editinline CameraShake    CamShakeIndirectDamage;

/** Sound to play when the submarine impacts */
var(Sound) SoundCue ImpactSoundCue;
/** Sound to play when the submarine takes damage */
var(Sound) SoundCue DamageSoundCue;
/** Sound to play when the sonar pulses */
var(Sound) SoundCue SonarPulseSound;

/** Distance within which to check for dangerous actors (mines, torpedos, etc) */
var config float DangerousActorDist;
/** Time delay between updating NearbyDangerousActors */
var config float DangerousActorUpdateTime;
/** Distance in front of sub location to check for updating NearbyDangerousActors */
var config float DangerousActorLocationOffset;
/** Array of nearby actors that are dangerous to the submarine. For use by AI turret drivers, since most dangerous actors are not Pawns.  */
var transient array<Actor> NearbyDangerousActors;

/** Time delay between updating player Sonar */
var config float SonarPulseUpdateTime;

struct native SonarItem
{
	var() Actor             DangerousActor;
	var() float             Dist;
};
struct native SonarHandle
{
	var() GearPC            PC;
	var() float             LastPlayerInputTime;
	var() float             UpdateTimer;
};
var transient array<SonarHandle> SonarHandleList;

struct CheckpointRecord
{
	var string BasePathName;
	var vector RelativeLocation;
	var rotator RelativeRotation;
	var rotator Rotation;
};

replication
{
	if (bNetDirty)
		FLTurretFlashLocation, FRTurretFlashLocation, BLTurretFlashLocation, BRTurretFlashLocation, PodHealth, bSpotlightEnabled;
	if (!IsSeatControllerReplicationViewer(1) || bDemoRecording)
		FRTurretFlashCount, FRTurretWeaponRotation;
	if (!IsSeatControllerReplicationViewer(2) || bDemoRecording)
		FLTurretFlashCount, FLTurretWeaponRotation;
	if (!IsSeatControllerReplicationViewer(3) || bDemoRecording)
		BRTurretFlashCount, BRTurretWeaponRotation;
	if (!IsSeatControllerReplicationViewer(4) || bDemoRecording)
		BLTurretFlashCount, BLTurretWeaponRotation;
}

cpptext
{
	/** Overridden to avoid doing Pawn's adjustment */
	virtual void AdjustInterpTrackMove(FVector& Pos, FRotator& Rot, FLOAT DeltaTime, UBOOL bIgnoreRotation = FALSE) {}

	/** Overridden to adjust pod height along with rotation */
	virtual void ApplyWeaponRotation(FLOAT DeltaSeconds, INT SeatIndex, FRotator NewRotation);

	/**
	 * Used for SkelControlLimb in BCS_BaseMeshSpace mode.
	 *
	 * @param SkelControlled - the mesh being modified by the skel control
	 *
	 * @return the skeletal mesh component to use for the transform calculation
	 */
	virtual USkeletalMeshComponent* GetMeshForSkelControlLimbTransform(const USkeletalMeshComponent* SkelControlled);
}

simulated native event CacheAnimNodes();

/** replicated event */
simulated event ReplicatedEvent(name VarName)
{
	switch (VarName)
	{
		case nameof(PodHealth):
			PodHealthChanged();
			break;
		case nameof(bSpotlightEnabled):
			Spotlight.SetEnabled(bSpotlightEnabled);
			break;
	}

	Super.ReplicatedEvent(VarName);
}

/** Attach components etc - (client + server) */
simulated event PostBeginPlay()
{
	local int Idx;

	// Set the seat meshes
	Seats[1].Mesh = TurretFRComp;
	Seats[2].Mesh = TurretFLComp;
	Seats[3].Mesh = TurretBRComp;
	Seats[4].Mesh = TurretBLComp;

	// Changing default properties after already instanced in level
	// TODO: RobM - remove after finished and is placed in level
	TurretFLComp.SetParentAnimComponent(None);
	TurretFRComp.SetParentAnimComponent(None);
	TurretBLComp.SetParentAnimComponent(None);
	TurretBRComp.SetParentAnimComponent(None);

	// Attach the turret meshes to the sub
	Mesh.AttachComponentToSocket(TurretFRComp, 'R_Front_Pod_Socket');
	Mesh.AttachComponentToSocket(TurretFLComp, 'L_Front_Pod_Socket');
	Mesh.AttachComponentToSocket(TurretBRComp, 'R_Back_Pod_Socket');
	Mesh.AttachComponentToSocket(TurretBLComp, 'L_Back_Pod_Socket');

	// Attach the spotlight to the sub
	Mesh.AttachComponentToSocket(Spotlight, 'Spotlight');

	// Attach effects to pod guns
	AttachTurretComponents();

	// Set the health for the pods
	for (Idx = 0; Idx < 4; Idx++)
	{
		PodHealth[Idx] = PodStartHealth;
		PrevPodHealth[Idx] = PodStartHealth;
	}

	// Set timer to update NearbyDangerousActors for AI in turrets
	if( Role == ROLE_Authority )
	{
		SetTimer( 1.f, TRUE, nameof(CheckUpdateSonar) );
		SetTimer(DangerousActorUpdateTime, TRUE, nameof(UpdateDangerousActors));
	}

	Super.PostBeginPlay();
}

/** Make sure that idle anim is playing on the pods */
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local int Idx;

	Super.PostInitAnimTree(SkelComp);
	for( Idx = 1; Idx < Seats.length; ++Idx )
	{
		Seats[Idx].Mesh.PlayAnim('Pod_Idle_Ready',,true);
	}
	CacheAnimNodes();
}


/** Attaches muzzle flash effects to pod guns */
simulated function AttachTurretComponents()
{
	local int SeatIndex;

	for( SeatIndex = 1; SeatIndex < Seats.length; ++SeatIndex )
	{
		// Instance the muzzle flash archetype for each barrel
		if( TurretEffects[SeatIndex-1].MuzzleFlashLeft == None )
		{
			TurretEffects[SeatIndex-1].MuzzleFlashLeft  = new(self) Seats[SeatIndex].GunClass.default.MuzzleFlashArchetype.Class(Seats[SeatIndex].GunClass.default.MuzzleFlashArchetype);
		}
		Seats[SeatIndex].Mesh.AttachComponentToSocket(TurretEffects[SeatIndex-1].MuzzleFlashLeft.MuzFlashEmitter, Seats[SeatIndex].GunSocket[0]);

		if( TurretEffects[SeatIndex-1].MuzzleFlashRight == None )
		{
			TurretEffects[SeatIndex-1].MuzzleFlashRight = new(self) Seats[SeatIndex].GunClass.default.MuzzleFlashArchetype.Class(Seats[SeatIndex].GunClass.default.MuzzleFlashArchetype);
		}
		Seats[SeatIndex].Mesh.AttachComponentToSocket(TurretEffects[SeatIndex-1].MuzzleFlashRight.MuzFlashEmitter, Seats[SeatIndex].GunSocket[1]);
	}
}

simulated function name GetRiderState(Pawn P)
{
	return LandMovementState;
}

/** (client + server) */
simulated function int GetVehicleDefaultHealth()
{
	return default.Health;
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
	Super.OnToggleHidden(Action);

	// TODO: RobM - Hide the 4 turrets
}

/** (client + server) */
simulated event Tick(float DeltaTime)
{
	local int i, HealthIdx;
	local GearMapSpecificInfo GearMapInfo;
	local LinearColor ColorValue;

	Super.Tick(DeltaTime);

	// update kelp materials with our location for material effects
	GearMapInfo = GearMapSpecificInfo(WorldInfo.GetMapInfo());
	if (GearMapInfo != None)
	{
		ColorValue.R = Location.X;
		ColorValue.G = Location.Y;
		ColorValue.B = Location.Z;
		for (i = 0; i < GearMapInfo.KelpMICs.length; i++)
		{
			GearMapInfo.KelpMICs[i].SetVectorParameterValue('Location', ColorValue);
		}
	}

	// Update pod health regeneration
	for (HealthIdx = 0; HealthIdx < 4; ++HealthIdx)
	{
		if( PodHealth[HealthIdx] < PodStartHealth && WorldInfo.TimeSeconds - PodDamageTime[HealthIdx] > PodHealthRegenDelay )
		{
			PodHealth[HealthIdx] = FClamp(PodHealth[HealthIdx] + (PodHealthRegenPerSec * DeltaTime), 0.f, PodStartHealth);
		}
	}

	// Update visual pod damage state
	PodHealthChanged();
}

/** Blow up the vehicle (will eventually need this) */
simulated function BlowupVehicle(Controller Killer)
{
	Super.BlowupVehicle(Killer);
}


simulated function SitDriver(GearPawn WP, int SeatIndex)
{
	local GearPC SeatPC;
	local Inventory CurrInv, DeleteInv;

	Super.SitDriver(WP, SeatIndex);

	WP.HolsterWeapon();
	WP.bCanDBNO = FALSE;

	if (WP.InvManager != None && WP.InvManager.InventoryChain != None)
	{
		CurrInv = WP.InvManager.InventoryChain;
		while (CurrInv != None)
		{
			DeleteInv = CurrInv;
			CurrInv = CurrInv.Inventory;
			if (GearVWeap_SubmarineTurretBase(DeleteInv) == None)
			{
				WP.InvManager.RemoveFromInventory(DeleteInv);
				DeleteInv.Destroy();
				WP.RefreshRemoteAttachments();
			}
		}
	}

	// If a player is in this seat, grab the GearPC
	SeatPC = GearPC(WP.Controller);
	if( SeatPC == None )
	{
		SeatPC = GearPC(Seats[SeatIndex].SeatPawn.Controller);
	}

	// Set proper view pitch limits on GearWeaponPawn
	if ( Seats[SeatIndex].ViewPitchMin != 0.0f )
	{
		GearWeaponPawn(Seats[SeatIndex].SeatPawn).ViewPitchMin = Seats[SeatIndex].ViewPitchMin;
	}
	else
	{
		GearWeaponPawn(Seats[SeatIndex].SeatPawn).ViewPitchMin = ViewPitchMin;
	}
	if ( Seats[SeatIndex].ViewPitchMax != 0.0f )
	{
		GearWeaponPawn(Seats[SeatIndex].SeatPawn).ViewPitchMax = Seats[SeatIndex].ViewPitchMax;
	}
	else
	{
		GearWeaponPawn(Seats[SeatIndex].SeatPawn).ViewPitchMax = ViewPitchMax;
	}

	// If we are a local player, hide the pawn mesh
	WP.Mesh.SetOwnerNoSee(true);
	WP.SetTimer(0.0001, false, 'UpdateAttachmentVisibility');
	WP.Mesh.SetTranslation(vect(0,0,0));
	WP.Mesh.SetScale(0.73);             // Scale him down so he fits in the pod properly
	if (SeatIndex > 0 && SeatIndex < Seats.length)
	{
		WP.AddAnimSetsToKismetArray( GunnerAnimData[SeatIndex-1].GunnerAnimSets );
		WP.Mesh.SetAnimTreeTemplate(GunnerAnimData[SeatIndex-1].GunnerAnimTree);

		// Setup hand IK
		if( WP.IKCtrl_RightHand != None )
		{
			WP.IKCtrl_RightHand.EffectorLocationSpace = BCS_BaseMeshSpace;
			WP.IKCtrl_RightHand.EffectorSpaceBoneName = 'R_Handle';
			WP.IKCtrl_RightHand.SetSkelControlActive(TRUE);
			WP.IKCtrl_RightHand.SetSkelControlStrength(1.0, 0.0);
		}
		if( WP.IKCtrl_LeftHand != None )
		{
			WP.IKCtrl_LeftHand.EffectorLocationSpace = BCS_BaseMeshSpace;
			WP.IKCtrl_LeftHand.EffectorSpaceBoneName = 'L_Handle';
			WP.IKCtrl_LeftHand.SetSkelControlActive(TRUE);
			WP.IKCtrl_LeftHand.SetSkelControlStrength(1.0, 0.0);
		}
	}
}

simulated function UnSitDriver(GearPawn WP, int SeatIndex)
{
	Super.UnSitDriver(WP, SeatIndex);

	WP.bCanDBNO = WP.default.bCanDBNO;
	WP.Mesh.SetOwnerNoSee(false);
	WP.Mesh.SetHidden(false);
	WP.Mesh.SetScale(1.0);
}

/** (client + server) */
simulated event float GetCameraFOV(int SeatIndex)
{
	local Controller UseC;

	// Find controller to look at for targetting
	if (SeatIndex == 0)
	{
		UseC = Controller;
	}
	else
	{
		UseC = Seats[SeatIndex].SeatPawn.Controller;
	}

	if (GearPC(UseC) != None && GearPC(UseC).bIsTargeting)
	{
		return TargetingFOV;
	}
	else
	{
		return DefaultFOV;
	}
}

simulated function bool ShouldShowWeaponOnHUD(GearPC PC)
{
	local GearWeaponPawn WP;

	WP = GearWeaponPawn(PC.Pawn);
	return (WP != None && WP.MyVehicle == self);
}

/** Used so we can override damage using our own table */
simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int Idx;
	local float PreHealth;
	local vector SocketLocation;
	local float HitDistance;
	local float ClosestHitDistance;
	local int ClosestSeatIndex;
	local int SeatIdx;
	local array<int> HitPodIndexes;
	local int HitIdx;
	local GearPRI SeatPRI;

	// make sure we are the server and we're alive
	if (Role < ROLE_Authority ||
		Health <= 0 || InGodMode() ||
		Seats[1].SeatPawn.InGodMode())
	{
		return;
	}

	// Ignore yourself doing damage
	if (EventInstigator != None)
	{
		for (SeatIdx = 1; SeatIdx < Seats.Length; SeatIdx++)
		{
			if (Seats[SeatIdx].SeatPawn != None &&
				Seats[SeatIdx].SeatPawn.Controller == EventInstigator)
			{
				return;
			}
		}
	}

	// Determine the health before the super class's decrement it in case the pods get hit. If they
	// get hit we don't want the vehicle itself to take the damage, only the pod
	PreHealth = Health;

	if (Damage > 0)
	{
		PlaySound(ImpactSoundCue,,,,HitLocation);

		// Determine if a pod got hit
		// First see if the component received the hit
		for (Idx = 1; Idx < Seats.Length; Idx++)
		{
			if (HitInfo.HitComponent == Seats[Idx].Mesh)
			{
				HitPodIndexes.AddItem(Idx);
				break;
			}
		}

		// If a component wasn't hit, do a distance check across all pods (component hit detection is faulty I'm told)
		if (HitPodIndexes.Length <= 0)
		{
			// First handle the special case of an explosion
			if (DamageType == class'GDT_WaterMine')
			{
				for (Idx = 1; Idx < Seats.Length; Idx++)
				{
					Seats[Idx].Mesh.GetSocketWorldLocationAndRotation(Seats[Idx].SeatBone, SocketLocation);
					HitDistance = VSize(HitLocation - SocketLocation);
					if (HitDistance < class'GearUnderwaterMine'.default.ExplosionDamageRadius)
					{
						HitPodIndexes.AddItem(Idx);
					}
				}
			}
			// Else just find the closest pod to give damage to
			else
			{
				ClosestSeatIndex = 1;
				Seats[1].Mesh.GetSocketWorldLocationAndRotation(Seats[1].SeatBone, SocketLocation);
				ClosestHitDistance = VSizeSq(HitLocation - SocketLocation);
				for (Idx = 2; Idx < Seats.Length; Idx++)
				{
					Seats[Idx].Mesh.GetSocketWorldLocationAndRotation(Seats[Idx].SeatBone, SocketLocation);
					HitDistance = VSizeSq(HitLocation - SocketLocation);
					if (HitDistance < ClosestHitDistance)
					{
						ClosestHitDistance = HitDistance;
						ClosestSeatIndex = Idx;
					}
				}
				HitPodIndexes.AddItem(ClosestSeatIndex);
			}
		}

		// If the pod was hit
		if (HitPodIndexes.Length > 0)
		{
			for (HitIdx = 0; HitIdx < HitPodIndexes.Length; HitIdx++)
			{
				// Adjust damage based on difficulty
				if( GearPC(Seats[HitIdx+1].SeatPawn.Controller) != None )
				{
					SeatPRI = GearPRI(Seats[HitIdx+1].SeatPawn.PlayerReplicationInfo);
					if( SeatPRI.Difficulty.default.DifficultyLevel == DL_Casual )
					{
						Damage *= DamageScale_Casual;
					}
					else if( SeatPRI.Difficulty.default.DifficultyLevel == DL_Hardcore )
					{
						Damage *= DamageScale_Hardcore;
					}
					else if( SeatPRI.Difficulty.default.DifficultyLevel == DL_Insane )
					{
						Damage *= DamageScale_Insane;
					}
				}


				// reset the health of the vehicle
				Health = PreHealth;
				// Give damage to the pod
				PodHealth[HitPodIndexes[HitIdx]-1] -= Damage;
				PodDamageTime[HitPodIndexes[HitIdx]-1] = WorldInfo.TimeSeconds;
				if( Seats[HitPodIndexes[HitIdx]].SeatPawn.Controller != None && Seats[HitPodIndexes[HitIdx]].SeatPawn.Controller.IsLocalPlayerController() )
				{
					Seats[HitPodIndexes[HitIdx]].SeatPawn.Controller.PlaySound(DamageSoundCue, true);
				}
				// Since this is the server we call the function that will get called
				// in the replicated event code-path here
				PodHealthChanged();
			}
		}
		else
		{
			Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
		}
	}
}

/**
 * Pod health has changed so do any effects, anims, and health monitoring needed
 *
 * @param SeatIndex - The seat index of the pod that was damaged
 */
simulated function PodHealthChanged()
{
	local int HealthIdx;
	local int SeatIdx;
	local float DamagePct;
	local bool bLocalPlayer;

	// Loop through all damaged pods
	for (HealthIdx = 0; HealthIdx < 4; HealthIdx++)
	{
		// Pod was damaged
		if (PodHealth[HealthIdx] != PrevPodHealth[HealthIdx])
		{
			// Set a local seat index variable so we don't need to add 1 for our data
			SeatIdx = HealthIdx + 1;

			// Set up MaterialInstanceConstants for this pod
			if( Seats[SeatIdx].SeatPawn.Controller != None && Seats[SeatIdx].SeatPawn.Controller.IsLocalPlayerController() )
			{
				bLocalPlayer = true;
				if( MIC_Pod[HealthIdx] == None )
				{
					MIC_Pod[HealthIdx] = Seats[SeatIdx].Mesh.CreateAndSetMaterialInstanceConstant(0);
				}
				if( MIC_Screen[HealthIdx] == None )
				{
					MIC_Screen[HealthIdx] = Seats[SeatIdx].Mesh.CreateAndSetMaterialInstanceConstant(1);
				}
				if( MIC_Glass[HealthIdx] == None )
				{
					MIC_Glass[HealthIdx] = Seats[SeatIdx].Mesh.CreateAndSetMaterialInstanceConstant(2);
				}
			}
			else
			{
				bLocalPlayer = false;
			}

			// See if we've passed each damage threshold in reverse order
			if (PodHealth[HealthIdx] <= RetractDamageThreshold &&
				PrevPodHealth[HealthIdx] > RetractDamageThreshold && 
				Role == ROLE_Authority)
			{
				// activate death event
				TriggerEventClass(class'SeqEvent_Death', self);
			}
			 
			// Update pod's visual damage state
			if( bLocalPlayer )
			{
				DamagePct = 1.0f - PodHealth[HealthIdx] / PodStartHealth;
				MIC_Pod[HealthIdx].SetScalarParameterValue('MinorDamage', FClamp(2.0f * DamagePct, 0.0f, 1.0f));
				MIC_Pod[HealthIdx].SetScalarParameterValue('MajorDamage', FClamp(2.0f * DamagePct - 1.0f, 0.0f, 1.0f));
				MIC_Screen[HealthIdx].SetScalarParameterValue('MinorDamage', FClamp(2.0f * DamagePct, 0.0f, 1.0f));
				MIC_Screen[HealthIdx].SetScalarParameterValue('MajorDamage', FClamp(2.0f * DamagePct - 1.0f, 0.0f, 1.0f));
				MIC_Glass[HealthIdx].SetScalarParameterValue('GlassDamage', DamagePct);
			}

			// Set the new previous health value
			PrevPodHealth[HealthIdx] = PodHealth[HealthIdx];
		}
	}
}

/** Function called when the first pod is ready for extraction */
function PodHasRecovered1()
{
	PodHealth[0] = PodStartHealth;
	PodHealthChanged();
}

/** Function called when the second pod is ready for extraction */
function PodHasRecovered2()
{
	PodHealth[1] = PodStartHealth;
	PodHealthChanged();
}

/** Function called when the third pod is ready for extraction */
function PodHasRecovered3()
{
	PodHealth[2] = PodStartHealth;
	PodHealthChanged();
}

/** Function called when the fourth pod is ready for extraction */
function PodHasRecovered4()
{
	PodHealth[3] = PodStartHealth;
	PodHealthChanged();
}

/** Play weapon effects and sounds (will need later) */
simulated function VehicleWeaponFireEffects(vector HitLocation, int SeatIndex)
{
	Super.VehicleWeaponFireEffects(HitLocation, SeatIndex);

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (SeatIndex > 0 && SeatIndex < Seats.length)
		{
			PlayTurretEffects(SeatIndex);
		}
	}
}

/** Plays turret fire effects, anims, and sounds for the given SeatIndex */
simulated function PlayTurretEffects(int SeatIndex)
{
	local int BarrelIndex;
	local vector FireLocation;
	local GearPC SeatPC;
	local SkeletalMeshComponent CurrMesh;
	local class<GearVWeap_SubmarineTurretBase> TurretClass;

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		BarrelIndex = (Seats[SeatIndex].BarrelIndex + 1) % 2;

		// Set the muzzle flash to the correct barrel
		CurrMesh = GetSeatMesh(SeatIndex);
		if (CurrMesh != None)
		{
			TurretClass = class<GearVWeap_SubmarineTurretBase>(Seats[SeatIndex].GunClass);

			// Play fire sound
			VehiclePlayLocalSound(TurretClass.default.FireSound, TurretClass.default.FireSound_Player,,,SeatIndex);

			// Play force feedback
			SeatPC = GearPC(Seats[SeatIndex].SeatPawn.Controller);
			if( SeatPC != None && SeatPC.IsLocalPlayerController() )
			{
				SeatPC.ClientPlayForceFeedbackWaveform(TurretClass.default.WeaponFireWaveForm);
			}

			GetBarrelLocationAndRotation(SeatIndex, FireLocation);

			// Play effects on the appropriate barrel of the gun
			if( BarrelIndex == 0 )
			{
				TurretEffects[SeatIndex-1].MuzzleFlashLeft.MuzFlashEmitter.SetLODLevel(GearGRI(WorldInfo.GRI).GetLODLevelToUse(TurretEffects[SeatIndex-1].MuzzleFlashLeft.MuzFlashEmitter.Template, FireLocation));
				TurretEffects[SeatIndex-1].MuzzleFlashLeft.MuzFlashEmitter.ActivateSystem(true);
				Seats[SeatIndex].Mesh.PlayAnim(TurretClass.default.WeaponFireAnimLeft);

				if( TurretEffects[SeatIndex-1].MuzzleFlashLeft.MuzzleFlashLight != None &&
					!GearGRI(WorldInfo.GRI).ShouldDisableEffectsDueToFramerate(Instigator) &&
					(!TurretEffects[SeatIndex-1].MuzzleFlashLeft.bLoopMuzzleFlashLight || !TurretEffects[SeatIndex-1].MuzzleFlashLeft.MuzzleFlashLight.bEnabled) )
				{
					TurretEffects[SeatIndex-1].MuzzleFlashLeft.MuzzleFlashLight.CastDynamicShadows = Seats[SeatIndex].GunClass.default.bDynamicMuzzleFlashes;
					TurretEffects[SeatIndex-1].MuzzleFlashLeft.MuzzleFlashLight.SetEnabled(TRUE);

					// Reset Pulse time to zero, so we start at the beginning.
					TurretEffects[SeatIndex-1].MuzzleFlashLeft.MuzzleLightPulseTime = 0.f;
				}

			}
			else
			{
				TurretEffects[SeatIndex-1].MuzzleFlashRight.MuzFlashEmitter.SetLODLevel(GearGRI(WorldInfo.GRI).GetLODLevelToUse(TurretEffects[SeatIndex-1].MuzzleFlashRight.MuzFlashEmitter.Template, FireLocation));
				TurretEffects[SeatIndex-1].MuzzleFlashRight.MuzFlashEmitter.ActivateSystem(true);
				Seats[SeatIndex].Mesh.PlayAnim(TurretClass.default.WeaponFireAnimRight);

				if( TurretEffects[SeatIndex-1].MuzzleFlashRight.MuzzleFlashLight != None &&
					!GearGRI(WorldInfo.GRI).ShouldDisableEffectsDueToFramerate(Instigator) &&
					(!TurretEffects[SeatIndex-1].MuzzleFlashRight.bLoopMuzzleFlashLight || !TurretEffects[SeatIndex-1].MuzzleFlashRight.MuzzleFlashLight.bEnabled) )
				{
					TurretEffects[SeatIndex-1].MuzzleFlashRight.MuzzleFlashLight.CastDynamicShadows = Seats[SeatIndex].GunClass.default.bDynamicMuzzleFlashes;
					TurretEffects[SeatIndex-1].MuzzleFlashRight.MuzzleFlashLight.SetEnabled(TRUE);

					// Reset Pulse time to zero, so we start at the beginning.
					TurretEffects[SeatIndex-1].MuzzleFlashRight.MuzzleLightPulseTime = 0.f;
				}
			}
		}
	}
}


simulated event DriverSpeakLine(SoundCue Audio, bool bSuppressSubtitles)
{
	local AudioComponent SpeakingComp;

	SpeakingComp = CreateAudioComponent( Audio, FALSE, TRUE );
	if (SpeakingComp != None)
	{
		AttachComponent(SpeakingComp);

		SpeakingComp.bAutoDestroy = TRUE;
		SpeakingComp.Location = Location;
		SpeakingComp.bSuppressSubtitles = bSuppressSubtitles;

		// jack priority for scripted lines
		SpeakingComp.bAlwaysPlay = TRUE;

		SpeakingComp.FadeIn(0.2f, 1.f);
	}
}

/**
 * returns true if Pawn P successfully became driver of this vehicle
 */
function bool TryToDrive(Pawn P)
{
	if( !CanEnterVehicle( P ) )
	{
		return FALSE;
	}

	return PassengerEnter(P, GetFirstAvailableSeat());
}


/** Return the rotation of the vehicle used as basis for vehicle-space camera */
simulated function rotator GetVehicleSpaceCamRotation(float DeltaTime, bool bPassenger, optional int SeatIndex=-1)
{
	local rotator RelRot;

	if (SeatIndex > 0 && SeatIndex < Seats.length)
	{
		RelRot.Yaw = Seats[SeatIndex].BaseYawOffset;
		return RTransform(RelRot, Rotation);
	}

	return Rotation;
}

/**
 * Returns the mesh used by the seat (assumed to be the vehicle if not set in the seat)
 *
 * @param SeatIndex - The index in the Seats array for the seat in question
 * @return - Either the mesh set in the Seats array at index SeatIndex, or the mesh of the vehicle
 */
simulated event SkeletalMeshComponent GetSeatMesh(int SeatIndex)
{
	local GearPC PC;

	PC = GearPC(Seats[SeatIndex].SeatPawn.Controller);
	if (PC != None && PC.IsLocalPlayerController())
	{
		return HighResPod1;
	}
	else
	{
		switch (SeatIndex)
		{
			case 1: return TurretFRComp;
			case 2: return TurretFLComp;
			case 3: return TurretBRComp;
			case 4: return TurretBLComp;
		}
	}
	return Super.GetSeatMesh(SeatIndex);
}

/**
 * Returns the seat index, low-res pod component, high-res pod component and socket attachment name for this GearPC
 *
 * @ param - The GearPC to get the pod data for
 * @ out_param out_SeatIdx - The seat index of the seat this GearPC is located
 * @ out_param out_LowResPodComp - The low-res pod component this GearPC should use
 * @ out_param out_HighResPodComp - The high-res pod component this GearPC should use
 * @ out_param out_AttachSocketName - the name of the socket the pod components attach to on the submarine
 * @return - whether we were able to find a seat for this GearPC or not
 */
simulated event bool GetPodDataForPC(Pawn SeatPawn,
						   out int out_SeatIdx,
						   out SkeletalMeshComponent out_LowResPodComp,
						   out SkeletalMeshComponent out_HighResPodComp,
						   out Name out_AttachSocketName)
{
	if (SeatPawn != None)
	{
		// Find which seat this player is in
		for (out_SeatIdx = 1; out_SeatIdx < Seats.length; out_SeatIdx++)
		{
			if (Seats[out_SeatIdx].SeatPawn == SeatPawn)
			{
				// Determine which high res pod to use
				out_HighResPodComp = HighResPod1;
				// Determine which low res pod this player is in and the socket to attach to
				switch (out_SeatIdx)
				{
					case 1:
						out_LowResPodComp = TurretFRComp;
						out_AttachSocketName = 'R_Front_Pod_Socket';
						break;
					case 2:
						out_LowResPodComp = TurretFLComp;
						out_AttachSocketName = 'L_Front_Pod_Socket';
						break;
					case 3:
						out_LowResPodComp = TurretBRComp;
						out_AttachSocketName = 'R_Back_Pod_Socket';
						break;
					case 4:
						out_LowResPodComp = TurretBLComp;
						out_AttachSocketName = 'L_Back_Pod_Socket';
						break;
				}
				return TRUE;
			}
		}
	}

	out_SeatIdx = INDEX_NONE;
	return FALSE;
}

/** Override to attach 1st person pod for local PC */
simulated function AttachLocalComponents(GearPC PC)
{
	local int SeatIdx;
	local SkeletalMeshComponent HighResComp;
	local SkeletalMeshComponent LowResComp;
	local Name AttachName;
	local GearSkelCtrl_TurretConstrained Turret;
	local vector PivotLoc, MuzzleLoc;

	// Get the pod data for this player
	if (GetPodDataForPC(PC.Pawn, SeatIdx, LowResComp, HighResComp, AttachName))
	{
		// Attach the high res pod to the correct spot
		Mesh.AttachComponentToSocket(HighResComp, AttachName);

		// Hide the 3rd person mesh for the owner
		if( Seats[SeatIdx].Mesh != None )
		{
			Seats[SeatIdx].Mesh.SetOwnerNoSee(true);
		}
		// Set the seat mesh
		Seats[SeatIdx].Mesh = HighResComp;
		// Hide the low res mesh and show the high res one
		LowResComp.SetOwnerNoSee(true);
		HighResComp.SetOnlyOwnerSee(false);

		// Hide the mesh of the pawn sitting in the pod
		if( Seats[SeatIdx].StoragePawn != None )
		{
			Seats[SeatIdx].StoragePawn.Mesh.SetOwnerNoSee(true);
		}

		// Hook up the turret controls
		Turret = GearSkelCtrl_TurretConstrained(HighResComp.FindSkelControl(Seats[SeatIdx].TurretControls[0]));
		if (Turret != None)
		{
			Turret.AssociatedSeatIndex = SeatIdx;
			Seats[SeatIdx].TurretControllers.AddItem(Turret);
			// Initialize turrets to vehicle rotation.
			Turret.InitTurret(PC.Rotation, Mesh);
			SeatWeaponRotation(SeatIdx, PC.Rotation, FALSE);

			// Calculate Z distance between weapon pivot and muzzle
			PivotLoc = GetSeatPivotPoint(SeatIdx);
			GetBarrelLocationAndRotation(SeatIdx, MuzzleLoc);
			Seats[SeatIdx].PivotFireOffsetZ = MuzzleLoc.Z - PivotLoc.Z;

			// Make sure that idle anim is playing on the pod
			Seats[SeatIdx].Mesh.PlayAnim('Pod_Idle_Ready',,true);
		}
		CacheAnimNodes();
		AttachTurretComponents();
	}
}

/** Override to detach 1st person pod for local PC */
simulated function DetachLocalComponents(GearPC PC)
{
	local int SeatIdx;
	local SkeletalMeshComponent HighResComp;
	local SkeletalMeshComponent LowResComp;
	local GearSkelCtrl_TurretConstrained Turret;
	local Name AttachName;

	// Get the pod data for this player
	if (GetPodDataForPC(PC.Pawn, SeatIdx, LowResComp, HighResComp, AttachName))
	{
		// Remove the turret controls
		Turret = GearSkelCtrl_TurretConstrained(HighResComp.FindSkelControl(Seats[SeatIdx].TurretControls[0]));
		if (Turret != None)
		{
			Seats[SeatIdx].TurretControllers.RemoveItem(Turret);
		}
		// Detach the high res pod
		Mesh.DetachComponent(HighResComp);
		// Set the other mesh for the seat
		Seats[SeatIdx].Mesh = LowResComp;
		// Hide the high res mesh and show the low res one
		HighResComp.SetHidden(true);
		LowResComp.SetHidden(false);
	}
}

/**
 * returns the camera focus position (adjusted for camera lag)
 */
simulated event vector GetCameraStart(int SeatIndex)
{
	local SkeletalMeshComponent HighResMesh;
	local SkeletalMeshComponent LowResMesh;
	local int SeatIdx;
	local Name AttachName;
	local vector SocketLocation;

	if (GetPodDataForPC(Seats[SeatIndex].SeatPawn, SeatIdx, LowResMesh, HighResMesh, AttachName))
	{
		if (Seats[SeatIdx].Mesh != None)
		{
			SocketLocation = Seats[SeatIdx].Mesh.GetBoneLocation(Seats[SeatIdx].GunPivotPoints[0]);
		}
	}
	return SocketLocation;
}

/**
 * Don't draw crosshair if the turret is disabled
 * 
 * @param PC - the controller that is drawing a hud
 * @return TRUE if we should draw a crosshair
 */
simulated function bool WantsCrosshair(PlayerController PC)
{
	if( GearVWeap_SubmarineTurretBase(PC.Pawn.Weapon) != None )
	{
		return !GearVWeap_SubmarineTurretBase(PC.Pawn.Weapon).bTurretDisabled;
	}
	return true;
}

/** Function that handles damage given from kismet to the submarine or one of its' pods */
function OnDoSubmarineDamage(SeqAct_DoSubmarineDamage Action)
{
	local GearPawn_LocustIthycusBase FishPawn;
	local GearUnderwaterRocket Rocket;
	local GearUnderwaterMine Mine;

	// Handle giving damage to turret(s) or resetting their health
	if (Action.InputLinks[GSA_TurretHealth].bHasImpulse)
	{
		// If we are resetting health, do so and bail
		if (Action.bResetHealth)
		{
			DoSubmarineHealthReset(Action.PodIndex);
			return;
		}

		// If the instigator was an Ithycus, we need it to play a special move (it will give damage from there)
		FishPawn = GearPawn_LocustIthycusBase(Action.Instigator);
		Rocket = GearUnderwaterRocket(Action.Instigator);
		Mine = GearUnderwaterMine(Action.Instigator);
		if (FishPawn != None)
		{
			if (FishPawn.Health > 0)
			{
				FishPawn.AttackSubmarine(self, Action.PodIndex, Action.Damage);
			}
		}
		// If the instigator was a rocket, we need to blow up the rocket
		else if (Rocket != None)
		{
			Rocket.Detonate();
		}
		// If the instigator was a mine, explode it
		else if (Mine != None)
		{
			Mine.Detonate();
		}
		// Do the damage now
		else
		{
			DoSubmarineDamage(Pawn(Action.Instigator), Action.PodIndex, Action.Damage, Action.DamageType);
		}
	}
	else if (Action.InputLinks[GSA_WeaponOn].bHasImpulse)
	{
		ToggleTurretWeapon(Action.PodIndex, false);
	}
	else if (Action.InputLinks[GSA_WeaponOff].bHasImpulse)
	{
		ToggleTurretWeapon(Action.PodIndex, true);
	}
	else if (Action.InputLinks[GSA_SpotlightOn].bHasImpulse)
	{
		ToggleTurretSpotlight(false);
	}
	else if (Action.InputLinks[GSA_SpotlightOff].bHasImpulse)
	{
		ToggleTurretSpotlight(true);
	}
}

/**
 * Turn the ability to fire the turret's weapon on or off
 * @param PodIndex - The index of the turret to toggle the weapon of (1-4, outside this range means all turrets)
 * @param bDisableTurret - Whether to disable the weapon
 */
function ToggleTurretWeapon(int PodIndex, bool bDisableTurret)
{
	local GearVWeap_SubmarineTurretBase SubTurret;
	local int Idx;

	// See if we only need to handle one pod
	if (PodIndex > 0 && PodIndex < 5)
	{
		SubTurret = GearVWeap_SubmarineTurretBase(Seats[PodIndex].Gun);
		if (SubTurret != None)
		{
			SubTurret.ToggleWeaponFire(bDisableTurret);
		}
	}
	// Handle all pods
	else
	{
		for (Idx = 1; Idx < 5; Idx++)
		{
			SubTurret = GearVWeap_SubmarineTurretBase(Seats[Idx].Gun);
			if (SubTurret != None)
			{
				SubTurret.ToggleWeaponFire(bDisableTurret);
			}
		}
	}
}

/**
 * Turn the spotlight of the turret on or off
 * @param PodIndex - The index of the turret to toggle the spotlight of (1-4, outside this range means all turrets)
 * @param bDisableSpotlight - Whether to disable the spotlight
 */
function ToggleTurretSpotlight(bool bDisableSpotlight)
{
	bSpotlightEnabled = !bDisableSpotlight;
	Spotlight.SetEnabled(bSpotlightEnabled);
}

/** Function to reset the health of pods */
function DoSubmarineHealthReset(optional int PodIndex)
{
	local int Idx;

	// If a valid pod was set, we only reset that pod's health
	if (PodIndex > 0 && PodIndex < 5)
	{
		PodHealth[PodIndex-1] = PodStartHealth;
	}
	// else we reset all pods' health
	else
	{
		for (Idx = 0; Idx < 4; Idx++)
		{
			PodHealth[Idx] = PodStartHealth;
		}
	}

	// Notify the health changed for effects, etc.
	PodHealthChanged();
}

/** Function that actually handles how specific attacks to the submarine should be handled */
function DoSubmarineDamage(Pawn InstigatorPawn, int PodIndex, float Damage, class<GearDamageType> DamageType)
{
	local Controller InstigatorController;
	local GearPC PC;
	local vector HitLocation;
	local TraceHitInfo HitInfo;
	local vector Momentum;
	local int PodIdx;

	// Set the instigator controller
	InstigatorController = (InstigatorPawn != None) ? InstigatorPawn.Controller : None;

	// Play camera shake on all players in the sub
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		PC.ClientPlayCameraShake(CamShakeIndirectDamage, 1.0, true);
	}

	// One pod was specifically hit
	if (PodIndex > 0 && PodIndex < 5)
	{
		HitInfo.HitComponent = Seats[PodIndex].Mesh;
		Seats[PodIndex].Mesh.GetSocketWorldLocationAndRotation(Seats[PodIndex].SeatBone, HitLocation);
		Momentum = vect(0,0,0);

		// Play camera shake on all players in the sub
		foreach LocalPlayerControllers(class'GearPC', PC)
		{
			if( Seats[PodIndex].SeatPawn.Controller == PC )
			{
				PC.ClientPlayCameraShake(CamShakeDirectDamage, 1.0, true);
			}
			else
			{
				PC.ClientPlayCameraShake(CamShakeIndirectDamage, 1.0, true);
			}
		}

		TakeDamage(FCeil(Damage), InstigatorController, HitLocation, Momentum, DamageType, HitInfo, InstigatorPawn);
	}
	// All pods take damage
	else
	{
		for (PodIdx = 1; PodIdx < 5; PodIdx++)
		{
			HitInfo.HitComponent = Seats[PodIdx].Mesh;
			Seats[PodIdx].Mesh.GetSocketWorldLocationAndRotation(Seats[PodIdx].SeatBone, HitLocation);
			Momentum = vect(0,0,0);

			// Play camera shake on all players in the sub
			PC = GearPC(Seats[PodIdx].SeatPawn.Controller);
			if( PC != None )
			{
				PC.ClientPlayCameraShake(CamShakeDirectDamage, 1.0, true);
			}

			TakeDamage(FCeil(Damage), InstigatorController, HitLocation, Momentum, DamageType, HitInfo, InstigatorPawn);
		}
	}
}

simulated function TakeRadiusDamage
(
	Controller			InstigatedBy,
	float				BaseDamage,
	float				DamageRadius,
	class<DamageType>	DamageType,
	float				Momentum,
	vector				HurtOrigin,
	bool				bFullDamage,
	Actor               DamageCauser,
	optional float      DamageFalloffExponent=1.f
	)
{
	local vector HitLocation, Dir, NewDir;
	local float Dist, DamageScale;
	local TraceHitInfo HitInfo;
	local vector RealHurtOrigin;

	if ( Role < ROLE_Authority )
		return;

	RealHurtOrigin = HurtOrigin;
	// calculate actual hit position on mesh, rather than approximating with cylinder
	HitLocation = Location;
	Dir = Location - HurtOrigin;

	CheckHitInfo( HitInfo, Mesh, Dir, HitLocation );
	NewDir = HitLocation - HurtOrigin;
	Dist = VSize(NewDir);

	if ( bFullDamage )
	{
		DamageScale = 1.f;
	}
	else if ( dist > DamageRadius )
		return;
	else
	{
		DamageScale = FMax(0,1 - Dist/DamageRadius);
		DamageScale = DamageScale ** DamageFalloffExponent;
	}

	RadialImpulseScaling = DamageScale;

	TakeDamage
		(
		BaseDamage * DamageScale,
		InstigatedBy,
		RealHurtOrigin,
		(DamageScale * Momentum * Normal(dir)),
		DamageType,
		HitInfo,
		DamageCauser
		);
	RadialImpulseScaling = 1.0;
// 	if (Health > 0)
// 	{
// 		DriverRadiusDamage(BaseDamage, DamageRadius, InstigatedBy, DamageType, Momentum, HurtOrigin, DamageCauser);
// 	}
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	if (Base != None)
	{
		Record.BasePathName = PathName(Base);
	}
	Record.RelativeLocation = RelativeLocation;
	Record.RelativeRotation = RelativeRotation;
	Record.Rotation = Rotation;
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	local Actor NewBase;

	DoSubmarineHealthReset();

	NewBase = Actor(FindObject(Record.BasePathName, class'Actor'));
	if (NewBase != None)
	{
		SetBase(NewBase);
	}
	SetRelativeLocation(Record.RelativeLocation);
	SetRelativeRotation(Record.RelativeRotation);
	SetRotation(Record.Rotation);
}

/** Update list of actors implementing Interface_AIVehicleWeaponTarget for AI to use */
function UpdateDangerousActors()
{
	local Actor Target;
	local vector Dir;

	Dir = Normal(GetBaseMost().Velocity);
	NearbyDangerousActors.length = 0;

 	//DrawDebugSphere(Location + Dir * DangerousActorLocationOffset, DangerousActorDist, 10, 255, 0, 0, true);
	foreach CollidingActors(class'Actor', Target, DangerousActorDist, Location + Dir * DangerousActorLocationOffset, false, class'Interface_AIVehicleWeaponTarget')
	{
		NearbyDangerousActors.AddItem(Target);
	}
}

function CheckUpdateSonar()
{
	local GearPC PC;
	local int SeatIndex;

	for( SeatIndex = 0; SeatIndex < Seats.Length; ++SeatIndex )
	{
		if( Seats[SeatIndex].SeatPawn != None )
		{
			PC = GearPC(Seats[SeatIndex].SeatPawn.Controller);
			if( PC != None )
			{
				ServerUpdateSonarFor( PC, FALSE );
			}
		}
	}
}

/** Update list of actors implementing Interface_AIVehicleWeaponTarget for AI to use */
reliable server function ServerUpdateSonarFor( GearPC PC, bool bPlayerInput )
{
	local int HandleIdx;
	local float ActorDotDir;
	local Vector CamLoc;
	local Rotator CamRot;
	local Actor Target;
	local array<SonarItem> DangerousActors;
	local array<SonarItem> RegisteredDangerousActors;
	local int Idx, BestIdx;
	local float MinDist;
	local vector Dir;

	HandleIdx = SonarHandleList.Find( 'PC', PC );
	if( HandleIdx < 0 )
	{
		HandleIdx = SonarHandleList.Length;
		SonarHandleList.Length = HandleIdx + 1;
		SonarHandleList[HandleIdx].PC = PC;
	}

	if( bPlayerInput )
	{
		if( `TimeSince(SonarHandleList[HandleIdx].LastPlayerInputTime) <= 1.f || SonarHandleList[HandleIdx].UpdateTimer >= SonarPulseUpdateTime - 1.f )
		{
			return;
		}
		SonarHandleList[HandleIdx].LastPlayerInputTime = WorldInfo.TimeSeconds;
	}
	if( !bPlayerInput )
	{
		SonarHandleList[HandleIdx].UpdateTimer -= 1.f;
		if( SonarHandleList[HandleIdx].UpdateTimer > 0.f )
		{
			return;
		}
	}

	SonarHandleList[HandleIdx].UpdateTimer = SonarPulseUpdateTime;

	PC.GetPlayerViewPoint( CamLoc, CamRot );
	Dir = Normal(GetBaseMost().Velocity);
	//DrawDebugSphere(CamLoc, DangerousActorDist, 10, 255, 0, 0, true);
	foreach CollidingActors( class'Actor', Target, DangerousActorDist, Location + Dir * DangerousActorLocationOffset, FALSE, class'Interface_AIVehicleWeaponTarget' )
	{
		ActorDotDir = Normal( Target.Location - CamLoc ) DOT Dir;
		if( ActorDotDir > 0.f )
		{
			Idx = DangerousActors.Length;
			DangerousActors.Length = Idx + 1;

			DangerousActors[Idx].DangerousActor = Target;
			DangerousActors[Idx].Dist = VSize2D(Target.Location - CamLoc);
		}
	}

	while( RegisteredDangerousActors.Length < 3 && DangerousActors.Length > 0 )
	{
		BestIdx = -1;
		for( Idx = 0; Idx < DangerousActors.Length; Idx++ )
		{
			if( BestIdx < 0.f || DangerousActors[Idx].Dist < MinDist )
			{
				BestIdx = Idx;
				MinDist = DangerousActors[Idx].Dist;
			}
		}

		if( BestIdx >= 0 )
		{
			RegisteredDangerousActors.AddItem(DangerousActors[BestIdx]);
			DangerousActors.Remove( BestIdx, 1 );
		}
	}

	for( Idx = 0; Idx < RegisteredDangerousActors.Length; Idx++ )
	{
		PC.ClientAddHitLocator(RegisteredDangerousActors[Idx].DangerousActor, (DangerousActorDist - RegisteredDangerousActors[Idx].Dist) / DangerousActorDist * 200.f, RegisteredDangerousActors[Idx].DangerousActor.Location, FALSE);
	}

	PC.ClientPlaySound( SonarPulseSound );
}

defaultproperties
{
	LandMovementState=PlayerDrivingSubmarineTurret
	WaterMovementState=PlayerDrivingSubmarineTurret

	bNoDelete=true
	bUpdateSimulatedPosition=false

	// Spotlight is on by default
	bSpotlightEnabled=true

	HUDSonarColor=(R=0,G=40,B=255,A=255)

	// Mesh for the front-left turret
	Begin Object Class=SkeletalMeshComponent Name=TurretFLSkel
		LightEnvironment=MyLightEnvironment
		BlockActors=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockRigidBody=TRUE
		ShadowParent=SVehicleMesh
	End Object
	TurretFLComp=TurretFLSkel

	// Mesh for the front-right turret
	Begin Object Class=SkeletalMeshComponent Name=TurretFRSkel
		LightEnvironment=MyLightEnvironment
		BlockActors=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockRigidBody=TRUE
		ShadowParent=SVehicleMesh
	End Object
	TurretFRComp=TurretFRSkel

	// Mesh for the back-left turret
	Begin Object Class=SkeletalMeshComponent Name=TurretBLSkel
		LightEnvironment=MyLightEnvironment
		BlockActors=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockRigidBody=TRUE
		ShadowParent=SVehicleMesh
	End Object
	TurretBLComp=TurretBLSkel

	// Mesh for the back-right turret
	Begin Object Class=SkeletalMeshComponent Name=TurretBRSkel
		LightEnvironment=MyLightEnvironment
		BlockActors=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockRigidBody=TRUE
		ShadowParent=SVehicleMesh
	End Object
	TurretBRComp=TurretBRSkel

	// Mesh for the first high res turret
	Begin Object Class=SkeletalMeshComponent Name=HighResSkel1
		LightEnvironment=MyLightEnvironment
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		CollideActors=FALSE
		BlockRigidBody=FALSE
		ShadowParent=SVehicleMesh
	End Object
	HighResPod1=HighResSkel1

	Begin Object Class=SpotLightComponent Name=SpotLight0
		InnerConeAngle=0
		OuterConeAngle=20
		Radius=12000
		Brightness=4
		LightColor=(B=255,G=242,R=175,A=255)
	End Object
	Spotlight=SpotLight0

	Begin Object Name=MyLightEnvironment
		bForceNonCompositeDynamicLights=true
	End Object

	Begin Object Class=GearCameraShake Name=CamShakeDirectDamage0
		OscillationDuration=0.5f
		LocOscillation={(Y=(Amplitude=2.f,Frequency=3.f),
		Z=(Amplitude=10.f,Frequency=30.f))}
	End Object
	CamShakeDirectDamage=CamShakeDirectDamage0

	Begin Object Class=GearCameraShake Name=CamShakeInirectDamage0
		OscillationDuration=0.2f
		LocOscillation={(Y=(Amplitude=1.f,Frequency=3.f),
		Z=(Amplitude=5.f,Frequency=10.f))}
	End Object
	CamShakeIndirectDamage=CamShakeInirectDamage0

	bVehicleSpaceViewLimits=FALSE
	bVehicleSpaceCamera=TRUE
	bPassengerVehicleSpaceCamera=TRUE
	bShowWeaponOnHUD=FALSE
	bAlwaysViewFriction=TRUE
	Physics=PHYS_Interpolating
	CameraLag=0.0f
	bCollideWorld=false

	PodSkelCtrlPitchRange=(X=-5461,Y=5461)
}
