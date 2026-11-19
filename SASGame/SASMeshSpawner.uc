//=============================================================================
// SASMeshSpawner.uc
//
//=============================================================================

class SASMeshSpawner extends StaticMeshActor;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

event PostBeginPlay()
{
	Super(Actor).PostBeginPlay();
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, class<DamageType> damageType, optional Weapon wpn)
{
	local Vector tTemp;
	local Rotator tTemp2;
	tTemp.z = 16;
	
	tTemp2.pitch = -5000 + (FRand() * 10000);
	tTemp2.yaw = -5000 + (FRand() * 10000);
	tTemp2.roll = -5000 + (FRand() * 10000);
	
	if (tTemp2.pitch<0)
		tTemp2.pitch-=4000;
	else
		tTemp2.pitch+=4000;
		
	Spawn( class'SASFloatyPaper',,, Location, tTemp2);
	Spawn( class'SASFloatyPaper',,, Location, tTemp2);
	Spawn( class'SASFloatyPaper',,, Location, tTemp2);
	Spawn( class'SASFloatyPaper',,, Location, tTemp2);
	Spawn( class'SASFloatyPaper',,, Location, tTemp2);
	Spawn( class'SASFloatyPaper',,, Location, tTemp2);
		
	Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType, wpn);
}

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    bStatic=false
}