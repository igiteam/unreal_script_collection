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

class KynapseUnrealDynamicAvoidance extends KynapseDynamicAvoidance
	editinlinenew
	native
	hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

struct native mainSettings_V2
{
	var() const float Courtesy;
	//var() const bool Smoothing;
	var() const bool ContinuousSpeed;
};

struct native secondarySettings_V2
{
	var() const float QueueingDelay;
	var() const float PushingDelay;
	var() const float StuckDelay;
	//var() const float SmoothingAngleMax;
	var() const float MaxAngularSpeed;
	//var() const float MaxSpeedReduction;
	var() const float MinSpeed;
	var() const float ExtraGap;
	//var() const float StrafeDistMin;
	//var() const float StrafeDistMax;
	var() const float StrafeRadius;
	var() const float StrafeAngle;
};

struct native technicalSettings_V2
{
	var() const int MaxCollisionTestsPerFrame;
	var() const float DiagramHalfWidth;
	var() const float CandidateSpacing;
	var() const float DiagramRefreshPeriod;
	var() const float EntityDistMax;
	//var() const float TtiMax;
	var() const float DiagramMaxLength;
};

var() const mainSettings_V2 main;
var() const secondarySettings_V2 secondary;
var() const technicalSettings_V2 technical;


