/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoFan_Transformer extends NanoInterpActor
	dependson(NanoFanBase)
	placeable;


/** The fan we want to affect when this transformer is damaged **/
var() NanoFanBase FanToAffect;

/** The speed at which to set the targeted fan to. **/
var() EFanSpeed FanSpeed_ToSet;
var transient EFanSpeed FanSpeed_ToRestore;

/** How long this Transformer will affect the fan before shorting out and shutting the fan down. **/
var() float DurationBeforeShortingOut;

var int NumShotsBeforeAffectingFan;
var transient int CurrShotsTaken;

/** Once this takes damage we will no longer be working.  HealBots need to come by and fix us up **/
var transient bool bIsWorking;

/** How long until the heal bots come and fix this transformer up! **/
var() float TimeBeforeHealBotsComeAround;



event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	Super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

`log( "DamageType" @ DamageType );

	if( ClassIsChildOf(DamageType, class'NDT_Ballistic') == TRUE )
	{
		CurrShotsTaken++;

		if( CurrShotsTaken > NumShotsBeforeAffectingFan )
		{
			AffectFan();
		}
	}

	if( (DamageType == class'NanoGame.NDT_NanoSwordThrown') )
	{
		AffectFan();
	}

}


/** We will now affect the fan.  Usually by just adjusting the fan speed. **/
function AffectFan()
{
	if( ( FanToAffect != none ) && ( IsTimerActive( nameof(TurnOffFan) ) == FALSE ) && ( IsTimerActive( nameof(TransformerHasBeenFixed) ) == FALSE ) )
	{
		FanSpeed_ToRestore = FanToAffect.FanSpeed_Curr;
		FanToAffect.SetFanSpeed( FanSpeed_ToSet, 1.0f );

		SetTimer( DurationBeforeShortingOut, FALSE, nameof(TurnOffFan) );
	}
}


/** We have lost all power so the fan now has no electricity.  So shut it off. **/
function TurnOffFan()
{
	FanToAffect.SetFanSpeed( FS_Off, 1.0f );
	bIsWorking = FALSE;

	SetTimer( TimeBeforeHealBotsComeAround, FALSE, nameof(TransformerHasBeenFixed) );
}


/** The healbots have come to fix us up.  Restart the fan and ourself **/
function TransformerHasBeenFixed()
{
	bIsWorking = TRUE;
	FanToAffect.SetFanSpeed( FanSpeed_ToRestore, 1.0f );
}



/** Is this object currently targetable */
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return bIsWorking;
}

simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

/** Returns base priority for targeting this object. */
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	return 10.f; // these should be pretty low
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






defaultproperties
{
	bCollideActors=TRUE
	bBlockActors=TRUE

	bIsWorking=TRUE
	FanSpeed_ToSet=FS_DoubleHeight
	TimeBeforeHealBotsComeAround=25.0f

	Begin Object Class=StaticMeshComponent Name=TransformerComp
	    StaticMesh=StaticMesh'GP_Pickups.SM.Mesh.S_GP_Pickups_Sphere01'
		Scale3D=(X=10,Y=10,Z=10)
		CollideActors=TRUE
		BlockActors=TRUE
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		MaxDrawDistance=50000 // too big for this probably
	End Object
	CollisionComponent=TransformerComp
	Components.Add(TransformerComp)

}