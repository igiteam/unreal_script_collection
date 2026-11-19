/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Vehicle_Ratbike_Base extends GearVehicle
	native(Vehicle)
	config(Pawn)
	abstract;

// DAMAGE

/** config version of health for ride reaver. */
var()	config int				DefaultBikeHealth;
/** How quickly ridereaver heals per second. */
var()	config float			HealthRechargeRate;
/** Used to keep track of partial heal points between ticks. */
var		float					PartialHealth;

/** FOV to use when targetting on the reaver. */
var()	float					TargetingFOV;

var		AnimTree				DriverAnimTree;
var		array<AnimSet>			DriverAnimSets;

var		AnimTree				GunnerAnimTree;
var		array<AnimSet>			GunnerAnimSets;

var	protected const SoundCue			RocketFireSound;
var	protected const SoundCue			RocketFireSound_Player;

struct native BikeWheel
{
	var name BoneName;
	var name SkelControlName;
	var float WheelDisplacement; //target wheel displacement updated every frame
	var float WheelRoll; //current rotational roll of the wheel
	var float RollVel;   //wheel velocity driving the wheel roll
	var SkelControlWheel WheelControl;
	var float Radius;
	var bool bHasContact;
	var bool bHadContact;
	var vector WheelVelocity; //current wheel velocity (along axis)
	var matrix WheelRefPosTM;
};

/** Array of bike wheels used by the bike visuals */
var(BikeVisuals) array<BikeWheel> BikeWheels;

var(MuzzleEffects)	editconst PointLightComponent	RocketMuzzleLight;
var(MuzzleEffects)	float							RocketMuzzleLightTime;

var(MuzzleEffects)	ParticleSystem					RocketMuzzleEffect;
var					ParticleSystemComponent			PSC_RocketMuzzleEffect;

/** Last position passed to AdjustInterpTrackMove... used for worst camera location */
var		transient vector		LastOrigInterpLocation;
/** Last perpendicular vector to the spline... used for collision resolution */
var     transient vector		LastSplineRight;

/** Name of the skel control for bike Z */
var name BikeZSkelControlName;
/** Skel control for the raising and lowering of the bike in Z */
var(BikeVisuals) editinline transient SkelControlSingleBone BikeZSkelControl;
/** Interpolation speed for the skel control Z */
var(BikeVisuals) config float BikeZInterpSpeed;

/** Current running bike normals */
var	transient vector BikeNormalHistory[10];
/** Slot in history to insert next entry */
var	transient int NextBikeHistorySlot;

var		AnimNodeBlend		GunnerSeatBlendNode;
var		GearAnim_Slot		GunnerFullBodySlotNode;

var repnotify vector TurretFlashLocation;

/** If TRUE, gunner starts using the minigun */
var()	bool				bStartOnMinigun;

var		bool				bPendingMoveDriver;

var		transient bool		bHasAlreadySeated;


/** Sound to play when reaver dies */
var		SoundCue		BikeExplodeSound;
/** Particle effect for when reaver dies through shooting. */
var		ParticleSystem	BikeExplodeEffect;

///////////////////////////////////////////////////////////////////////////
// POST PROCESS EFFECT
/** MI that is used by the post process, that is modified as Reaver rider looks around */
var(PostProcess)		MaterialInstance	OverlayMI;
/** Ratbike additional post process chain */
var(PostProcess)		PostProcessChain	OverlayEffect;


/** Amount to increase 'spreead' in effect as we boost */
var(PostProcess)		float				OverlaySpreadFactor;
/** Amount to blend in effect as we boost */
var(PostProcess)		float				OverlayEffectFactor;


/** Sound used when flying around */
var	protected transient AudioComponent	BikeEngineSoundLoopAC;
var protected const SoundCue			BikeEngineLoop;
var protected const SoundCue			BikeEngineLoop_Player;
/** True to signal a change in driving status such that the audio may need to be changed. */
var protected transient bool			bRestartBikeEngineLoop;

