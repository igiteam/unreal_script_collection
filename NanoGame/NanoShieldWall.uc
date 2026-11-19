/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoShieldWall extends NanoBustableActor_Dynamic;



//look at NanoWeap_GreyGooCube and copy that bad boy

// need to make this do path blocking

//

//



simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

}




simulated singular event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	//`log( GetFuncName() @ self @ `showvar(Other) );

	if ( (Other == None) || Other.bDeleteMe ) // Other just got destroyed in its touch?
	{
		return;
	}

	// prob want some call outs

}


/** Function to forge the implementing actor.  Actor is responsible for calling the callback when object is forged and ready to use. */
function ForgeActor(optional delegate<NanoPlan.OnForgeActorFinished> OnFinishCallback)
{
	OnFinishCallback();
}




defaultproperties
{
	LifeSpan=120
	bCanBeSmashedByMechs=TRUE
}
