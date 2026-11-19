/**
 * Copyright 1998-2010 Epic Games, Inc. All Rights Reserved.
 */
class TMVehicle_TankBase extends TMVehicle
    native(Vehicle)
	abstract;

/** animation for the Scorpion's extendable blades */
//var TMAnimBlendByWeapon BladeBlend;

var MaterialInstanceConstant 		LeftTrackMat;
var MaterialInstanceConstant 		RightTrackMat;
var float 					LeftTrack_TravelledDist;
var float 					RightTrack_TravelledDist;

var const ParticleSystem		WheelDust;
var ParticleSystemComponent     R_WheelDust;
var ParticleSystemComponent     L_WheelDust;
var name R_Wheel_DustSocketName;
var name L_Wheel_DustSocketName;

var ParticleSystem	TankFireWavePSCTemplate;
var TMParticleSystemComponent	TankFireWavePSC;
var ParticleSystem	MuzzleFlashPSCTemplate;
var TMParticleSystemComponent	MuzzleFlashPSC;
var name MuzzleFlashSocket;
var name TankFireWaveSocket;
var vector ExitLocXOffset;
var vector ExitLocYOffset;
/** Internal variable.  Maintains brake light state to avoid extraMatInst calls.	*/
var bool bBrakeLightOn;

/** Internal variable.  Maintains reverse light state to avoid extra MatInst calls.	*/
var bool bReverseLightOn;

/** Internal variable.  Maintains headlight state to avoid extra MatInst calls.	*/
var bool bHeadlightsOn;

/** whether or not the blades are currently extended */
//var repnotify bool bBladesExtended;

/** whether or not the blade on each side has been broken off */
//var repnotify bool bLeftBladeBroken, bRightBladeBroken;

/** how far along blades a hit against world geometry will break them */
//var float BladeBreakPoint;

/** material parameter that should be modified to turn the brake lights on and off */
var name BrakeLightParameterName;

/** material parameter that should be modified to turn the reverse lights on and off */
var name ReverseLightParameterName;

/** material parameter that should be modified to turn the headlights on and off */
var name HeadLightParameterName;

/** socket names for the start and end of the blade traces
	if the corresponding blade is not broken anything that gets in between the start and end bone triggers a BladeHit() event */
//var name RightBladeStartSocket, RightBladeEndSocket, LeftBladeStartSocket, LeftBladeEndSocket;

/** damage type for blade kills */
//var class<DamageType> BladeDamageType;

/** blade sounds */
//var SoundCue BladeBreakSound, BladeExtendSound, BladeRetractSound;

/** rocket booster properties */
//var float BoosterForceMagnitude;

//var repnotify bool	bBoostersActivated;
/** If true, steering is very limited (enabled while boosting) */
//var		bool	bSteeringLimited;
var Controller SelfDestructInstigator;

/** Radius to auto-check for targets when in self-destruct mode */
//var float BoosterCheckRadius;

/** How long you can boost */
//var float MaxBoostDuration;
/** used to track boost duration */
//var float BoostStartTime;
/** How long it takes to recharge between boosts */
//var float BoostChargeDuration;
/** used to track boost recharging duration */
//var float BoostChargeTime;
//var AudioComponent BoosterSound;

/** Coordinates for the boost tooltip textures */
//var UIRoot.TextureCoordinates BoostToolTipIconCoords;

/** Coordinates for the eject tooltip textures */
//var UIRoot.TextureCoordinates EjectToolTipIconCoords;

//var class<TMDamageType> SelfDestructDamageType;
//var float BoostPowerSpeed;
//var float BoostReleaseTime;
//var float BoostReleaseDelay;
//var SoundCue SelfDestructSoundCue;
//var SoundCue SelfDestructReadyCue;
//var SoundCue SelfDestructWarningSound;
//var SoundCue SelfDestructEnabledSound;
//var SoundCue SelfDestructEnabledLoop;

//var CameraAnim RedBoostCamAnim;
//var CameraAnim BlueBoostCamAnim;

/** Sound played whenever Suspension moves suddenly */
//var SoundCue SuspensionShiftSound;
//var AudioComponent SelfDestructEnabledComponent;
//var AudioComponent SelfDestructWarningComponent;
//var AudioComponent SelfDestructReadyComponent;
var SoundCue EjectSoundCue;

/** desired camera FOV while using booster */
//var float BoosterFOVAngle;

/** animation for the boosters */
//var TMAnimBlendByWeapon BoosterBlend;

/** set when boosters activated by Kismet script, so keep them active regardless of input */
//var bool bScriptedBoosters;

/** replicated flag indicating when self destruct is activated */
//var repnotify bool bSelfDestructArmed;

/** double tap forward to start rocket boosters */
//var bool bTryToBoost;
//var bool bWasThrottle;
//var float ThrottleStartTime;

//var() float	BoostUprightTorqueFactor;
//var() float	BoostUprightMaxTorque;

var float	DefaultUprightTorqueFactor;
var float	DefaultUprightMaxTorque;

/** dynamic light */
//var	PointLightComponent LeftBoosterLight, RightBoosterLight;

//var RB_ConstraintActor BladeVictimConstraint[2];

//var StaticMesh ScorpionHood;

/** Rocket speed is the (clamped) max speed while boosting */
//var float RocketSpeed;

/** Square of minimum speed needed to engage self destruct */
//var float SelfDestructSpeedSquared;

/** How long the springs should be when the wheels need to be locked to the ground */
var() float LockSuspensionTravel;

/** How stiff the suspension should be when the wheels need to be locked to the ground */
var() float LockSuspensionStiffness;

/** How much the steering should be restricted while boosting */
//var() float BoostSteerFactors[3];

