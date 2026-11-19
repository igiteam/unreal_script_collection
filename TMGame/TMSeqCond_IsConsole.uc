/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSeqCond_IsConsole extends SequenceCondition;

event Activated()
{
	OutputLinks[ (Class'WorldInfo'.Static.IsConsoleBuild()) ? 0 : 1].bHasImpulse = true;
}