/** Sound used when adding throttle */
var protected const SoundCue            ThrottleRevSound;

/** Sound used when adding throttle for local player*/
var protected const SoundCue            ThrottleRevSound_Player;

/** Name of the skel control for the handlebar steering */
var name HandlebarSkelControlName;
/** Cached reference to the skel control */
var transient SkelControlHandlebars HandlebarControl;

/** Time offset on the matinee track */
var transient float TimeOffset;
/** Rate of time to move forward and back along the track given throttle */
var(BikeConstraints) config float TimeRate;
/** Distance +/- along the track the bike can go */
var(BikeConstraints) config float MaxTimeOffset;

/** Whether or not to display the matinee track */
var(BikeConstraints) bool bDebugDisplayMatineeTrack;
/** Distance offset from the matinee track */
var transient float DistOffset;
/** Rate to move perpendicular along the track given steering */
var(BikeConstraints) config float DistRate;
/** Distance +/- from the track the bike can go */
var(BikeConstraints) config float MaxDistOffset;

/** Amount of influence the steering has on the rotation of the bike */
var(BikeVisuals) config float SteeringRotationPct;

/** Rate of turn of the visual steering */
var(BikeVisuals) config float MaxSteerAnglePerSec;
/** Max steering angle */
var(BikeVisuals) config float MaxSteerAngle;

/** Amount of vertical movement absorbed by shocks */
var(BikeVisuals) config float WheelAbsorbPct;
/** Speed at which the shocks move */
var(BikeVisuals) config float WheelDisplacementInterpSpeed;

/** Friction applied to spinning wheels no longer in contact with ground */
var(BikeVisuals) config float FreeSpinningWheelFrictionDecel;

/** bones where the turret controller places their hands **/
var name LeftHandBoneHandleName;
var name RightHandBoneHandleName;

/** Custom anim node **/
var GearAnim_Slot CustomAnimNode;

/** To play custom Throttle/Clutch shift animation**/
var transient float PreviousThrottle;
var transient float PreviousSpeed;
var transient vector PreviousLocation;
/** custom gear shift speed interval - every 500? or every 1000 **/
var float GearShiftInterval;
/** Driver AimOffset change scale
 *  - not gunner
 *  - lean/forward upperbody movement
 **/
var float DriverYawOffsetScale;
var float DriverPitchOffsetScale;

replication
{
	if (bNetDirty)
		TurretFlashLocation;
}

cpptext
{
	virtual FVector CheckForLedges(FVector AccelDir, FVector Delta, FVector GravDir, int &bCheckedFall, int &bMustJump ) { return Delta; }
	virtual void ApplyWeaponRotation(FLOAT DeltaSeconds, INT SeatIndex, FRotator NewRotation);

	// Actor interface.
	virtual void TickSpecial(FLOAT DeltaSeconds);
	virtual void TickAuthoritative( FLOAT DeltaSeconds );
	virtual void SetBase(AActor *NewBase, FVector NewFloor = FVector(0,0,1), INT bNotifyActor=1, USkeletalMeshComponent* SkelComp=NULL, FName BoneName=NAME_None );
	virtual void physRigidBody(FLOAT DeltaTime);
	virtual void physWalking(FLOAT deltaTime, INT Iterations);
	void processHitWall(FCheckResult const& WallHit, FLOAT TimeSlice);
	virtual void setPhysics(BYTE NewPhysics, AActor *NewFloor, FVector NewFloorV);
	virtual void CalcVelocity(FVector &AccelDir, FLOAT DeltaTime, FLOAT MaxSpeed, FLOAT Friction, INT bFluid, INT bBrake, INT bBuoyant);

	virtual void AdjustInterpTrackMove(FVector& Pos, FRotator& Rot, FLOAT DeltaTime, UBOOL bIgnoreRotation = FALSE);

	//Override SVehicle setup of wheels
	virtual void ModifyNxActorDesc(NxActorDesc& ActorDesc,UPrimitiveComponent* PrimComp, const class NxGroupsMask& GroupsMask, UINT MatIndex) {}

    //Update the visual wheels, returns an average normal from the wheel line traces
	void UpdateWheels(const FVector& BikePosition, FLOAT ForwardSpeed, FLOAT DeltaTime, FVector& AvgNormal);
	//Update the visual steering, returns current wheel orientation
	FLOAT UpdateSteering(FVector& ForwardDir, FLOAT ForwardSpeed, FLOAT DeltaTime);
}