/** swap BigExplosionTemplate for this when self-destructing */
//var ParticleSystem SelfDestructExplosionTemplate;
//var class<TMGib> HatchGibClass;

/** The mesh to spawn when the blades are broken off **/
//var StaticMesh BrokenBladeMesh;

/** Last time bot tried to do blade boost */
//var float LastBladeBoostTime;

//var bool bAISelfDestruct;

//replication
//{
//	if (bNetDirty)
//		bBladesExtended, bLeftBladeBroken, bRightBladeBroken, bSelfDestructArmed;
//	if (bNetDirty)
//		bBoostersActivated;
//}

/**
  * Returns true if self destruct conditions (boosting, going fast enough) are met
  */
//function bool ReadyToSelfDestruct()
//{
//	return (bBoostersActivated && (VSizeSq(Velocity) > SelfDestructSpeedSquared));
//}

// match wheels with WheelsIndex, just do the displacement
struct native TankTrackWheel
{
  var int    WheelsIndex;
  var name   SkelControlName;
  var SkelControlWheel	WheelControl;
};

var array<TankTrackWheel>             TrackWheels;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function TankFire()
{
  MuzzleFlashPSC.ActivateSystem();
  TankFireWavePSC.ActivateSystem();
}

function Tick( float DeltaSeconds )
{
//	local TeamInfo InstigatorTeam;
//	local float BoostRemaining;
//	local vector BoostDir, Start, End, HitLocation, HitNormal;
//	local Actor HitActor;
	local bool bSetBrakeLightOn, bSetReverseLightOn;

	// ready sound above everything else so that it can be stopped if dead
//	if ( SelfDestructReadyComponent != None )
//	{
//		// stop self destruct ready sound if no longer ready
//		if( !bDriving || (SelfDestructInstigator != None) || !IsLocallyControlled() || !ReadyToSelfDestruct() )
//		{
//			SelfDestructReadyComponent.Stop();
//			SelfDestructReadyComponent = None;
//		}
//	}
//	else if( bDriving && !bDeadVehicle && IsLocallyControlled() && ReadyToSelfDestruct() )
//	{
//		// play sound when ready to self destruct
//		SelfDestructReadyComponent = CreateAudioComponent(SelfDestructReadyCue,TRUE,TRUE,FALSE);
//	}

	if ( bDeadVehicle )
		return;

	if( bRecoverHealth && (WorldInfo.TimeSeconds - LastDamageTime) > 2.f && Health > 0.f)
	{
		if(Health < MaxHealth)
		{
		    if(RecoverRate * DeltaSeconds < 1.f)
                Health += 1;
    	    else
      			Health += RecoverRate * DeltaSeconds;
		}
		else
			Health = MaxHealth;
	}

//	if ( SelfDestructInstigator != None )
//	{
//		if ( (WorldInfo.TimeSeconds - BoostStartTime > MaxBoostDuration) )
//		{
//			// blow up
//			SelfDestruct(None);
//			return;
//		}
//
//		InstigatorTeam = (SelfDestructInstigator.PlayerReplicationInfo != None) ? SelfDestructInstigator.PlayerReplicationInfo.Team : None;
//		if ( CheckAutoDestruct(InstigatorTeam, BoosterCheckRadius) )
//		{
//			return;
//		}
//	}
//	else
//	{
//		if ( bTryToBoost )
//		{
//			// turbo mode
//			if ( !bBoostersActivated )
//			{
//				if ( WorldInfo.TimeSeconds - BoostChargeTime > BoostChargeDuration ) // Starting boost
//				{
//					ActivateRocketBoosters();
//					bBoostersActivated = TRUE;
//					BoostStartTime = WorldInfo.TimeSeconds;
//				}
//			}
//		}
//
//		bTryToBoost = false;
//
//		if ( (Role == ROLE_Authority) || IsLocallyControlled() )
//		{
//			if ( bBoostersActivated )
//			{
//				if ( WorldInfo.TimeSeconds - BoostStartTime > MaxBoostDuration ) // Ran out of Boost
//				{
//					DeactivateRocketBoosters();
//					bBoostersActivated = FALSE;
//					BoostChargeTime = WorldInfo.TimeSeconds;
//				}
//				else if ( (Throttle <= 0) && (WorldInfo.TimeSeconds - BoostReleaseTime > BoostReleaseDelay) ) // Stopped in middle of boost
//				{
//					DeactivateRocketBoosters();
//					bBoostersActivated = FALSE;
//					BoostRemaining = MaxBoostDuration - WorldInfo.TimeSeconds + BoostStartTime;
//					BoostChargeTime = WorldInfo.TimeSeconds - FMin(BoostChargeDuration - 2.0, BoostRemaining * BoostChargeDuration/MaxBoostDuration);
//				}
//				else
//				{
//					BoostReleaseTime = WorldInfo.TimeSeconds;
//				}
//			}
//			else if ( bSteeringLimited && (VSizeSq(Velocity) < Square(AirSpeed)) )
//			{
//				EnableFullSteering();
//			}
//		}
//	}

//	if ( bBoostersActivated )
//	{
//		BoostDir = vector(Rotation);
//		if ( VSizeSq(Velocity) < BoostPowerSpeed*BoostPowerSpeed )
//		{
//			if ( BoostDir.Z > 0.7 )
//				AddForce( (1.0 - BoostDir.Z) * BoosterForceMagnitude * BoostDir );
//			else
//				AddForce( BoosterForceMagnitude * BoostDir );
//		}
//		else
//			AddForce( 0.25 * BoosterForceMagnitude * BoostDir );
//	}

//	if (bBladesExtended)
//	{
//		if (!bRightBladeBroken)
//		{
//			// trace across right blade
//			Mesh.GetSocketWorldLocationAndRotation(RightBladeStartSocket, Start);
//			Mesh.GetSocketWorldLocationAndRotation(RightBladeEndSocket, End);
//			HitActor = Trace(HitLocation, HitNormal, End, Start, true);
//			if ( (Pawn(HitActor) != None) || (VSize(HitLocation - Start) < BladeBreakPoint*VSize(End - Start)) )
//			{
//				BladeHit(HitActor, HitLocation, false);
//			}
//		}
//		if (!bLeftBladeBroken)
//		{
//			// trace across the left blade
//			Mesh.GetSocketWorldLocationAndRotation(LeftBladeStartSocket, Start);
//			Mesh.GetSocketWorldLocationAndRotation(LeftBladeEndSocket, End);
//			HitActor = Trace(HitLocation, HitNormal, End, Start, true);
//			if ( (Pawn(HitActor) != None) || (VSize(HitLocation - Start) < BladeBreakPoint*VSize(End - Start)) )
//			{
//				BladeHit(HitActor, HitLocation, true);
//			}
//		}
//	}

	// client side effects follow - return if server or not rendered
	if (LastRenderTime < WorldInfo.TimeSeconds - 0.2)
		return;

	// Update brake light and reverse light
	// Both lights default to off.

	// check if scorpion is braking
	if( ( (OutputBrake > 0.0) || bOutputHandbrake) && (VSizeSq(Velocity) > 4.0) )
	{
		bSetBrakeLightOn = true;
		if ( !bBrakeLightOn )
		{
			// turn on brake light
			bBrakeLightOn = TRUE;
			if(DamageMaterialInstance[0] != None)
			{
				DamageMaterialInstance[0].SetScalarParameterValue(BrakeLightParameterName, 60.0 );
			}
		}
	}

    // check if scorpion is in reverse
	if ( Throttle < 0.0 )
	{
		bSetReverseLightOn = true;
		if ( !bReverseLightOn )
		{
			// turn on reverse light
			bReverseLightOn = true;
			if(DamageMaterialInstance[0] != None)
			{
				DamageMaterialInstance[0].SetScalarParameterValue(ReverseLightParameterName, 50.0 );
			}
		}
	}

	if ( bBrakeLightOn && !bSetBrakeLightOn )
	{
		// turn off brake light
		bBrakeLightOn = false;
		if(DamageMaterialInstance[0] != None)
		{
			DamageMaterialInstance[0].SetScalarParameterValue(BrakeLightParameterName, 0.0 );
		}
	}
	if ( bReverseLightOn && !bSetReverseLightOn )
	{
		// turn off reverse light
		bReverseLightOn = false;
		if(DamageMaterialInstance[0] != None)
		{
			DamageMaterialInstance[0].SetScalarParameterValue(ReverseLightParameterName, 0.0 );
		}
	}

	// update headlights
	if ( bHeadlightsOn )
	{
		if ( PlayerReplicationInfo == None )
		{
			// turn off headlights
			bHeadlightsOn = false;
			if(DamageMaterialInstance[0] != None)
			{
				DamageMaterialInstance[0].SetScalarParameterValue(HeadLightParameterName, 0.0 );
			}
		}
	}
	else if ( PlayerReplicationInfo != None )
	{
		// turn on headlights
		bHeadlightsOn = true;
		if(DamageMaterialInstance[0] != None)
		{
			DamageMaterialInstance[0].SetScalarParameterValue(HeadLightParameterName, 100.0 );
		}
	}
}

