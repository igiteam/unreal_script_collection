/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Targeted Reaction Condition - activates when an enemy in front of us has his crosshair on us
 */
class AIReactCond_Targeted extends AIReactCondition_Base
	native(AI);

var Pawn Shooter;
/** enemies within this range will qualify for evade */
var() float ShooterRangeThreshold;
/** enemies within this range will qualify for evade */
var() float LookToTargetThreshold;
/** if true, check if the AI can evade */
var bool bCheckEvade;
/** indicates we should only trigger when the enemy is wielding an instant hit weapon */
var bool bOnlyInstantHitWeapon;

cpptext
{
	virtual UBOOL ShouldActivateNative(AActor* Instigator, UAIReactChannel* OriginatingChannel);

protected:
	UBOOL CheckEnemyView(APawn* EnemyPawn);
}


event Activate( Actor EventInstigator, AIReactChannel OriginatingChannel )
{
	Super.Activate(EventInstigator, OriginatingChannel);

	if (Shooter != None && Shooter.Weapon != None && (!bOnlyInstantHitWeapon || Shooter.Weapon.bInstantHit))
	{
		// If in cover not exposed to the shooter
		if (MyGearPawn.IsInCover() && !IsCoverExposedToAnEnemy(GearAI_Cover(Outer).Cover, Shooter))
		{
			// Stop leaning out as a "dodge"
			if (MyGearPawn.IsLeaning() || MyGearPawn.IsPeeking(MyGearPawn.CoverAction))
			{
				bFailedToFireFromCover = true;
			}
		}
		// Otherwise, do the evade
		else if (InterpActor(MyGearPawn.Base) == None)
		{
			DoEvade(GetBestEvadeDir(MyGearPawn.Location, Shooter), true);
		}
	}
	else
	{
		`warn(self @ GetFuncName() @ "No Shooter" @ Outer @ EventInstigator);
	}
}


defaultproperties
{
	AutoSubscribeChannels(0)=SightPlayer
	ShooterRangeThreshold=1024
	LookToTargetThreshold=64
	bCheckEvade=true
}
