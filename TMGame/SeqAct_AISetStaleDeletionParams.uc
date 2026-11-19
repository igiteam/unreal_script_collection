/**
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_AISetStaleDeletionParams extends SequenceAction;

/** amount of time this AI can do nothing before he's deleted */
var() float StaleTimeout;
/** whether or not deletion of this guy is allowed when he's stale */
var() bool  bAllowDeleteWhenStale;