simulated function PostBeginPlay()
{
    local int idx;
	Super.PostBeginPlay();

	if(SimObj.bAutoDrive)
	{
		SetDriving(true);
	}

	if (WorldInfo.NetMode != NM_DedicatedServer && !bDeleteMe && DamageMaterialInstance[0] != none)
	{
		// turn off headlights
		DamageMaterialInstance[0].SetScalarParameterValue('Green_Glows_Headlights', 0.f );
	}

    //cache trackwheels skelcontrol
    for (Idx=0; Idx<TrackWheels.length; ++Idx)
	{
		TrackWheels[Idx].WheelControl = SkelControlWheel(Mesh.FindSkelControl(TrackWheels[Idx].SkelControlName));
	}

    R_WheelDust = new(self) class'TMParticleSystemComponent';
   	L_WheelDust = new(self) class'TMParticleSystemComponent';
   	R_WheelDust.bAutoActivate = false;
    L_WheelDust.bAutoActivate = false;
    if(WheelDust != none)
    {
     	R_WheelDust.SetTemplate(WheelDust);
     	L_WheelDust.SetTemplate(WheelDust);
	}
	mesh.AttachComponentToSocket(R_WheelDust,R_Wheel_DustSocketName);
	mesh.AttachComponentToSocket(L_WheelDust,L_Wheel_DustSocketName);

	if ( (MuzzleFlashPSCTemplate != none))
	{
		MuzzleFlashPSC = new(Outer) class'TMParticleSystemComponent';
		MuzzleFlashPSC.bAutoActivate = false;
		//MuzzleFlashPSC.SetDepthPriorityGroup(SDPG_Foreground);
		//MuzzleFlashPSC.SetFOV(TMSkeletalMeshComponent(mesh).FOV);
		mesh.AttachComponentToSocket(MuzzleFlashPSC, MuzzleFlashSocket);
		MuzzleFlashPSC.SetTemplate(MuzzleFlashPSCTemplate);
	}
	if(TankFireWavePSCTemplate != none)
	{
		TankFireWavePSC = new(Outer) class'TMParticleSystemComponent';
		TankFireWavePSC.bAutoActivate = false;
		//TankFireWavePSC.SetFOV(TMSkeletalMeshComponent(mesh).FOV);
		mesh.AttachComponentToSocket(TankFireWavePSC, TankFireWaveSocket);
		TankFireWavePSC.SetTemplate(TankFireWavePSCTemplate);
	}
}

