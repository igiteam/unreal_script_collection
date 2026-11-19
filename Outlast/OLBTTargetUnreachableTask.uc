/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTTargetUnreachableTask extends OLBTPlayAnimTask
	native(AI);

cpptext
{
	virtual void OnTerminate(EStatus status);
}

defaultproperties
{
}