/**
 * This will hold all of our map specific data.
 *
 * examples:  AR light colors, ink cloud colors, weapon emissive light colors
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearMapSpecificInfo extends MapInfo
	editinlinenew
	hidecategories(Object)
	native;

/** This points to an archetype which will hold all of the per map color values **/
var() GearPerMapColorConfig ColorConfig;

/** list of MICs for manipulating kelp meshes in certain underwater levels */
var array<MaterialInstanceConstant> KelpMICs;

/** modifier to visibility/range calculations for player and AI targeting (range is 0.0 to 1.0) */
var() float VisibilityModifier;

/** whether or not enemies may spawn with mortars in Siege */
var() bool bAllowMortarInSiege;

/** list of labeled map locations for the MP overhead map */
var array<OverheadMapLocation> MapLocations;

simulated final function RegisterKelpStaticMesh(GearKelpStaticMeshActor Kelp)
{
	local int i, j, Elements;
	local MaterialInterface BaseMaterial;
	local MaterialInstanceConstant MIC;
	local LinearColor UnusedColor;

	Elements = Kelp.StaticMeshComponent.GetNumElements();
	for (i = 0; i < Elements; i++)
	{
		BaseMaterial = Kelp.StaticMeshComponent.GetMaterial(i);
		if (BaseMaterial != None && BaseMaterial.GetVectorParameterValue('Location', UnusedColor))
		{
			for (j = 0; j < KelpMICs.length; j++)
			{
				if (BaseMaterial == KelpMICs[j].Parent)
				{
					MIC = KelpMICs[j];
					break;
				}
			}
			if (MIC == None)
			{
				MIC = new(self) class'MaterialInstanceConstant';
				MIC.SetParent(BaseMaterial);
				KelpMICs.AddItem(MIC);
			}
			Kelp.StaticMeshComponent.SetMaterial(i, MIC);
		}
	}
}

defaultproperties
{
	VisibilityModifier=1.0
	bAllowMortarInSiege=true
}