/**
 * RanInto() called for encroaching actors which successfully moved the other actor out of the way
 *
 * @param	Other 		The pawn that was hit
 */
//event RanInto(Actor Other)
//{
//	local float BoostRemaining;
//
//	if ( bBoostersActivated && !bAISelfDestruct && (Other == Controller.Enemy) && (TMBot(Controller) != None) )
//	{
//		DeactivateRocketBoosters();
//		bBoostersActivated = FALSE;
//		BoostRemaining = MaxBoostDuration - WorldInfo.TimeSeconds + BoostStartTime;
//		BoostChargeTime = WorldInfo.TimeSeconds - FMin(BoostChargeDuration - 2.f, BoostRemaining * BoostChargeDuration/MaxBoostDuration);
//	}
//	super.RanInto(Other);
//}

//function PancakeOther(Pawn Other)
//{
//	local float BoostRemaining;
//
//	if ( bBoostersActivated && !bAISelfDestruct && (Other == Controller.Enemy) && (TMBot(Controller) != None) )
//	{
//		DeactivateRocketBoosters();
//		bBoostersActivated = FALSE;
//		BoostRemaining = MaxBoostDuration - WorldInfo.TimeSeconds + BoostStartTime;
//		BoostChargeTime = WorldInfo.TimeSeconds - FMin(BoostChargeDuration - 2.f, BoostRemaining * BoostChargeDuration/MaxBoostDuration);
//	}
//	super.PancakeOther(Other);
//}

/**
 * Are we allowing this Pawn to be based on us?
 */
simulated function bool CanBeBaseForPawn(Pawn APawn)
{
	return bCanBeBaseForPawns && !bDriving;
}

/** DriverEnter()
Make Pawn P the new driver of this vehicle
*/
function bool DriverEnter(Pawn P)
{
	local Pawn BasedPawn;
	if ( super.DriverEnter(P) )
	{
		foreach BasedActors(class'Pawn', BasedPawn)
		{
			if(BasedPawn != Driver)
			{
				BasedPawn.JumpOffPawn();
			}
		}
		return true;
	}
	return false;
}

//simulated function SetInputs(float InForward, float InStrafe, float InUp)
//{
//	Super.SetInputs(InForward, InStrafe, InUp);
//
//	if (!bBoostersActivated && WorldInfo.TimeSeconds - BoostChargeTime > BoostChargeDuration)
//	{
//		if (bScriptedBoosters)
//		{
//			bTryToBoost = true;
//		}
//		else if (IsLocallyControlled())
//		{
//			if (Throttle > 0.0)
//			{
//				if (Rise > 0.0)
//				{
//					ServerBoost();
//					bTryToBoost = true;
//				}
//				else if (!bWasThrottle)
//				{
//					if (WorldInfo.TimeSeconds - ThrottleStartTime < class'PlayerInput'.default.DoubleClickTime)
//					{
//						ServerBoost();
//						bTryToBoost = true;
//					}
//					ThrottleStartTime = WorldInfo.TimeSeconds;
//				}
//				bWasThrottle = true;
//			}
//			else if (Throttle <= 0)
//			{
//				bWasThrottle = false;
//			}
//		}
//	}
//}

//simulated function StopVehicleSounds()
//{
//	super.StopVehicleSounds();
//	BoosterSound.Stop();
//}

//simulated event SuspensionHeavyShift(float Delta)
//{
//	if(Delta>0)
//	{
//		PlaySound(SuspensionShiftSound);
//	}
//}

/**
when called makes the wheels stick to the ground more
*/
simulated function LockWheels()
{
	local SVehicleSimCar SimCar;

//	bSteeringLimited = true;
	SimCar = SVehicleSimCar(SimObj);

	Wheels[0].SuspensionTravel = LockSuspensionTravel;
	Wheels[1].SuspensionTravel = LockSuspensionTravel;
	SimCar.WheelSuspensionStiffness= LockSuspensionStiffness;
//	SimCar.MaxSteerAngleCurve.Points[0].OutVal = BoostSteerFactors[0]; //10.0;
//	SimCar.MaxSteerAngleCurve.Points[1].OutVal = BoostSteerFactors[1]; //4.0;
//	SimCar.MaxSteerAngleCurve.Points[2].OutVal = BoostSteerFactors[2]; //1.2;

}

