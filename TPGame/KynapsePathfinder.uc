/**********************************************************************
 *
 * Use of this file or software is subject to the terms of an end user 
 * license agreement.
 *
 * Confidential Information of Kynogon S.A.
 * Not for disclosure or distribution without Kynogon's prior written 
 * consent. This file contains code, techniques and know-how which is 
 * confidential and proprietary to Kynogon.
 *
 * Kynapse (C) Copyright 2000-2006. Kynogon and Kynapse are registered 
 * trademarks of Kynogon S.A. Kynogon All Rights Reserved.
 *
 **********************************************************************/

class KynapsePathfinder extends KynapseBrainService
	editinlinenew
	native
	hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

enum EFindVertexCbk
{
	NearestVertex,
	LocallyVisibleVertex,
	NearestVertexOpt
};

struct native ComputPathSettings
{
	var() const string GraphName;
	var() const float DistMinNewGoal;
	var() const EFindVertexCbk FindVertex;
	var() const bool AvoidCpuPeaks;
	var() const int MaxPathSize;
};

enum ECanGoCbk
{
	AlwaysGo,
	VisibleGo
};

enum ENextSubgoalCbk
{
	SimpleCheck,
	ComplexCheck
};

struct native NextSubgoalSettings
{
	var() const float DistStop;
	var() const int NbMaxSubgoal;
	var() const float MaxDeltaHeight;
	var() const float DistSubgoalMax;
	var() const ECanGoCbk CanGo;
	var() const ENextSubgoalCbk NextSubgoal;
};

enum EStopConditionCbk
{
	SimpleStopCondition,
	VisibleDistStopCondition
};

enum EMoveModeCheck
{
	VisibilityCheck,
	NoCheck
};

enum EMoveCbk
{
	VisibleMove,
	VisibleAvoidDynMove,
	UnrealVisibleMove
};

enum ETargetPointComputation
{
	ComputeSmoothTargetPoint,
	NoSmoothing
};

struct native MoveToSettings
{
	var() const float DistGoal;
	var() const float DistGoalSlowDown;
	var() const float DistSlowDown;
	var() const EStopConditionCbk StopCondition;
	var() const EMoveModeCheck MoveModeCheck;
	var() const EMoveCbk SimpleMove;
	var() const EMoveCbk ComplexMove;
	var() const ETargetPointComputation TargetPointComputation;
	var() const float SmoothingSpeed;
	var() const bool UpdateTorsoRotate;
};

struct native DynamicAvoidanceSettings
{
	var() const bool DisableDA;
	var() const instanced KynapseDynamicAvoidance DA;
};

var() const ComputPathSettings ComputePath;
var() const NextSubgoalSettings NextSubgoal;
var() const MoveToSettings MoveTo;
var() const DynamicAvoidanceSettings DynamicAvoidance;

