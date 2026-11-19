/**
 * Pacifier Bot Limb - Grabby Arm
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class PacifierLimb_GrabArm extends Pacifier_LimbBase;

event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	// Pass collision along to the weapon
	Weapon.HandleTouch( Other, OtherComp );
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	Weapon.HandleTouch( Other, OtherComp );
}

simulated function bool PreventBotMovement()
{
	return IsDensed() || (Weapon != None && Weapon.IsFiring());
}

simulated function bool AbleToFire()
{
	if( IsDensed() )
	{
		return FALSE;
	}
	return Super.AbleToFire();
}

/////////////////////////////////////////////////////
//////// INTERFACE: NanoInterface_PowerAffect ////////
/////////////////////////////////////////////////////
simulated function bool CanBeDusted()
{
	return (CurrNanoState!=ENS_Dust);
}

simulated function bool CanBeDensed()
{
	return (CurrNanoState!=ENS_Dense);
}

simulated function bool SetNanoState(ENanoState NewState, Actor InInstigator, optional float NanoPowerAmount)
{
	local bool bReturnValue;
	bReturnValue = Super.SetNanoState(NewState, InInstigator, NanoPowerAmount);
	if( CurrNanoState == ENS_Dense )
	{
		Bot.Controller.MoveTimer = -1.f;
	}
	return bReturnValue;
}

/////////////////////////////////////////////////////
////// INTERFACE: NanoInterface_ActiveAttacker //////
/////////////////////////////////////////////////////
/** Get the number of attack slots this attacker consumes */
function int GetActiveAttackSlots()
{
	return 2;
}

defaultproperties
{
	SocketName=GrabHand
	MuzzleSocketName=GrabHand

	DefaultWeaponClass=class'NanoWeap_Pacifier_GrabHand'

	MaterialIndex=6

	Begin Object Class=StaticMeshComponent Name=StaticMesh0
    	StaticMesh=StaticMesh'EngineMeshes.Cube'
		BlockZeroExtent=TRUE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockRigidBody=FALSE
		HiddenGame=TRUE
		Scale3D=(X=0.5,Y=0.3,Z=0.3)
		Rotation=(Pitch=-8192,Yaw=0,Roll=0)
    End Object
	Components.Add(StaticMesh0)
	StaticMeshComp=StaticMesh0
	CollisionComponent=StaticMesh0
	RelLoc=(X=50,Y=0,Z=-25)

	// need this so the encroaching point check is done and we get collisions with lyrik to trigger the grab
	bNoEncroachCheck=FALSE
}