/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyInteractableComponent extends SequenceAction;


/** Replaces the actor's InteractableComponent with this one **/
var() InteractableComponent NewComp;




static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}


event Activated()
{
	local int Idx;
	local NanoInterface_Interact InteractInterface;
	local InteractableComponent CompToMod;

	for( Idx = 0; Idx < Targets.Length; Idx++ )
	{
		InteractInterface = NanoInterface_Interact(Targets[Idx]);
		if( InteractInterface != None )
		{
			CompToMod = InteractInterface.GetInteractableComponent();

			if( CompToMod != None )
			{
				CompToMod = NewComp;
			}
		}
	}
}



defaultproperties
{
	ObjName="Modify Interactable Component"
	ObjCategory="Nano"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',PropertyName=Targets)

	bCallHandler=FALSE

}