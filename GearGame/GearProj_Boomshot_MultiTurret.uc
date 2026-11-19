/**
 * Boomshot projectile for the Multi Turret
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_Boomshot_MultiTurret extends GearProj_Boomshot;

/**
 * Don't make the rocket explode if it hits the player
 *
 * @param Other - the actor that is touching the rocket
 *
 * @param HitLocation - where Other and the rocket touched
 *
 * @param HitNormal - the direction of their contact
 */
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local GearTurret GT;

	GT = GearTurret(Instigator);
	if (GT == None || GT.Driver != Other)
	{
		Super.ProcessTouch(Other, HitLocation, HitNormal);
	}
}

/**
 * Don't make the rocket explode if it hits the player or the blimp
 *
 * @param HitNormal - the direction of the contact
 *
 * @param Wall - the actor that the rocket hit
 *
 * @param WallComp - the Wall's mesh that the rocket hit
 */
simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local GearTurret GT;

	GT = GearTurret(Instigator);
	if ((GT == None || GT.Driver != Wall) && Wall != Instigator.Base)
	{
		Super.HitWall(HitNormal, Wall, WallComp);
	}
}

/**
 * Adjust the projectile speed by the grandparent's velocity
 * 
 * @param Direction - which direction the projection was fired
 */
function Init(vector Direction)
{
	Super.Init(Direction);

	// These multi turrets can be on a base which is not matinee'd, have to query the base's base.
	if (Instigator != None && Instigator.Base != None && Instigator.Base.Base != None)
	{
		InitialFrameOfRefVelocity = Instigator.Base.Base.Velocity + (Instigator.Base.Base.AngularVelocity cross (Instigator.Location - Instigator.Base.Base.Location));
		Velocity += InitialFrameOfRefVelocity;

		//`log(`showvar(InitialFrameOfRefVelocity) @ `showvar(Direction*Speed) @ `showvar(Velocity));
	}
	else
	{
		InitialFrameOfRefVelocity = vect(0,0,0);
	}
}

simulated function DelayArc();

defaultproperties
{
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_Boomshot_MultiTurret'
		ContentTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.BoomShot.Boomshot_Turret_Proj_Explo'
	End Object

	MaxSpeed=10000

	GravityScale=0.4
}
