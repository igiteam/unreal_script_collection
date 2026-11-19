/**
 * GearPawnRidable_Base
 *
 * The base class for any ridable (vehicle-like) pawn.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawnRidable_Base extends GearPawn
	native(Pawn)
	config(Pawn)
	abstract;


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** GearPawn that is the driver */
var repnotify GearPawn Driver;

/** Copy of the Driver so the client can set the anim-tree when the driver detaches */
var	GearPawn BackupDriver;

/** GearPawn class to spawn for Driver */
var class<GearPawn> DriverClass;

/** Name of the socket that the driver should be attached to */
var Name DriverSocket;

/** The AnimTree for the driver */
var AnimTree DriverAnimTree;

/** The AnimSet for the driver */
var Array<AnimSet> DriverAnimSets;
/** Clear driver translation offset to zero when attached on the ridable pawn */
var bool bClearDriverTranslationOffset;

/** Sound cue to play when the pawn is dying */
var SoundCue DyingSound;

/** Whether this ridable pawn is controlled by a human player or not */
var bool bIsHumanControlled;

/**
 * Positions (relative to this pawn) to try putting the player when exiting. Optional -
 * automatic system for determining exitpositions if none is specified.
 */
var()	Array<Vector>	ExitPositions;

/** Radius for automatic exit positions. */
var	float ExitRadius;

/** Offset from center for Exit test circle. */
var	vector ExitOffset;

/** The damage modifier for the driver of this ridable pawn */
var config float DriverDamageModifier;

/** HUD action info associated with mounting this ridable pawn */
var const ActionInfo Action;

/** Whether the driver can take damage independent from this pawn */
var const bool bAllowDriverDamage;

/** Health bar to draw if bAllowDriverDamage is set */
var CanvasIcon HealthIcon;

/** The last time the health of the pawn changed */
var transient float LastHealthChangeTime;

/** Icon to draw if another player is taking cover on us */
var CanvasIcon CoverIcon;

/** Health is not replicated, so we must manually notify clients when ridable pawns are no longer ridable */
var bool bDeadVehicle;

cpptext
{
	/**
	 * The network code uses this to see if the driver can help establish relevance for replication.
	 *
	 * @param ReplicatedActor - actor being tested for relevance
	 *
	 * @param ActorOwner - actor which should be considered the owner of ReplicatedActor (normally ReplicatedActor->Owner)
	 *
	 * @return true if this actor should be considered relevancy owner for ReplicatedActor, which has bOnlyRelevantToOwner=true
	 */
	virtual UBOOL IsRelevancyOwnerFor(AActor* ReplicatedActor, AActor* ActorOwner);
}

/************************************************************************/
/* Replication Block                                                    */
/************************************************************************/

replication
{
	if (Role == ROLE_Authority)
		Driver, bDeadVehicle;
}

/************************************************************************/
/* Stub script functions for subclasses to define                       */
/************************************************************************/

simulated function EjectDriver();

/************************************************************************/
/* Overloaded script functions                                          */
/************************************************************************/

/** Overloaded so we can tell GearPCs to look for vehicles */
simulated function PostBeginPlay()
{
	local GearPC PC;

	Super.PostBeginPlay();

	ForEach LocalPlayerControllers(class'GearPC', PC)
	{
		PC.bCheckVehicles = TRUE;
	}
}

/** Need to make sure the driver is detached and cleaned up */
simulated function Destroyed()
{
	Super.Destroyed();

	// Detach the driver of the backup is valid
	if( BackupDriver != None )
	{
		DoDriverDetach( BackupDriver );
		BackupDriver = None;
	}

	// Clean up the driver
	if( Driver != None )
	{
		Driver.Destroy();
		Driver = None;
	}
}

