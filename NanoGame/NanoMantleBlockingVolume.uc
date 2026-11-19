/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoMantleBlockingVolume extends BlockingVolume
	native;

/** If the NanoPawn::MantleLedgeCheck() hits this volume when checking for mantles listed in the array below, the mantle will be automatically disallowed */
var() array<NanoTypes.EMantleType> DisallowedMantleList;

defaultproperties
{
	bWorldGeometry=false

	DisallowedMantleList(0)=MANTLE_None
	DisallowedMantleList(1)=MANTLE_Ledge
	DisallowedMantleList(2)=MANTLE_Waist
	DisallowedMantleList(3)=MANTLE_WaistRoll
	DisallowedMantleList(4)=MANTLE_WallRun
	DisallowedMantleList(5)=MANTLE_Jump
	DisallowedMantleList(6)=MANTLE_EndingMantle
	DisallowedMantleList(7)=MANTLE_BigStep
	DisallowedMantleList(8)=MANTLE_FlipJump
	DisallowedMantleList(9)=MANTLE_ChestHigh
	DisallowedMantleList(10)=MANTLE_Hurdle
	DisallowedMantleList(11)=MANTLE_StepDown
	DisallowedMantleList(12)=MANTLE_AntennaRun
   
};