/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
 class SeqEvt_NanoStateChanged extends SequenceEvent;
 
 defaultproperties
 {
	ObjName="Nano State Changed"
	ObjCategory="Nano"
 
 	OutputLinks(0)=(LinkDesc="Normal")
	OutputLinks(1)=(LinkDesc="Dust")
	OutputLinks(2)=(LinkDesc="Dense")
	
	bPlayerOnly=FALSE
}
