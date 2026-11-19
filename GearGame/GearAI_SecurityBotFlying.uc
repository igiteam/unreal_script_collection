/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GearAI_SecurityBotFlying extends GearAI
	native(AI);

/** Cached reference to pawn */
var transient GearPawn_SecurityBotFlyingBase Bot;

var config float    HoveringHeight;
var config Vector2D CirclingRadius;
var config Vector2D CirclingHeight;
var config float    CirclingStep;

var() config float EnemyAcquiredGracePeriod;

/** Delay between playing the telegraph sound and starting to fire */
var() config float StartFireDelay;

/** Radius to keep spaced apart from enemies */
var() config float EnemyAvoidanceRadius;
/** Force to apply for avoiding squad enemies */
var() config float AvoidEnemyStrength;

var instanced AIReactCond_GenericCallDelegate LostEnemyReaction;

cpptext
{
	// Overidden to fly to the min height of the two polys joined by this edge
	virtual FVector GetEdgeZAdjust(FNavMeshEdgeBase* Edge)
	{
		FVector Extent = FVector(1.f);
		
		if(Pawn != NULL)
		{
			Extent = Pawn->GetCylinderExtent();
		}
		if(Edge == NULL || Edge->GetPoly0() == NULL || Edge->GetPoly1() == NULL)
		{
			return FVector(0.f,0.f,Extent.Z);
		}
		FLOAT HeightOffEdge = Min<FLOAT>(Edge->GetPoly0()->GetPolyHeight(), Edge->GetPoly1()->GetPolyHeight());
		HeightOffEdge -= Extent.Z+5.f;

		return FVector(0.f,0.f,HeightOffEdge);
	}

	// Overridden to avoid all pawns, not just squadmates
	virtual void GetFlockAvoidForce( FVector& AvoidForce );
};

function Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn,bVehicleTransition);
	Bot = GearPawn_SecurityBotFlyingBase(NewPawn);
}

singular function bool StepAsideFor( Pawn ChkPawn );

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget);

function bool CheckInterruptCombatTransitions();

function OnLostEnemy(Actor InInstigator, AIReactChannel OrigChannel)
{
	Bot.OnLostEnemy();
	BeginCombatCommand(none,"Lost LOS, restarting");
}

function OnNewEnemy(Actor InInstigator, AIReactChannel OrigChannel)
{
	`AILog(GetFuncName());
	Bot.OnAcquireEnemy();
}

function bool IsFiringWeapon()
{
	return ( IsTimerActive('StartFiring') || Super.IsFiringWeapon() );
}

function DelayedStartFire()
{
	if( !IsTimerActive('StartFiring') )
	{
		Bot.PlaySound(Bot.PreAttackVocal);
		SetTimer(StartFireDelay, false, 'StartFiring');
	}
}

function React_Damage( Actor EventInstigator, AIReactChannel OrigChannel )
{
	local Vector EvadeLocation, VectToShooter;

	if( !MyGearPawn.IsDoingASpecialMove() )
	{
		VectToShooter = Normal(EventInstigator.Location - Pawn.Location);
		EvadeLocation = (VectToShooter CROSS vect(0,0,1)) * (128.f + (FRand() * 256.f));
		if( (EvadeLocation DOT Pawn.Velocity) > 0.f )
		{
			EvadeLocation *= -1.f;
		}
		EvadeLocation.Z += RandRange( -64.f, 64.f );
		EvadeLocation += Pawn.Location;

		class'AICmd_Attack_Sentry_Evade'.static.Evade( self, EvadeLocation );
	}
}

/** Allow shriekers to traverse over jumplink edges */
event bool CanUseJumpLink(JumpLink Link)
{
	return Link.bAllowShrieker;
}

event bool JumpLinkToDest(JumpLink Link, vector Start, vector End)
{
	return true;
}

function bool GetMoveToCombatZoneLocation( out Vector out_Dest )
{
	local bool bResult;

	bResult = Super.GetMoveToCombatZoneLocation( out_Dest );
	if( bResult )
	{
		out_Dest.Z += RandRange( CirclingHeight.X, CirclingHeight.Y );
	}

	return bResult;
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_SecurityBotFlying'

	DefaultReactConditions.Empty()
	DefaultReactConditionClasses.Empty()

	// plays a sound whenever we have a new enemy
	Begin Object class=AIReactCond_GenericCallDelegate Name=NewEnemy0
		AutoSubscribeChannels(0)=NoticedEnemy
		OutputFunction=OnNewEnemy
	End Object
	DefaultReactConditions.Add(NewEnemy0)

	Begin Object class=AIReactCond_GenericCallDelegate Name=Pusher0
		AutoSubscribeChannels(0)=LostEnemyVisibility
		OutputFunction=OnLostEnemy
	End Object
	DefaultReactConditions.Add(Pusher0)
	LostEnemyReaction=Pusher0

	// shot too much
	Begin Object class=AIReactCond_DmgThreshold Name=DmgReact0
		DamageThreshold=50
		MinTimeBetweenActivations=2
		OutputFunction=React_Damage
	End Object
	DefaultReactConditions.Add(DmgReact0)

	bCanMelee=false

	bUseFlockingMovement=true
	bOnlyPlanarFlocking=false
}
