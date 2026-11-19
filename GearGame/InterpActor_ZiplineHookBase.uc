/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class InterpActor_ZiplineHookBase extends InterpActor
	abstract;

/** The anim sets for the player riding the zipline */
var() array<AnimSet> ZiplineAnimSets;
/** The anim tree for the player riding the zipline */
var() AnimTree ZiplineAnimTree;

defaultproperties
{
}