/**
Resets the variables that are changed in the LockWheels call
*/
simulated function UnlockWheels()
{
	local SVehicleSimCar SimCar;

//	bSteeringLimited = false;
	SimCar = SVehicleSimCar(SimObj);

	Wheels[0].SuspensionTravel = Default.Wheels[0].SuspensionTravel;
	Wheels[1].SuspensionTravel = Default.Wheels[1].SuspensionTravel;
	SimCar.WheelSuspensionStiffness = SVehicleSimCar(Default.SimObj).WheelSuspensionStiffness;
}
/** ActivateRocketBoosters()
called when player activates rocket boosters
*/
//simulated event ActivateRocketBoosters()
//{
//	local CameraAnim UseCamAnim;
//
//	bSteeringLimited = true;
//
//	AirSpeed = Default.RocketSpeed;
//
//	if ( WorldInfo.NetMode == NM_DedicatedServer )
//		return;
//
//	// Play any animations/etc here
//
//	if ( TMPlayerController(Controller) != none )
//	{
//		TMPlayerController(Controller).StartZoom(BoosterFOVAngle,60);
//
//		UseCamAnim = (Team==1) ? BlueBoostCamAnim : RedBoostCamAnim;
//		TMPlayerController(Controller).PlayCameraAnim(UseCamAnim, 1.0, 1.0, 0.1, 0.2, FALSE, FALSE);
//	}
//
//	// play animation
//	BoosterBlend.AnimFire('boosters_out', true,,, 'boosters_out_idle');
//	// activate booster sound and effects
//	BoosterSound.Play();
//	if (VehicleEffects[0].EffectRef != none)
//	{
//		VehicleEffects[0].EffectRef.bJustAttached = TRUE;
//	}
//	if (VehicleEffects[1].EffectRef != none)
//	{
//		VehicleEffects[1].EffectRef.bJustAttached = TRUE;
//	}
//	VehicleEvent( 'BoostStart' );
//
//	if ( PlayerController(Controller) != None )
//	{
//		Mesh.AttachComponentToSocket(LeftBoosterLight, VehicleEffects[0].EffectSocket);
//		Mesh.AttachComponentToSocket(RightBoosterLight, VehicleEffects[1].EffectSocket);
//		LeftBoosterLight.SetEnabled(TRUE);
//		RightBoosterLight.SetEnabled(TRUE);
//	}
//	LockWheels();
//
//	DefaultUprightMaxTorque = TMVehicleSimCar(SimObj).InAirUprightMaxTorque;
//	DefaultUprightTorqueFactor = TMVehicleSimCar(SimObj).InAirUprightTorqueFactor;
//
//	TMVehicleSimCar(SimObj).InAirUprightMaxTorque = BoostUprightMaxTorque;
//	TMVehicleSimCar(SimObj).InAirUprightTorqueFactor = BoostUprightTorqueFactor;
//}

/** DeactivateHandbrake()
called (usually by a timer) to deactivate the handbrake
*/
simulated function DeactivateHandbrake()
{
    bOutputHandbrake = FALSE;
    bHoldingDownHandbrake = FALSE;
}

//simulated event EnableFullSteering()
//{
//	local SVehicleSimCar SimCar;
//
//	bSteeringLimited = false;
//	SimCar = SVehicleSimCar(SimObj);
//	SimCar.MaxSteerAngleCurve.Points[0].OutVal = SVehicleSimCar(Default.SimObj).MaxSteerAngleCurve.Points[0].OutVal;
//	SimCar.MaxSteerAngleCurve.Points[1].OutVal = SVehicleSimCar(Default.SimObj).MaxSteerAngleCurve.Points[1].OutVal;
//	SimCar.MaxSteerAngleCurve.Points[2].OutVal = SVehicleSimCar(Default.SimObj).MaxSteerAngleCurve.Points[2].OutVal;
//}

/** DeactivateRocketBoosters()
called when player deactivates rocket boosters or they run out
*/
//simulated event DeactivateRocketBoosters()
//{
//	local TMPlayerController PC;
//
//	// Set handbrake to decrease the possibility of a rollover
//	AirSpeed = Default.AirSpeed;
//	EnableFullSteering();
//
//	if ( WorldInfo.NetMode == NM_DedicatedServer )
//		return;
//
//	PC = TMPlayerController(Controller);
//	if ( PC != none )
//	{
//		PC.StartZoom(PC.DefaultFOV,120);
//	}
//
//	// play animation
//	BoosterBlend.AnimStopFire();
//	// deactivate booster sound and effects
//	BoosterSound.Stop();
//	VehicleEvent( 'BoostStop' );
//
//	LeftBoosterLight.SetEnabled(FALSE);
//	RightBoosterLight.SetEnabled(FALSE);
//	Mesh.DetachComponent(LeftBoosterLight);
//	Mesh.DetachComponent(RightBoosterLight);
//	UnlockWheels();
//
//	TMVehicleSimCar(SimObj).InAirUprightMaxTorque = DefaultUprightMaxTorque;
//	TMVehicleSimCar(SimObj).InAirUprightTorqueFactor = DefaultUprightTorqueFactor;
//}

//function OnActivateRocketBoosters(TMSeqAct_ActivateRocketBoosters BoosterAction)
//{
//	bScriptedBoosters = true;
//}

//reliable server function ServerBoost()
//{
//    bTryToBoost = true;
//}

/** Self destruct immediately if activated and hit by EMP */
//simulated function bool DisableVehicle()
//{
//	local bool bResult;
//
//	bResult = super.DisableVehicle();
//
//	if ( SelfDestructInstigator != None )
//	{
//		SelfDestruct(None);
//		return true;
//	}
//	return bResult;
//}

//simulated function BlowupVehicle()
//{
//	if (bBoostersActivated)
//	{
//	    bBoostersActivated=FALSE;
//		DeactivateRocketBoosters();
//	}
//
//	Super.BlowupVehicle();
//}

//event SelfDestruct(Actor ImpactedActor)
//{
//	Health = -100000;
//	if(SelfDestructWarningComponent != none)
//	{
//		SelfDestructWarningComponent.Stop();
//	}
//	if(SelfDestructEnabledComponent != none)
//	{
//		SelfDestructEnabledComponent.Stop();
//	}
//	KillerController = SelfDestructInstigator;
//	BlowUpVehicle();
//	if ( ImpactedActor != None )
//	{
//		ImpactedActor.TakeDamage(600, SelfDestructInstigator, GetTargetLocation(), 200000 * Normal(Velocity), SelfDestructDamageType,, self);
//	}
//	HurtRadius(600,600, SelfDestructDamageType, 200000, GetTargetLocation(), ImpactedActor, SelfDestructInstigator);
//	PlaySound(SelfDestructSoundCue);
//	BoostStartTime = WorldInfo.TimeSeconds;
//}

