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

class KynapseFleeAgent extends KynapseAgent
	editinlinenew
	native
	hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var() const string Graph;
var() const string Traversal;
var() const float DangerRadius;
var() const bool StopWhenHidden;

var const float Speed;