/** Cache ref pose to determine "neutral" wheel position */
simulated native final function CacheWheelRefPoseTMs();

/** Attach components etc - (client + server) */
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Role == ROLE_Authority)
	{
		Health = DefaultBikeHealth;
	}

	CacheWheelRefPoseTMs();

	// Create PSC for rocket muzzle effect
	PSC_RocketMuzzleEffect = new(self) class'ParticleSystemComponent';
	Mesh.AttachComponentToSocket( PSC_RocketMuzzleEffect, Seats[0].GunSocket[0] );
	PSC_RocketMuzzleEffect.SetTemplate( RocketMuzzleEffect );

	BikeEngineSoundLoopAC = VehiclePlayLocalSound(BikeEngineLoop, BikeEngineLoop_Player, BikeEngineSoundLoopAC, 0.5f);
}

/** Cache pointers to anim nodes - (client + server) */
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local int WheelIdx;

	Super.PostInitAnimTree(SkelComp);
	//local int TentacleIdx;

	if (SkelComp == Mesh)
	{
		//Find the bike z skel control
		BikeZSkelControl = SkelControlSingleBone(Mesh.FindSkelControl(BikeZSkelControlName));

		//Find the wheel skel controls
		for (WheelIdx=0; WheelIdx<BikeWheels.length; ++WheelIdx)
		{
			BikeWheels[WheelIdx].WheelControl = SkelControlWheel(Mesh.FindSkelControl(BikeWheels[WheelIdx].SkelControlName));
		}

		// cache custom animation node
		CustomAnimNode = GearAnim_Slot(Mesh.FindAnimNode('Custom_FullBody'));
	}
}

/** (client + server) */
simulated function int GetVehicleDefaultHealth()
{
	return DefaultBikeHealth;
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
	Super.OnToggleHidden(Action);

	// Also hide any driver/gunner
	if(Driver != None)
	{
		Driver.OnToggleHidden(Action);
	}

	if(Seats[1].SeatPawn != None)
	{
		Seats[1].SeatPawn.OnToggleHidden(Action);
	}
}

