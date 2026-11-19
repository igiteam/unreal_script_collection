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

class KynapseBrain extends Object
	editinlinenew
	native
	hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

const nbBrainServices = 5;
const nbAgents = 5;

var() const string brainName;
var() const string className;
var() const instanced KynapseBrainService servicesList[nbBrainServices];
var() const instanced KynapseAgent agentsList[nbAgents];


