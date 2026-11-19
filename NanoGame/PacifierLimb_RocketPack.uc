/**
 * Pacifier Bot Limb - Back Gun
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class PacifierLimb_RocketPack extends Pacifier_LimbBase;

var config int NumRocketsToDropOnDust;

var PacifierLimb_RocketPack_Wrapper Wrapper;

function GetWeaponFireInfo( out Vector out_FireStart, out Rotator out_FireDir, optional out Actor out_Target )
{
	Super.GetWeaponFireInfo( out_FireStart, out_FireDir, out_Target );
	out_FireDir = Rotator(vect(0,0,1));
}

function bool ChooseTarget()
{
	return (FireTarget != None);
}

function bool CanFire()
{
	return FALSE;
}

simulated function bool AbleToFire()
{
	local Vector	FireStart;
	local Rotator	FireDir;
	local Actor		TargetActor;

	if( !bEnabled || Health <= 0 )
	{
		return FALSE;
	}
	if( IsDusted() )
	{
		return FALSE;
	}

	if( FireTarget != None )
	{
		GetWeaponFireInfo( FireStart, FireDir, TargetActor );
		if( !AI.CanSeeByPoints( FireStart, TargetActor.Location, Rotator(TargetActor.Location-FireStart) ) )
		{
			return FALSE;
		}

		if( FastTrace( FireStart + vect(0,0,256.f), FireStart ) )
		{
			return TRUE;
		}
	}
	
	return FALSE;
}


function float GetFireDelay()
{
	return 10.f+(5.f*FRand());
}

function DropRocket() 
{
	local NanoProj_Pacifier_Rocket Proj;

	NumRocketsToDropOnDust--;
	if( NumRocketsToDropOnDust > 0 )
	{
		SetTimer( 0.5f, FALSE, nameof(DropRocket) );
	}
	Proj = Spawn(class'NanoProj_Pacifier_Rocket', Bot,, Location, Rotator(vect(0,0,-1)) );
	Proj.Instigator = Bot;
	Proj.DropRocket();
}

/////////////////////////////////////////////////////
////// INTERFACE: NanoInterface_ActiveAttacker //////
/////////////////////////////////////////////////////
function RegisterAsAttacker();
function UnregisterAsAttacker();
function RegisterAsActiveAttacker();
function UnregisterAsActiveAttacker();

function bool AllowedToActivelyAttackTarget()
{
	return Wrapper.AllowedToActivelyAttackTarget();
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
	return FALSE;
}

simulated function bool SetNanoState(ENanoState NewState, Actor InInstigator, optional float NanoPowerAmount)
{
	local bool bAttemptStateChange;
	local bool bReturnValue;


	if( NewState != CurrNanoState )
	{
		bAttemptStateChange = TRUE;
	}

	bReturnValue = Super.SetNanoState(NewState, InInstigator, NanoPowerAmount);

	if( bAttemptStateChange && CurrNanoState == ENS_Dust )
	{
		NumRocketsToDropOnDust = default.NumRocketsToDropOnDust;
		SetTimer( 0.5f, FALSE, nameof(DropRocket) );
	}

	return bReturnValue;
}

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=StaticMesh0
    	StaticMesh=StaticMesh'EngineMeshes.Cube'
		BlockZeroExtent=TRUE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockRigidBody=FALSE
		HiddenGame=TRUE
		Scale3D=(X=0.33,Y=0.25,Z=0.66)
    End Object
	Components.Add(StaticMesh0)
	StaticMeshComp=StaticMesh0
	CollisionComponent=StaticMesh0
}