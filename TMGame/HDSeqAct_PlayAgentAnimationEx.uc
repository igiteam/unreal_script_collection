//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDSeqAct_PlayAgentAnimationEx extends SeqAct_PlayAgentAnimation;

//Select animation index randomly
var() bool bRandomIndex;

function SetCurrentAnimationActionFor(GameCrowdAgentSkeletal Agent)
{
	local HDGameCrowdBehavior_PlayAnimation AnimBehavior;
	local int i;

	// init behavior properties
	AnimBehavior = new(Agent) class'HDGameCrowdBehavior_PlayAnimation';
	AnimBehavior.AnimSequence = self;
	AnimBehavior.BlendInTime = BlendInTime;
	AnimBehavior.BlendOutTime = BlendOutTime;
	AnimBehavior.bUseRootMotion = bUseRootMotion;
	AnimBehavior.bFaceActionTargetFirst = bFaceActionTargetFirst;
	AnimBehavior.bLooping = bLooping;
	AnimBehavior.LoopIndex = LoopIndex;
	AnimBehavior.LoopTime = LoopTime;
	AnimBehavior.bBlendBetweenAnims = bBlendBetweenAnims;
	AnimBehavior.CustomActionTarget = ActionTarget;

    //Ex
	AnimBehavior.bRandomIndex = bRandomIndex;

	for ( i=0; i<AnimationList.Length; i++ )
	{
		AnimBehavior.AnimationList[i] = AnimationList[i];
	}

	// activate behavior
	Agent.ActivateInstancedBehavior(AnimBehavior);
}

