/**
 * Troika Cabal turret
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class HDTurret_Base extends TGTurret
	//config(TGPawn)
	native(TG)
    notplaceable;

/** Spotter: defines target to shoot at */
var	HDBasePawn	Spotter;
/** Loader: reloads Troika */
var	HDBasePawn Loader;

/** Rotation of controller on turret bone (smoothed aiming) */
var rotator TurretControlRot;

/** Normal gunner track speed */
var()	float	TrackSpeed;
/** Speed of tracking when gunner has a spotter */
var()	float	TrackSpeedWithSpotter;
/** Speed of searching */
var()	float	SearchSpeed;

/** Target is too close, abandon gun */
var()	float	TooCloseDist;

/** Current marked location by spotter */
var		Vector	SpottedLoc;
/** Desired marked location by spotter */
var		Vector	DesiredSpottedLoc;

/** Turret look at controllers */
var SkelControlLookAt	Pivot_Latitude, Pivot_Longitude;

var	name	Pivot_Latitude_BoneName;
var name	MuzzleSocketName, PlayerRefSocketName ,FPViewSocketName,ZoomedViewSocketName;

/** Animation node playing the magazine spinning animation. */
var AnimNodeSequence	SpinSeqNode;

var float	EntryRadius;

var HDPlatform_DerrickWheels DerrickWheelsBody;
var rotator EnterWheelRot;

//var const ParticleSystem	BulletShells;
var ParticleSystemComponent     BulletShellsComponent;
var const name    BulletShellsSocketName;

var rotator AimDirOffset;
var rotator InitRotOffset;
var rotator LeaveRotOffset;
var float TurretRecoverSpeed;
var bool  bForceRecover;

//overload
//var() float CoolDownTime;
var(TurretCoolDown) float	TopOverload;
var(TurretCoolDown) float   OverloadPerBullet;
var(TurretCoolDown) float	CoolDownRate;

var() float HitDamage;
var() float FireSpread;
var() float AIHitDamage;
var() float AIFireSpread;

var() bool  bNoLimitYaw;

var() float NewDriverCylRad;
var transient vector BackedUpDriverCollisionSize;
var() bool bFreeEnterAndLeave;

var vector CurrViewLoc;

var int ControlSlowRate;

var MaterialInstanceConstant 		CoolDownMat;

var bool                       bZoomed;
var bool                       bCanZoom;
var PostProcessSettings			CachedSetting;

var vector CachedLeftIKLoc,CachedRightIKLoc;
var rotator CachedLeftIKRot,CachedRightIKRot;
var Pawn OldDriver;

replication
{
	if(bNetInitial)
		bNoLimitYaw;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

    //InitRotOffset = AimDir;
	// Cache animation nodes.
	AimDir = rot(0,0,0);
	CacheAnimNodes();
	//SetRotation(InitRotOffset);
}

simulated event ReplicatedEvent( name VarName )
{
	//`log( WorldInfo.TimeSeconds @ GetFuncName() @ "VarName:" @ VarName );

	super.ReplicatedEvent( VarName );

	if( VarName == 'FlashCount' )	// FlashCount and FlashLocation are changed when a weapon is fired.
	{
		FlashCountUpdated(MyWeapon, FlashCount, TRUE);
	}
	else if( VarName == 'FlashLocation' ) // FlashCount and FlashLocation are changed when a weapon is fired.
	{
		FlashLocationUpdated(MyWeapon, FlashLocation, TRUE);
	}
}

simulated function Destroyed()
{
	// Clear references to animations nodes
	ClearAnimNodes();

	Super.Destroyed();
}

simulated /*protected*/ function CacheAnimNodes()
{
	Pivot_Latitude	= SkelControlLookAt(Mesh.FindSkelControl('Pivot_Latitude'));
	Pivot_Longitude = SkelControlLookAt(Mesh.FindSkelControl('Pivot_Longitude'));
	SpinSeqNode		= AnimNodeSequence(Mesh.FindAnimNode('SpinSeqNode'));
}


/** Clear references to anim nodes. */
simulated function /*protected*/ ClearAnimNodes()
{
	Pivot_Latitude	= None;
	Pivot_Longitude	= None;
	SpinSeqNode		= None;
}

simulated event vector GetEntryLocation()
{
	local vector	EntryLoc;
	local rotator	EntryRot;

	// Get location of player reference socket.
	Mesh.GetSocketWorldLocationAndRotation(PlayerRefSocketName, EntryLoc, EntryRot);
	//EntryLoc.Z += 32.f;

	return EntryLoc ;
}

simulated function bool CanEnterVehicle(Pawn P)
{
	/*return (VSize(P.Location - GetEntryLocation()) <= EntryRadius &&
			Super.CanEnterVehicle(P));*/
	return (bFreeEnterAndLeave == true && super.CanEnterVehicle(P));
}

simulated function bool IsWithinRotationClamps(vector Loc)
{
	local rotator rot;
	local vector FireLoc;

	FireLoc			= GetPhysicalFireStartLoc( vect(0,0,0) );
	rot				= Rotator(Loc - FireLoc);
	return !TurretClampYaw(rot);
}

/************************************************************************************
 * AI
 ***********************************************************************************/

/**
 * Perform update for AI controller.
 * tracks targets and such...
 */
