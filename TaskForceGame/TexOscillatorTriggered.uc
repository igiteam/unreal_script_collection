class TexOscillatorTriggered extends TexOscillator
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

enum ERetriggerAction
{
	RTA_Reverse,
	RTA_Reset,
	RTA_Ignore,
	RTA_Retrigger,
};

var() ERetriggerAction RetriggerAction;
var() float StopAfterPeriod;
var transient float TriggeredTime;
var transient bool Reverse;
var transient bool Triggered;

function Trigger( Actor Other, Actor EventInstigator )
{
	if( Triggered )
	{
		switch( RetriggerAction )
		{
		case RTA_Reverse:
			Triggered = False;
			TriggeredTime = Other.Level.TimeSeconds;
			Reverse = True;
			break;
		case RTA_Reset:
			Triggered = False;
			TriggeredTime = -1.0;
			Reverse = True;
			break;
		}		
	}
	else
	{
		if( RetriggerAction != RTA_Retrigger )
			Triggered = True;
		TriggeredTime = Other.Level.TimeSeconds;
		Reverse = False;
	}
}

function Reset()
{
	Triggered = False;
	TriggeredTime = -1.0;
	Reverse = False;
}


// Decompiled with UE Explorer.
defaultproperties
{
    RetriggerAction=3
    StopAfterPeriod=0.5000000
    UOscillationRate=0.0000000
    VOscillationRate=0.5000000
    VOscillationPhase=0.2500000
    UOscillationAmplitude=0.0000000
    VOscillationAmplitude=0.5000000
}