/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCrowdBehavior_ChickenAttack extends GameCrowdAgentBehavior
	native
	placeable
	dependsOn(GearCrowdAgent_ChickenBase);

/** Damage type to use for kryll */
var() class<DamageType> MyDamageType;
/** Damage applied per chicken attack */
var() float AttackDamage;
/** Distance from victim that a chicken is considered attacking */
var() float AttackRange;
/** Minimum time interval between this chicken's attacks */
var float MinAttackInterval;

/** Time of last attack from this chicken */
var transient float LastAttackTime;

/** Reference to chicken agent */
var transient GearCrowdAgent_ChickenBase MyChicken;
	
/**
*  Agent's current behavior gets ticked
*/
native function Tick(float DeltaTime);

/**
* Called when Agent activates this behavior
*/
function InitBehavior(GameCrowdAgent Agent)
{
	Super.InitBehavior(Agent);

	MyChicken = GearCrowdAgent_ChickenBase(Agent);

	MyChicken.SetMaxSpeed();
	MyChicken.bIsPanicked = bIsPanicked;
	MyChicken.GroupAttractionStrength = 50.f;
	MyChicken.AvoidPlayerStrength = 300.0f;
	MyChicken.AvoidOtherStrength = 400.f;
	MyChicken.MatchVelStrength = 0.5f;
	MyChicken.FollowPathStrength = 500.f;
	MyChicken.GroundOffset = RandRange(90.f, 200.f);

	MyChicken.PlaySound(MyChicken.AttackVocal);
}

function StopBehavior()
{
	Super.StopBehavior();

	MyChicken.SetMaxSpeed();
	MyChicken.bIsPanicked = false;
	MyChicken.GroupAttractionStrength = MyChicken.default.GroupAttractionStrength;
	MyChicken.AvoidPlayerStrength = MyChicken.default.AvoidPlayerStrength;
	MyChicken.AvoidOtherStrength = MyChicken.default.AvoidOtherStrength;
	MyChicken.MatchVelStrength = MyChicken.default.MatchVelStrength;
	MyChicken.FollowPathStrength = MyChicken.default.FollowPathStrength;
}

function Actor GetDestinationActor()
{
	return ActionTarget;
}

function string GetBehaviorString()
{
	return "Chicken Attack! at "@ActionTarget;
}

event PropagateViralBehaviorTo(GameCrowdAgent OtherAgent)
{
	local GearCrowdAgent_ChickenBase OtherChicken;

	OtherChicken = GearCrowdAgent_ChickenBase(OtherAgent);
	if( OtherChicken != None )
	{
		OtherChicken.SetFreakout(Pawn(ActionTarget));
	}
}

event ApplyDamage(float DeltaTime)
{
	local GearPawn TargetGP;
	local float DistSqToTarget;
	local Vector EndTrace;
	local ImpactInfo Impact;

	// Do damage and effects to pawn
	TargetGP = GearPawn(ActionTarget);
	DistSqToTarget = VSizeSq(MyChicken.Location - ActionTarget.Location);
	if( TargetGP != None && 
		DistSqToTarget < AttackRange*AttackRange && 
		LastAttackTime + MinAttackInterval < MyChicken.WorldInfo.TimeSeconds )
	{
// 		if( FRand() < 0.1f )
// 		{
// 			if( FRand() < 0.5f )
// 			{
// 				MyChicken.PlaySound(MyChicken.BiteSound);
// 			}
// 			else
// 			{
// 				MyChicken.PlaySound(MyChicken.AltBiteSound);
// 			}
// 		}

		// Trace to neck for maximum blood in your face
		EndTrace = TargetGP.Mesh.GetBoneLocation(TargetGP.MeleeDamageBoneName);

		// Do a trace to get HitInfo
		MyChicken.TraceComponent(Impact.HitLocation, Impact.HitNormal, TargetGP.Mesh, EndTrace, MyChicken.Location, Vect(0,0,0), Impact.HitInfo);

		Impact.HitActor = TargetGP;
		Impact.RayDir = Normal(Impact.HitLocation - MyChicken.Location);
		TargetGP.TakeDamage(AttackDamage, None, Impact.HitLocation, Normal(VRand()) * RandRange(-128,128), MyDamageType, Impact.HitInfo, MyAgent);

		// Cover head!
		if( TargetGP.CanCoverHead() )
		{
			TargetGP.PlayHeadCoverAnim(1.5f, TRUE);
		}

		LastAttackTime = MyChicken.WorldInfo.TimeSeconds;
	}
}

defaultproperties
{
	AttackDamage=70
	AttackRange=50
	MinAttackInterval=0.5f
	MyDamageType=class'GDT_Chicken'

	bIsPanicked=true
	bIsViralBehavior=true
	bFaceActionTargetFirst=true
	MaxPlayerDistance=20000.0
}
