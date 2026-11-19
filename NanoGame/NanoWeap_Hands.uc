/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Hands extends NanoWeapon;


/** We do not drop hands into the world when we die. **/
function DropFrom(vector StartLocation, vector StartVelocity);

defaultproperties
{
	bMeleeWeapon=TRUE
	bAllowTargeting=TRUE
}
