/**
 * GearPawn_LayeredBase
 * Base class for layered animation
 * TEST
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_LayeredBase extends GearPawn_COGGear
	abstract
	config(Pawn)
	native(Pawn);

/** Definition of a layered character for easy switching */
struct native LayeredCharacterStruct
{
	var()   SkeletalMesh    SkelMesh;
	var()   PhysicsAsset    PhysAsset;
};
var()   Array<LayeredCharacterStruct> LayeredCharacterList;
var()   INT                         LayeredCharacterIndex;

/** Set Layered Character by Index 
 *  @param INDEX    Index of LayeredCharacterList
 */
simulated function SetLayeredCharacterByIndex(INT Index)
{
	// Check for out of bounds.
	if( Index >= LayeredCharacterList.Length )
	{
		`Warn(Self @ GetFuncName() @ "Index" @ Index @ "out of bounds" @ LayeredCharacterList.Length);
		return;
	}

	LayeredCharacterIndex = Index;

	Mesh.SetSkeletalMesh( LayeredCharacterList[LayeredCharacterIndex].SkelMesh );
	Mesh.SetPhysicsAsset( LayeredCharacterList[LayeredCharacterIndex].PhysAsset );
}

defaultproperties
{

}