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

/*
 * This is a base class for TPPawn & KynapsePawn
*/

class KynapseGamePawn extends GamePawn
	notplaceable
	native
	config(Game);


var(Kynapse) float FaceEnemyDist; // distance the npc is directly facing his enemy
var(Kynapse) float BeginFacingEnemyDist; // distance the npc begins facing his enemy


