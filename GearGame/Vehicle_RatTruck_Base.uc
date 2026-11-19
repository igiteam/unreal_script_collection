/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Vehicle_RatTruck_Base extends GearVehicle
	native(Vehicle)
	config(Pawn)
	abstract;


/** config version of health. */
var() config int DefaultRatHealth;
/** How quickly to heal per second. */
var() config float HealthRechargeRate;
/** Used to keep track of partial heal points between ticks. */
var	float PartialHealth;

/** Dampening to apply to screenshakes when targeting on the Rat Truck */
var() config float TargetingShakeDampening;

/** Camera shake for running over enemies */
var() protected const GearCameraShake RunOverCameraShake;

/** Allow seat changing to debug cameras, model placement, etc. */
var() bool bDebugAllowSeatChanging;

var transient repnotify GearPawn LPassenger;
var transient repnotify GearPawn RPassenger;

// used to detach passengers when NULL rep comes down (stored locally only)
var transient GearPawn Old_LPassenger;
var transient GearPawn Old_RPassenger;

// sim for wheels
var instanced WheelGroundConformHelper WheelSim;

replication
{
	if(ROLE==ROLE_Authority)
		RPassenger,LPassenger;
}

cpptext
{
}

simulated function int L_Idx()
{
	return 2;
}

simulated function int R_Idx()
{
	return 1;
}

simulated event PostBeginPlay()
{
	
	Super.PostBeginPlay();
	WheelSim.InitializeWheels(self,Mesh);

	if (Role == ROLE_Authority)
	{
		Health = DefaultRatHealth;
	}
}


/** Handle repnotify vars (client only) */
simulated function ReplicatedEvent(name VarName)
{

	Super.ReplicatedEvent(VarName);

	if (VarName == 'LPassenger')
	{		
		if( LPassenger != none )
		{
			PassengerStartDriving(LPassenger,L_Idx());
		}
		else if( Old_LPassenger != none )
		{
			KickPawn(Old_LPassenger);
		}

		Old_LPassenger = LPassenger;
	}
	else if( VarName == 'RPassenger')
	{
		
		if( RPassenger != none )
		{
			PassengerStartDriving(RPassenger,R_Idx());
		}
		else if( Old_RPassenger != none )
		{
			KickPawn(Old_RPassenger);
		}

		Old_RPassenger = RPassenger;
	}
}

/** (client + server) */
simulated function int GetVehicleDefaultHealth()
{
	return DefaultRatHealth;
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
	local VehicleSeat SeatData;

	Super.OnToggleHidden(Action);

	// Also hide any driver/gunner
	if(Driver != None)
	{
		Driver.OnToggleHidden(Action);
	}

	foreach Seats(SeatData)
	{		
		// SeatPawns can be set to the vehicle, usually seat 0, avoid infinite recursion
		if (SeatData.SeatPawn != None && SeatData.SeatPawn != Self)
		{
			SeatData.SeatPawn.OnToggleHidden(Action);
		}
	}
}

