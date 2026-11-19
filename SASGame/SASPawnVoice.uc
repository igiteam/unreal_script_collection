
class SASPawnVoice extends Actor
	native
	abstract
	notplaceable;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.


struct native DelayedSpeech
{
	var SASPawn				speaker;
	var EPawnSpeech			eSpeechType;
	var float				playTime;
	var int					sampleIndex;
};

var SASPawnVoice			mNextVoiceInList;		// Ptr to next voice object in linked list.
var SASVoiceManager			mVoiceMgr;
var array<DelayedSpeech>	mDelayedSpeech;			// List of delayed speech pending.
var bool					mbPlayingDelayedSpeech;	// Flag to indicate when we in process of firing off a delayed speech sample.

var float					mSpeechRadius;			// Sound audible radius.

// Loudness values for AI hearing.
var float					mWhisperAILoudness;
var float					mTalkAILoudness;
var float					mShoutAILoudness;

// General pawn speech.
var array<Sound>			mHitSounds;
var Range					mGenHitDelay;
var float					mGenHitChance;
var array<Sound>			mIncapacitatedSounds;
var array<Sound>			mDeathSounds;
var float					mDeathChance;
var array<Sound>			mCoughSounds;


native function bool PlaySpeech(
	SASPawn			aSpeaker,
	EPawnSpeech		aeSpeechType,
	optional bool	abAlwaysPlay,
	optional int	aSampleIndex );

native function bool PlayDelayedSpeech(
	SASPawn			aSpeaker,
	EPawnSpeech		aeSpeechType,
	optional bool	abAlwaysPlay,
	optional int	aSampleIndex );

native function ClearDelayedSpeechFor(
	SASPawn			aSpeaker );


event PostBeginPlay()
{
	local SASGameInfo	gi;

	Super.PostBeginPlay();

	gi = SASGameInfo( Level.Game );
	if ( gi != None )
	{
		mVoiceMgr = gi.GetVoiceManager();
	}

	Enable( 'Tick' );
}


event Tick(
	float	aDeltaSeconds )
{
	local int	i;

	// Update delayed speech.
	for ( i = 0; i < mDelayedSpeech.Length; i++ )
	{
		if ( mDelayedSpeech[i].playTime <= Level.TimeSeconds )
		{
			mbPlayingDelayedSpeech = true;
			PlaySpeech( mDelayedSpeech[i].speaker, mDelayedSpeech[i].eSpeechType, true );
			mbPlayingDelayedSpeech = false;

			mDelayedSpeech.Remove( i, 1 );
			i--;
		}
	}

	/*if ( mDelayedSpeech.Length == 0 )
	{
		Disable( 'Tick' );
	}*/
}


private event Speak(
	SASPawn		aSpeaker,
	Sound		aSample,
	ESoundSlot	aeSoundSlot,
	FLOAT		aAILoudness )
{
	aSpeaker.PlaySound(
		aSample,				// Sample
		aeSoundSlot,			// Slot
		1.0,					// Volume
		true,					// No override
		mSpeechRadius,			// Radius
		1.0,					// Pitch
		true );					// Attenuate

	// Make AI noise.
	if ( aAILoudness > 0.0 )
	{
		aSpeaker.MakeNoise( aAILoudness, NOISE_Voice );
	}
}



// Decompiled with UE Explorer.
defaultproperties
{
    mSpeechRadius=100.0000000
    mWhisperAILoudness=0.1000000
    mTalkAILoudness=0.2000000
    mShoutAILoudness=0.4000000
    mGenHitDelay=(Min=0.6000000,Max=0.8000000)
    mGenHitChance=0.8000000
    mDeathChance=0.8000000
    bHidden=true
}