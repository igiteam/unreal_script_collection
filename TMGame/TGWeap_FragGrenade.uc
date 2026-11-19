
/**
 * TGWeap_FragGrenade
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class TGWeap_FragGrenade extends TGWeap_GrenadeBase;

/** projectile behavior upgrade */
var()	TWeaponParam	PRM_Behavior;

var MeshComponent PickupMeshComp;


/**
 * ThrowGrenade Projectile
 */
function TGProj_Grenade ThrowGrenade()
{
	if ( WorldInfo.NetMode != NM_Client )
	{
		//TGGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_ThrowingFragGrenade, Instigator);
	}
	return super.ThrowGrenade();
}

/*
simulated function LinearColor GetWeaponEmisColor_COG()
{
	return WorldInfo.Gears_COGWeapons.GrenadeFrag;
}

simulated function LinearColor GetWeaponEmisColor_Locust()
{
	return WorldInfo.Gears_LocustWeapons.GrenadeFrag;
}
*/

static function PrimitiveComponent GetPickupMesh(PickupFactory Factory)
{
	return default.PickupMeshComp;
}


/** This will return the COG Emissive Color for this weapon for this map **/
// frags are always this color
static simulated function LinearColor GetWeaponEmisColor_COG( WorldInfo TheWorldInfo, EWeaponClass WeapID )
{
	local LinearColor LC;

	LC.R = 15;
	LC.G = 2;
	LC.B = 0;
	LC.A = 0;

	return LC;
}

/** This will return the Locust Emissive Color for this weapon for this map **/
// frags are always this color
static simulated function LinearColor GetWeaponEmisColor_Locust( WorldInfo TheWorldInfo, EWeaponClass WeapID )
{
	local LinearColor LC;

	LC.R = 15;
	LC.G = 2;
	LC.B = 0;
	LC.A = 0;

	return LC;
}