// The pawn Driver has tried to take control of this vehicle
//function bool TryToDrive(Pawn P)
//{
//	return (SelfDestructInstigator == None) && Super.TryToDrive(P);
//}

//simulated event ReplicatedEvent(name VarName)
//{
//	if (VarName == 'bBladesExtended')
//	{
//		SetBladesExtended(bBladesExtended);
//	}
//	else if (VarName == 'bLeftBladeBroken')
//	{
//		BreakOffBlade(true);
//	}
//	else if (VarName == 'bRightBladeBroken')
//	{
//		BreakOffBlade(false);
//	}
//	else if (VarName == 'bBoostersActivated')
//	{
//		if ( bBoostersActivated )
//		{
//			ActivateRocketBoosters();
//		}
//		else
//		{
//			DeActivateRocketBoosters();
//		}
//	}
//	else if (VarName == 'bSelfDestructArmed')
//	{
//		PlaySelfDestruct();
//	}
//	else
//	{
//		Super.ReplicatedEvent(VarName);
//	}
//}

//simulated function bool OverrideBeginFire(byte FireModeNum)
//{
//	if (FireModeNum == 1)
//	{
//		if (Role == ROLE_Authority && !bBladesExtended)
//		{
//			SetBladesExtended(true);
//		}
//		// note: the blade hit checks are in native tick
//		return true;
//	}
//
//	return false;
//}

//simulated function bool OverrideEndFire(byte FireModeNum)
//{
//	if (FireModeNum == 1)
//	{
//		if (Role == ROLE_Authority && bBladesExtended)
//		{
//			SetBladesExtended(false);
//		}
//		return true;
//	}
//
//	return false;
//}

/** extends and retracts the blades */
//simulated function SetBladesExtended(bool bExtended)
//{
//	local int i;
//
//	bBladesExtended = bExtended;
//	if (bBladesExtended)
//	{
//		BladeBlend.AnimFire('Blades_out', true,,, 'Blades_out_idle');
//		PlaySound(BladeExtendSound, true);
//	}
//	else
//	{
//		for (i = 0; i < 2; i++)
//		{
//			if (BladeVictimConstraint[i] != None)
//			{
//				BladeVictimConstraint[i].Destroy();
//				BladeVictimConstraint[i] = None;
//			}
//		}
//		BladeBlend.AnimStopFire();
//		PlaySound(BladeRetractSound, true);
//	}
//}
//simulated function PlaySelfDestruct()
//{
//	local TMGib HatchGib;
//	local SkelControlBase SkelControl;
//
//	DeadVehicleLifeSpan = BurnOutTime + 0.01;
//	TMVehicleSimCar(SimObj).bDriverlessBraking = false;
//	// play sound
//	PlaySound(SelfDestructEnabledSound);
//	if(SelfDestructWarningComponent == none)
//	{
//		SelfDestructWarningComponent = CreateAudioComponent(SelfDestructWarningSound, FALSE, TRUE);
//		if ( SelfDestructWarningComponent != None )
//		{
//			SelfDestructWarningComponent.Location = Location;
//			SelfDestructWarningComponent.bUseOwnerLocation = true;
//			AttachComponent(SelfDestructWarningComponent);
//		}
//	}
//	if ( SelfDestructWarningComponent != None )
//	{
//		SelfDestructWarningComponent.Play();
//	}
//	if(SelfDestructEnabledComponent == None)
//	{
//		SelfDestructEnabledComponent = CreateAudioComponent(SelfDestructEnabledLoop, FALSE, TRUE);
//		if ( SelfDestructEnabledComponent != None )
//		{
//			SelfDestructEnabledComponent.Location = Location;
//			SelfDestructEnabledComponent.bUseOwnerLocation = true;
//			AttachComponent(SelfDestructEnabledComponent);
//		}
//	}
//	if ( SelfDestructEnabledComponent != None )
//	{
//		SelfDestructEnabledComponent.FadeIn(1.0f,1.0f);
//	}
//	// blow off the hatch
//	SkelControl = Mesh.FindSkelControl('Hatch');
//	if (SkelControl != None)
//	{
//		SkelControl.BoneScale = 0.0;
//		HatchGib = Spawn(HatchGibClass, self,, Mesh.GetBoneLocation('Hatch_Slide'), rot(0,0,0));
//		if(HatchGib != none)
//		{
//			HatchGib.Velocity = 0.25*Velocity;
//			HatchGib.Velocity.Z = 400.0;
//			HatchGib.GibMeshComp.WakeRigidBody();
//			HatchGib.GibMeshComp.SetRBLinearVelocity(HatchGib.Velocity, false);
//		}
//	}
//	BigExplosionTemplates.length = 1;
//	BigExplosionTemplates[0].Template = SelfDestructExplosionTemplate;
//	BigExplosionTemplates[0].MinDistance = 0.0;
//}

//simulated function DisplayHud(TMHud Hud, Canvas Canvas, vector2D HudPOS, optional int SeatIndex)
//{
//	local PlayerController PC;
//	super.DisplayHud(HUD, Canvas, HudPOS, SeatIndex);
//
//	PC = PlayerController(Seats[0].SeatPawn.Controller);
//	if (PC != none)
//	{
//		if (Throttle > 0.0 && !bBoostersActivated && (WorldInfo.TimeSeconds - BoostChargeTime > BoostChargeDuration))
//		{
//		   	Hud.DrawToolTip(Canvas, PC, "GBA_Jump", Canvas.ClipX * 0.5, Canvas.ClipY * 0.95, BoostToolTipIconCoords.U, BoostToolTipIconCoords.V, BoostToolTipIconCoords.UL, BoostToolTipIconCoords.VL, Canvas.ClipY/720);
//		}
//		else if (ReadyToSelfDestruct())
//		{
//			Hud.DrawToolTip(Canvas, PC, "GBA_Use", Canvas.ClipX * 0.5, Canvas.ClipY * 0.95, EjectToolTipIconCoords.U, EjectToolTipIconCoords.V, EjectToolTipIconCoords.UL, EjectToolTipIconCoords.VL, Canvas.ClipY/720);
//		}
//	}
//}

