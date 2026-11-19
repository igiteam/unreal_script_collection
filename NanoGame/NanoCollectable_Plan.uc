/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCollectable_Plan extends NanoCollectableActorBase
	placeable;


/** This is the plan that this actor will give the player if they pick it up. **/
var() class<NanoPlan> PlanClass;

/** Whether or not not the plan will be unlocked for the player **/
var() bool bShouldUnlockPlan;


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	ChooseCollectable();
}


/** For now just set this on post begin play.**/
function ChooseCollectable()
{
	local NanoPlanActor ThePlan;

	if( PlanClass != None )
	{
		ThePlan = Spawn( class'NanoPlanActor', ,, Location, Rotation,, TRUE );

		ThePlan.PlanClass = PlanClass;
		ThePlan.bShouldUnlockPlan = bShouldUnlockPlan;

		Interact = ThePlan;
	}
}


// we need to override this and "forward" the SetHidden to the item we spawned
simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
	if( Interact != None )
	{
		if (Action.InputLinks[0].bHasImpulse)
		{
			Interact.SetHidden(True);
		}
		else if (Action.InputLinks[1].bHasImpulse)
		{
			Interact.SetHidden(False);
		}
		else
		{
			Interact.SetHidden(!bHidden);
		}
	}
}




defaultproperties
{

	Begin Object Class=SpriteComponent Name=Sprite0
		Sprite=Texture2D'Nano_Proto_B.SM.Mesh.MS_Neutral_SUV_Mask_Dup'
		HiddenGame=TRUE
		HiddenEditor=FALSE
		AlwaysLoadOnClient=FALSE
		AlwaysLoadOnServer=FALSE
		Scale=0.10f
	End Object
	Components.Add(Sprite0)

	bShouldUnlockPlan=FALSE
}






