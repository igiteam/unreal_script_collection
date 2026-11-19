class AlarmSwitch extends UseButton
	hidecategories(Visual)
    placeable;
    
var SkeletalMeshComponent SkeletalMeshComponent;
var SkelControlSingleBone LeverControl;
var float Rate;
var bool bIsDown;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if( LeverControl == None )
	{
		LeverControl  = SkelControlSingleBone(SkeletalMeshComponent.FindSkelControl('LeverControl'));
		if (LeverControl == none)
		{
			;
			return;
		}
	}
}

function bool UsedBy(Pawn User)
{
	super.UsedBy(User);
	
	if (LeverControl != none)
	{
		if (!IsInState('Animating'))
			PushState('Animating');
	}

	return true;
}

state Animating
{
	function PoppedState()
	{
		bIsDown = !bIsDown;
		Rate *= -1;
	}

	function Tick(float dt)
	{
		LeverControl.BoneRotation.Roll += Rate * dt;
		if (!bIsDown)
		{
			if (LeverControl.BoneRotation.Roll >= 16384)
			{
				LeverControl.BoneRotation.Roll = 16384;
				PopState();
			}
		}
		else
		{
			if (LeverControl.BoneRotation.Roll <= 0)
			{
				LeverControl.BoneRotation.Roll = 0;
				PopState();
			}
		}
	}
}