/** (client + server) */
simulated event Tick(float DeltaTime)
{
	local GearPC GPC;
	local int HealAmount;
	local bool bIsPassengerController;
	local Rotator ViewRot;
	local int PrevClutch, CurClutch;

	Super.Tick(DeltaTime);

	// If desired, swap to sidecar
	if(bPendingMoveDriver)
	{
		SwitchToSidecar(FALSE);
		bPendingMoveDriver = FALSE;
	}

	// Try and find a controller to look at its input
	if(Controller != None)
	{
		GPC = GearPC(Controller);
		bIsPassengerController = FALSE;
	}
	else if(Seats[1].SeatPawn != None)
	{
		GPC = GearPC(Seats[1].SeatPawn.Controller);
		bIsPassengerController = TRUE;
	}

	// Got a controller, pass input to server
	if(GPC != None)
	{
		// Force gunner to point forwards when first seated
		if(bIsPassengerController)
		{
			bHasAlreadySeated = TRUE;
		}
		else if(!bHasAlreadySeated && !bIsPassengerController)
		{
			ViewRot = GetVehicleSpaceCamRotation(0.0, FALSE);
			ViewRot.Roll = 0;
			GPC.SetRotation(ViewRot);
			bHasAlreadySeated = TRUE;
		}

		UpdateOverlayEffects( GPC );
	}

	// Handle healing
	if(Role == ROLE_Authority)
	{
		// If hurt, heal
		if(Health < DefaultBikeHealth)
		{
			// We need to save off partially healed points
			PartialHealth += DeltaTime * HealthRechargeRate;
			if ( PartialHealth >= 1.f )
			{
				HealAmount = FFloor(PartialHealth);
				PartialHealth -= HealAmount;
				Health += HealAmount;
			}
		}
		// Not healing, reset heal counter
		else
		{
			PartialHealth = 0.0;
		}
	}

	if (bRestartBikeEngineLoop)
	{
		BikeEngineSoundLoopAC.FadeOut(0.2f, 0.f);
		BikeEngineSoundLoopAC = VehiclePlayLocalSound(BikeEngineLoop, BikeEngineLoop_Player,, 0.2f);
		bRestartBikeEngineLoop = FALSE;
	}

	// if Throttle turns to +
	if ( Throttle > 0.f && PreviousThrottle <= 0.f)
	{
		VehiclePlayLocalSound(ThrottleRevSound, ThrottleRevSound_Player);
		PlayThrottleAnimation();
	}

	// I don't know if this makes sense, every GearShiftInterval, he will switch gear
	CurClutch = VSize(Velocity)/GearShiftInterval;
	PrevClutch = PreviousSpeed/GearShiftInterval;

	// they're not in the same category
	if (CurClutch != PrevClutch)
	{
		PlayClutchShiftAnimation();
	}

	PreviousThrottle = Throttle;
	PreviousSpeed = VSize(Velocity);
	PreviousLocation = Location;
}

event bool DriverLeave(bool bForceLeave)
{
	local bool	 bLeft;
	local GearPC GPC;

	GPC = GearPC(Controller);
	bLeft = Super.DriverLeave( bForceLeave );
	if( bLeft && GPC != None )
	{
		ClientSetCameraEffect( GPC, FALSE );
	}
	return bLeft;
}

/** Update the overlay parameters for a local GearPC */
simulated function UpdateOverlayEffects( GearPC PC )
{
	local Vector  FwdDir, CamLoc;
	local Rotator CamRot;
	local float	  DotP;

	// Only do this for local players
	if( PC == None || OverlayMI == None || LocalPlayer(PC.Player) == None)
		return;

	FwdDir = Vector(Rotation);
	PC.GetPlayerViewPoint( CamLoc, CamRot );

	DotP = Abs(FwdDir DOT Vector(CamRot));
	OverlayMI.SetScalarParameterValue( 'UseEffect',		DotP * OverlayEffectFactor );
	OverlayMI.SetScalarParameterValue( 'OverallSpread', DotP * OverlaySpreadFactor );
}

/** turns on or off the camera effect */
simulated function SetCameraEffect(Controller C, bool bEnabled)
{
	local GearPC PC;
	local LocalPlayer LP;
	local MaterialEffect NewEffect;
	local int i;
	local MaterialInstanceConstant CurrentMI;

	PC = GearPC(C);
	if (PC != None)
	{
		LP = LocalPlayer(PC.Player);
		if (LP != None)
		{
			if (bEnabled && !PC.bHasVehicleOverlay)
			{
				LP.InsertPostProcessingChain(OverlayEffect, INDEX_NONE, true);

				NewEffect = MaterialEffect(LP.PlayerPostProcess.FindPostProcessEffect('MotionEffect'));
				if(NewEffect != None)
				{
					// Create instance for this reaver if necessary
					if(OverlayMI == None)
					{
						CurrentMI = MaterialInstanceConstant(NewEffect.Material);
						OverlayMI = new(None) class'MaterialInstanceConstant';
						OverlayMI.SetParent(CurrentMI);
					}

					NewEffect.Material = OverlayMI;
				}

				PC.bHasVehicleOverlay = TRUE;
			}
			else if (!bEnabled && PC.bHasVehicleOverlay)
			{
				for (i = 0; i < LP.PlayerPostProcessChains.length; i++)
				{
					if (LP.PlayerPostProcessChains[i].FindPostProcessEffect('MotionEffect') != None)
					{
						LP.RemovePostProcessingChain(i);
						i--;
					}
				}

				PC.bHasVehicleOverlay = FALSE;
			}
		}
	}
}

