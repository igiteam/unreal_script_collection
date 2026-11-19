/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class TGWeap_SmokeGrenade extends TGWeap_GrenadeBase;

var MeshComponent PickupMeshComp;

function TGProj_Grenade ThrowGrenade()
{
	//if (TGGame(WorldInfo.Game) != None)
	//{
	//	TGGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_ThrowingSmokeGrenade, Instigator);
	//}
	return super.ThrowGrenade();
}

/*
simulated function LinearColor GetWeaponEmisColor_COG()
{
	return WorldInfo.Gears_COGWeapons.GrenadeSmoke;
}

simulated function LinearColor GetWeaponEmisColor_Locust()
{
	return WorldInfo.Gears_LocustWeapons.GrenadeSmoke;
}
*/

static function PrimitiveComponent GetPickupMesh(PickupFactory Factory)
{
	return default.PickupMeshComp;
}


/** This will return the COG Emissive Color for this weapon for this map **/
// smokes are always this color
static simulated function LinearColor GetWeaponEmisColor_COG( WorldInfo TheWorldInfo, EWeaponClass WeapID )
{
	local LinearColor LC;

	LC.R = 1;
	LC.G = 3;
	LC.B = 8;
	LC.A = 1;

	return LC;
}

/** This will return the Locust Emissive Color for this weapon for this map **/
// smokes are always this color
static simulated function LinearColor GetWeaponEmisColor_Locust( WorldInfo TheWorldInfo, EWeaponClass WeapID )
{
	local LinearColor LC;

	LC.R = 1;
	LC.G = 3;
	LC.B = 8;
	LC.A = 1;

	return LC;
}