function UpdateAIController(TGAI_Cover C, float DeltaTime)
{
	local float		InterpSpeed, DistToTarg;
	local Vector	TargLoc, FireLoc;
	



	// by default, slowest speed
	InterpSpeed = SearchSpeed;

	// if we have a spotter, track faster what he's tracking
	if( Spotter != none )
	{
		InterpSpeed		= TrackSpeedWithSpotter;
	}

	// if we have a visible target, track it down
	if( C.HasValidTarget() )
	{
		InterpSpeed		= TrackSpeed;
		TargLoc			= C.GetFireTargetLocation();


		// if distance to target is inside our fire offset range
		DistToTarg = VSize(Location-TargLoc);
		if( C.FireTarget != self && DistToTarg < TooCloseDist )
		{
			// Notify AI that enemy is too close - abandon gun
			//C.TargetInsideFireArc();
			return;
		}

		FireLoc			= GetPhysicalFireStartLoc( vect(0,0,0) );
		DesiredAimDir	= Rotator(TargLoc - FireLoc);
	}
	// keep desired aim within limits
	if( TurretClampYaw(DesiredAimDir) )
	{
		
















		TurretOverRotated();
	}

	// Interpolate to the desired aim direction
	AimDir = RInterpTo( AimDir + Rotation, DesiredAimDir, DeltaTime, InterpSpeed );
	AimDir = AimDir - Rotation;
//    AimDir = DesiredAimDir;
	// Update controllers rotation
	//C.SetDesiredRotation(AimDir);
	//driver.SetRotation(AimDir);
}


/**
 * Called every second when AI is Idle.
 */
function AIIdleNotification(TGAI_Cover C)
{
	// pick a random orientation only if not guided by spotter
	if( (Spotter == None || !bSpottedSomething) && FRand() < 0.33 )
	{
		DesiredAimDir = GetRandomRotForTurretScan(C);
	}
}

function bool ClaimTurret( Controller C )
{
	local TGAI_Cover AI;

	if( super.ClaimTurret( C ) )
	{
		AI = TGAI_Cover(C);
		if( AI != None )
		{
			AI.CurrentTurret = self;
			//AI.bForceDesiredRotation = TRUE;
		}

		return TRUE;
	}

	return FALSE;
}

function bool UnclaimTurret( Controller C )
{
	local TGAI_Cover AI;

	if( super.UnclaimTurret( C ) )
	{
		AI = TGAI_Cover(C);
		if( AI != none )
		{
			AI.CurrentTurret = None;
			//AI.bForceDesiredRotation = FALSE;
		}

		return TRUE;
	}

	return FALSE;
}

final function OnAILeaveTurret( SeqAct_AILeaveTurret Action )
{
	if(AICmd_Base_TroikaGunner(TGAI_Cover(Controller).CommandList) != None)
	{
		AICmd_Base_TroikaGunner(TGAI_Cover(Controller).CommandList).LeaveTurret();
	}
}
/************************************************************************************
 * Spotter
 ***********************************************************************************/

/**
 * Returns TRUE if player can be a spotter for this Troika.
 */
function bool CanBeSpotter(TGAI_Cover C)
{
	// only allow one spotter per troika
	if( Spotter == None &&
		TGPawn(C.Pawn) != none )
	{
		return TRUE;
	}

	return FALSE;
}


/**
 * Called when a new AI guy become the spotter for the Troika
 */
function bool ClaimSpotter( TGAI_Cover AI )
{
	if( CanBeSpotter( AI ) )
	{
		Spotter = TGPawn(AI.Pawn);
		//bStasis	= FALSE;
		AI.CurrentTurret = self;

		return TRUE;
	}

	return FALSE;
}

function bool UnclaimSpotter( TGAI_Cover AI )
{
	if( Spotter == AI.Pawn ||
		(Spotter != None &&
			(Spotter.Controller == none || Spotter.Health <= 0)))
	{
		Spotter = None;
		bSpottedSomething = FALSE;
		AI.CurrentTurret = None;

		if( Claim == None )
		{
			//bStasis = TRUE;
		}

		return TRUE;
	}

	return FALSE;
}

function StartSpotting()
{
	local TGAI_Cover AI;

	AI = TGAI_Cover(Spotter.Controller);
	if( AI != None )
	{
		bSpottedSomething = TRUE;
		AI.Focus = AI.FireTarget;
	}
}

function StopSpotting()
{
	bSpottedSomething = FALSE;
	Spotter.Controller.Focus = None;
}

simulated function Tick(float DeltaTime)
{
	super.Tick( DeltaTime );
	UpdateTurret(DeltaTime);

	if( Driver != none )
	{
	    TMPawn(Driver).CurrentWeaponAttachment.Mesh.SetHidden(true);
		UpdateDriver(DeltaTime);
	}
	else if(AimDir != InitRotOffset)
	{
	    if(!bForceRecover)//fix me!
	    {
  			if((AimDir.Pitch - InitRotOffset.Pitch) > 0)
  			{
	    		AimDir.Pitch -= TurretRecoverSpeed * DeltaTime;
	    		if(AimDir.Pitch <= InitRotOffset.Pitch)
	    		{
	        		AimDir.Pitch = InitRotOffset.Pitch;
	    		}
	    	}
	    	else if((AimDir.Pitch - InitRotOffset.Pitch) < 0)
	    	{
          		AimDir.Pitch += TurretRecoverSpeed * DeltaTime;
	    		if(AimDir.Pitch >= InitRotOffset.Pitch)
	    		{
	        		AimDir.Pitch = InitRotOffset.Pitch;
	    		}
			}

			if((AimDir.Yaw - InitRotOffset.Yaw) > 0)
  			{
	    		AimDir.Yaw -= TurretRecoverSpeed * DeltaTime;
	    		if(AimDir.Yaw <= InitRotOffset.Yaw)
	    		{
	        		AimDir.Yaw = InitRotOffset.Yaw;
	    		}
	    	}
	    	else if((AimDir.Yaw - InitRotOffset.Yaw) < 0)
	    	{
          		AimDir.Yaw += TurretRecoverSpeed * DeltaTime;
	    		if(AimDir.Yaw >= InitRotOffset.Yaw)
	    		{
	        		AimDir.Yaw = InitRotOffset.Yaw;
	    		}
			}
	    }
	    else
	    {
           AimDir = InitRotOffset;
		}
	}
}

