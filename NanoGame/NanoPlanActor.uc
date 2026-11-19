/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 class NanoPlanActor extends NanoInteractableActor;


 /** This is the plan that this actor will give the player if they pick it up. **/
 var transient class<NanoPlan> PlanClass;

 /** Whether or not not the plan will be unlocked for the player **/
 var transient bool bShouldUnlockPlan;


 simulated event PreBeginPlay()
 {
	 Super.PreBeginPlay();

	 SetPhysics( Phys_None );

 }


simulated function InteractionSuccessfullyCompleted()
{
	// so we have finished interacting now give the plan to the player
	NanoHUD_Base(NanoGRI(WorldInfo.GRI).GetNanoPC().myHUD).SlideTextMessage( PlanClass.default.PlanName @ "Plan Gained!", 2.0f, class'Engine'.static.GetMediumFont(), None  );
	NanoPRI(NanoGRI(WorldInfo.GRI).GetNanoPC().PlayerReplicationInfo).GiveNanoPlan( PlanClass, bShouldUnlockPlan );
	NanoGRI(WorldInfo.GRI).NCM.HandleChallengeEvent( ECET_AcquiredANewDataPlan );
}





 defaultproperties
 {
	Components.Remove( StaticMeshComponent0 )

	CollisionComponent=InteractableComponent0

	Begin Object Class=NanoParticleSystemComponent Name=ParticleSystemComponent0
		Template=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_Collectible_02'
		Translation=(X=0,Y=0,Z=32)
	End Object
	Components.Add(ParticleSystemComponent0)

	bStatic=FALSE
	bNoDelete=FALSE
 }


