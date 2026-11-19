/** 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAcquireTarget extends DynamicSMActor_Spawnable
	implements( NanoInterface_Objective, NanoInterface_Interact );


var InteractableComponent InteractableComp;

/** Our UIIconComponent for easy access. **/
var UIIconComponent UIComponent;



/////// NanoInterface_Interact
simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{
	if( InteractableComp.BeingAbsorbedBy != None )
	{
		return "Absorbing!";
	}

	out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';

	if(InteractableComp.bCanGrab)
	{
		if(InteractableComp.bCanAbsorb)
		{
			return "to pick up or to absorb";
		}
		else
		{
			return "to pick up";
		}
	}
	else
	{
		if(InteractableComp.bCanAbsorb)
		{
			return "to absorb";
		}
		else
		{
			return "Cannot interact";
		}	
	}
}


/** Returns the UI component which we will then act upon. **/
simulated function InteractableComponent GetInteractableComponent()
{
	return InteractableComp;
}

/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted();

simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	return InteractableComp.CanInteract( NP, Type );
}


/** Called from input code when you interact with object */
simulated function DoInteract( NanoPawn NP, ENanoInteractType Type )
{
	InteractableComp.DoInteract( NP, Type );
}
/////// End NanoInterface_Interact


//////// NanoInterface_Objective
/** Return location of objective, used by radar */
simulated function vector GetObjectiveLocation()
{
	return Location;
}
//////// End NanoInterface_Objective


simulated event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	
	InteractableComp.Tick( DeltaTime );
}

/** Returns the UI component which we will then act upon. **/
function UIIconComponent GetUIIconComponent()
{
	return UIComponent;
}




defaultproperties
{
	Begin Object Name=StaticMeshComponent0
		BlockRigidBody=TRUE
		RBChannel=RBCC_GameplayPhysics		
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
	End Object	

	Begin Object Class=InteractableComponent Name=InteractableComponent0
		InteractDistance=128.0
		bCanGrab=TRUE
		bCanAbsorb=FALSE
		AbsorbTime=2.0
	End Object
	InteractableComp=InteractableComponent0
	Components.Add(InteractableComponent0)


	Begin Object Class=UIIconComponent Name=UIIconComponent0
	End Object
	UIComponent=UIIconComponent0
	Components.Add(UIIconComponent0)


}