/** Handle all replication events */
simulated event ReplicatedEvent( Name VarName )
{
	// See if we need to attach or detach the driver
	if( VarName == nameof(Driver) )
	{
		// Variable replication can get batched up in lag scenarios, remove stale driver as needed
		// Remove the old driver
		if (BackupDriver != None && Driver != BackupDriver)
		{
			DoDriverDetach(BackupDriver);
			BackupDriver = None;
		}

		// Attach a new driver
		if( Driver != None )
		{
			DoDriverAttachment(Driver);
			BackupDriver = Driver;
		}
	}
	else
	{
		Super.ReplicatedEvent( VarName );
	}
}

/** We're probably getting close to DBNO which we'll put in a bad state if we clear anims after it has started, we need to RPC to beat variable replication */
simulated reliable client function ClientForceDriverDetach()
{
	if (BackupDriver != None)
	{
		DoDriverDetach(BackupDriver);
		BackupDriver = None;
	}
}

/** No need for attachement visibility */
simulated function SetAttachmentVisibility(EAttachSlot Slot, class<Inventory> AttachClass);

/** Can't be special melee attacked **/
simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	return FALSE;
}


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Whether Pawn P is allowed to enter this ridable pawn */
simulated function bool CanEnterRidablePawn(GearPawn P, optional bool bIgnoreRange)
{
	return ( !bDeleteMe && !bTearOff && AnySeatAvailable() && !P.bIsCrouched && P.DrivenVehicle == None &&
		P.Controller != None && !P.IsA('Vehicle') && !P.IsA('GearPawnRidable_Base') && Health > 0 && !P.bCoveringHead );
}

/** If a seat is available for a pawn */
simulated function bool AnySeatAvailable()
{
	return (Driver == none);
}

/** Makes Pawn P became driver of this ridable pawn if he is able to be */
function bool TryToDrive(Pawn P)
{
	local GearPC PC;
	local GearPawn GP;

	PC = GearPC(P.Controller);
	GP = GearPawn(P);

	if (!CanEnterRidablePawn(GP))
	{
		// Not a human player or can't enter ridable pawn so bail
		return FALSE;
	}

	if (PC != None)
	{
		// Enter the ridable pawn
		PC.DriveRidablePawn(Self, TRUE);
	}
	else
	{
		SetDriver(GP, P.Controller);
	}

	return TRUE;
}

/**
 * Forces a given pawn out
 *
 * @param GP - the pawn to kick
 */
function KickPawn(GearPawn GP)
{
	if (Driver == GP)
	{
		DriverLeave(TRUE);
	}
}