/** turns on or off the camera effect */
reliable client function ClientSetCameraEffect(Controller C, bool bEnabled)
{
	SetCameraEffect(C, bEnabled);
}


simulated function BlowupVehicle(Controller Killer)
{
	Super.BlowupVehicle(Killer);
}

simulated function SitDriver( GearPawn WP, int SeatIndex)
{
	Super.SitDriver(WP, SeatIndex);

	//SetCameraEffect(WP.Controller, TRUE);

	WP.HolsterWeapon();
	WP.bCanDBNO = FALSE;

//	WP.Mesh.SetTranslation(vect(0,0,0));

	// set animation tree depending on seat index
	if ( SeatIndex == 0 )
	{
		WP.Mesh.SetAnimTreeTemplate(DriverAnimTree);
		WP.AddAnimSetsToKismetArray( DriverAnimSets );
	}
	else
	{
		WP.Mesh.SetAnimTreeTemplate(GunnerAnimTree);
		WP.AddAnimSetsToKismetArray( GunnerAnimSets );
	}

	// cache anim nodes and update anismet list
	WP.ClearAnimNodes();
	WP.CacheAnimNodes();
	WP.UpdateAnimSetList();

	if(bStartOnMinigun)
	{
		`log("START ON MINIGUN");
		bPendingMoveDriver = TRUE;
		bStartOnMinigun = FALSE;
	}
}

/** (client + server) */
simulated event float GetCameraFOV(int SeatIndex)
{
	local Controller UseC;

	// Find controller to look at for targetting
	if(SeatIndex == 0)
	{
		UseC = Controller;
	}
	else
	{
		UseC = Seats[SeatIndex].SeatPawn.Controller;
	}

	if(UseC != None && GearPC(UseC).bIsTargeting)
	{
		return TargetingFOV;
	}
	else
	{
		return DefaultFOV;
	}
}

simulated function vector GetCameraWorstCaseLoc( int SeatIndex )
{
	local Vector CamLoc;

	Mesh.GetSocketWorldLocationAndRotation('Camera', CamLoc);
	CamLoc += (Seats[SeatIndex].WorstCameraLocOffset >> Rotation);

	return CamLoc;
}

/** Move driver to seat 1 */
reliable server function SwitchToSidecar(bool bMatchYaw)
{
	local GearPC PC;
	local Rotator ViewRot;

	PC = GearPC(Controller);

	if(!bMatchYaw)
	{
		ViewRot = GetVehicleSpaceCamRotation(0.0, TRUE);
		ViewRot.Roll = 0;
		//PC.SetRotation(ViewRot);
		PC.ClientSetJustControllerRotation(ViewRot);
	}

	ChangeSeat(Controller, 1);
}

/** Move passenger C to seat 0 */
reliable server function SwitchToBikeSeat(Controller C, bool bMatchYaw)
{
	local GearPC PC;
	local Rotator ViewRot;

	PC = GearPC(C);

	if(!bMatchYaw)
	{
		ViewRot = GetVehicleSpaceCamRotation(0.0, FALSE);
		ViewRot.Roll = 0;
		//PC.SetRotation(ViewRot);
		PC.ClientSetJustControllerRotation(ViewRot);
	}

	ChangeSeat(C, 0);
}

simulated function bool ShouldShowWeaponOnHUD(GearPC PC)
{
	local GearWeaponPawn WP;

	WP = GearWeaponPawn(PC.Pawn);
	return (WP != None && WP.MyVehicle == self);
}

/** Called when a client presses X while in the vehicle. (server only) */
reliable server function ServerPressedX()
{
	SwitchToSidecar(FALSE);
}

/** Called when a passenger presses X */
simulated function PassengerPressedX(Controller C)
{
	SwitchToBikeSeat(C, FALSE);
}

function PassengerBecomeDriver(Controller C)
{
	SwitchToBikeSeat(C, TRUE);
}

/** Used so we can override damage using our own table */
simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	//local int DamageDone, i;
	//local bool bFoundDmg;
	//local GearPC GPC;

	// make sure we are the server and we're alive
	if (Role < ROLE_Authority || Health <= 0 || InGodMode() || Seats[1].SeatPawn.InGodMode() )
	{
		return;
	}

	// Ignore yourself doing damage
	if((EventInstigator != None) && (EventInstigator == Controller || EventInstigator == Seats[1].SeatPawn.Controller))
	{
		return;
	}

	/*
	// Look through damage mapping
	for(i=0; i<DamageInfos.length; i++)
	{
		if(DamageType.Name == DamageInfos[i].DmgType)
		{
			DamageDone = DamageInfos[i].DamageDone;
			bFoundDmg = TRUE;
			break;
		}
	}

	// If we found it, apply damage now
	if(bFoundDmg)
	{
		Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
		if (DamageDone > 0)
		{
			for (i = 0; i < Seats.Length; i++)
			{
				if (Seats[i].SeatPawn != None)
				{
					GPC = GearPC(Seats[i].SeatPawn.Controller);
					if (GPC != None && (EventInstigator == None || EventInstigator.GetTeamNum() != GPC.GetTeamNum()))
					{
						GPC.ClientAddHitLocator(EventInstigator.Pawn,DamageDone,HitLocation);
					}
				}
			}
		}
		//`log("TAKEDAM:"@Health@DamageDone@DamageType@EventInstigator@DamageCauser);
	}
	else
	{
		`log("RIDEREAVER: Unhandled DmgType"@DamageType.Name@Damage);
		foreach WorldInfo.AllControllers(class'GearPC', GPC)
		{
			GPC.ClientMessage("RIDEREAVER: Unhandled DmgType"@DamageType.Name@Damage);
		}
	}
	*/
}

simulated function VehicleWeaponFireEffects(vector HitLocation, int SeatIndex)
{
	Super.VehicleWeaponFireEffects(HitLocation, SeatIndex);

	//Both seats fire same cannon
	if(SeatIndex == 0 || SeatIndex == 1)
	{
		VehiclePlayLocalSound(RocketFireSound, RocketFireSound_Player);

		PSC_RocketMuzzleEffect.ActivateSystem(FALSE);

		TriggerVehicleMuzzleLight(RocketMuzzleLight, Seats[1].GunSocket[0], RocketMuzzleLightTime);
	}

	PlayFireAnimation();
}

// play fire animation of gunner and vehicle
simulated function PlayFireAnimation()
{
	local GearPawn_Infantry GP;
	local GearPawn.BodyStance FireAnims;

	if ( CustomAnimNode!=none )
	{
		CustomAnimNode.PlayCustomAnim('Ratbike_cannon_fire', 1.f, 0.25f, 0.25f, false, true);
		GP = GearPawn_Infantry(Seats[1].SeatPawn.Driver);
		// if storagepawn exists
		if ( GP!=none )
		{
			FireAnims.Stance.Length = 1; // Array of struct needs to be pre-sized.
			FireAnims.Stance[0].Slot = BS_FullBody;
			FireAnims.Stance[0].AnimName = 'Ratbike_gunner_fire';
			GP.BS_Play(FireAnims, 1.f);
		}
	}
}

// play throttle animation
simulated function PlayThrottleAnimation()
{
	local GearPawn_Infantry GP;
	local GearPawn.BodyStance Anim;

	GP = GearPawn_Infantry(Seats[0].SeatPawn.Driver);
	// if storagepawn exists
	if ( GP!=none )
	{
		Anim.Stance.Length = 1; // Array of struct needs to be pre-sized.
		Anim.Stance[0].Slot = BS_FullBody;
		Anim.Stance[0].AnimName = 'ADD_Ratbike_throttle_rev';
		GP.BS_Play(Anim, 1.f, 0.25f, 0.25f, false, false);
	}
}

// play gear shift animation
simulated function PlayClutchShiftAnimation()
{
	local GearPawn_Infantry GP;
	local GearPawn.BodyStance Anim;

	GP = GearPawn_Infantry(Seats[0].SeatPawn.Driver);
	// if storagepawn exists
	if ( GP!=none )
	{
		// clear timer
		ClearTimer('PlayThrottleAnimation');
		Anim.Stance.Length = 1; // Array of struct needs to be pre-sized.
		Anim.Stance[0].Slot = BS_FullBody;
		Anim.Stance[0].AnimName = 'ADD_Ratbike_clutch_shift';
		GP.BS_Play(Anim, 1.f, 0.25f, 0.25f, false, false);
		// Ideally after clutch shift, I'm playing throttle. I could have used anim notifier, but
		// it's extra work(from pawn->vehicle) that doesn't have to be that much accurate
		// This just plays throttle animation after 1 second elapsed
		SetTimer(0.8f, false, 'PlayThrottleAnimation');
	}
}

simulated function DrivingStatusChanged()
{
	bRestartBikeEngineLoop = TRUE;
	super.DrivingStatusChanged();
}

/**
* Called when a passenger enters the vehicle
*
* @param P				The Pawn entering the vehicle
* @param SeatIndex		The seat where he is to sit
*/

function bool PassengerEnter(Pawn P, int SeatIndex)
{
	local GearPawn WP;

	if ( Super.PassengerEnter( P, SeatIndex ) )
	{
		// need to place the passenger to be in the right location
		WP = GearPawn(P);

		WP.SetBase(self,, Mesh, 'Gunner');
		WP.SetCollision( false, false);
		WP.bCollideWorld = false;
		WP.SetBase(self,, Mesh, 'Gunner');
		WP.SetLocation( Location );
		WP.SetRotation( Rotation );
		WP.SetPhysics( PHYS_None );
		WP.Mesh.SetBlockRigidBody(FALSE);
		WP.Mesh.SetHasPhysicsAssetInstance(FALSE);

		// now call sitdriver to set new trees and stuff
		SitDriver(WP, 1);

		return true;
	}

	return false;
}

defaultproperties
{
	// so the matinees can link to the reaver correctly - could be done differently if bNoDelete causes pain
	bNoDelete=true

	// matinee controlled, so shouldn't need any of this stuff
	bReplicateMovement=false
	bUpdateSimulatedPosition=false

// 	Begin Object Class=AudioComponent Name=FaceAudioComponent
// 	End Object
// 	FacialAudioComp=FaceAudioComponent
// 	Components.Add(FaceAudioComponent)

	bVehicleSpaceViewLimits=TRUE
	bVehicleSpaceCamera=FALSE
	bOnlyInheritVehicleSpaceYaw=TRUE
	bShowWeaponOnHUD=FALSE

	TargetingFOV=30.0
	MaxStepHeight=20.0

	bCollideActors=true
	bBlockActors=true
	bCollideWorld=true

	BikeZSkelControlName=BikeZ

	LeftHandBoneHandleName=L_Handle
	RightHandBoneHandleName=R_Handle

	GearShiftInterval = 800

	DriverYawOffsetScale = 8.f;
	DriverPitchOffsetScale = 16.f;
}