function DriverLeft()
{
	//if ( ReadyToSelfDestruct() )
	//{
		SelfDestructInstigator = (Driver != none) ? Driver.Controller : None;

		//bShouldEject = true;
		if ( PlayerController(SelfDestructInstigator) != None )
		{
			PlayerController(SelfDestructInstigator).ClientPlaySound(EjectSoundCue);
		}

		//BoostStartTime = WorldInfo.TimeSeconds - MaxBoostDuration + 1.0;
		//bSelfDestructArmed = true;
		//PlaySelfDestruct();
	//}
//	else if (bBladesExtended)
//	{
//		SetBladesExtended(false);
//	}

	Super.DriverLeft();
}

/**
 * Extra damage if hit while boosting
 */
//simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
//{
//	local PlayerController PC;
//
//	if (Role == ROLE_Authority)
//	{
//		if ( SelfDestructInstigator != None )
//		{
//			PC = PlayerController(SelfDestructInstigator);
//			Damage *= 2.0;
//		}
//		else if ( bBoostersActivated )
//			Damage *= 1.5;
//	}
//
//	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
//
//	if ( (Role == ROLE_Authority) && (Health < 0) && (SelfDestructInstigator != None) && (EventInstigator != PC) )
//	{
//		if ( PC != None )
//			PC.ReceiveLocalizedMessage(class'TMLastSecondMessage', 1, PC.PlayerReplicationInfo, None, None);
//		if ( PlayerController(EventInstigator) != None )
//		{
//			PlayerController(EventInstigator).ReceiveLocalizedMessage(class'TMLastSecondMessage', 1, PC.PlayerReplicationInfo, None, None);
//		}
//	}
//}

/** called when the blades hit something (not called for broken blades) */
//simulated event BladeHit(Actor HitActor, vector HitLocation, bool bLeftBlade)
//{
//	local TraceHitInfo HitInfo;
//	local vector VelDir;
//	local Pawn P;
//	local int index;
//
//	if (HitActor.bBlockActors)
//	{
//		if (Vehicle(HitActor) != None)
//		{
//			if (HitActor.IsA('TMVehicle_Hoverboard'))
//			{
//				P = Vehicle(HitActor).Driver;
//			}
//		}
//		else
//		{
//			P = Pawn(HitActor);
//		}
//
//		// if we hit a vehicle or a non-pawn, break off the blade and do no damage
//		if (P == None)
//		{
//			if (Role == ROLE_Authority)
//			{
//				if (bLeftBlade)
//				{
//					bLeftBladeBroken = true;
//				}
//				else
//				{
//					bRightBladeBroken = true;
//				}
//				BreakOffBlade(bLeftBlade);
//			}
//		}
//		// else we hit a pawn and we are now going to do damage to said pawn
//		else
//		{
//			if (Role == ROLE_Authority)
//			{
//				P.TakeDamage(1000, Controller, HitLocation, Velocity * 100.f, BladeDamageType);
//			}
//			if ( P.Health <= 0 && !P.bDeleteMe && P.Physics == PHYS_RigidBody
//				&& P.Mesh != None && P.Mesh.PhysicsAssetInstance != None )
//			{
//				// grab ragdoll
//				VelDir = Normal(Velocity);
//				P.CheckHitInfo( HitInfo, P.Mesh, VelDir, HitLocation );
//				if ( HitInfo.BoneName == '' )
//				{
//					P.CheckHitInfo( HitInfo, P.Mesh, Normal(P.Location - HitLocation), HitLocation );
//				}
//				if ( HitInfo.BoneName != '' )
//				{
//					index = 0;
//					if ( BladeVictimConstraint[index] != None )
//					{
//						index = 1;
//						if ( BladeVictimConstraint[index] != None )
//						{
//							index = 0;
//							BladeVictimConstraint[index].Destroy();
//							BladeVictimConstraint[index] = None;
//						}
//					}
//					BladeVictimConstraint[index] = Spawn(class'RB_ConstraintActorSpawnable',,,HitLocation);
//					BladeVictimConstraint[index].InitConstraint( self, P, '', HitInfo.BoneName, 200.f);
//					BladeVictimConstraint[index].LifeSpan = 1 + 4*FRand();
//				}
//			}
//		}
//	}
//}


/** if exit while boosting, boost out of the vehicle
Try to exit above
*/
//function bool FindAutoExit(Pawn ExitingDriver)
//{
//	local vector X,Y,Z;
//	local float PlaceDist;
//
//	if ( bBoostersActivated )
//	{
//		GetAxes(Rotation, X,Y,Z);
//		Y *= -1;
//
//		PlaceDist = 150 + 4*ExitingDriver.GetCollisionHeight();
//
//		if ( TryExitPos(ExitingDriver, GetTargetLocation() + PlaceDist * Z, false) )
//			return true;
//	}
//	return Super.FindAutoExit(ExitingDriver);
//}

//========================================
// AI Interface

