/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoRideableForgeableBase extends Vehicle
	native(Vehicle)
	implements( NanoInterface_Targetable )
	abstract;

/** ref to the orb we have spawned **/
var transient array<NanoAbsorbOrb> Orbs;

/** Class of Absorb orb this pawn drops **/
var array< class<NanoAbsorbOrb> > DroppedOrbClasses;


/** TeamNum is not working / set up correct in nano it seems  Wheee! **/
var transient bool bWasSpawnedByPlayer;
/** Keep track of this **/
var transient NanoPawn PawnWhoSpawnedMe;

/** Is this object currently targetable */
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return Health > 0;
}

/** Returns the Targetable Octree component */
simulated function TargetableOctreeComponent GetTargetableOctreeComponent()
{
	local TargetableOctreeComponent TargetableComp;

	foreach AllOwnedComponents( class'TargetableOctreeComponent', TargetableComp )
	{
		return TargetableComp;
	}

	return None;
}

/** Should we rate this target? (if not just skip in rating loop) */
simulated function bool ShouldRateTarget()
{
	return TRUE;
}

/** Should this targetable actor ignore distance checks in rating calculations (caution...use with care!) */
simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

/** Returns base priority for targeting this object. */
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	return 100.0f;
}

/** Get location that target should be considered */
simulated event vector GetTargetedLocation()
{
	return Location;
}

/** Rotation of the target.  Useful to see if they are facing some dir **/
simulated event rotator GetRotation()
{
	return Rotation;
}

/** How fast the target is currently moving **/
simulated event vector GetVelocity()
{
	return Velocity;
}

/** Pass in a struct and then have the interface fill in a ton of different firing targetable data **/
simulated function GetFiringTargetableDatum( out FiringTargetableDatum Out_FiringTargetableDatum );

/** Called when target is struck by thrown sword */
simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );

/** Called when target struck by ricochet moon hook */
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

/** Indicates this object can be dash-attacked with sword */
simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return FALSE;
}

simulated function name GetDefaultCameraMode( PlayerController RequestedBy )
{
	if( RequestedBy != None && RequestedBy.PlayerCamera != None && RequestedBy.PlayerCamera.CameraStyle == 'Fixed' )
	{
		return 'Fixed';
	}

	return 'Default';
}


simulated event Destroyed()
{
	// don't kill for now as the sentry kills itself and we want the orb to keep existing
	//Orb.Destroy();
	
	Super.Destroyed();
}



function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	if (Super.Died(Killer,DamageType,HitLocation))
	{
		return TRUE;
	}

	// only spawn an Orb if we are not on the Rebels Team
	//if( GetTeamNum() != 0 )
	if( bWasSpawnedByPlayer == FALSE )
	{
		SpawnAnOrb();
	}

	return FALSE;
}


function SpawnAnOrb()
{
	local class<NanoAbsorbOrb> DroppedOrbClass;

	foreach DroppedOrbClasses( DroppedOrbClass )
	{
		Orbs.AddItem( NanoGRI(WorldInfo.GRI).SpawnANanoOrb( DroppedOrbClass, self, FALSE ) );
	}


	//Orb.SetLocation( Location );
	//Orb.SetBase( self, , Mesh, MeleeDamageBoneName );
}


event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// so here we check to see if we are on the same team and then do NOT do damage to same team
	if( GetTeamNum() == InstigatedBy.GetTeamNum() )
	{
		//`log( "SAME TEAM!! NO DAMAGE!!!!!" @ self @ `showvar(InstigatedBy));
		Damage = 0.0f;
	}

	Super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

}




defaultproperties
{
	InventoryManagerClass=class'NanoInventoryManager'

	DroppedOrbClasses.Add(class'NanoAbsorbOrb_SentryTurret')

	Begin Object Class=TargetableOctreeComponent Name=TargetableOctreeComp0
	End Object
	Components.Add(TargetableOctreeComp0)

}
