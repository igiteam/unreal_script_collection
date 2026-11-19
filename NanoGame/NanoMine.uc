/**
 * We are just extending NanoProj_ForgedRocket for now as it will drop and will do all of the nice
 * forge effects for us.  Also it already has an explosion and such.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoMine extends NanoProj_ForgedRocket;

var config float MineTriggerRadius;



function NanoProjInit( Vector Direction, optional Actor TargetActor )
{
	SetPhysics( PHYS_Falling );
}


simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	// we prob only want to blow up on MetaCorpBase classes ?

	Super.ProcessTouch( Other, HitLocation, HitNormal );
}



simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	// do nothing
}

simulated function Landed( vector HitNormal, actor FloorActor )
{
	// on land set the size and the physics to not move

	SetPhysics( PHYS_None );
	
	CylinderComponent.SetCylinderSize( MineTriggerRadius, 8 );
}




defaultproperties
{
	Begin Object Name=RocketStaticMesh0
		StaticMesh=StaticMesh'Locust_PoisonGrenade.Meshes.Locust_PoisonGrenade_Pickup1_SM'
	End Object

	Begin Object Name=CollisionCylinder
		CollideActors=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
 	End Object
	CollisionComponent=CollisionCylinder

	MyDamageType=class'NDT_ForgedMine'

}