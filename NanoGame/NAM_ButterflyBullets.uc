/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NAM_ButterflyBullets extends NanoAmmoModifier;

struct ButterflyBulletLevel
{
	/** 2D velocity to push juggled pawn */
	var() float JuggleMag;
	/** How much Z boost to give */
	var() float JuggleZ;
	/** Whether target pawn must be falling already to be juggled */
	var() bool	bOnlyJuggleFallingTarget;
};
var() config array<ButterflyBulletLevel> ModLevel;

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
	local Vector HitDir;

	local NanoPC NPC;

	Targ = NanoInterface_JuggleTarget(Victim);
	if( Targ != None )
	{
		//`log( "setting LastCausedJuggleActor" @ self );

		// JUGGLING
		// If hitting the pawn in an upward direction - try juggle
		HitDir = Normal(HitLocation-InstigatedBy.Pawn.Location);

		// we want to be able to juggle from standing on high so don't do this check
		//if( HitDir.Z > 0 )
		//{
			HitDir.Z = 0;
			HitDir = Normal(HitDir);

			// If bullet level can affect ground targets or the target is falling already
			if( !default.ModLevel[AmmoModLevel].bOnlyJuggleFallingTarget || Victim.Physics == PHYS_Falling )
			{
	        	NanoPawn(InstigatedBy.Pawn).LastCausedJuggleTime = InstigatedBy.WorldInfo.TimeSeconds;
		        NanoPawn(InstigatedBy.Pawn).LastCausedJuggleActor = Targ;

			    NPC = NanoPC(InstigatedBy);
				NPC.JuggleMag = default.ModLevel[AmmoModLevel].JuggleMag;
				NPC.JuggleZ = default.ModLevel[AmmoModLevel].JuggleZ;
				NPC.JuggleDir = HitDir;
				NPC.bDidJuggle = FALSE;

				//Targ.ResolveJuggleVars( InstigatedBy, JuggleMag, JuggleZ, JuggleDir, FALSE );

// 				Victim.DrawDebugLine( Victim.Location+vect(0,0,10), Victim.Location + JuggleDir * 128.f+vect(0,0,10), 0, 255, 0, TRUE );
// 				Victim.DrawDebugLine( Victim.Location+vect(0,0,10), Victim.Location + HitDir * 128.f+vect(0,0,10), 255, 0, 0, TRUE );
// 				`log( `showvar(JuggleMag)@`showvar(JuggleZ)@`showvar(JuggleDir)@`showvar(HitDir)@"LookUp"@PC.PlayerInput.RawJoyLookUp@"LookRight"@PC.PlayerInput.RawJoyLookRight );

				//Targ.ApplyJuggle( JuggleMag, JuggleZ, JuggleDir, NanoPawn(InstigatedBy.Pawn) );
			}
		//}
	}
}



defaultproperties
{
	WeaponsThisCanModify=(class'NanoWeap_MP7')
}