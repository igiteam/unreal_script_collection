/**
 * Troika Cabal turret
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Turret_HarpoonBase extends Turret_TroikaBase
	abstract
	config(Pawn);

var() class<Gear_RappelRopeBase> RopeClass;

/** The start of the dynamic rope */
var Gear_RappelRopeBase RopeStart;

/** The end of the dynamic rope */
var Gear_RappelRopeBase RopeEnd;

/** The fake harpoon mesh */
var SkeletalMeshComponent FakeHarpoon;

/** Tangents, in local space to the Gear_RappelRopeBase actor */
var() protected const vector RopeStartTangentWhenAttached;
var() protected const vector RopeEndTangent;

var() protected const vector RopeStartRelLoc;

var protected transient GearAnim_BlendList	AnimBlendNode;
var protected transient AnimNodeSequence    ReloadAnimNode;

var protected BodyStance BS_DriverReload;

var protected SoundCue HarpoonFireSound;
var protected SoundCue HarpoonReloadSound;
var protected SoundCue HarpoonRopeReleaseSound;

/** Spawn the dynamic rope and the fake harpoon */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	RopeStart = Spawn(RopeClass);
 	RopeEnd = Spawn(RopeClass);

 	RopeStart.SetHardAttach(TRUE);
 	RopeEnd.SetHardAttach(TRUE);

 	RopeStart.AddConnectionTo(RopeEnd);
	RopeStart.SetHidden(TRUE);

	Mesh.AttachComponent(FakeHarpoon, 'Harpoon_Attach');

	AnimBlendNode = GearAnim_BlendList(Mesh.FindAnimNode('HarpoonBlendNode'));
	ReloadAnimNode = AnimNodeSequence(Mesh.FindAnimNode('Reload'));
}

/** Internal.  */
simulated protected function SetupRope(GearProj_HarpoonBase Harpoon)
{
	RopeStart.SetPhysics(PHYS_None);
	RopeStart.SetBase(Self,, Mesh, 'Harpoon_Attach');
	RopeStart.SetRelativeLocation(RopeStartRelLoc);
	RopeStart.SplineActorTangent = RopeStartTangentWhenAttached;

 	RopeEnd.SetBase(Harpoon);
 	RopeEnd.SetRelativeLocation(vect(0,0,0));
 	RopeEnd.SplineActorTangent = vect(0,0,0);

	RopeStart.SetHidden(FALSE);
}

/** Reload the weapon and unhide the fake harpoon */
simulated function HarpoonReload()
{
	local GearPawn DriverGP;

	GearWeapon(Weapon).AmmoUsedCount = 0;

	RopeStart.SetHidden(TRUE);
	FakeHarpoon.SetHidden(FALSE);

	// start reload anim
	ReloadAnimNode.SetPosition(0.f, FALSE);
	ReloadAnimNode.bPlaying = TRUE;
	AnimBlendNode.SetActiveChild(2, 0.f);

	// start reload anim on driver too
	DriverGP = GearPawn(Driver);
	if (DriverGP != None)
	{
		DriverGP.BS_Play(BS_DriverReload, 1.f, 0.1f, 0.15f);
	}

	PlaySound(HarpoonReloadSound, TRUE);
}

/**
 * Hide the fake harpoon and attach the dynamic rope to the projectile
 * 
 * @param Harpoon - the fired projectile
 */
simulated function HarpoonFired(GearProj_HarpoonBase Harpoon)
{
	FakeHarpoon.SetHidden(TRUE);
	SetupRope(Harpoon);
	AnimBlendNode.SetActiveChild(1, 0.05f);
	PlaySound(HarpoonFireSound, true);
}

simulated function DetachRope(vector DetachVel)
{
	local vector Grav;
	Grav = vect(0,0,1) * GetGravityZ();

	RopeStart.SetBase(None);
	RopeStart.SetPhysics(PHYS_Projectile);
	RopeStart.Velocity = DetachVel;
	RopeStart.Acceleration = Grav;

	PlaySound(HarpoonRopeReleaseSound, TRUE);
}

/** no crosshair, even if targeting */
simulated function bool WantsCrosshair(PlayerController PC)
{
	return FALSE;
}

simulated function bool ShouldShowWeaponOnHUD()
{
	return FALSE;
}


defaultproperties
{
	RopeStartTangentWhenAttached=(X=200)
	RopeStartRelLoc=(X=-5,Z=8)

	BS_DriverReload=(Stance=((Slot=BS_FullBody,AnimName="HarpoonTurret_Reload")))

	HarpoonFireSound=SoundCue'Weapon_MultiTurrets.HarpoonTurret.HarpoonTurret_Fire01_Cue'
	HarpoonReloadSound=SoundCue'Weapon_MultiTurrets.HarpoonTurret.HarpoonTurret_Reload01_Cue'
	HarpoonRopeReleaseSound=SoundCue'Weapon_MultiTurrets.HarpoonTurret.HarpoonTurret_RopeCut01_Cue'
}