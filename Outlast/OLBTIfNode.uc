/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTIfNode extends OLBTCompositeNode
	abstract
	native(AI);

var() bool bNot;

cpptext
{
	/* for editor use. */
	virtual FString GetNodeTitle();
}

defaultproperties
{
	Children(0)=(Name="Child")
	bFixNumChildren=TRUE
	bNot=false
}