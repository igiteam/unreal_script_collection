//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_LMGM249 extends HDWeap_LMG;

var transient TMAnimNodeSequence  BaseNode, AddNode;
var transient AnimNodeAdditiveBlending  AdditiveBlendingNode;

simulated function PostEquipped()
{
    local SkeletalMeshComponent SkelCpnt;
    SkelCpnt = SkeletalMeshComponent(Mesh);
    if ( SkelCpnt != none )
    {
       BaseNode = TMAnimNodeSequence(SkelCpnt.FindAnimNode('BaseNode'));
       AddNode = TMAnimNodeSequence(SkelCpnt.FindAnimNode('AddNode'));
       AdditiveBlendingNode = AnimNodeAdditiveBlending(SkelCpnt.FindAnimNode('AdditiveBlending'));
    }
}

simulated event Tick( float deltaTime )
{
    Super.Tick(deltaTime);
    if ( BaseNode == none || AddNode == none || AdditiveBlendingNode == none )
        PostEquipped();
}

simulated state WeaponEquipping
{
	simulated function WeaponEquipped()
	{
       PostEquipped();
       Super.WeaponEquipped();
	}
}

simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
	local float DesiredRate;
    if (Mesh == None || !Mesh.bAttached)
	   return;

	// do not play on a dedicated server
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	if ( SkelMesh == None )
	{
		SkelMesh = SkeletalMeshComponent(Mesh);
	}

	// Check we have access to mesh and animations
	if( SkelMesh == None || BaseNode == None )
	{
		return;
	}

	if(fDesiredDuration > 0.0)
	{
			// @todo - this should call GetWeaponAnimNodeSeq, move 'duration' code into AnimNodeSequence and use that.
			//ArmMeshComp.PlayAnim(Sequence, fDesiredDuration, bLoop);
			if (BaseNode.AnimSeq != None && BaseNode.AnimSeq.SequenceName == Sequence)
			{
				DesiredRate = (fDesiredDuration > 0.0) ? (BaseNode.AnimSeq.SequenceLength / fDesiredDuration) : 1.0;
				if (true || !BaseNode.bPlaying)
				{
					BaseNode.PlayAnim(bLoop, DesiredRate);
				}
				else
				{
					BaseNode.Rate = DesiredRate;
					BaseNode.bLooping = bLoop;
				}
			}
			else
			{
				BaseNode.SetAnim(Sequence);
				if (BaseNode.AnimSeq != None)
				{
					DesiredRate = (fDesiredDuration > 0.0) ? (BaseNode.AnimSeq.SequenceLength / fDesiredDuration) : 1.0;
					BaseNode.PlayAnim(bLoop, DesiredRate);
				}
			}
	}
	else
	{
		BaseNode.SetAnim(Sequence);
		BaseNode.PlayAnim(bLoop, DefaultAnimSpeed);
	}
}

// Play Fire Effect
simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	Super.PlayFireEffects( FireModeNum, HitLocation );

	// additive node
	if ( AddNode != None && AdditiveBlendingNode != None )
	{
	   AddNode.PlayAnim(false,1);
	   AdditiveBlendingNode.SetBlendTarget(1.0f, 0.f);
	}
}

