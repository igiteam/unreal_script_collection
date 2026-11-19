/**
 * Copyright 1998-2010 Epic Games, Inc. All Rights Reserved.
 */
class TMVWeap_TankTurret extends TMVehicleWeapon
	HideDropDown;

var name MuzzleBoneName;
var SoundCue CannonPulloverCue;
/**
 * GetAdjustedAim begins a chain of function class that allows the weapon, the pawn and the controller to make
 * on the fly adjustments to where this weapon is pointing.
 */

simulated function FireAmmunition()
{
    super.FireAmmunition();
    PlayFiringSound();
    SetTimer(0.6f,false,'CannonPullover');
}

function CannonPullover()
{
    PlaySound(CannonPulloverCue,true);
}

//simulated function Rotator GetAdjustedAim( vector StartFireLoc )
//{
//	local rotator R;
//
//	// Start the chain, see Pawn.GetAdjustedAimFor()
//	R = Instigator.GetAdjustedAimFor( Self, StartFireLoc );
//
//	if ( PlayerController(Instigator.Controller) != None )
//	{
//		R.Pitch = R.Pitch & 65535;
//		if ( R.Pitch < 16384 )
//		{
//			R.Pitch += (16384 - R.Pitch)/16;
//		}
//		else if ( R.Pitch > 49152 )
//		{
//			R.Pitch += 1024;
//		}
//	}
//	else
//	{
//		// due to the way SuggestTossVelocity() tests in increments combined with the high projectile speed,
//		// the bots tend to overshoot just a tiny bit, so we nudge their aim down a little here
//		R.Pitch -= 100;
//	}
//
//	return R;
//}

simulated function Projectile ProjectileFire()
{
//	if(Role==ROLE_Authority)
//	{
//		WeaponProjectiles[0] = TeamProjectiles[(MyVehicle.GetTeamNum()==1)?1:0];
//	}
    local vector muzzleLoc;
    muzzleLoc = MyVehicle.Mesh.GetBoneLocation(MuzzleBoneName);
    MyVehicle.Mesh.AddImpulse(vect(0,0,500), muzzleLoc,  MuzzleBoneName);
    TMVehicle_TankBase(MyVehicle).TankFire();
	return super.ProjectileFire();
}

