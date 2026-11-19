/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnimNodeSlot extends AnimNodeSlot 
	native(Anim);

cpptext
{
	virtual void SelectedActiveSequence( UAnimNodeSequence* Seq );
}

final native function float PlayCustomAnimEx
(
				Name	AnimName,
				float	Rate,
	optional	float	BlendInTime,
	optional	float	BlendOutTime,
	optional	bool	bLooping,
	optional	bool	bOverride,
	optional	ENanoCameraTransition CameraTrans
);
	
defaultproperties
{

}