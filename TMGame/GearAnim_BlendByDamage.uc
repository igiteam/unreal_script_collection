
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_BlendByDamage extends GearAnim_BlendList
	native(TGAnim);

/** Internal cached pointer to TGPawn Owner */
var const	transient	TGPawn		MyTGPawn;
var()					float			Duration;
var						float			TimeToGo;
var()					float			BlendInTime, BlendOutTime;
var()					bool			bRequiresStoppingPower;
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

