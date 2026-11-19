/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyCollectables_ShowAllOnMinimap extends SequenceAction;



static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}



/**
 * Called when this event is activated.
 */
event Activated()
{
	local NanoCollectableBase Collectable;


	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'NanoCollectableBase', Collectable)
	{
		// show
		if( InputLinks[0].bHasImpulse == TRUE )
		{
			Collectable.UIComponent.Minimap.bShown = TRUE;
		}
		// hide
		else if( InputLinks[1].bHasImpulse == TRUE )
		{
			Collectable.UIComponent.Minimap.bShown = FALSE;
		}
		// toggle
		else if( InputLinks[2].bHasImpulse == TRUE )
		{
			Collectable.UIComponent.Minimap.bShown = !Collectable.UIComponent.Minimap.bShown;
		}
	}
}




defaultproperties
{
	ObjName="Modify Collectables Show All On Minimap"
	ObjCategory="Nano"

	VariableLinks.Empty()
	bCallHandler=FALSE

	InputLinks(0)=(LinkDesc="ShowAll")
	InputLinks(1)=(LinkDesc="HideAll")
	InputLinks(2)=(LinkDesc="Toggle")
}


