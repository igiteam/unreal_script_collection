/**
 * The way for kismet to have a non Player based object give "events" is to make a Latent action and then
 * have it poll the non player object (e.g. a Manager Object of some sort) and the fire off events that way.
 *
 * The polling occurs in UpdateOp
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_ChaosTierChanged extends SeqAct_Latent
	native(Sequence);

/** This allows this object to keep track of the previous tier and then compare it against what the current tier is. s**/
var protected EChaosTier PrevTier;


cpptext
{
	//virtual void Activated();

	virtual UBOOL UpdateOp( FLOAT DeltaTime );

	//virtual void DeActivated();
}


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 8;
}


defaultproperties
{
	ObjCategory="Nano Procedural"
	ObjName="Chaos Tier Changed"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="NanoChaosZoneInfo",PropertyName=Targets,bWriteable=FALSE,MaxVars=1)
    bCallHandler=FALSE

	OutputLinks(0)=(LinkDesc="Chaos Tier Changed To 0 0<-1")

	OutputLinks(1)=(LinkDesc="Chaos Tier Changed To 1 0->1")
	OutputLinks(2)=(LinkDesc="Chaos Tier Changed To 1 1<-2")

	OutputLinks(3)=(LinkDesc="Chaos Tier Changed To 2 1->2")
	OutputLinks(4)=(LinkDesc="Chaos Tier Changed To 2 2<-3")
	
	OutputLinks(5)=(LinkDesc="Chaos Tier Changed To 3 2->3")
	OutputLinks(6)=(LinkDesc="Chaos Tier Changed To 3 3<-4")
	
	OutputLinks(7)=(LinkDesc="Chaos Tier Changed To 4 3->4")
	OutputLinks(8)=(LinkDesc="Chaos Tier Changed To 4 4<-5")
	
	OutputLinks(9)=(LinkDesc="Chaos Tier Changed To 5 4->5")

	PrevTier=ECT_Tier0
}
