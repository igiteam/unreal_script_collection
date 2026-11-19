/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 * Used to keep custom char assets alive after loading.
 */

class TMCharFamilyAssetStore extends Object
	native;

/** Id of family whose assets this is the store for. */
var const string			FamilyID;

/** Pointers to all objects contained within asset packages. */
var	const array<Object>		FamilyAssets;

/** Number of packages still waiting to be loaded. You need to wait for this to reach zero before calling StartCustomCharMerge */
var const int				NumPendingPackages;

/** Time that we started loading these assets. */
var const float				StartLoadTime;