/** Called from the Controller when player wants to get out */
event bool DriverLeave( bool bForceLeave )
{
	local Controller C;
	local PlayerController PC;
	local Rotator ExitRotation;

	if( Role < ROLE_Authority)
	{
		`Warn("DriverLeave() called on client");
		ScriptTrace();
		return FALSE;
	}

	// Do nothing if we're not being driven
	if( Controller == None && (Driver == None || Driver.Controller == None) )
	{
		return FALSE;
	}

	// Before we can exit, we need to find a place to put the driver.
	// Iterate over array of possible exit locations.
	if( Driver != None )
	{
		Driver.SetHardAttach(FALSE);
		Driver.bCollideWorld = TRUE;
		Driver.SetCollision(TRUE, TRUE);

		if( !PlaceExitingDriver() )
		{
			if( !bForceLeave )
			{
				// If we could not find a place to put the driver, leave driver inside as before.
				Driver.SetHardAttach(TRUE);
				Driver.bCollideWorld = FALSE;
				Driver.SetCollision(FALSE, FALSE);
				return FALSE;
			}
			else
			{
				Driver.SetLocation(GetTargetLocation());
			}
		}
	}

	ExitRotation = GetExitRotation(Controller);

	// Reconnect Controller to Driver.
	// Try and get the controller from the controller of this ridable pawn
	if( Controller != None )
	{
		C = Controller;
	}
	// then try the driver's controller
	else if( Driver != None && Driver.Controller != None )
	{
		C = Driver.Controller;
	}

	// Clear move targets
	if( C.RouteGoal == Self )
	{
		C.RouteGoal = None;
	}
	if( C.MoveTarget == Self )
	{
		C.MoveTarget = None;
	}

	// Unpossess the ridable pawn if the controller is the ridable pawn controller
	if( C != None && C == Controller )
	{
		Controller.UnPossess();
	}

	if( Driver != None && Driver.Health > 0 )
	{
		Driver.SetRotation(ExitRotation);
		Driver.SetOwner(C);

		// Possess the Driver if the controller is the ridable pawn controller
		C.Possess(Driver, TRUE);
		Driver.SetPhysics(PHYS_Falling);
		Driver.DropToGround();

		PC = PlayerController(C);
		if( PC != None )
		{
			// Set playercontroller to view the person that got out
			if( PC.GetViewTarget() != Driver )
			{
				PC.ClientSetViewTarget(Driver);
			}

			// Replicate those through RPC, so they get there fast enough...
			// Otherwise they take a few frames to reach the client, and transition isn't smooth.
			GearPC(PC).ClientSetLocationAndBase(Driver.Location, Driver.Base);
		}
		DoDriverDetach(Driver);
	}

	// If controller didn't change, clear it...
	if( C == Controller )
	{
		Controller = None;
	}

	// Force replication now.
	Driver.bForceNetUpdate = TRUE;
	bForceNetUpdate = TRUE;

	//WorldInfo.Game.DriverLeftVehicle(self, Driver);

	// Ridable pawn now has no driver
	Driver = None;
	return TRUE;
}

/** Returns the rotation for the pawn when it exits the ridable pawn */
function rotator GetExitRotation(Controller C)
{
	local rotator rot;
	rot.Yaw = Controller.Rotation.Yaw;
	return rot;
}

/**
 * Find an acceptable position to place the exiting driver pawn, and move it there.
 * Returns true if pawn was successfully placed.
 */
function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
	local int i;
	local vector tryPlace, Extent, HitLocation, HitNormal, ZOffset;

	if( ExitingDriver == None )
	{
		ExitingDriver = Driver;
	}
	if( ExitingDriver == None )
	{
		return FALSE;
	}

	Extent = ExitingDriver.GetCollisionRadius() * vect(1,1,0);
	Extent.Z = ExitingDriver.GetCollisionHeight();
	ZOffset = Extent.Z * vect(0,0,1);

	if( ExitPositions.Length > 0 )
	{
		// specific exit positions specified
		for (i = 0; i < ExitPositions.Length; i++)
		{
			if (ExitPositions[0].Z != 0)
			{
				ZOffset = Vect(0,0,1) * ExitPositions[0].Z;
			}
			else
			{
				ZOffset = ExitingDriver.CylinderComponent.default.CollisionHeight * vect(0,0,1);
			}

			tryPlace = Location + ( (ExitPositions[i]-ZOffset) >> Rotation) + ZOffset;

			//DrawDebugSphere(tryPlace, Extent.Z, 10, 255, 255, 255, TRUE);
			//DrawDebugSphere(Location + ZOffset, Extent.Z, 10, 255, 0, 255, TRUE);

			//`log(Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent));

			//DrawDebugSphere(HitLocation, 10, 10, 255, 0, 0, TRUE);

			// First, do a line check (stops us passing through things on exit).
			if (Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent) != None)
			{
				continue;
			}

			// Then see if we can place the player there.
			if (!ExitingDriver.SetLocation(tryPlace))
			{
				continue;
			}

			return TRUE;
		}
	}
	else
	{
		return FindAutoExit(ExitingDriver);
	}
	return FALSE;
}

/**
 * Tries to find exit position on either side of vehicle, in back, or in front
 * returns true if driver successfully exited
 */
