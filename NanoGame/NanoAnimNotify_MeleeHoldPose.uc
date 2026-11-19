/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnimNotify_MeleeHoldPose extends AnimNotify_Scripted
	native(Anim);

/** How long the pose should be held for **/
var() float DurationToHold;



cpptext
{
	virtual FString GetEditorComment() 
	{ 
		return TEXT("HOLDPOSE"); 	
	}

	virtual FColor GetEditorColor() { return FColor(64,64,255); }
}


event Notify( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;

	NP = NanoPawn(Owner);
	if( ( NP != None ) && ( DurationToHold > 0.0f ) )
	{
		if( NP.IsTimerActive(nameof(NP.EndHoldPose)) == FALSE )
		{
			NP.StartHoldPose( DurationToHold );
			NP.SetTimer( GetTimeLeft(Owner), FALSE, nameof(NP.EndHoldPose) );
			`log( "NanoAnimNotify_MeleeHoldPose:  Holding a pose!" @ `showvar(Outer) @ `showvar(DurationToHold) @ `showvar(GetTimeLeft(Owner)) ); // this should already be happening as the data is extracted from the notifies
		}
	}

	// don't need this for the time
	//OpenComboWindow( Owner, AnimSeqInstigator );
}


event NotifyEnd( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;

	`log( "NotifyEndNotifyEndNotifyEndNotifyEndNotifyEndNotifyEndNotifyEnd for NanoAnimNotify_MeleeHoldPose" @ `showvar(Outer) );

	NP = NanoPawn(Owner);
	if( ( NP != None ) )
	{
		//NP.EndHoldPose();
	}
}


function float GetTimeLeft( Actor Owner )
{
	local int i;

	local AnimNodeSequence Seq;
	//local AnimSequence AnimSeq;


	local float HoldAPoseStartTime;
	local float HoldAPoseDuration;
	local float TimeWeHaveLeft;

	Seq = NanoPawn(Owner).FullBodySlot.GetCustomAnimNodeSeq();


	

	// we need to figure out the rate at which to play the anim to match the hold pose
	//AnimSeq = Mesh.FindAnimSequence( Seq.AnimSeqName );

	for( i = 0; i < Seq.AnimSeq.Notifies.length; i++ )
	{
		// First notify of desired class after this 'start'
		if( ClassIsChildOf(Seq.AnimSeq.Notifies[i].Notify.Class, class'NanoAnimNotify_MeleeHoldPose'))
		{
			HoldAPoseDuration += NanoAnimNotify_MeleeHoldPose(Seq.AnimSeq.Notifies[i].Notify).DurationToHold;
			`log( "   -->" @ `showvar(NanoAnimNotify_MeleeHoldPose(Seq.AnimSeq.Notifies[i].Notify).DurationToHold) @ " Total:" @ `showvar(HoldAPoseDuration) );

			HoldAPoseStartTime += Seq.AnimSeq.Notifies[i].Time;


		}
	}


	TimeWeHaveLeft = Seq.AnimSeq.SequenceLength - HoldAPoseStartTime;

	
	`log(  `showvar(TimeWeHaveLeft) @ `showvar(HoldAPoseDuration) @ `showvar((TimeWeHaveLeft + HoldAPoseDuration)) );

	//RateToPlay = 0.1f; // AnimSeq.SequenceLength / (AnimSeq.SequenceLength + HoldPoseTime);


	return TimeWeHaveLeft + HoldAPoseDuration;


	//`log( `showvar(RateToPlay) @ `showvar(Seq.Rate) );

	//Seq.bPlaying = FALSE;
}


/** 
 * We need to open the combo window when we do a HoldPose as we could be holding the pose for A LONG LONG TIME.
 * AND the hold pose could come before the combo success point occurs.  So the melee system is there thinking
 * that we are not allowed to transition even tho the player has mashed the correct buttons.
 *
 * So if we have not mashed buttons then we will pause for a long time.
 * otherwise we will transition nicely.  
 *
 * And we should be able to transition on hitting a button also during the hold pose?
 **/
private function OpenComboWindow( Actor Owner, AnimNodeSequence AnimSeqInstigator )
{
	local NanoPawn NP;
	local NanoWeap_Melee Sword;

	NP = NanoPawn(Owner);
	if(NP != None)
	{
		Sword = NanoWeap_Melee(NP.Weapon);
		if(Sword != None)
		{
		//	Sword.ComboWindowOpen();
		//	Sword.ComboSuccessTransition();
		}
	}
}




defaultproperties
{
	DurationToHold=0.1f
}