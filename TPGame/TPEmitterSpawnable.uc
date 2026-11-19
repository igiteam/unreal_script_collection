class TPEmitterSpawnable extends EmitterSpawnable
	native
    notplaceable;

var native TPPlayerController tpcontroller;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function ParticleCleanup()
{
	//if ( tPC != none )
		//tPC.numEmittersInMemory--;
}

function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
	Super.OnParticleSystemFinished(FinishedComponent);

	if ( tpcontroller != none )
		tpcontroller.numEmittersOnScreen--;
}

/*function FinishDestroy()
{
	`log("FinishDestroy()");

	if ( tPC != none )
	{
		tPC.numEmittersInMemory--;
		`log("FinishDestroy() 2");
	}
		
	Super.FinishDestroy();
}*/

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	ParticleSystemComponent.OnSystemFinished = OnParticleSystemFinished;
	SetTPC();

	if ( tpcontroller != none )
	{
		tpcontroller.numEmittersOnScreen++;
		tpcontroller.numEmittersInMemory++;
		
	}
		
}

function SetTPC()
{
	foreach LocalPlayerControllers(class'TPPlayerController', tpcontroller)
	{
		//`log("tPC = " @ tPC);
		return;
	}
}
	
