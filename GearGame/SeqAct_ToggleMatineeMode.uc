/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ToggleMatineeMode extends SeqAct_Latent
	native(Sequence);

/** If this is true, hit reaction or death will interrupt animation **/
/*var() bool TakeDamage;
var() bool DetectEnemy;
*/
/** Set up Location/Rotation using this Actor. Move to this actor's location and rotate to this actor's rotation. This does not have character to walk to the location. **/
var array<Actor> StartActors;

/** Created new variables for enabel/aborted to avoid conflicts with parents */
var transient bool bActionEnabled;
var transient bool bActionAborted;

cpptext
{
	// if reached rotation, return
	virtual void Activated();
	virtual UBOOL UpdateOp(FLOAT DeltaTime);
	virtual void DeActivated();

	virtual void UpdateDynamicLinks();
};

defaultproperties
{
	ObjName="Toggle Pawn Matinee Mode"
	ObjCategory="Toggle"

	InputLinks(0)=(LinkDesc="Enable")
	InputLinks(1)=(LinkDesc="Disable")
	InputLinks(2)=(LinkDesc="Abort")

	OutputLinks.Empty
	OutputLinks(0)=(LinkDesc="Enabled")
	OutputLinks(1)=(LinkDesc="Disabled")
	OutputLinks(2)=(LinkDesc="Aborted")

	bAutoActivateOutputLinks = FALSE

	// Dynamically create this
	//VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Start Actor",PropertyName=StartActor)
}