/** (client + server) */
simulated event Tick(float DeltaTime)
{
	local int HealAmount;

	Super.Tick(DeltaTime);

	WheelSim.UpdateWheels(DeltaTime,self,Mesh);

	// Handle healing
	if (Role == ROLE_Authority)
	{
		// If hurt, heal
		if (Health < DefaultRatHealth)
		{
			// We need to save off partially healed points
			PartialHealth += DeltaTime * HealthRechargeRate;
			if (PartialHealth >= 1.f)
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
}

simulated function BlowupVehicle(Controller Killer)
{
	Super.BlowupVehicle(Killer);
}


/**
 * @Returns true if a seat is not occupied
 * overloaded to avoid the driver seat 0
 */
function bool SeatAvailable(int SeatIndex)
{
	return SeatIndex != 0 && (Seats[SeatIndex].SeatPawn == none || Seats[SeatIndex].SeatPawn.Controller == none);
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

simulated function name GetRiderState(Pawn P)
{
	return 'PlayerRidingVehicle';
}


/**
 * Called after AttachDriver (Vehicle or WeaponPawn), orients the driver in the vehicle
 * turns off physics
 * Network : ALL
 * @param WP - pawn to orient in the vehicle
 * @param SeatIndex - Seat to put pawn in
 */
simulated function SitDriver( GearPawn WP, int SeatIndex)
{
	Super.SitDriver(WP, SeatIndex);
	WP.bCanDBNO = FALSE;
}

/**
 * StartDriving() and StopDriving() also called on clients
 * on transitions of DrivenVehicle variable.
 * Network: ALL
 */
simulated event PassengerStartDriving(GearPawn GP, int SeatIdx)
{
	if (GP.bWantsToMelee)
	{
		GP.StopMeleeAttack();
	}

	GP.StopFiring();
	if ( GP.Health <= 0 )
		return;

	GP.bForceNetUpdate = TRUE;

	// Move the driver into position, and attach to car.
	GP.ShouldCrouch(false);
	GP.bIgnoreForces = true;
	GP.bCanTeleport = false;
	GP.BreathTime = 0.0;
	AttachPassenger( GP, SeatIdx );

	GP.ClearTimer('TryHolsterAgain');
}

/**
 * called to handle owner visibility/releative offsets 
 * Network : ALL
 * @param WP - pawn to orient in the vehicle
 * @param SeatIndex - Seat to put pawn in
 */
simulated function SetupSeatDriverVisibility(int SeatIndex, GearPawn WP)
{	
	if ( (WP.Mesh != None) && (Mesh != None) )
	{
		WP.Mesh.SetShadowParent(Mesh);
	}
	WP.Mesh.SetOwnerNoSee(FALSE);
	WP.SetHidden(FALSE);
}
	
/**
* Attach the Passenger to the vehicle.  If he's visible, find him a place, otherwise hide him
* If you update this function, please update GearWeaponPawn.AttachDriver()
* @param	P		the Pawn the attach
*/
simulated function AttachPassenger( Pawn P, int SeatIdx )
{
	local GearPawn GP;

	//`log("AttachPassenger!"@`showvar(self)@`showvar(P)@`showvar(SeatIdx));
	if( !bAttachDriver )
	{
		return;
	}

	GP = GearPawn(P);
	if( GP != None )
	{
		//`log(`showvar(GP)@`showvar(GP.Controller));
		if( PlayerController(GP.Controller) != None )
		{
			GP.Controller.GotoState(GetRiderState(P));
		}
		else if( GearAI(GP.Controller) != None )
		{
			GearAI(GP.Controller).bGodMode = true;
		}

		GP.SetCollision(true, false);
		GP.bCollideWorld = false;		
		GP.SetBase(none);
		GP.SetLocation(Location);
		GP.SetHardAttach(true);
		GP.DoSpecialMove(SM_RidingRatTruck, true);
		GP.SetPhysics(PHYS_Interpolating);
		GP.SetHidden(false);
		GP.Mesh.SetBlockRigidBody(false);
		GP.Mesh.SetHasPhysicsAssetInstance(false);

		
		SitDriver(GP, SeatIdx);
	}
}

/** Forces a given pawn out of the vehicle */
simulated function KickPawn(GearPawn GP)
{
	local int i;

	if(GP.Base == self)
	{
		if( PlayerController(GP.Controller) != none)
		{			
			GP.Controller.GotoState(GP.LandMovementState);
		}
		else if( GearAI(GP.Controller) != None )
		{
			GearAI(GP.Controller).bGodMode = false;
		}

		GP.SetHardAttach(false);
	    GP.bCollideWorld = true;
		GP.bIgnoreBaseRotation = false;
		GP.DoSpecialMove(SM_None, true);

	    GP.SetCollision(true, true);

		if ( !PlaceExitingDriver(GP) )
	    {
			GP.SetLocation(GetTargetLocation());
	    }

	    for (i = 0; i < Seats.length; i++)
		{
			if (Seats[i].StoragePawn == GP)
			{
				break;
			}
		}

		if( i == L_Idx())
		{
			LPassenger = none;
		}
		else if(i == R_Idx())
		{
			RPassenger = none;
		}
		SetSeatStoragePawn(i,none);

		DetachDriver(GP);

		GP.SetPhysics(PHYS_Falling);
		GP.bCanDBNO = GP.default.bCanDBNO;
	}
}

/**
 * Called when a passenger enters the vehicle
 *
 * @param P				The Pawn entering the vehicle
 * @param SeatIndex		The seat where he is to sit
 */
function bool PassengerEnter(Pawn P, int SeatIndex)
{
	local bool bEntered;
	local GearAI AIController;


	//bEntered = Super.PassengerEnter(P, SeatIndex);
	if (SeatIndex <= 0 || SeatIndex >= Seats.Length)
	{
		`warn("Attempted to add a passenger to unavailable passenger seat" @ SeatIndex);		
	}
	else
	{
		bEntered = true;
	}

	// Set pawns current controller to control the vehicle pawn instead
	PassengerStartDriving( GearPawn(P), SeatIndex );

	// Set up the AI
	AIController = GearAI(P.Controller);
	if (AIController != None && bEntered)
	{
		SetupAssaultRifleAI(AIController);
	}

	SetSeatStoragePawn(SeatIndex,P);
	if( SeatIndex == L_Idx() )
	{
		LPassenger=GearPawn(P);
	}
	else if( SeatIndex == R_Idx() )
	{
		RPassenger=GearPawn(P);
	}

	P.SetHidden(false);

	return bEntered;
}

/**
 * Called when a passenger leaves the vehicle
 *
 * @param	SeatIndex		Leaving from which seat
 */
function PassengerLeave(int SeatIndex)
{
	local GearAI AIController;
	local Pawn P;

	P = Seats[SeatIndex].StoragePawn;

	// Set up the AI
	AIController = GearAI(P.Controller);
	if (AIController != None)
	{
		AIcontroller.AbortCommand(none,class'AICmd_Base_RatTruckGunner');
	}
	else if( PlayerController(P.Controller) != none)
	{
		P.Controller.GotoState(P.LandMovementState);
	}

	Super.PassengerLeave(SeatIndex);

	 
}


function SetupAssaultRifleAI(GearAI AIController)
{
	// abort current combat command if there is one
	AIController.AbortCommand(None, AIController.DefaultCommand);
	// switch to mounted gunner
	class'AICmd_Base_RatTruckGunner'.static.InitCommand(AIController);
}

/** Used so we can override damage using our own table */
simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
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
}

/** Returns the team of a passenger */
simulated function TeamInfo GetTeam()
{
	if( RPassenger != None )
	{
		return RPassenger.GetTeam();
	}
	if( LPassenger != None )
	{
		return LPassenger.GetTeam();
	}
	return Super.GetTeam();
}

/**
* RanInto() called for encroaching actors which successfully moved the other actor out of the way
*
* @param	Other 		The pawn that was hit
*/
event RanInto(Actor Other)
{
	local vector Momentum;
	local float SpeedSq;
	local GearPawn HitGP;
	local GearPC PassengerPC;

	//`log(GetFuncName()@`showvar(Other));
	HitGP = GearPawn(Other);

	if( HitGP == None || !HitGP.bCanBeRunOver || Other == Instigator || Other.Role != ROLE_Authority )
	{
		return;
	}

	// If we have a base, use its velocity
	if( Base != None )
	{
		SpeedSq = VSizeSq(Base.Velocity);
	}
	else
	{
		SpeedSq = VSizeSq(Velocity);
	}
	
	if( !WorldInfo.GRI.OnSameTeam(self,Other) && SpeedSq > MinRunOverSpeed*MinRunOverSpeed )
	{
		Momentum = GetBaseMost().Velocity * 0.25 * HitGP.Mass;

		// Play crunch sound
		if( RanOverSound != None )
		{
			PlaySound(RanOverSound);
		}

		// Do FX for players in each seat
		PassengerPC = GearPC(LPassenger.Controller);
		if( PassengerPC != None )
		{
			//`log(" Seats[SeatIndex].SeatPawn:"@Seats[SeatIndex].SeatPawn);
			PassengerPC.ClientPlayCameraShake(RunOverCameraShake,,true);
			if( PassengerPC.IsAimingAt( HitGP, 0.1f ) )
			{
				PassengerPC.ClientSpawnCameraLensEffect( HitGP.ShotgunCameraLensEffectTemplate );
			}
		}
		PassengerPC = GearPC(RPassenger.Controller);
		if( PassengerPC != None )
		{
			//`log(" Seats[SeatIndex].SeatPawn:"@Seats[SeatIndex].SeatPawn);
			PassengerPC.ClientPlayCameraShake(RunOverCameraShake,,true);
			if( PassengerPC.IsAimingAt( HitGP, 0.1f ) )
			{
				PassengerPC.ClientSpawnCameraLensEffect( HitGP.ShotgunCameraLensEffectTemplate );
			}
		}

		// Instakill!
		HitGP.TakeDamage(100000, GetCollisionDamageInstigator(), HitGP.Location, Momentum, RanOverDamageType);
	}
}

simulated event byte ScriptGetTeamNum()
{
	return TEAM_COG;
}

defaultproperties
{
	RanOverDamageType=class'GDT_HitByRatTruck'

	// so the matinees can link to the truck correctly - could be done differently if bNoDelete causes pain
	bNoDelete=true

	// matinee controlled, so shouldn't need any of this stuff
	bReplicateMovement=false
	bUpdateSimulatedPosition=false

	Begin Object Class=GearCameraShake Name=RunOverCameraShake0
		OscillationDuration=0.4f
		LocOscillation={(Y=(Amplitude=2.f,Frequency=3.f),
						 Z=(Amplitude=20.f,Frequency=30.f))}
		RotOscillation={(Pitch=(Amplitude=80.f,Frequency=80.f),
						Yaw=(Amplitude=60.f,Frequency=50.f),
						Roll=(Amplitude=35.f,Frequency=20.f))}
	End Object
	RunOverCameraShake=RunOverCameraShake0

	Begin Object Class=AudioComponent Name=FaceAudioComponent
	End Object
	FacialAudioComp=FaceAudioComponent
	Components.Add(FaceAudioComponent)


	Begin Object Class=WheelGroundConformHelper Name=WheelSim0
	End Object
	WheelSim=WheelSim0

	bVehicleSpaceViewLimits=TRUE
	bVehicleSpaceCamera=FALSE
	bOnlyInheritVehicleSpaceYaw=FALSE
	bShowWeaponOnHUD=FALSE


	bCollideWithCamera=true
	bDebugAllowSeatChanging=true
	bDriverIsVisible=true
	ExitPositions(0)=(x=-500,y=0,z=70)
}

