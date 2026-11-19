/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface NanoInterface_CanAffectChaos extends Interface;


///** This is the current Chaos Zone this is in **/
//var transient NanoVolume_ChaosZone CurrChaosZone;



simulated function NanoVolume_ChaosZone GetChaosZone()
{
	//return CurrChaosZone;
}

simulated function SetChaosZone( const NanoVolume_ChaosZone InChaosZone )
{
	//CurrChaosZone = InChaosZone;
}




defaultproperties
{

}