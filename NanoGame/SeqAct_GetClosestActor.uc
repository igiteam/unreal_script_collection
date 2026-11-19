/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * SeqAct_GetClosestActor:  Outputs the actor that is closest to the specified Target.  If more than one target is specified, the centroid of the specified targets will be used
 */
class SeqAct_GetClosestActor extends SequenceAction
	native(Sequence);
	
cpptext
{
	void Activated();
}

var array<Actor> PotentialActors;
var Actor ClosestActor;

/**
* Return the version number for this class.  Child classes should increment this method by calling Super then adding
* a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
* link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
* Super.GetObjClassVersion() should be incremented by 1.
*
* @return	the version number for this specific class.
*/
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Get Closest Actor"
	ObjCategory="Actor"

	bCallHandler=FALSE

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Potential Actors",PropertyName=PotentialActors)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Closest",bWriteable=true,PropertyName=ClosestActor)
}
