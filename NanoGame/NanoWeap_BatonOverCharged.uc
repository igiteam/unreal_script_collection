/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_BatonOverCharged extends NanoWeap_Baton;


defaultproperties
{
	WeaponSheetClass=class'NanoMeleeWeaponSheet_Baton'

	Begin Object Name=SparkLightcomp
		Radius=500
		Brightness=12
	End Object

	Begin Object Name=WeaponMeshComp
	    Scale3D=(X=4.0,Y=1.5,Z=1.5)
	End Object

}


