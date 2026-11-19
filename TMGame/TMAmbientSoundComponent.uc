/** used for gameplay-relevant ambient sounds (e.g. weapon loading sounds) 
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMAmbientSoundComponent extends AudioComponent;

event OcclusionChanged(bool bNowOccluded)
{
	Super.OcclusionChanged(bNowOccluded);
}

