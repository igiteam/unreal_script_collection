/**
 * Player idling while sliding down the zipline
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_ZiplineIdle extends GearSpecialMove;

/** The max amount the player should be able to rotate from the base */
var const float MaxYawRotation;

var Vector  HandLocationIKOffset;
var Rotator HandRotationIKOffset;

var() Vector  RelativeLocationToHook;
var() Rotator RelativeRotationToHook;

var() InterpActor_ZiplineHookBase ZiplineBase;

var() bool bWasUnlimitedClips;

/**
 * Start the body animation, switch to the pistol, and force targeting
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearWeapon Weap;

	Super.SpecialMoveStarted(bForced, PrevMove);

	ZiplineBase = InterpActor_ZiplineHookBase(PawnOwner.Base);
	PawnOwner.AddLocalCustomAnimSets(ZiplineBase.ZiplineAnimSets);
	PawnOwner.Mesh.SetAnimTreeTemplate(ZiplineBase.ZiplineAnimTree);
	
	foreach PawnOwner.InvManager.InventoryActors(class'GearWeapon', Weap)
	{
		if (Weap.WeaponType == WT_Holster)
		{
			PawnOwner.InvManager.SetCurrentWeapon(Weap);

			// Set the pistol to infinite ammo with no reloading
			Weap.SetInfiniteMagazineSize();
			bWasUnlimitedClips = Weap.bInfiniteSpareAmmo;
			Weap.SetInfiniteSpareAmmo();

			// If the weapon is the boltok we need to up the fire rate
			if (Weap.Class == class'GearWeap_LocustPistol')
			{
				Weap.SetRateOfFire(120);
			}

			break;
		}
	}

	PawnOwner.bIgnoreBaseRotation = TRUE;
	PawnOwner.SetPhysics(PHYS_Interpolating);
	PawnOwner.SetRelativeLocation( RelativeLocationToHook );
	PawnOwner.SetRelativeRotation( RelativeRotationToHook );

	if( PawnOwner.Controller != None )
	{
		PawnOwner.Controller.bGodMode = TRUE;
	}

	if( PawnOwner.IKCtrl_LeftHand != None )		
	{ 
		PawnOwner.IKCtrl_LeftHand.EffectorLocationSpace = BCS_WorldSpace;
		PawnOwner.IKCtrl_LeftHand.SetSkelControlActive(TRUE);
		PawnOwner.IKCtrl_LeftHand.SetSkelControlStrength(1.0, 0.0);
	}
	
 	if( PawnOwner.IKRotCtrl_LeftHand != None )
 	{
 		PawnOwner.IKRotCtrl_LeftHand.bApplyRotation = TRUE;
 		PawnOwner.IKRotCtrl_LeftHand.BoneRotationSpace = BCS_WorldSpace;
 		PawnOwner.IKRotCtrl_LeftHand.SetSkelControlActive(TRUE);
 		PawnOwner.IKRotCtrl_LeftHand.SetSkelControlStrength(1.0, 0.0);
 	}	

	PawnOwner.Mesh.SetTickGroup(TG_PostAsyncWork);
	PawnOwner.SetTickGroup(TG_PostAsyncWork);

	UpdateIK();
}

/**
 * Stop the animation from playing and turn off forced targeting
 *
 * @param PrevMove - the previous special move to run
 * 
 * @param NextMove - the next special move to run
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearWeapon GWeapon;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Clear the ammo overriding
	GWeapon = GearWeapon(PawnOwner.Weapon);
	if (GWeapon != None)
	{
		GWeapon.ClearInfiniteMagazineSize();
		if( !bWasUnlimitedClips )
		{
			GWeapon.ClearInfiniteSpareAmmo();
		}
		GWeapon.ResetRateOfFire();
	}
	
	PawnOwner.bIgnoreBaseRotation = PawnOwner.default.bIgnoreBaseRotation;

	if( PawnOwner.IKCtrl_LeftHand != None )
	{
		PawnOwner.IKCtrl_LeftHand.SetSkelControlStrength(0.0, 0.0);
		PawnOwner.IKCtrl_LeftHand.SetSkelControlActive(FALSE);
	}

	if( PawnOwner.IKRotCtrl_LeftHand != None )
	{
		PawnOwner.IKRotCtrl_LeftHand.SetSkelControlStrength(0.0, 0.0);
		PawnOwner.IKRotCtrl_LeftHand.SetSkelControlActive(FALSE);
	}

	PawnOwner.Mesh.SetTickGroup(PawnOwner.default.Mesh.TickGroup);
	PawnOwner.SetTickGroup(PawnOwner.default.TickGroup);
}

/**
 * Restrict yaw rotation while riding the zipline
 * 
 * @param out_ViewRotation - the limited viewed rotation to pass to the camera system
 */
function LimitViewRotation(out Rotator out_ViewRotation)
{
	if( PawnOwner.Base != None && !PawnOwner.InFreeCam() )
	{
		out_ViewRotation.Yaw = ClampRotAxisFromBase( out_ViewRotation.Yaw, PawnOwner.Rotation.Yaw, MaxYawRotation );
	}
}

/**
 * Don't let the special move base class zero out the aim offset
 * 
 * @param DeltaRot - the current aim offset delta
 * 
 * @return FALSE to signify the aim offset should not be changed
 */
event bool DisableAimOffset()
{
	return FALSE;
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	UpdateIK();
}

simulated function UpdateIK()
{
	PawnOwner.IKCtrl_LeftHand.EffectorLocation = PawnOwner.Base.Location + HandLocationIKOffset;
	PawnOwner.IKRotCtrl_LeftHand.BoneRotation  = PawnOwner.Base.Rotation + HandRotationIKOffset;

/*
	PawnOwner.FlushPersistentDebugLines();
	PawnOwner.DrawDebugBox( PawnOwner.IKCtrl_LeftHand.EffectorLocation, vect(5,5,5), 255, 0, 0, TRUE );
	PawnOwner.DrawDebugLine( PawnOwner.IKCtrl_LeftHand.EffectorLocation, PawnOwner.IKCtrl_LeftHand.EffectorLocation + Vector(PawnOwner.IKRotCtrl_LeftHand.BoneRotation) * 128.f, 255, 0, 0, TRUE );

	PawnOwner.SetRelativeLocation( RelativeLocationToHook );
	PawnOwner.SetRelativeRotation( RelativeRotationToHook );
*/
}

defaultproperties
{
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'

	bCanSwitchWeapons=FALSE
	bDisableMovement=TRUE
	bLockPawnRotation=TRUE
	bDisallowDBNO=TRUE

	MaxYawRotation=11000

	HandLocationIKOffset=(X=2,Y=0,Z=0)
	HandRotationIKOffset=(Pitch=0,Yaw=0,Roll=0)

	RelativeLocationToHook=(X=-100,Y=-50,Z=10)
	RelativeRotationToHook=(Pitch=14164,Yaw=16690,Roll=-21418)
}