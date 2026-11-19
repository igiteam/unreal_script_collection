class TruckHigh extends TPSkeletalMeshActor
    placeable;

var ParticleSystemComponent ExhaustPSC;
var ParticleSystem ExhaustPSCTemplate;
var name ExhaustPipeSocket;
var bool bEnableExhaust;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    AttachExhaustParticle();
          
}

function CheckExhaustParticle()
{
    if(bEnableExhaust)
        AttachExhaustParticle();
    else
        DetachExhaustParticle();
}     

function AttachExhaustParticle()
{
    if (  SkeletalMeshComponent != none )
	{
		if (ExhaustPSCTemplate != none && bEnableExhaust)
		{
			ExhaustPSC = new(Outer) class'ParticleSystemComponent';
			SkeletalMeshComponent.AttachComponentToSocket(ExhaustPSC, ExhaustPipeSocket);
			ExhaustPSC.SetDepthPriorityGroup(SDPG_World);  				
            ExhaustPSC.SetTemplate(ExhaustPSCTemplate);
			ExhaustPSC.ActivateSystem();
		}
	}
}

function DetachExhaustParticle()
{
	if (  SkeletalMeshComponent != none && !bEnableExhaust)
	{
		if (ExhaustPSC != none)
			SkeletalMeshComponent.DetachComponent( ExhaustPSC );
	}
}

// Toggleable Exhaust for the Mad Kuo
simulated function OnToggle(SeqAct_Toggle action)
{
	if (action.InputLinks[0].bHasImpulse)
	{
		// turn on
		bEnableExhaust = true;
	}
	else if (action.InputLinks[1].bHasImpulse)
	{
		// turn off
		bEnableExhaust = false;
	}
	else if (action.InputLinks[2].bHasImpulse)
	{
		// toggle
		bEnableExhaust = !bEnableExhaust;
	}
	CheckExhaustParticle();
}     

