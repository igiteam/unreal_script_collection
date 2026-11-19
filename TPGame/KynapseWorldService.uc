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

class KynapseWorldService extends Object
	native
	hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

struct native WServiceAperiodicTask
{
	var() const string taskName;
	var() const float priority;
	var() const float tpf;
	var() const int maxCall;
	
	structdefaultproperties
	{
		taskname = "NoTask"
		priority = 1.0
		tpf = 1.0
		maxCall = 1
	}
};
var() const array<WServiceAperiodicTask> time_aperiodicTasksList;

struct native WServicePeriodicTask
{
	var() const string taskName;
	var() const float period;

	structdefaultproperties
	{
		taskname = "NoTask"
		period = 1000
	}
};
var() const array<WServicePeriodicTask> time_periodicTasksList;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var() const string serviceName;
var() const string className;