function bool FindAutoExit(Pawn ExitingDriver)
{
	local vector FacingDir, CrossProduct;
	local float PlaceDist;

	FacingDir = vector(Rotation);
	CrossProduct = Normal(FacingDir cross vect(0,0,1));

	if (ExitRadius == 0)
	{
		ExitRadius = GetCollisionRadius() + ExitingDriver.VehicleCheckRadius;
	}
	PlaceDist = ExitRadius + ExitingDriver.GetCollisionRadius();

	return (TryExitPos(ExitingDriver, GetTargetLocation() + ExitOffset + PlaceDist * CrossProduct, false) ||
			TryExitPos(ExitingDriver, GetTargetLocation() + ExitOffset - PlaceDist * CrossProduct, false) ||
			TryExitPos(ExitingDriver, GetTargetLocation() + ExitOffset - PlaceDist * FacingDir, false) ||
			TryExitPos(ExitingDriver, GetTargetLocation() + ExitOffset + PlaceDist * FacingDir, false));
}

/* Used by PlaceExitingDriver() to evaluate automatically generated exit positions */
function bool TryExitPos(Pawn ExitingDriver, vector ExitPos, bool bMustFindGround)
{
	local vector Slice, HitLocation, HitNormal, StartLocation, NewActorPos;
	local actor HitActor;

	//DrawDebugBox(ExitPos, ExitingDriver.GetCollisionExtent(), 255,255,0, TRUE);

	Slice = ExitingDriver.GetCollisionRadius() * vect(1,1,0);
	Slice.Z = 2;

	// First, do a line check (stops us passing through things on exit).
	StartLocation = GetTargetLocation();
	if (Trace(HitLocation, HitNormal, ExitPos, StartLocation, false, Slice) != None)
	{
		return FALSE;
	}

	// Now trace down, to find floor
	HitActor = Trace(HitLocation, HitNormal, ExitPos - ExitingDriver.GetCollisionHeight()*vect(0,0,5), ExitPos, true, Slice);

	if (HitActor == None)
	{
		if (bMustFindGround)
		{
			return FALSE;
		}
		HitLocation = ExitPos;
	}

	NewActorPos = HitLocation + (ExitingDriver.GetCollisionHeight()+ExitingDriver.MaxStepHeight)*vect(0,0,1);

	// Check this wont overlap this vehicle.
	if (PointCheckComponent(Mesh, NewActorPos, ExitingDriver.GetCollisionExtent()))
	{
		return FALSE;
	}

	// try placing driver on floor
	return ExitingDriver.SetLocation(NewActorPos);
}

/** Set/Unset a new driver to this vehicle */
function SetDriver(GearPawn NewDriver, optional Controller AttachController)
{
	local GearPawn OldDriver;
	local float HealthRatio;
	local GearPRI PRI;

	OldDriver = Driver;
	// Assign new driver
	Driver = NewDriver;
	bForceNetUpdate = TRUE;

	if( Driver != None )
	{
		Driver.PreviousController = Driver.Controller;
		if( AttachController != None )
		{
			AttachController.UnPossess();
		}

		Driver.bCollideWorld = FALSE;
		SetDriverCollision();

		Driver.SetPhysics( PHYS_None );
		Driver.SetOwner( self );
		Driver.SetBase( None );

		if( Driver.InvManager != None )
		{
			Driver.InvManager.ClearPendingWeapon();
		}

		if( AttachController != None )
		{
			AttachController.Possess(Self, TRUE);
			AttachController.GotoState(LandMovementState);
		}

		OnDriverSet();

		// Attach driver
		DoDriverAttachment(Driver);

		// Scale the health against the player difficulty
		HealthRatio = float(Health) / float(DefaultHealth);

		PRI = GearPRI(PlayerReplicationInfo);
		if (PRI != None)
		{
			PRI.Difficulty.static.ApplyDifficultySettings(Controller);

			Health = HealthRatio * DefaultHealth;
		}
	}
	else
	{
		if( OldDriver != None )
		{
			OldDriver.SetOwner( None );
			OldDriver.SetBase( None );
			DoDriverDetach( OldDriver );
		}

		if( AttachController != None )
		{
			AttachController.UnPossess();
			if( OldDriver != None )
			{
				AttachController.Possess(OldDriver, TRUE);
			}
		}

		OnDriverUnset(OldDriver);
	}
}

