/**
 * Blimp Ball Turret
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Turret_BlimpBallBase extends GearTurret
	abstract
	config(Pawn)
	native;

/** Turret look at controllers */
var SkelControlLookAt Pivot_Latitude;
var SkelControlLookAt Pivot_Longitude;

var	Name Pivot_Latitude_BoneName;
var Name MuzzleSocketName;
var Name PlayerRefSocketName;
var Name CameraRefSocketName;

/** The rotational offset of the camera view from the playercontroller rotation */
var const rotator ViewOffset;

/** Delay in between bursts for human controlled players */
var() config float BurstDelay;
/** Minimum delay in between bursts for AI */
var() config float MinAIBurstDelay;
/** Maximum delay in between bursts for AI */
var() config float MaxAIBurstDelay;

/** Death explosion template */
var GearExplosion ExplosionTemplate;

var StaticMeshComponent SMC_Gunner;
var repnotify bool bHideGunner;

replication
{
	if( Role == ROLE_Authority && bNetInitial )
		bHideGunner;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	bHideGunner = bDontPossess;
	Mesh.AttachComponentToSocket( SMC_Gunner, 'Player_Ref' );
	UpdateGunnerMesh();
}

simulated function Destroyed()
{
	// Clear references to animations nodes
	ClearAnimNodes();
	
	Super.Destroyed();
}

simulated event ReplicatedEvent( name VarName )
{
	switch( VarName )
	{
		case 'bHideGunner' : 
			UpdateGunnerMesh(); 
			break;
	}

	Super.ReplicatedEvent( VarName );
}

simulated function UpdateGunnerMesh()
{
	SMC_Gunner.SetHidden( bHideGunner );
}

/** No pawns driving this turret, purely AI controlled */
function bool TryToDrive(Pawn P)
{
	return FALSE;
}

native event bool IsValidEnemyTargetFor(const PlayerReplicationInfo PRI, bool bNoPRIisEnemy);

