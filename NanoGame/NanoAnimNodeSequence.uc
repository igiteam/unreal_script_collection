/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnimNodeSequence extends AnimNodeSequence
	native(Anim);

cpptext
{
	virtual	void TickAnim(FLOAT DeltaSeconds);
	virtual void PlayAnim(UBOOL bLoop=FALSE,FLOAT InRate=1.000000,FLOAT StartTime=0.000000);
	virtual void OnAnimComplete( FLOAT PlayedTime, FLOAT ExcessTime );
	virtual void OnBecomeRelevant();
	virtual void OnCeaseRelevant();
}
	
defaultproperties
{
}