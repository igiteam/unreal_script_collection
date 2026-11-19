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

class KynapseMapBuilder extends Actor
	native
	placeable
	hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

var() const string MapBuilderName;
var() editconst string fileName;
//var() const string fileName;
var() const float oneMeter;
var() const bool active;

/* old way with this inside KynapseMapBuilder
var() const Volume explorationBoundingBox;
var() const editinlineuse array<Actor> seeds;
*/

struct native PhysicalParams
{
	var() const float entityRadius;
	var() const float entityHeight;
	var() const float stepLength;
	var() const float stepMax;
	var() const float holeMax;
	var() const bool CheckGroundSlope;
	var() const float groundSlopeMax;
	var() const float groundSlopeMin;
	
	structdefaultproperties
	{
		entityRadius = 0.2
		entityHeight = 1.8
		stepLength = 0.2
		stepMax = 0.3
		holeMax = 0.5
		CheckGroundSlope = true
		groundSlopeMax = 50.0
		groundSlopeMin = 20.0
	}
};
var() const PhysicalParams Physical;

struct native AccuracyParams
{
	var() const float pitch;
	var() const float graphAccuracy;
	var() const float nbSectors;
	var() const float distEdgeMax;
	var() const float edgeRadius;
	var() const float MaxDeltaHeight;

	structdefaultproperties
	{
		pitch = 0.3
		graphAccuracy = 1.5
		nbSectors = 128
		distEdgeMax = 8.0
		edgeRadius = 0.21
		MaxDeltaHeight = 100
	}
};
var() const AccuracyParams Accuracy;

enum EProcessStep
{
   A_Exploration,
   B_Analysis,
   C_GraphCreation,
   D_GraphOptimization
};

struct native ProcessParams
{
	var() const EProcessStep FirstStep;
	var() const EProcessStep LastStep;
	var EProcessStep dummy1;
	var EProcessStep dummy2;
	
	structdefaultproperties
	{
		FirstStep = A_Exploration
		LastStep = D_GraphOptimization
	}
};
var() const ProcessParams Process;

enum ECollisionModel
{
   A_Sphere,
   B_SweptSphere
};

struct native AdvancedParams
{
	var() const int LocalMapSize;
	var() const int MaxMapSize;
	var() const bool EnlargeBoundingBox;
	var() const bool ForbidCollidingEdge;
	var() const float OverConnectionRatio;
	var() const int ComponentSizeMin;
	var() const ECollisionModel CollisionModel;
	
	structdefaultproperties
	{
		LocalMapSize = 50
		MaxMapSize = 10000000
		EnlargeBoundingBox = false
		ForbidCollidingEdge = false
		OverConnectionRatio = 1.2
		ComponentSizeMin = 1
		CollisionModel = A_Sphere
	}
};
var() const AdvancedParams Advanced;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