simulated function bool CanBeBaseForPawn(Pawn APawn)
{
	// special case allow for driver
	return (APawn == Driver || Super.CanBeBaseForPawn(APawn));
}

function SetDriverCollision()
{
	Driver.SetCollision(TRUE, FALSE);
}

/** Event called when new Driver is Set. Called on server only. */
function OnDriverSet()
{
	AddDefaultInventory();
}

/** Event called when Driver is unset. Called on server only. */
function OnDriverUnset(GearPawn OldDriver)
{

}

/**
 *  Attaches the InDriver to this pawn to become the driver
 *  Called on all netmodes.
 */
simulated function DoDriverAttachment(GearPawn InDriver)
{
	local int i;
	local MeshComponent MeshComp;

	// Attach the driver to the correct socket
	InDriver.SetHardAttach(TRUE);
	InDriver.SetBase(self,, Mesh, DriverSocket);

	// Disable the mesh translation since we are attaching to a socket
	InDriver.bDisableMeshTranslationChanges = TRUE;
	InDriver.bCanDBNO = FALSE;
	// Do this to avoid weird collision
	InDriver.bDisableKicksCorpseAfterRecovery = TRUE;

	if( InDriver.Mesh != None )
	{
		if( Mesh != None )
		{
			InDriver.Mesh.SetShadowParent(Mesh);
		}
		if( bClearDriverTranslationOffset )
		{
	 		InDriver.Mesh.SetTranslation(vect(0,0,0));
		}
		else
		{
			InDriver.Mesh.SetTranslation(InDriver.default.Mesh.Translation);
		}

	 	InDriver.Mesh.SetLightEnvironment(LightEnvironment);

		for (i = 0; i < InDriver.Mesh.Attachments.Length; i++)
		{
			MeshComp = MeshComponent(InDriver.Mesh.Attachments[i].Component);
			if (MeshComp != None)
			{
				MeshComp.SetLightEnvironment(LightEnvironment);
			}
		}
	}
	Driver.LightEnvironment.SetEnabled(FALSE);

	// Switch Driver AnimTree if needed
	if( DriverAnimTree != None && DriverAnimTree != InDriver.Mesh.AnimTreeTemplate )
	{
		// Add necessary AnimSets
		InDriver.AddAnimSetsToKismetArray( DriverAnimSets );

		// Backup his original Animation Tree.
		InDriver.RecoverFromRagdollAnimTree = InDriver.Mesh.AnimTreeTemplate;
		// Set driver AnimTree
		InDriver.Mesh.SetAnimTreeTemplate(DriverAnimTree);
	}

	LastHealthChangeTime = WorldInfo.TimeSeconds;
}

/** Detaches the driver from this pawn */
simulated function DoDriverDetach(GearPawn OldDriver)
{
	local rotator NewRot;
	local int i;
	local MeshComponent MeshComp;

	// ReEnable the mesh translation
	OldDriver.bDisableMeshTranslationChanges = FALSE;
	OldDriver.bCanDBNO = OldDriver.default.bCanDBNO;
	OldDriver.bDisableKicksCorpseAfterRecovery = OldDriver.default.bDisableKicksCorpseAfterRecovery;

	if( OldDriver.Mesh != none )
	{
		OldDriver.Mesh.SetTranslation(OldDriver.default.Mesh.Translation);
		OldDriver.Mesh.SetShadowParent(None);

		OldDriver.Mesh.SetLightEnvironment(OldDriver.LightEnvironment);
		for (i = 0; i < OldDriver.Mesh.Attachments.Length; i++)
		{
			MeshComp = MeshComponent(OldDriver.Mesh.Attachments[i].Component);
			if (MeshComp != None)
			{
				MeshComp.SetLightEnvironment(OldDriver.LightEnvironment);
			}
		}

		NewRot = OldDriver.Mesh.Rotation;
		NewRot.Roll = 0;
		OldDriver.Mesh.SetRotation(NewRot);
	}
	OldDriver.LightEnvironment.SetEnabled(TRUE);

	// Restore driver AnimTree
	if( OldDriver.RecoverFromRagdollAnimTree != None &&
	   OldDriver.Mesh.AnimTreeTemplate != OldDriver.RecoverFromRagdollAnimTree )
	{
		OldDriver.Mesh.SetAnimTreeTemplate(OldDriver.RecoverFromRagdollAnimTree);
		OldDriver.RecoverFromRagdollAnimTree = None;

		// Remote pawns might get bCoveringHead while still having the wrong anim tree on
		if (OldDriver.bCoveringHead)
		{
			OldDriver.ReplicatedEvent('bCoveringHead');
		}
	}

	// Remove Driver AnimSets
	OldDriver.RemoveAnimSetsFromKismetArray( DriverAnimSets );

	// Make the bloodmount stop moving
	Acceleration = vect(0,0,0);
}

