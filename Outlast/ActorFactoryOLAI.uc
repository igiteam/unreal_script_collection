/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class ActorFactoryOLAI extends ActorFactoryAI
	dependson(OLEnemyPawn)
	config(Editor)
	native(AI);

var() OLBTBehaviorTree BehaviorTree;
var() SkeletalMesh MeshOverride;

var() struct native ShaderValues
{
	var bool bOverride_UniformColor;

	var() LinearColor UniformColor<editcondition=bOverride_UniformColor>;
} ShaderOverrides;

var const name UniformColorName;

var() bool bOverrideLightingFlags;
var() bool bCastStaticShadow;
var() bool bCastDynamicShadow;
var() bool bSelfShadowOnly;
var() bool bCastShadowInNightVision;
var() bool bPlaySpawnWaypointAnim;

var() EnemyModifiers PawnModifiers;

var() array<AnimSet> AdditionalAnimSets;

var() OLAIContextualVOAsset VOAsset;

cpptext
{
	virtual AActor* CreateActor( const FVector* const Location, const FRotator* const Rotation, const class USeqAct_ActorFactory* const ActorFactoryData );

	virtual void PostLoad();

	void CreateOverrideMaterials(AOLEnemyPawn* NewPawn);
}

var deprecated bool ShouldAttack;
var deprecated bool bUseKillingBlow;
var deprecated bool bAlwaysLookAtPlayer;

defaultproperties
{
	PawnClass=class'OLEnemyPawn'
	ControllerClass=class'OLBot'

	UniformColorName=uniform_color
}