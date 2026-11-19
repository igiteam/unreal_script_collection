/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvent_HordeWaveNotify extends SequenceEvent;

/** the wave number the notify is being sent for (base wave, not including loops) */
var int WaveNum;
/** "total" wave number, including loops (as displayed on HUD) */
var int TotalWaveNum;

event Activated()
{
	local GearGameHorde_Base Game;

	Game = GearGameHorde_Base(GetWorldInfo().Game);
	WaveNum = Game.CurrentWave;
	TotalWaveNum = WaveNum + (Game.MaxWaves * GearGRI_Horde(GetWorldInfo().GRI).ExtendedRestartCount);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjCategory="Gear"
	ObjName="Horde Wave Notification"
	bPlayerOnly=false
	MaxTriggerCount=0

	OutputLinks.Empty()
	OutputLinks[0]=(LinkDesc="Started")
	OutputLinks[1]=(LinkDesc="Success")
	OutputLinks[2]=(LinkDesc="Failure")

	VariableLinks.Empty()
	VariableLinks[0]=(ExpectedType=class'SeqVar_Int',LinkDesc="Wave #",bWriteable=true,PropertyName=WaveNum)
	VariableLinks[1]=(ExpectedType=class'SeqVar_Int',LinkDesc="Total Wave #",bWriteable=true,PropertyName=TotalWaveNum)
}
