/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAttractMetaCorpTroops extends NanoAttractMetaCorpTroopsBase;





simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetPhysics( PHYS_Falling );
	LifeSpan = DurationOfEffectiveAttraction;
}


simulated singular event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
//	Super.Bump( Other, OtherComp, HitNormal );

	if ( (Other == None) || Other.bDeleteMe ) // Other just got destroyed in its touch?
	{
		return;
	}

	// don't allow projectiles to explode while spawning on clients
	// because if that were accurate, the projectile would've been destroyed immediately on the server
	// and therefore it wouldn't have been replicated to the client
	if( Other != Instigator )
	{
		// do a mesmorize NSM  (orbitals)
		//`log( "AHHHHHHHHHHHHHHHHHHHHHHHHHH MESMORIZED!" @ `showvar(Other) );
		if( ( NanoPawn_MetaCorp_NanoInfantry(Other) != None ) 
			&& ( NanoPawn_MetaCorp_NanoInfantry(Other).IsDoingSpecialMove( 'NSM_MesmorizedByNanoAttractor') == FALSE ) 
			)
		{
			NanoAI(NanoPawn_MetaCorp_NanoInfantry(Other).Controller).OverrideAnimNameToPlay = 'Orbitals_Swarm';
			NanoPawn_MetaCorp_NanoInfantry(Other).DoSpecialMove( 'NSM_MesmorizedByNanoAttractor' );
			CurrNumAttracted++;
		}
		

	}
}


/** Function to forge the implementing actor.  Actor is responsible for calling the callback when object is forged and ready to use. */
function ForgeActor(optional delegate<NanoPlan.OnForgeActorFinished> OnFinishCallback)
{
	OnFinishCallback();
}




defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=RocketStaticMesh0
		StaticMesh=StaticMesh'LT_Spaceship.SM_Cine.Meshes.LT_Spaceship_SM_Cine_Body2'
		HiddenGame=FALSE
		CastShadow=FALSE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		BlockRigidBody=FALSE
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE)
		Scale=0.10f
	End Object
	Components.Add(RocketStaticMesh0)


	Begin Object Class=CylinderComponent Name=CollisionCylinder
	    CollisionRadius=256
		CollisionHeight=8
		CollideActors=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	bCollideActors=TRUE
	bCollideWorld=TRUE

}