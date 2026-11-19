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

class KynapseGapDynamicAvoidance extends KynapseDynamicAvoidance
	editinlinenew
	native
	hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

struct native mainSettings
{
	var() const float Courtesy;
	var() const bool Smoothing;
	var() const bool ContinuousSpeed;
};

struct native secondarySettings
{
	var() const float QueueingDelay;
	var() const float PushingDelay;
	var() const float StuckDelay;
	var() const float SmoothingAngleMax;
	var() const float MaxSpeedReduction;
	var() const float ExtraGap;
	var() const float StrafeDistMin;
	var() const float StrafeDistMax;
};

struct native technicalSettings
{
	var() const int MaxCollisionTestsPerFrame;
	var() const float DiagramHalfWidth;
	var() const float CandidateSpacing;
	var() const float DiagramRefreshPeriod;
	var() const float EntityDistMax;
	var() const float TtiMax;
};

var() const mainSettings main;
var() const secondarySettings secondary;
var() const technicalSettings technical;


