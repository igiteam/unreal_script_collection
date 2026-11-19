/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NAM_DenseBullets extends NanoAmmoModifier;

struct DenseBulletLevel
{
	/** 2D velocity to push juggled pawn */
	var() float JuggleMag;
	/** Whether target pawn must be falling already to be juggled */
	var() bool	bOnlyJuggleFallingTarget;
};
var() config array<DenseBulletLevel> ModLevel;

/** Returns max number of pips available for this modifier */
static function int GetMaxModLevel()
{
	return default.ModLevel.Length-1;
}

/** Returns max number of pips available for this modifier for the UI */
static function int GetMaxModLevelUI()
{
	return default.ModLevel.Length;
}

static function HandleAmmoImpact( int AmmoModLevel, Actor Victim, Controller InstigatedBy, out int Damage, vector HitLocation, TraceHitInfo HitInfo )
{
	local NanoInterface_JuggleTarget Targ;
	local Vector JuggleDir;
	local float JuggleMag;

	Targ = NanoInterface_JuggleTarget(Victim);
	if( Targ != None )
	{
		// If bullet level can affect ground targets or the target is falling already
		if( !default.ModLevel[AmmoModLevel].bOnlyJuggleFallingTarget || Victim.Physics == PHYS_Falling )
		{
			JuggleMag = default.ModLevel[AmmoModLevel].JuggleMag;

			JuggleDir = Normal(Victim.Location - InstigatedBy.Pawn.Location);  // we just want them pushed directly forward from our shot

			//Victim.DrawDebugLine( Victim.Location+vect(0,0,10), Victim.Location + JuggleDir * 128.f+vect(0,0,10), 0, 255, 0, TRUE );
			//Victim.DrawDebugLine( Victim.Location+vect(0,0,10), Victim.Location + HitDir * 128.f+vect(0,0,10), 255, 0, 0, TRUE );
 			//`log( `showvar(JuggleMag)@`showvar(JuggleZ)@`showvar(JuggleDir)@`showvar(HitDir)@"LookUp"@PC.PlayerInput.RawJoyLookUp@"LookRight"@PC.PlayerInput.RawJoyLookRight );

			// need to have a non-zero JuggleZ due to ApplyJuggleCode checking for a zero JuggleZ
			Targ.ApplyJuggle( JuggleMag, 1.0f, JuggleDir, NanoPawn(InstigatedBy.Pawn), TRUE );
		}
	}
}



defaultproperties
{
	WeaponsThisCanModify=(class'NanoWeap_MP7',class'NanoWeap_RicochetMoon')
}