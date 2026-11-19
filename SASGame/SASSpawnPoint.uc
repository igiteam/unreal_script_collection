//=============================================================================
// SASSpawnPoint.uc
//=============================================================================

class SASSpawnPoint extends PlayerStart
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

var(PlayerStart) bool bDMStart;				// start can be used in deathmatch games
var(PlayerStart) bool bSSquadStart;			// start can be used in sabre squad games
var(PlayerStart) bool bCTFStart;			// start can be used in capture the flag games
var(PlayerStart) bool bKotHStart;			// start can be used in king of the hill games

var(PlayerStart) float					mOccupationDistance;			// Distance within which a pawn is considered to occupy this spawn point

var(Script) export editinline array<SASScriptTrigger>	mScriptTriggers;	// Script triggers

event PostBeginPlay()
{
	Super.PostBeginPlay();
}


// Is this spawnpoint occupied?
function bool isOccupied()
{
	local float		spawnPawnCollRadius,
					spawnPawnCollHeight;
	local float		verticalDist,
					distSq,
					minSpacing;
	local SASPawn	pawn;

	if ( mSpawnPawnClass != None )
	{
		spawnPawnCollRadius = mSpawnPawnClass.default.CollisionRadius;
		spawnPawnCollHeight = mSpawnPawnClass.default.CollisionHeight;
	}
	else
	{
		spawnPawnCollRadius = class'SASPawn'.default.CollisionRadius;
		spawnPawnCollHeight = class'SASPawn'.default.CollisionHeight;
	}

	foreach SASGameInfo(Level.Game).AllSASPawns (class'SASPawn', pawn)
	{
		verticalDist = Abs(pawn.Location.Z - Location.Z);
		if ( verticalDist > spawnPawnCollHeight + pawn.CollisionHeight )
		{
			continue;
		}

		minSpacing = Max( spawnPawnCollRadius + pawn.CollisionRadius, mOccupationDistance );
		distSq = Abs(VSizeHorizSq(pawn.Location - Location));
		if (distSq < Square( minSpacing ) )
		{
			return true;
		}
	}
	return false;
}


// Decompiled with UE Explorer.
defaultproperties
{
    mOccupationDistance=32.0000000
}