simulated event rotator GetDriverIdealRotation()
{
	return TurretControlRot;
}

simulated function UpdateTurret(float DeltaTime)
{
	local vector AimTargetWorld, AimTargetLoc, PivotLatLoc;
	// Get location of latitude pivot
	Mesh.GetSocketWorldLocationAndRotation(PlayerRefSocketName,PivotLatLoc, TurretControlRot);
    Mesh.GetSocketWorldLocationAndRotation(MuzzleSocketName,PivotLatLoc,,);


	//PivotLatLoc = Mesh.GetBoneLocation(Pivot_Latitude_BoneName);
	//RootRot = QuatToRotator(Mesh.GetBoneQuaternion(Root_BoneName));
	AimTargetWorld = PivotLatLoc + Vector(GetTurretAimDir() + Rotation) * 1024;
	AimTargetLoc = AimTargetWorld/*(AimTargetWorld - Location) << Rotation*/;		// the skelcontrols expect actor-local space

	if( Pivot_Latitude != none )
	{
		Pivot_Latitude.TargetLocation = AimTargetLoc/*(WorldInfo.NetMode != NM_Client || IsLocallyControlled()) ? AimTargetLoc : VInterpTo(Pivot_Latitude.TargetLocation, AimTargetLoc, DeltaTime, 2.0)*/;
	}
	if( Pivot_Longitude != none )
	{
		Pivot_Longitude.TargetLocation = AimTargetLoc/*(WorldInfo.NetMode != NM_Client || IsLocallyControlled()) ? AimTargetLoc : VInterpTo(Pivot_Longitude.TargetLocation, AimTargetLoc, DeltaTime, 2.0)*/;
	}
	// Use smooth location for pawn rotation as well
//	TurretControlRot = rotator(Pivot_Latitude.TargetLocation >> Rotation);

	if( SpinSeqNode != none )
	{
		if( FiringMode == class'TGWeapon'.const.FIREMODE_CHARGE || IsFiring() )
		{
			// If wasn't firing, make sure we start from zero.
			if( !SpinSeqNode.bPlaying )
			{
				SpinSeqNode.Rate = 0.f;
			}

			SpinSeqNode.bPlaying = TRUE;
			SpinSeqNode.Rate = FMin(SpinSeqNode.Rate + DeltaTime, 1.f);
		}
		else if( SpinSeqNode.bPlaying )
		{
			SpinSeqNode.Rate = FInterpTo(SpinSeqNode.Rate, 0.f, DeltaTime, 2.f);
			//SpinSeqNode.Rate = FMax(SpinSeqNode.Rate * (1.f - DeltaTime), 0.f);

			if( SpinSeqNode.Rate <= 0.001f )
			{
				SpinSeqNode.bPlaying = FALSE;
			}
		}
	}

//	if(Driver != none)
//	{
//	   `log("Translation.Z="$Driver.Mesh.Translation.Z);
//
//    }
}


//function bool PlaceExitingDriver(optional Pawn Who)
//{
//	// do not re position driver when exiting.
//	if(Who != none)
//	{
//      Who.SetLocation( Location );
//      return true;
//    }
//	return false;
//}


/**
 * Player just changed weapon
 * Network: Server, Local Player
 *
 * @param	OldWeapon	Old weapon held by Pawn.
 * @param	NewWeapon	new weapon held by Pawn.
 */
simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
	local TGWeapon	OldWeap, NewWeap;

	Super.PlayWeaponSwitch(OldWeapon, NewWeapon);

	OldWeap = TGWeapon(OldWeapon);
	NewWeap	= TGWeapon(NewWeapon);

	//`log("PlayWeaponSwitch OldWeapon:" $ OldWeapon @ "NewWeapon:" $ NewWeapon );
	// detach old weapon
	if( OldWeap != none )
	{
		OldWeap.DetachWeapon();
	}

	// attach new weapon
	if( NewWeap != none )
	{
		NewWeap.AttachWeaponTo(Mesh, 'rt_barrel_bone');
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
//simulated function TurretOverRotated()
//{
//	local TGAI_Cover DriveAI, SpotAI;
//
//	if( Driver != none )
//	{
//		DriveAI = TGAI_Cover(Controller);
//	}
//	if( Spotter != None )
//	{
//		SpotAI = TGAI_Cover(Spotter.Controller);
//	}
//
//	if( DriveAI != none )
//	{
//		DriveAI.NotifyTurretRotationClamped();
//	}
//	if( SpotAI != None )
//	{
//		SpotAI.NotifyTurretRotationClamped();
//	}
//
//	ViewRotVel = vect(0,0,0);
//}

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


simulated function bool CalcCamera(float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV)
{
	// don't do special camera stuff, normal camera works, using warcam_turret mode
	//return FALSE;
	//local rotator	TempRotation, AimRot;
	//local vector	CamLookAt, HitLocation, HitNormal;
	//local vector	dirX, dirY, dirZ;
	//local float		Elevation;

    local vector	ViewLoc;
	local rotator	ViewRot;
    //local vector PivotLatLoc;

	//AimRot = GetTurretAimDir();

	//CamLookAt = Mesh.GetBoneLocation( PitchBone ) + vector(AimRot) * 2048;
	//CamLookAt = Location + vector(AimRot) * 16384;

	// Base Direction (Only YAW)
//	TempRotation.Pitch	= 0;
//	TempRotation.Yaw	= AimRot.Yaw;
//	TempRotation.Roll	= 0;
//	GetAxes(TempRotation, dirX, dirY, dirZ);
//	out_CamLoc = Location + POV.Distance * (dirX*POV.DirOffset.X + dirY*POV.DirOffset.Y + dirZ*POV.DirOffset.Z);

	//Elevation = float(NormalizeRotAxis( AimRot.Pitch ));	// elevation angle the controller is aiming at

	// Z Adjust based on pitch
	if(bZoomed)
        Mesh.GetSocketWorldLocationAndRotation(ZoomedViewSocketName, ViewLoc, ViewRot);
	else
    	Mesh.GetSocketWorldLocationAndRotation(FPViewSocketName, ViewLoc, ViewRot);
	//PivotLatLoc = Mesh.GetBoneLocation(Pivot_Latitude_BoneName);
	//ViewLoc.Z += DerrickWheelsBody.BodyCtrl.BoneTranslation.Z;
	out_CamLoc = ViewLoc;

//	if( Trace( HitLocation, HitNormal, out_CamLoc, Location, false, vect(10, 10, 10) ) != none )
//	{
//		out_CamLoc = HitLocation + HitNormal * 10;
//	}

	//
	// rotate camera to match focus point
	//
	out_CamRot = ViewRot;//GetViewRotation();

    if ( TMWeapon(MyWeapon) != none)
    {
         TMWeapon(MyWeapon).WeaponCalcCamera(fDeltaTime, out_CamLoc, out_CamRot);
    }
	return true;
}


/** @See Pawn::FaceRotation */
simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
     local rotator DeltaRot;
	// short circuit camera for free cam.
	if(Controller == None)
	{
	  return;
    }
	if( InFreeCam() )
	{
		// only affect pitch in free cam.
		AimDir.Pitch = Controller.Rotation.Pitch;
		return;
	}

	// Define relative turret rotation as being the controller rotation
    if(HDPlayerController(Controller).PlayerInput != none)
	{
	    DeltaRot.Yaw	= HDPlayerController(Controller).PlayerInput.aTurn;
    	DeltaRot.Pitch	= HDPlayerController(Controller).PlayerInput.aLookUp;
	    DeltaRot.Yaw /= ControlSlowRate;
	    DeltaRot.Pitch /= ControlSlowRate;

        CalcTurretRotClient(DeltaRot,InitRotOffset,AimDirOffset);
        if(ROLE < ROLE_Authority)
        {
            ServerCalcTurretRot(AimDir);
        }
	}
}

reliable Server function bool ServerCalcTurretRot(Rotator AimRot)
{
    //return CalcTurretRotClient(deltaRot,IROffset,ADOffset);
    AimDir = AimRot;
    bNetDirty = true;
    return true;
}

//reliable sync function SyncTurretRot(Rotator AimRot)
//{
//    AimDir = AimRot;
//}

//simulated function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
//{
//	// otherwise, give a chance to controller to adjust this Aim Rotation
//	return Controller.GetAdjustedAimFor( W, StartFireLoc );
//}

function bool CalcTurretRotClient(Rotator deltaRot,Rotator IROffset,Rotator ADOffset)
{
    local int	DeltaFromCenter; //, YawAdj,PitchAdj;
	local bool	bResult;

    ADOffset.Pitch = NormalizeRotAxis(ADOffset.Pitch);
    ADOffset.Yaw = NormalizeRotAxis(ADOffset.Yaw);
	ADOffset.Yaw += deltaRot.Yaw;
	ADOffset.Pitch += deltaRot.Pitch;
	//DeltaFromCenter = NormalizeRotAxis(AimDirOffset.Yaw);
	if(!bNoLimitYaw)
	{
	    DeltaFromCenter =  ADOffset.Yaw - IROffset.Yaw;
		//DeltaFromCenter = NormalizeRotAxis(AimDirOffset.Yaw);
		if( DeltaFromCenter > YawLimit.Y )
		{
		    ADOffset.Yaw = IROffset.Yaw + YawLimit.Y;
			bResult = TRUE;
		}
		else if( DeltaFromCenter < YawLimit.X )
		{
			ADOffset.Yaw = IROffset.Yaw + YawLimit.X;
			bResult = TRUE;
		}
	}

    DeltaFromCenter = ADOffset.Pitch - IROffset.Pitch;
	//DeltaFromCenter = NormalizeRotAxis(AimDirOffset.Pitch);
	if( DeltaFromCenter > ViewPitchMax )
	{
		ADOffset.Pitch = IROffset.Pitch + ViewPitchMax;
		bResult = TRUE;
	}
	else if( DeltaFromCenter < ViewPitchMin )
	{
		ADOffset.Pitch = IROffset.Pitch + ViewPitchMin;
		bResult = TRUE;
	}

    AimDirOffset = ADOffset;
    AimDir = AimDirOffset /*+ DerrickWheelsBody.Rotation*/;
    bNetDirty = true;
	return bResult;
}

simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional vector HitLocation)
{
	// Play magazine spinning animation
//	if( SpinSeqNode != none )
//	{
//		SpinSeqNode.bPlaying = TRUE;
//	}
   local HDPawn HDP;
   local TGPawn TGP;
   local HDWeapon HDW;
   HDP = HDPawn(Driver);
   TGP = TGPawn(Driver);
   if(HDP != None)
   {
    if(HDP.CurrentWeaponAttachmentClass == none)
        Weapon.AttachWeaponTo(Mesh);
    HDP.CurrentWeaponAttachment.FirstPersonFireEffects(InWeapon, HitLocation);
    if ( HitLocation != Vect(0,0,0) && (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone || bViaReplication) )
	{
		HDP.CurrentWeaponAttachment.PlayImpactEffects(HitLocation);
	}
	//InWeapon.PlayFireEffects(FiringMode, HitLocation);
    //HDP.WeaponFired(InWeapon,bViaReplication,HitLocation);
   }
   //.hack
   else if(TGP != None)
   {
	InWeapon.PlayFireEffects(FiringMode, HitLocation);
	HDW = HDWeapon(InWeapon);
	if(HDW != None)
		HDW.PlayOwnedFireEffects(FiringMode,HitLocation);
   }
}

simulated function WeaponStoppedFiring(Weapon InWeapon, bool bViaReplication)
{
	// Stop magazine spinning animation
//	if( SpinSeqNode != none )
//	{
//		SpinSeqNode.bPlaying = FALSE;
//	}
   local HDPawn HDP;
   HDP = HDPawn(Driver);
   if(HDP != None)
   {
    //HDP.WeaponFired(InWeapon,bViaReplication);
   }
}

/** Overridden to get xhair when targeting. */
//simulated function bool WantsCrosshair(PlayerController PC)
//{
//	local GearPC GPC;
//	GPC = GearPC(Controller);
//	return ( (GPC != None) && GPC.bIsTargeting );
//}

simulated event Attach(Actor Other)
{
	Super.Attach(Other);

	// don't allow driver to become attached to us
	if (Other == Driver)
	{
		Other.SetBase(Base);
	}
}

simulated function AttachToPlatformWheels(HDPlatform_DerrickWheels DerrickWheels)
{
    local SkeletalMeshComponent wheelmesh;
    local SkeletalMeshSocket TurretSocket;
    wheelmesh = DerrickWheels.GetMesh();
	DerrickWheelsBody = DerrickWheels;

	//wheelmesh.AttachComponentToSocket(Mesh,DerrickWheels.GetTurretSocketName());

	SetBase(DerrickWheels);
	//wheelmesh.GetSocketWorldLocationAndRotation(DerrickWheels.GetTurretSocketName(),outPos,outRot);
	TurretSocket = wheelmesh.GetSocketByName(DerrickWheels.GetTurretSocketName());

	SetRelativeLocation(TurretSocket.RelativeLocation);
	SetRelativeRotation(TurretSocket.RelativeRotation);
	//wheelmesh.AttachComponentToSocket(Mesh,DerrickWheels.GetTurretSocketName());
	//SetHardAttach(true);
	//AimDirOffset = rot(0,0,0);

	Mesh.SetShadowParent(wheelmesh);
	Mesh.SetLightEnvironment(DerrickWheels.DerrickBody.LightEnvironment);
	//SetCollisionType(COLLIDE_NoCollision);
	//setPhysics(PHYS_None);

	//Mesh.ForcedLODModel = DerrickWheels.StaticMeshComponent.ForcedLODModel;

	if (DerrickWheels.bHidden)
	{
		SetTurretHidden(TRUE);
	}
	bFreeEnterAndLeave = false;
}

simulated function SetTurretHidden(bool bNewHidden)
{
	SetHidden(bNewHidden);

	if (bNewHidden)
	{
		SetCollision(FALSE, FALSE, TRUE);
	}
	else
	{
		SetCollision(default.bCollideActors, default.bBlockActors, default.bIgnoreEncroachers);
	}
}

function ReadyTurret();
function RecoverTurret();
native function CalcLeaveRot();

function OnFreeUseTurret(HDSeqAct_FreeUseTurret inAction)
{
  bFreeEnterAndLeave = inAction.FreeUseTurret;
}

