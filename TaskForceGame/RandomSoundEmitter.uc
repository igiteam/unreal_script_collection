class RandomSoundEmitter extends Trigger placeable; 

var(RandomSoundEmitter)	float SoundGeneratingInterval;

// random value between min and max is generated and added to the 
// SoundGeneratingInterval to produce next sound generation time
var(RandomSoundEmitter)	float RandomMinInterval, RandomMaxInterval; 

var(RandomSoundEmitter)	float Radius; 
var(RandomSoundEmitter) bool Repeating;

var(RandomSoundEmitter) sound RandomSound; 

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	SetCollisionSize(Radius,Radius);
}

function Touch( actor Other )
{
	Super.Touch(Other); 
	SetTimer(0.01, Repeating);
}

function UnTouch( actor Other )
{

	SetTimer(0.0, false);
}

function Timer()
{
	if (RandomSound != None)
		PlaySound(RandomSound,, 1,,Radius, 1.0,true);

	if(Repeating)
	{
		SetTimer(SoundGeneratingInterval+Rand(RandomMaxInterval-RandomMinInterval)+RepeatTriggerTime, Repeating);
	}
}



// Decompiled with UE Explorer.
defaultproperties
{
    SoundGeneratingInterval=5.0000000
    RandomMinInterval=1.0000000
    RandomMaxInterval=2.0000000
    Radius=500.0000000
    TriggerType=5
    Texture=Texture'Engine.S_MaterialTrigger'
}