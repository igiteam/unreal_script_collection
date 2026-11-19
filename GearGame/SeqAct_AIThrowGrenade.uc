/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_AIThrowGrenade extends SeqAct_Latent;

var() Actor FireTarget;

defaultproperties
{
	ObjName="Throw Grenade"
	ObjCategory="AI"

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Throw At",PropertyName=FireTarget)
}