reliable sync function bool SyncDriverLeave(bool bForceLeave)
{
    local bool ret;
	local HDWeapon HDW;
	local HDPawn HDP;
//	local HDHUD tmpHUD;
//    local PlayerController PC;
	if(bFreeEnterAndLeave == true  || bForceLeave)//
	{
		//InitLeaveRot = InitRotOffset;
		//InitLeaveRot.Pitch += 5000;
		//AimDir = InitLeaveRot;
        HDP = HDPawn(Driver);
		HDP.CurrentTurret = none;
		if(HDP != none)
		{
          HDP.StateBlend.SetActiveChild(0, 0.2f);
//          HDP.LeftHandIKController.BoneTranslationSpace = BCS_ParentBoneSpace;
//          HDP.RightHandIKController.BoneTranslationSpace = BCS_ParentBoneSpace;
//          HDP.LeftHandIKController.BoneRotationSpace = BCS_ParentBoneSpace;
//          HDP.RightHandIKController.BoneRotationSpace = BCS_ParentBoneSpace;
          HDP.LeftHandIK.EffectorLocationSpace = BCS_OtherBoneSpace;
          HDP.RightHandIK.EffectorLocationSpace = BCS_OtherBoneSpace;
          HDP.LeftHandIKRot.BoneRotationSpace = BCS_BoneSpace;
          HDP.RightHandIKRot.BoneRotationSpace = BCS_BoneSpace;

          HDP.LeftHandIK.EffectorLocation = CachedLeftIKLoc;
          HDP.RightHandIK.EffectorLocation = CachedRightIKLoc;
          HDP.LeftHandIKRot.BoneRotation = CachedLeftIKRot;
          HDP.RightHandIKRot.BoneRotation = CachedRightIKRot;
          HDP.CurrentWeaponAttachment.Mesh.SetHidden(false);
          HDP.Weapon.GotoState('Active');
        }
		RecoverTurret();
		//HDWeap_TurretBase(Weapon).CloseHUD();

//		if(HDPlayerController(Controller) != none)
//		{
//			tmpHUD = HDHUD(HDPlayerController(Controller).myHUD);
//			tmpHUD.CurrentVeh = none;
//		}

		CalcLeaveRot();
		if( bZoomed )
		  ZoomFireMode();

   		if( PlayerController(Controller).PlayerCamera != none)
  		    PlayerController(Controller).PlayerCamera.SetFOV(0);//Unlock FOV
		PlayerController(Controller).ResetFOV();
//        OldDriver = HDPawn(Driver);
		HDW = HDWeapon(Weapon);
		if(!HDW.IsFiring())
            HDW.TriFireCount = 0;
		ret = super.DriverLeave(bForceLeave);
		Driver.setPhysics(PHYS_Walking);

//		PC = PlayerController(OldDriver.Controller);
//		if(OldDriver != none)
//		{
//		  PC.bDuck = 0;
//		  PC.bProne = 0;
//          OldDriver.ShouldCrouchOrProne(false,false);
//        }
        return ret;
	}

	return false;
}

function bool DriverLeave( bool bForceLeave )
{
    return SyncDriverLeave(bForceLeave);
}

reliable sync function bool SyncDriverEnter(Pawn P)
{
  local vector ExitPos;
  local bool bRet;
  local HDPawn HDP;
  local PlayerController PC;
//  local HDHUD tmpHUD;
  ExitPos = P.Location - Location;
  AimDirOffset = InitRotOffset;
  ReadyTurret();

  if(TMPawn(P) != none)
  {
    SetWeaponFireProperties(HitDamage,FireSpread);
  }
  else
  {
    SetWeaponFireProperties(AIHitDamage,AIFireSpread);
    P.SetRotation(InitRotOffset);
  }

  HDP = HDPawn(P);
  if(HDP != none)
  {
      HDP.StateBlend.SetActiveChild(1, 0.2f);
      CachedLeftIKLoc = HDP.LeftHandIK.EffectorLocation;
      CachedRightIKLoc = HDP.RightHandIK.EffectorLocation;
      CachedLeftIKRot = HDP.LeftHandIKRot.BoneRotation;
      CachedRightIKRot = HDP.RightHandIKRot.BoneRotation;
//      HDP.LeftHandIKController.BoneTranslationSpace = BCS_WorldSpace;
//      HDP.RightHandIKController.BoneTranslationSpace = BCS_WorldSpace;
//      HDP.LeftHandIKController.BoneRotationSpace = BCS_WorldSpace;
//      HDP.RightHandIKController.BoneRotationSpace = BCS_WorldSpace;
      HDP.LeftHandIK.EffectorLocationSpace = BCS_WorldSpace;
      HDP.RightHandIK.EffectorLocationSpace = BCS_WorldSpace;
      HDP.LeftHandIKRot.BoneRotationSpace = BCS_WorldSpace;
      HDP.RightHandIKRot.BoneRotationSpace = BCS_WorldSpace;
      HDP.CurrentWeaponAttachment.Mesh.SetHidden(true);
  }
  PC = PlayerController(P.Controller);
  if(HDP != none)
  {
    if(PC != none)
    {
//        if(HDP.IsCrouch())
//           HDPlayerInput(PC.PlayerInput).Duck();
//        else if(HDP.IsProne())
//           HDPlayerInput(PC.PlayerInput).Prone();
//        HDPlayerInput(PC.PlayerInput).Duck();
       PlayerController(P.Controller).bDuck = 0;
       PlayerController(P.Controller).bProne = 0;
       HDP.ShouldCrouchOrProne(false, false);
    }
  }
  HDP.CurrentTurret = self;
  bRet = super.DriverEnter(P);
  P.setPhysics(PHYS_None);
  PlayerController(Controller).SetFOV(CameraFOV);
  ExitPositions[0] = ExitPos;
  if(DerrickWheelsBody != none)
   EnterWheelRot = DerrickWheelsBody.Rotation;


//  if(HDPlayerController(Controller) != none)
//  {
//    tmpHUD = HDHUD(HDPlayerController(Controller).myHUD);
//    tmpHUD.CurrentVeh = DerrickWheelsBody.DerrickBody;
//  }
//  Weapon.AttachWeaponTo(Mesh);
  MyWeapon.GotoState('Active');
  TriggerEventClass(class'HDSeqEvent_PlayerOnTurret', self);
  return bRet;
}

