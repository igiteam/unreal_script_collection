/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_MoveAlongRoute extends SeqAct_Latent
	native(Sequence);

cpptext
{
	virtual void OnVariableConnect(USequenceVariable *Var, INT LinkIdx);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	void UpdateOutputLinks();
}

var() bool bRefresh;
var() editinline Route Route;
var() ERouteDirection RouteDirection;
var() EAIMoods InterruptOnMood;

var Actor LastReached;

defaultproperties
{
	ObjName="Move Along Route"
	ObjCategory="AI"

	InterruptOnMood=AIMood_Scared

	InputLinks(0)=(LinkDesc="Move Along Route")
	OutputLinks.Empty
	OutputLinks(0)=(LinkDesc="Interrupted")
	OutputLinks(1)=(LinkDesc="Reached Any")
	OutputLinks(2)=(LinkDesc="Finished")

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Route",PropertyName=Route)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Last Reached",PropertyName=LastReached,bWriteable=TRUE)
}
