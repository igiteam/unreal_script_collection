/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSeqEvent_TouchStatus extends SeqEvent_Touch
	native(Sequence)
	hidecategories(SeqEvent_Touch);

/** internal - set when checking activation; indicates whether it's a touch check or untouch check */
var const private transient bool bCheckingTouch;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