function bool DriverEnter(Pawn P)
{
  return SyncDriverEnter(P);
}

function SetWeaponFireProperties(float Damage,float spread)
{
	MyWeapon.InstantHitDamage[0] = Damage;
	MyWeapon.Spread[0] = spread;
}

native simulated function UpdateDriver(FLOAT DeltaTime);


simulated function OnGiveInventory(SeqAct_GiveInventory InAction)
{
  local HDPawn HDP;
  HDP = HDPawn(Driver);
  if(HDP != none)
  {
  	HDP.OnGiveInventory(InAction);
  }
}

simulated function OnGiveAmmo(HDSeqAct_GiveAmmo Action)
{
  local HDBasePawn HDP;
  HDP = HDBasePawn(Driver);
  if(HDP != none)
  {
   HDP.OnGiveAmmo(Action);
  }
}

simulated function DrivingStatusChanged()
{
	super.DrivingStatusChanged();
    if(WorldInfo.NetMode > NM_Standalone)
        return;

	if (bDriving)
	{
		// shrink radius of drivers cylinder
		// this is a hack to make him able to spin freely around the turret's fake collision
		BackedUpDriverCollisionSize = Driver.GetCollisionExtent();
		BackedUpDriverCollisionSize.Z = TMPawn(Driver).DefaultHeight;
		Driver.SetCollisionSize(NewDriverCylRad, BackedUpDriverCollisionSize.Z / 1.5);
		OldDriver = Driver;
	}
	else
	{
	    if(OldDriver != none)
    		OldDriver.SetCollisionSize(BackedUpDriverCollisionSize.X, BackedUpDriverCollisionSize.Z);
	}
}

function bool PlaceExitingDriver(optional Pawn Who)
{
 local vector HitLocation, HitNormal, NewActorPos;
 local Actor HitActor;
 local vector StartTrace, EndTrace, PawnExtent;
 local vector TraceUp;
/*
	local vector HitLocation, HitNormal, NewActorPos;
	local Actor HitActor;
	local vector TurretFwd, StartTrace, EndTrace, PawnExtent;
	local vector TraceUp;

	if (Who == None)
	{
		Who = Driver;
	}

	if (Who.Base == Base)
	{
		// try and place straight back
		PawnExtent = BackedUpDriverCollisionSize;

		TurretFwd = vector(Rotation);
		TurretFwd.Z = 0.f;
		TurretFwd = Normal(TurretFwd);

		TraceUp.Z = PawnExtent.Z*2.f;

		StartTrace = Location - (TurretFwd * (PawnExtent.X * 1.5f)) + TraceUp;
		EndTrace = StartTrace - TraceUp*2.f;

		HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true, PawnExtent);
		if (HitActor != None)
		{
//			FlushPersistentDebugLines();
//			DrawDebugBox(HitLocation, vect(10,10,10), 255, 255, 0, TRUE);
//			DrawDebugBox(HitLocation, PawnExtent, 255, 0, 0, TRUE);

			NewActorPos = HitLocation + vect(0,0,2.f);

			// back to local pos
			NewActorPos = (NewActorPos - Base.Location) << Base.Rotation;

			// assuming based on derrick
			if (Who.SetRelativeLocation(NewActorPos))
			{
				return TRUE;
			}
		}
	}

	// fall back to default behavior
	return Super.PlaceExitingDriver(Who);
*/
    if (Who == None)
	{
		Who = Driver;
	}
	if(Who != none)
	{
	  if(ExitPositions.Length > 0)
	  {
	      if(DerrickWheelsBody != none)
	      {
             PawnExtent = BackedUpDriverCollisionSize;

		     TraceUp.Z = PawnExtent.Z*2.f;

		     StartTrace = DerrickWheelsBody.Location +  ExitPositions[0] + TraceUp;
		     EndTrace = StartTrace - TraceUp*2.f;

		     HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true, PawnExtent);
		     if(HitActor != none)
		       NewActorPos = HitLocation + vect(0,0,2.f);
             else
               NewActorPos = DerrickWheelsBody.Location +  ExitPositions[0];
             Who.SetLocation( NewActorPos);
          }
          else
             Who.SetLocation( Location +  ExitPositions[0]);
      	  return true;
      }
    }
	return false;
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
    local Pawn P;
    if(Driver != none)
    {
     P = Driver;
     DriverLeave(false);
     P.OnTeleport(Action);
    }
}

