/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ToggleInteractableComponent extends SequenceAction;



static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}


/**
 * Called when this event is activated.
 */
event Activated()
{
	local int Idx;
	local NanoInterface_Interact InteractInterface;
	local NanoCollectableActorBase TheCollectible;
	local InteractableComponent CompToMod;


	for( Idx = 0; Idx < Targets.Length; Idx++ )
	{
		InteractInterface = NanoInterface_Interact(Targets[Idx]);
	
		// hack until we can think of a better way to handle objecs that spawn other objects
		if( InteractInterface == None )
		{
			TheCollectible = NanoCollectableActorBase(Targets[Idx]);

			if( TheCollectible != None )
			{
				InteractInterface = NanoInterface_Interact(TheCollectible.Interact);
			}
		}


		//`log( GetFuncName() @ `showvar(Targets[Idx]) @ `showvar(InteractInterface) );
		
		if( InteractInterface != None )
		{
			CompToMod = InteractInterface.GetInteractableComponent();

			if( CompToMod != None )
			{
				ModifyActualComponent( CompToMod );
			}
		}
	}
}


private function ModifyActualComponent( out InteractableComponent Comp )
{
	//`log( GetFuncName() @ `showvar(Comp) @ `showvar(Comp.bEnabled) );

	if( InputLinks[0].bHasImpulse == TRUE )
	{
		Comp.bEnabled = TRUE;
	}
	else if( InputLinks[1].bHasImpulse == TRUE )
	{
		Comp.bEnabled = FALSE;
	}
	else if( InputLinks[2].bHasImpulse == TRUE )
	{
		Comp.bEnabled = !Comp.bEnabled;
	}
}



defaultproperties
{
	ObjName="Toggle Interactable Component"
	ObjCategory="Nano"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Interactables",PropertyName=Targets,)
    bCallHandler=FALSE

	InputLinks(0)=(LinkDesc="Enable")
	InputLinks(1)=(LinkDesc="Disable")
	InputLinks(2)=(LinkDesc="Toggle")
}