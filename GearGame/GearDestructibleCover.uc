/**
 * Destructible cover object that can optionally autogenerate its cover in the editor
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 **/

class GearDestructibleCover extends GearDestructibleObject
	placeable
	native;

struct native CoverLinkSpawnInfo
{
	var() bool bEnabled;
	var() vector Offset;

	structdefaultproperties
	{
		bEnabled=true
	}
};

/** If true, cover will automatically be set up for this object */
var() bool bAutogenerateCover;

/** Locations where cover slots should be spawned, relative to the cover object. 
 *  Delete entries from this array to get rid of cover on certain sides of the object.
*/
var() array<CoverLinkSpawnInfo> CoverLinkSpawnData;

cpptext
{
	virtual void PostScriptDestroyed();
	virtual void PostEditMove(UBOOL bFinished);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
}

native function InitializeCover();
native function DestroyCover();

defaultproperties
{
	bAutogenerateCover=TRUE

	CoverLinkSpawnData(0)={(Offset=(x=0.f,y=300.f,z=20.f))}
	CoverLinkSpawnData(1)={(Offset=(x=-300.f,y=0.f,z=20.f))}
	CoverLinkSpawnData(2)={(Offset=(x=0.f,y=-300.f,z=20.f))}
	CoverLinkSpawnData(3)={(Offset=(x=300.f,y=0.f,z=20.f))}
}


