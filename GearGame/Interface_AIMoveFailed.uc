/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface Interface_AIMoveFailed;

/**
 * allows objects to handle situations where an AI fails to path to it
 * @param FailingAI - the ai that failed to path to this object
 */
function AIFailedToPathToMe(GearAI FailingAI);

/**
 * function used to early out of pathing to an enemy if someone has failed to do so recently
 * @param AskingAI - the ai who wants to know if we should early out
 * @return TRUE if path has failed recently 
 */
function bool HasPathFailedRecently(GearAI AskingAI);