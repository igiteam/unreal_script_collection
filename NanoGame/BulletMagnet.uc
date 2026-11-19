/** 
 * Will call for rebel help.
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class BulletMagnet extends DynamicSMActor_Spawnable
	notplaceable
	config(Game);


var ParticleSystem PS_PersistentEffect;

var transient ParticleSystemComponent PSC_PersistentEffect;

/** The radius around the BulletMagnet to attract bullets **/
var config float RadiusToAttractBullets;


function PostBeginPlay()
{
	Super.PostBeginPlay();


	PSC_PersistentEffect = new(self) class'ParticleSystemComponent';
	PSC_PersistentEffect.SetTemplate( PS_PersistentEffect );
	AttachComponent( PSC_PersistentEffect );
	PSC_PersistentEffect.ActivateSystem();
}






DefaultProperties
{
	LifeSpan=20

	PS_PersistentEffect=ParticleSystem'Nano_Effects_Forgeable.BulletMagnet.P_BulletMagnet'

	Begin Object Class=CylinderComponent Name=CollisionCylinder
	    CollisionRadius=8
		CollisionHeight=8
		CollideActors=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	bCollideActors=TRUE
	bBlockActors=FALSE
}