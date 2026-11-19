/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
interface Interface_AIMoveOverride;

/**
 * Allows other objects to override the behavior of the MoveToGoal of a GearAI
 *
 * @param AIToMove - the AI who is to attempt the move
 * @param MoveAction - the action that kicked off the AI to move
 * @return - true if we are going to handle the move
 */
function bool DoMoveOverride(GearAI AIToMove, SeqAct_AIMove MoveAction);
