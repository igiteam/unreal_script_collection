class MovieSubtitles extends Actor
	placeable;

var() bool bShowPlaceholder;
var bool bShowSpeakerNames;

var bool bShowMessage;
var float elapsedTime;
var float prevMilliSec;

struct Subtitle
{
	var() localized string Line1;
	var() localized float StartTime;
	var() localized float EndTime;
	var() localized SpeakerName.ESpeaker Speaker;
	var() localized bool bAlwaysShow;
};

var int currInx;

var() localized array<Subtitle> subtitles;


function Start()
{
//	Log("MovieSubtitles.Start        subtitles.Length:"$ subtitles.Length );
	elapsedTime = 0.4;  // Hack: because we previously had a slightly random offset due to a bug.
	currInx = 0;
	prevMilliSec = Level.Millisecond;
//	Log("st elapsedT:"$ elapsedTime $"  Lvl s:"$Level.Minute $":"$ Level.Second $"."$ Level.Millisecond );
}

function UpdateMessage()
{
	// Update time
	if( prevMilliSec != Level.Millisecond )
	{
		if( prevMilliSec > Level.Millisecond )
			elapsedTime += ((Level.Millisecond + 1000) - prevMilliSec)/1000.0;
		else
			elapsedTime += (Level.Millisecond  - prevMilliSec)/1000.0;
		prevMilliSec = Level.Millisecond;
	}
//	Log("   elapsedT:"$ elapsedTime $"  Lvl s:"$Level.Minute $":"$ Level.Second $"."$ Level.Millisecond );

	if( subtitles.Length == 0 )
		return;

	// Determine whether or not to increment index and 
	// whether or not to show message
	if( elapsedTime > subtitles[currInx].EndTime )
	{
	//	Log("MovieSubtitles.UpdateMessage     about to increment index  currInx:"$ currInx );

		// If there's still more entries in the list
		if( currInx < subtitles.Length - 1 )
		{
			// Advance message index
			currInx++;

			// Have we have reached the start time of the new current message?
			if( elapsedTime >= subtitles[currInx].StartTime )
				bShowMessage = true;
			else
				bShowMessage = false;
		}
		else
		{
			// Ok, no more messages in list
			bShowMessage = false;
		}
	}
	else
	{
		// Have we have reached the start time of the current message?
		if( elapsedTime >= subtitles[currInx].StartTime )
			bShowMessage = true;
		else
			bShowMessage = false;
	}
}

function string GetLine(bool bShowSubtitles)
{
	local string temp;

	if( subtitles.Length == 0 && bShowPlaceholder )
	{
		temp = "Placeholder subtitle: Blahblah!";
	}
	else
	{
		if( bShowMessage && (bShowSubtitles || subtitles[currInx].bAlwaysShow) )
		{
			// Add speaker name if a speaker is specified.  Otherwise, just print the line as-is.
			if( subtitles[currInx].Speaker == SPKR_None || !bShowSpeakerNames )
				temp = subtitles[currInx].Line1;
			else
				temp = class'SpeakerName'.static.GetSpkrName( subtitles[currInx].Speaker ) $": "$ subtitles[currInx].Line1;
		}
		else
		{
			temp = "";
		}
	//	Log("  bShowMessage:"$ bShowMessage $" bShowSubtitles:"$ bShowSubtitles $" temp:"$ temp );
	}

	return temp;
}