/** Spawn death explosion */
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local GearExplosionActorReplicated ExplosionActor;

	`log("-- PlayDying()");
	ExplosionTemplate.InitFromContentTemplate();
	ExplosionActor = Spawn(class'GearExplosionActorReplicated',,, Location, Rotation);
	ExplosionActor.InstigatorController = Controller;
	if (ExplosionActor.InstigatorController != None)
	{
		ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
	}
	ExplosionActor.Explode(ExplosionTemplate);

	Super.PlayDying(DamageType, HitLoc);
}

simulated function CacheAnimNodes()
{
	Super.CacheAnimNodes();

	Pivot_Latitude	= SkelControlLookAt(Mesh.FindSkelControl('Turret_Lat'));
	Pivot_Longitude = SkelControlLookAt(Mesh.FindSkelControl('Turret_Long'));
}


/** Clear references to anim nodes. */
simulated function ClearAnimNodes()
{
	Super.ClearAnimNodes();

	Pivot_Latitude	= None;
	Pivot_Longitude	= None;
}

/**
 * Move the camera to the camera socket
 *
 * @return the Location of the camera socket
 */
simulated event vector GetPawnViewLocation()
{
	local Vector CameraLocation;
	local Rotator UnusedRotation;

	Mesh.GetSocketWorldLocationAndRotation(CameraRefSocketName, CameraLocation, UnusedRotation);

	return CameraLocation;
}

/**
 * Block the Turret version of CalcCamera
 *
 * @param fDeltaTime - unused
 *
 * @param out_CamLoc - unused
 *
 * @param out_CamRot - unused
 *
 * @param out_FOV - unused
 *
 * @return FALSE to signify that we want the regular camera system to do its thing
 */
simulated function bool CalcCamera(float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV)
{
	// don't do special camera stuff, normal camera works, using warcam_turret mode
	return FALSE;
}

/** Hack until we have correct exiting mechanism (supposed to climp out with a special move) */
function bool DriverLeave( bool bForceLeave )
{
	return Super.DriverLeave(true);
}

/**
 * @hack to put the driver back on the blimp until we get proper anims
 * 
 * @param ExitingDriver - the driver leaving the turret
 * 
 * @return TRUE if the driver could be placed
 */
function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
	local vector ExitLocation;

	if (ExitingDriver == None)
	{
		ExitingDriver = Driver;
	}

	if (ExitingDriver != None && Base != None)
	{
		ExitLocation = Base.Location + Base.Velocity;
		ExitLocation.Z -= 100;

		if (ExitingDriver.SetLocation(ExitLocation))
		{
			return TRUE;
		}
	}

	return FALSE;
}

/************************************************************************************
 * AI
 ***********************************************************************************/

/**
 * Perform update for AI controller.
 * tracks targets and such...
 */
function UpdateAIController(GearAI C, float DeltaTime)
{
	local float		InterpSpeed;
	local Vector	TargLoc, FireLoc;
	`if(`notdefined(FINAL_RELEASE))
	local Rotator R;
	`endif

	// by default, slowest speed
	InterpSpeed = 0.4f;

	// if we have a visible target, track it down
	if( C.HasValidTarget() )
	{
		InterpSpeed		= 2.0f;
		TargLoc			= C.GetFocalPoint();

		FireLoc			= GetPhysicalFireStartLoc( vect(0,0,0) );
		DesiredAimDir	= Rotator(TargLoc - FireLoc);
	}
	// keep desired aim within limits
	if( TurretClampYaw(DesiredAimDir) )
	{
		`if(`notdefined(FINAL_RELEASE))
		//debug
		if( bDebugTurret )
		{
			FlushPersistentDebugLines();
			DrawDebugBox(TargLoc, vect(10,10,10), 255, 0, 0, TRUE );
			DrawDebugBox(GetPhysicalFireStartLoc( vect(0,0,0) ), vect(10,10,10), 255, 0, 0, TRUE );
			DrawDebugLine(TargLoc, GetPhysicalFireStartLoc( vect(0,0,0) ), 255, 0, 0, TRUE );
			DrawDebugLine(GetPhysicalFireStartLoc( vect(0,0,0) ) + Vector(Rotation)*256.f, GetPhysicalFireStartLoc( vect(0,0,0) ), 0, 255, 0, TRUE );
			R = Rotation;
			R.Yaw += YawLimit.Y;
			DrawDebugLine(GetPhysicalFireStartLoc( vect(0,0,0) ) + Vector(R)*256.f, GetPhysicalFireStartLoc( vect(0,0,0) ), 0, 255, 0, TRUE );
			R = Rotation;
			R.Yaw += YawLimit.X;
			DrawDebugLine(GetPhysicalFireStartLoc( vect(0,0,0) ) + Vector(R)*256.f, GetPhysicalFireStartLoc( vect(0,0,0) ), 0, 255, 0, TRUE );
		}
		`endif
		TurretOverRotated();
	}

	// Interpolate to the desired aim direction
	AimDir = RInterpTo( AimDir, DesiredAimDir, DeltaTime, InterpSpeed );

	// Update controllers rotation
	SetDesiredRotation(AimDir);
}


/**
 * Called every second when AI is Idle.
 */
function AIIdleNotification(GearAI_Cover C)
{
}

simulated function Tick(float DeltaTime)
{
	super.Tick( DeltaTime );

	UpdateTurret(DeltaTime);

	if( Driver != None )
	{
		UpdateDriver(DeltaTime);
	}
}

simulated function UpdateTurret(float DeltaTime)
{
	local vector AimTargetWorld, AimTargetLoc, PivotLatLoc;

	// Get location of latitude pivot
	PivotLatLoc = Mesh.GetBoneLocation(Pivot_Latitude_BoneName);
	AimTargetWorld = PivotLatLoc + Vector(AimDir) * 16384;

	// If looking at a POI, force the turret mesh to point there too
	if (GearPC(Controller) != None && GearPC(Controller).bLookingAtPointOfInterest)
	{
		AimTargetWorld = PivotLatLoc + Vector(GearPlayerCamera(GearPC(Controller).PlayerCamera).Rotation - ViewOffset) * 16384;
	}

	AimTargetLoc = (AimTargetWorld - Location) << Rotation;		// the skelcontrols expect actor-local space

	if( Pivot_Latitude != None )
	{
		Pivot_Latitude.TargetLocation = (WorldInfo.NetMode != NM_Client || IsLocallyControlled()) ? AimTargetLoc : VInterpTo(Pivot_Latitude.TargetLocation, AimTargetLoc, DeltaTime, 2.0);
	}
	if( Pivot_Longitude != None )
	{
		Pivot_Longitude.TargetLocation = (WorldInfo.NetMode != NM_Client || IsLocallyControlled()) ? AimTargetLoc : VInterpTo(Pivot_Longitude.TargetLocation, AimTargetLoc, DeltaTime, 2.0);
	}
}

/** Focus point has been cleared, keep looking that way */
simulated function UpdateAimToFocusPoint()
{
	local rotator NewAimDir;

	if (GearPC(Controller) != None)
	{
		NewAimDir = GearPlayerCamera(GearPC(Controller).PlayerCamera).Rotation - ViewOffset;
		NewAimDir.Roll = 0;
		Controller.SetRotation(NewAimDir);
		AimDir = Controller.Rotation;
		GearPlayerCamera(GearPC(Controller).PlayerCamera).ResetInterpolation();
	}
}

function SetMovementPhysics()
{
	// If in invalid physics mode - change it to None
	if(Physics != PHYS_Interpolating && Physics != PHYS_None)
	{
		SetPhysics(PHYS_None);
	}
}

/**
 * list important Pawn variables on canvas.  HUD will call DisplayDebug() on the current ViewTarget when
 * the ShowDebug exec is used
 *
 * @param	HUD		- HUD with canvas to draw on
 * @input	out_YL		- Height of the current font
 * @input	out_YPos	- Y position on Canvas. out_YPos += out_YL, gives position to draw text for next debug line.
 */
simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	super.DisplayDebug(HUD, out_YL, out_YPos);

	// Driver
	if( Driver != None )
	{
		HUD.Canvas.SetDrawColor(255,0,0);
		HUD.Canvas.DrawText("DRIVER");
		out_YPos += out_YL;
		HUD.Canvas.SetPos(4, out_YPos);

		Driver.DisplayDebug(HUD, out_YL, out_YPos);
	}
}
simulated function TurretOverRotated()
{
	local GearAI_Cover DriveAI;

	if( Driver != None )
	{
		DriveAI = GearAI_Cover(Controller);
	}

	if( DriveAI != None )
	{
		DriveAI.NotifyTurretRotationClamped();
	}

	ViewRotVel = vect(0,0,0);
}

simulated function ProcessViewRotation(float DeltaTime, out rotator OutViewRot, out Rotator OutDeltaRot)
{
	// let parents have their way...
	super.ProcessViewRotation(DeltaTime, OutViewRot, OutDeltaRot);

	if( !InFreeCam() )
	{
		// then put the clamps on!
		TurretClampYaw(OutViewRot);
	}
}

simulated native event vector GetPhysicalFireStartLoc( vector FireOffset );


simulated native event Rotator GetViewRotation();

simulated function bool TurretClampYaw( out Rotator Rot )
{
	return false;
}

/** Overridden to get xhair when targeting. */
simulated function bool WantsCrosshair(PlayerController PC)
{
	return false;
}

defaultproperties
{
	Health=1200
	bCanBeDamaged=FALSE

	bNoDelete=FALSE
	bEnforceHardAttach=FALSE
	bBlockActors=FALSE
	bCollideActors=TRUE
	bCollideWorld=FALSE
	bNoEncroachCheck=TRUE

	Begin Object Name=CollisionCylinder
		CollisionHeight=50.000000
		CollisionRadius=15.000000
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=TRUE
		BlockActors=TRUE
		CollideActors=TRUE
		Translation=(X=70)
	End Object

	Begin Object Class=SkeletalMeshComponent Name=SkelMeshComponent0
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockActors=TRUE
		BlockRigidBody=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
		LightEnvironment=TurretLightEnvironment
		RBChannel=RBCC_Vehicle
	End Object
	Mesh=SkelMeshComponent0
	CollisionComponent=SkelMeshComponent0
	Components.Add(SkelMeshComponent0)

	TurretTurnRateScale=0.3
	AimingTurretTurnRateScale=0.45
	ExitPositions(0)=(X=-110)
	EntryPosition=(X=-110)
	bRelativeExitPos=TRUE
	bAttachDriver=FALSE
	bUpdateSimulatedPosition=false
	POV=(DirOffset=(X=-9,Y=2,Z=4.5),Distance=25,fZAdjust=-100)
	CannonFireOffset=(X=250,Y=0,Z=24)

	InventoryManagerClass=class'GearInventoryManager'

 	ViewPitchMin=-8000
 	ViewPitchMax=1500

	ViewOffset=(Pitch=-3414,Yaw=160)

	bRearMountOnly=false
	
	bDontPossess=false
	ControllerClass=class'GearAI_BlimpTurret'
}
