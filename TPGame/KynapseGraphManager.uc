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

class KynapseGraphManager extends KynapseWorldService
	editinlinenew
	native
	hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

struct native AdditionalData
{
	var() const string className;

	structdefaultproperties
	{
		className="None"
	}
};

struct native Pathdata
{
	var() const string pathdataName;
	var() const KynapseMapBuilder mapBuilder;
	var() const bool usesPathObjectManager;
	var() const array<AdditionalData> additionalDataList;

	structdefaultproperties
	{
		pathdataName="None"
		mapBuilder=None
		usesPathObjectManager=true
	}
};

struct native Traversal
{
	var() const string TraversalName;
	var() const string ClassName;
	var() const int InstanceCount;
	var() const string TaskName;
};

var() const array<Pathdata> pathdataList;

var() const array<Traversal> traversalList;


