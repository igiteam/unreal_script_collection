/**
 * Pacifier Bot Limb - Rocket Pack Wrapper Class
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class PacifierLimb_RocketPack_Wrapper extends Pacifier_LimbBase;

var PacifierLimb_RocketPack RightPack, LeftPack;

function InitLimb( NanoAI_PacifierBot C )
{
	AI = C;
	Bot = NanoPawn_MetaCorp_PacifierBotBase(C.Pawn);

	RightPack = Spawn(class'PacifierLimb_RocketPack', Owner);
	LeftPack  = Spawn(class'PacifierLimb_RocketPack', Owner);

	RightPack.Wrapper = self;
	RightPack.SocketName = 'RightRocketPack';
	RightPack.MuzzleSocketName = 'RightRocketMuzzle';
	RightPack.RelLoc = vect(-65,-100,-25);
	RightPack.MaterialIndex=3;

	LeftPack.Wrapper = self;
	LeftPack.SocketName = 'LeftRocketPack';
	LeftPack.MuzzleSocketName = 'LeftRocketMuzzle';
	LeftPack.RelLoc = vect(65,-100,-25);
	LeftPack.MaterialIndex=2;
	

	RightPack.InitLimb( C );
	LeftPack.InitLimb( C );

	SpawnDefaultWeapon();
}

function SpawnDefaultWeapon()
{
	local NanoWeap_Pacifier_RocketPack Weap;

	Super.SpawnDefaultWeapon();

	Weap = NanoWeap_Pacifier_RocketPack(Weapon);
	if( Weap != None )
	{
		Weap.Limb		= RightPack;
		Weap.RightPack	= RightPack;
		Weap.LeftPack	= LeftPack;

		RightPack.Weapon = Weap;
		LeftPack.Weapon = Weap;
	}
}

function SetEnabled( bool bInEnabled )
{
	Super.SetEnabled( bInEnabled );

	RightPack.SetEnabled( bInEnabled );
	LeftPack.SetEnabled( bInEnabled );
}


/** Allowed to fire at all... */
simulated function bool AbleToFire()
{
	return (RightPack.AbleToFire() || LeftPack.AbleToFire());
}

/////////////////////////////////////////////////////
//////// INTERFACE: NanoInterface_Targetable /////////
/////////////////////////////////////////////////////
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return FALSE;
}

/////////////////////////////////////////////////////
////// INTERFACE: NanoInterface_ActiveAttacker //////
/////////////////////////////////////////////////////
/** Get the number of attack slots this attacker consumes */
function int GetActiveAttackSlots()
{
	return 2;
}

function RegisterAsAttacker()
{
	RightPack.FireTarget = FireTarget;
	LeftPack.FireTarget = FireTarget;

	Super.RegisterAsAttacker();
}

function UnregisterAsAttacker()
{
	RightPack.FireTarget = FireTarget;
	LeftPack.FireTarget = FireTarget;

	Super.UnregisterAsAttacker();
}

function RegisterAsActiveAttacker()
{
	RightPack.FireTarget = FireTarget;
	LeftPack.FireTarget = FireTarget;

	Super.RegisterAsActiveAttacker();
}

function UnregisterAsActiveAttacker()
{
	RightPack.FireTarget = FireTarget;
	LeftPack.FireTarget = FireTarget;

	Super.UnregisterAsActiveAttacker();
}


defaultproperties
{
	DefaultWeaponClass=class'NanoWeap_Pacifier_RocketPack'
}
