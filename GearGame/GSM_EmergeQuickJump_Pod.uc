/**
 * Special move for quickly jumping out of PODS
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_EmergeQuickJump_Pod extends GSM_EmergeQuickJump;

simulated function PlayJump()
{
	Super(GSM_BaseVariableFall).PlayJump();
}

defaultproperties
{
	TakeoffVelocityVertMin=200.0
	TakeoffVelocityVertMax=300.0
}