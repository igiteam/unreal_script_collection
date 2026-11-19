
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_AISilverbackGetCrate extends SeqAct_Latent;

/** Crate that should be picked up */
var() KActor_SilverbackLoaderCrateBase Crate;
/** Location where crate should be dropped */
var() Actor DropLocation;
/** Set to true if the crate should be dropped */
var bool bShouldDropCrate;

defaultproperties
{
	ObjName="AI: Silverback Carry Crate"
	ObjCategory="AI"

	InputLinks(0)=(LinkDesc="Pick Up")
	InputLinks(1)=(LinkDesc="Drop")

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Crate",PropertyName=Crate)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Destination",PropertyName=DropLocation)
}
