/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_HordeWaveNotify extends SequenceEvent;

var int WaveNumber;

event Activated()
{
	WaveNumber = GearGameHorde_Base(GetWorldInfo().Game).CurrentWave;
}

defaultproperties
{
	ObjName="Horde Wave Notification"
	ObjCategory="Multiplayer"

	VariableLinks.Empty()
	VariableLinks[0]=(ExpectedType=class'SeqVar_Int',LinkDesc="Wave",bWriteable=true,PropertyName=WaveNumber)

	OutputLinks[0]=(LinkDesc="Wave Start")
	OutputLinks[1]=(LinkDesc="Wave End (Success)")
	OutputLinks[2]=(LinkDesc="Wave End (Failure)")

	bPlayerOnly=false
	MaxTriggerCount=0
}