/**
 * If health goes to 0 or below, disable driving
 *
 * @param Damage - how much damage was applied
 *
 * @param EventInstigator - who gets credit for the damage
 *
 * @param HitLocation - where the damage should be applied
 *
 * @param Momentum - how much force should be transferred to us by the damage
 *
 * @param DamageType - the type of damage inflicted
 *
 * @param HitInfo - misc information about the line trace used to detect damage
 */
function DoDamageEffects(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, const out TraceHitInfo HitInfo)
{
	Super.DoDamageEffects( Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo );

	if (Health <= 0)
	{
		bDeadVehicle = TRUE;
	}

	LastHealthChangeTime = WorldInfo.TimeSeconds;
}

/** Show the health bar */
simulated function ReplicatedPlayTakeHitEffects()
{
	LastHealthChangeTime = WorldInfo.TimeSeconds;

	Super.ReplicatedPlayTakeHitEffects();
}

/** Forward that to Rider as well. for sync'd animations. */
simulated function ProcessGearPlayerAnim(SeqAct_GearPlayerAnim InAction, bool bPlay)
{
	Super.ProcessGearPlayerAnim(InAction, bPlay);

	if( Driver != None )
	{
		Driver.ProcessGearPlayerAnim(InAction, bPlay);
	}
}

/** Make sure the driver is killed on suicide */
function Suicide()
{
	// in Siege we don't want exiting players to leave Pawns around, vehicle or not
	if (GearGameSiege_Base(WorldInfo.Game) != None && IsHumanControlled())
	{
		KilledBy(self);
	}
	else if (Driver != None)
	{
		Driver.KilledBy(Driver);
	}
	else
	{
		KilledBy(Self);
	}
}

/**
 * Whether we should draw an icon to show a player is taking cover on us
 *
 * @return FALSE because the default behavior is to never show an icon
 */
simulated function bool ShouldDrawCoverIcon()
{
	return FALSE;
}

/**
 * Scale damage by DriverDamageModifier
 *
 * @param Damage - damage to give to the driver
 *
 * @param InstigatedBy - the causer of the damage
 *
 * @param HitLocation - where the damage happened
 *
 * @param Momentum - momentum applied by the damage
 *
 * @param DamageType - the class of damage inflicted
 */
function AdjustDriverDamage(out int Damage, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	Damage *= DriverDamageModifier;
}

defaultproperties
{
	bCanDo360AimingInCover=FALSE
	bRespondToExplosions=FALSE
	bCanDBNO=FALSE
	bCanBeBaseForPawns=TRUE
	bNoEncroachCheck=TRUE
	bCanSwim=FALSE
	bCanClimbLadders=FALSE
	PelvisBoneName=None

	bClearDriverTranslationOffset=TRUE

	Action={(
		ActionName=RidablePawn,
		ActionIconDatas=((ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // X Button
						 (ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=109,V=429,UL=68,VL=71)))),
		)}
}