//function byte ChooseFireMode()
//{
//	local TMVehicle V;
//	local float Dist;
//	local vector FacingDir, EnemyDir;
//
//	if ( bAISelfDestruct )
//	{
//		if ( !bTryToBoost )
//			bAISelfDestruct = false;
//		else
//			return 0;
//	}
//
//	if ( Pawn(Controller.Focus) != None && Controller.MoveTarget == Controller.Focus
//		&& Controller.InLatentExecution(Controller.LATENT_MOVETOWARD) )
//	{
//		V = TMVehicle(Controller.Focus);
//		if ( V == None )
//		{
//			Dist = VSize(Controller.GetFocalPoint() - Location);
//			if ( Dist < 1200.0 && Controller.LineOfSightTo(Controller.Focus) )
//		{
//				if ( (WorldInfo.TimeSeconds - LastBladeBoostTime > 5) && (Dist > 200.0) )
//		{
//					LastBladeBoostTime = WorldInfo.TimeSeconds;
//					FacingDir = vector(Rotation);
//					FacingDir.Z = 0;
//					EnemyDir = Controller.Focus.Location - Location;
//					EnemyDir.Z = 0;
//					bTryToBoost = (Normal(FacingDir) dot Normal(EnemyDir) > 0.93) && (FRand() < 0.5);
//				}
//
//			return 1;
//		}
//		}
//		else if ( (V.Health > 300 || V.ImportantVehicle()) && Controller.LineOfSightTo(Controller.Focus) )
//		{
//			// self destruct to take out highly armored vehicle
//			bTryToBoost = true;
//			bAISelfDestruct = true;
//			SetTimer(0.3, true, 'CheckScriptedSelfDestruct');
//		}
//		}
//	return 0;
//}

function bool TooCloseToAttack(Actor Other)
{
	if (Pawn(Other) != None && Vehicle(Other) == None)
	{
		return false;
	}
	return Super.TooCloseToAttack(Other);
}

function IncomingMissile(Projectile P)
{
	local TMBot B;

	B = TMBot(Controller);
	if (Health < 200 && B != None && B.Skill > 4.0 + 4.0 * FRand() && VSize(P.Location - Location) < VSize(P.Velocity))
	{
		DriverLeave(false);
	}
}

simulated function TeamChanged()
{
	super.TeamChanged();
	// clear out the flags since we have a new material:
	bBrakeLightOn = false;
	bReverseLightOn = false;
	bHeadlightsOn=false;
}

//function OnSelfDestruct(TMSeqAct_SelfDestruct Action)
//{
//	bScriptedBoosters = true;
//	SetTimer(0.5, true, 'CheckScriptedSelfDestruct');
//}

//function CheckScriptedSelfDestruct()
//{
//	if ( ReadyToSelfDestruct() )
//	{
//		DriverLeave(true);
//		ClearTimer('CheckScriptedSelfDestruct');
//		bAISelfDestruct = false;
//	}
//}

simulated event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
					const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	// only process rigid body collision if not hitting ground, or hitting at an angle
	if ( (Abs(RigidCollisionData.ContactInfos[0].ContactNormal.Z) < WalkableFloorZ)
		|| (Abs(RigidCollisionData.ContactInfos[0].ContactNormal dot vector(Rotation)) > 0.8)
		|| (VSizeSq(Mesh.GetRootBodyInstance().PreviousVelocity) * GetCollisionDamageModifier(RigidCollisionData.ContactInfos) > 5) )
	{
		super.RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
	}
}

/** breaks off the given blade by scaling the bone to zero and spawning effects */
//simulated function BreakOffBlade(bool bLeftBlade)
//{
//	local SkelControlBase SkelControl;
//	local vector BoneLoc;
//
//	PlaySound(BladeBreakSound, true);
//	SkelControl = Mesh.FindSkelControl(bLeftBlade ? 'LeftBlade' : 'RightBlade');
//	BoneLoc = Mesh.GetBoneLocation(bLeftBlade? 'Blade_L2' : 'Blade_R2');
//
//	if (SkelControl != None)
//	{
//		SkelControl.BoneScale = 0.0;
//	}
//	else
//	{
//		`warn("Failed to find skeletal controller named" @ (bLeftBlade ? 'LeftBlade' : 'RightBlade') @ "for mesh" @ Mesh);
//	}
//
//	if (WorldInfo.NetMode != NM_DedicatedServer && !IsZero(BoneLoc))
//	{
//		SpawnGibVehicle(BoneLoc, Rotation, BrokenBladeMesh, BoneLoc, true, vect(0,0,0), None, None);
//	}
//}

simulated function CauseMuzzleFlashLight(int SeatIndex)
{
	Super.CauseMuzzleFlashLight(SeatIndex);

	//@FIXME: should have general code for this in TMVehicle
	if (SeatIndex == 0)
	{
		VehicleEvent('MuzzleFlash');
	}
}

/**
 * We override here as the scorpion uttlery destroys itself when it blows up!  So we need to turn off the damage effects as they
 * are out of place just floating in the air.
 **/
simulated function SetBurnOut()
{
	Super.SetBurnOut();

	if( DeathExplosion != none )
	{
		DeathExplosion.ParticleSystemComponent.DeactivateSystem();
	}

	VehicleEvent( 'NoDamageSmoke' );
}

function bool RecommendCharge(TMBot B, Pawn Enemy)
{
	local TMVehicle V;

	if ( Enemy.bCanFly )
	{
		return false;
	}
	V = TMVehicle(Enemy);
	return (V == None) || V.ImportantVehicle() || (V.Health > 300);
}

/** Recommend high priority charge at enemy */
function bool CriticalChargeAttack(TMBot B)
{
	return (TMVehicle(B.Enemy) != None) && RecommendCharge(B, B.Enemy);
}

