/** 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoBombTarget extends NanoPawn;


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	AimNodes.length = 0;
}


event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	Super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

	if( DamageType == class'NDT_Bomb' )
	{
		`log( "BOOOOOOOOM" );
		Died( InstigatedBy, DamageType, HitLocation );
	}
}


/** This will return the struct that holds all of the values for this specific pawn **/
simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.LowLevelDisturbance;
}


defaultproperties
{
	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'COG_Mortar.Mesh.COG_Mortar_SK'
		PhysicsAsset=PhysicsAsset'COG_Mortar.Mesh.COG_Mortar_SK_Physics'
	End Object
}