//-----------------------------------------------------------
// ??????????????????
//-----------------------------------------------------------
class HDGameCrowdBehavior_PlayAnimation extends GameCrowdBehavior_PlayAnimation;

//Select animation index randomly
var() bool bRandomIndex;
var array<int> RandomIndex;

final function CreateRandomIndex()
{
   	local int i;

    RandomIndex.Length = 0;
    for(i = 0; i < AnimationList.Length; i++)
    {
        RandomIndex.AddItem(i);
    }
}

final function int GetRandomIndex()
{
    local int v, i;

    if(RandomIndex.Length == 0)
        return AnimationList.Length;

    i = Rand(RandomIndex.Length);
    v = RandomIndex[i];
    RandomIndex.Remove(i, 1);

    return v;
}

final function InitAnimIndex()
{
	if(bRandomIndex) //??????????
	{
        CreateRandomIndex();
        AnimationIndex = GetRandomIndex();
    }
	else
	{
	    AnimationIndex = 0;
    }
}

function InitBehavior(GameCrowdAgent Agent)
{
	local PlayerController PC, ClosestPC;
	local float ClosestDist, NewDist;
	local GameCrowdAgentSkeletal SkAgent;


	Super(GameCrowdAgentBehavior).InitBehavior(Agent);

	if ( CustomActionTarget != None )
	{
		ActionTarget = CustomActionTarget;
	}
	else if ( bLookAtPlayer )
	{
		ClosestDist = 1000000.0;

		// find local player, make it the action target
		foreach Agent.LocalPlayerControllers(class'PlayerController', PC)
		{
			if ( PC.Pawn != None )
			{
				NewDist = VSize(PC.Pawn.Location - Agent.Location);
				if ( NewDist < ClosestDist )
				{
					ClosestDist = NewDist;
					ClosestPC = PC;
				}
			}
		}
		if ( ClosestPC != None )
		{
			ActionTarget = ClosestPC.Pawn;
		}
	}

	SkAgent = GameCrowdAgentSkeletal(Agent);
	if ( SKAgent == None )
	{
		;
		return;
	}

    InitAnimIndex(); //Ex

	if ( !bFaceActionTargetFirst )
	{
		PlayAgentAnimation();
	}
}

final function PlayAgentAnimation()
{
   if(bLooping && LoopTime > 0.0 && LoopIndex == -1)  //????
   {
       MyAgent.SetTimer(LoopTime,FALSE,'OnPlayAgentAnimationExEnd');
   }

   PlayAgentAnimationNow();
}

/**
  *  Facing target, so play animation
  */
event FinishedTargetRotation()
{
	PlayAgentAnimation();
}

/**
  *  When an animation ends, play the next animation in the list.
  *  If done with list, if associated with a sequence, trigger its output.
  */
event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if(bLooping && LoopTime > 0.0 && AnimationIndex == LoopIndex) //????????
    {
        AnimEnd();
        return;
    }

	// called because we asked for early notify
	AnimationIndex = bRandomIndex ? GetRandomIndex() : AnimationIndex + 1;

	if(AnimationIndex < AnimationList.Length)
	{
		PlayAgentAnimationNow();
	}
	else if(bLooping)
	{
        InitAnimIndex();

        PlayAgentAnimationNow();
	}
	else
	{
        AnimEnd();
    }
}

final function AnimEnd()
{
    // see if there is another sequence attached to this one
    if ( (AnimSequence != None) && (AnimSequence.OutputLinks[0].Links.Length > 0) )
    {
    	SetSequenceOutput();
    	MyAgent.ClearLatentAction(class'SeqAct_PlayAgentAnimation', false);
    	AnimSequence.ActivateOutputLink(0);
    }

    MyAgent.StopBehavior();
}

