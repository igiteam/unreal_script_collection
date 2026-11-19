/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_GetCameraInfo extends SequenceAction
	native(Sequence);
	
cpptext
{
	void Activated();
}

var Vector CameraLocation;
var Vector CameraDirection;

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
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Get Camera Info"
	ObjCategory="Camera"
	VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Location",bWriteable=true,PropertyName=CameraLocation)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Direction",bWriteable=true,PropertyName=CameraDirection)
}
