class SASVoiceManager extends Actor
	native
	notplaceable;


var array<int> mLastPlayedSampleIdx;


event PostBeginPlay()
{
	local int i;

	// Init array to store index of last sample played per sample type.
	mLastPlayedSampleIdx.Length = int(EPawnSpeech.SPEECH_NumTypes);

	for ( i = 0; i < int(EPawnSpeech.SPEECH_NumTypes); ++i )
	{
		mLastPlayedSampleIdx[i] = -1;
	}
}




// Decompiled with UE Explorer.
defaultproperties
{
    bHidden=true
}