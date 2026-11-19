/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCollectableActor extends NanoCollectableActorBase
	placeable;

enum ECollectableTypes 
{
	ECT_Normal,
	ECT_Rare,
	ECT_UltraRare,
	ECT_Mobile,
	ECT_FleeFromPlayer,
	ECT_NanoSmallAmount,
	ECT_NanoLargeAmount,
};


/** Which type of collectable this is. **/
var() ECollectableTypes CollectableType;


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	ChooseCollectable();
}


/** For now just set this on post begin play.**/
function ChooseCollectable()
{
	local class<Actor> ToSpawn;

	switch( CollectableType )
	{
	case ECT_Normal: ToSpawn = class'NanoCollectable_Normal'; break;
	case ECT_Rare: ToSpawn = class'NanoCollectable_Rare'; break;
	case ECT_UltraRare: ToSpawn = class'NanoCollectable_UltraRare'; break;
	case ECT_Mobile: ToSpawn = class'NanoCollectable_Mobile'; break;
	case ECT_FleeFromPlayer: ToSpawn = class'NanoCollectable_FleeFromPlayer'; break;
	case ECT_NanoSmallAmount: ToSpawn = class'NanoCollectable_NanoSmallAmount'; break;
	case ECT_NanoLargeAmount: ToSpawn = class'NanoCollectable_NanoLargeAmount'; break;

	default: ToSpawn = class'NanoCollectable_Normal'; break;

	}

	//`log( "Spawning" @ `showvar(ToSpawn) );
	Spawn( ToSpawn, ,, Location, Rotation );

}




defaultproperties
{
	Begin Object Class=SkeletalMeshComponent Name=TickMeshComp
		SkeletalMesh=SkeletalMesh'MET_TechTick.SK_MET_TechTick'
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object

	CollisionComponent=TickMeshComp
	Components.Add(TickMeshComp)
}