simulated function ZoomFireMode()
{
    local TMPlayerController TMC;
   	local HDWeapon HDW;
	HDW = HDWeapon(MyWeapon);
    TMC = TMPlayerController(Controller);
    if( !bCanZoom )
        return;
    if(TMC != none)
    {
        bZoomed = !bZoomed;
        if(bZoomed)
        {
          TMC.StartZoomNonlinear(CameraTargetingFOV, 10.f);
          if(TMC.PlayerCamera != none)
          {
             TMC.PlayerCamera.SetFOV(CameraTargetingFOV);
          }
          HDW.SetZoomedState(ZST_Zoomed);
        }
        else
        {
          TMC.StartZoomNonlinear(CameraFOV,10.f);
          if(TMC.PlayerCamera != none)
          {
             TMC.PlayerCamera.SetFOV(CameraFOV);
          }
          HDW.SetZoomedState(ZST_NotZoomed);
        }
        if(ROLE < Role_Authority)
        {
            ServerSetTurretZoom(bZoomed);
        }
        //ToggleZoomPostProcess();
    }
}

reliable server function ServerSetTurretZoom(bool Zoomed)
{
    bZoomed = Zoomed;
}

simulated function ToggleZoomPostProcess()
{
	local HDWeapon HDW;
	HDW = HDWeapon(Weapon);
	if ( HDW == None ) return;

    if ( !bZoomed )
	{
        ClientResetDOF();
	}
	else
	{
		ClientCacheDefaultDOF();
		ClientSetDOFPostProcess( HDW.DOFSetting );
	}
}

reliable client function ClientCacheDefaultDOF()
{
    if ( ROLE >= ROLE_AutonomousProxy && IsLocallyControlled() )
    {
		CachedSetting.bEnableDOF = WorldInfo.DefaultPostProcessSettings.bEnableDOF;
		CachedSetting.DOF_BlurKernelSize = WorldInfo.DefaultPostProcessSettings.DOF_BlurKernelSize;
		CachedSetting.DOF_FalloffExponent = WorldInfo.DefaultPostProcessSettings.DOF_FalloffExponent;
		CachedSetting.DOF_FocusDistance = WorldInfo.DefaultPostProcessSettings.DOF_FocusDistance;
		CachedSetting.DOF_FocusInnerRadius = WorldInfo.DefaultPostProcessSettings.DOF_FocusInnerRadius;
		CachedSetting.DOF_MaxFarBlurAmount = WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount;
		CachedSetting.DOF_MaxNearBlurAmount = WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount;
    }
}

reliable client function ClientSetDOFPostProcess( PostProcessSettings DOFSetting )
{
	if ( ROLE >= ROLE_AutonomousProxy && IsLocallyControlled() )
	{
        WorldInfo.DefaultPostProcessSettings.bEnableDOF = DOFSetting.bEnableDOF;
		WorldInfo.DefaultPostProcessSettings.DOF_BlurKernelSize = DOFSetting.DOF_BlurKernelSize;
		WorldInfo.DefaultPostProcessSettings.DOF_FalloffExponent = DOFSetting.DOF_FalloffExponent;
		WorldInfo.DefaultPostProcessSettings.DOF_FocusDistance = DOFSetting.DOF_FocusDistance;
		WorldInfo.DefaultPostProcessSettings.DOF_FocusInnerRadius = DOFSetting.DOF_FocusInnerRadius;
		WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount = DOFSetting.DOF_MaxFarBlurAmount;
		WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount = DOFSetting.DOF_MaxNearBlurAmount;
    }
}

reliable client function ClientResetDOF()
{
	if ( ROLE >= ROLE_AutonomousProxy && IsLocallyControlled() )
	{
		WorldInfo.DefaultPostProcessSettings.bEnableDOF = CachedSetting.bEnableDOF;
		WorldInfo.DefaultPostProcessSettings.DOF_BlurKernelSize = CachedSetting.DOF_BlurKernelSize;
		WorldInfo.DefaultPostProcessSettings.DOF_FalloffExponent = CachedSetting.DOF_FalloffExponent;
		WorldInfo.DefaultPostProcessSettings.DOF_FocusDistance = CachedSetting.DOF_FocusDistance;
		WorldInfo.DefaultPostProcessSettings.DOF_FocusInnerRadius = CachedSetting.DOF_FocusInnerRadius;
		WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount = CachedSetting.DOF_MaxFarBlurAmount;
		WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount = CachedSetting.DOF_MaxNearBlurAmount;
    }
}

simulated function OnModifyHealth(SeqAct_ModifyHealth Action)
{
    if(Driver != none)
    {
        Driver.OnModifyHealth(Action);
    }
}

//function bool DriverEnter(Pawn P)
//{
//	local vector ExitPos;
//	local bool bRet;
//
//	ExitPos = P.Location - Location;
//	bRet = super.DriverEnter(P);
//	//`log("saved world pos"@P.Location@"saved local pos"@ExitPos);
//	ExitPositions[0] = ExitPos;
//
//	return bRet;
//}

//function OnHDPossess(HDSeqAct_HDPossess inAction)
//{
//   	local Pawn		OldPawn;
//	local Vehicle	V;
//	local HDPlatform_Derrick Derrick;
//    if( inAction.bTryToLeaveVehicle
//        && inAction.ActorToPossess != none )
//	{
////        V = Vehicle(inAction.ActorToPossess);
////	    Derrick = HDPlatform_Derrick(inAction.ActorToPossess);
////	    if(V != none )
////	    {
////          V.DriverLeave( true );
////        }
////        else
//        Derrick = HDPlatform_Derrick(inAction.ActorToPossess);
//        if(Derrick != None)
//        {
//          if(Derrick.TurretActor != none)
//          {
//            Derrick.TurretActor.DriverLeave( true );
//          }
//        }
//    }
//}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

