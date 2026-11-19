/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class JumpPoint extends PathNode
	native(TG);

/** List of destinations this node should try to create a jump spec to */
var() array<NavigationPoint> JumpDest;

