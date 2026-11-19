/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class InterpActor_BusTramBase extends InterpActor_GearBasePlatform
	abstract
	native(Vehicle)
	notplaceable;

var protected StaticMeshComponent HighCollision;
var protected StaticMeshComponent DoorCollision;

var protected SkeletalMeshComponent RenderingMesh;

var transient Array<AnimNodeSlot>	SlotNodes;

cpptext
{
	/**
	 *	Called by Matinee when we open it to start controlling animation on this Actor.
	 *	Is also called again when the GroupAnimSets array changes in Matinee, so must support multiple calls.
	 */
	virtual void PreviewBeginAnimControl(class UInterpGroup* InInterpGroup);

	/** Called each frame by Matinee to update the desired sequence by name and position within it. */
	virtual void PreviewSetAnimPosition(FName SlotName, INT ChannelIndex, FName InAnimSeqName, FLOAT InPosition, UBOOL bLooping, UBOOL bFireNotifies, UBOOL bEnableRootMotion, FLOAT DeltaTime);

	/** Called each frame by Matinee to update the desired animation channel weights for this Actor. */
	virtual void PreviewSetAnimWeights(TArray<FAnimSlotInfo>& SlotInfos);

	/** Called by Matinee when we close it after we have been controlling animation on this Actor. */
	virtual void PreviewFinishAnimControl(class UInterpGroup* InInterpGroup);

	/** Called each from while the Matinee action is running, to set the animation weights for the actor. */
	virtual void SetAnimWeights( const TArray<struct FAnimSlotInfo>& SlotInfos );
};

/** Handle Kismet controls */
simulated function OnBusTramControl(SeqAct_BusTramControl Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		// 0 is Open Gate
 		DetachComponent(DoorCollision);
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		// 1 is Close Gate
		AttachComponent(DoorCollision);
	}
}

/** start anim control via matinee */
simulated function BeginAnimControl(InterpGroup InInterpGroup)
{
	MAT_BeginAnimControl(InInterpGroup);
}
native function MAT_BeginAnimControl(InterpGroup InInterpGroup);

/** finish anim control via matinee */
simulated function FinishAnimControl(InterpGroup InInterpGroup)
{
	MAT_FinishAnimControl(InInterpGroup);
}
native function MAT_FinishAnimControl(InterpGroup InInterpGroup);


simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, bool bEnableRootMotion)
{
	local AnimNodeSequence	SeqNode;

	SeqNode = AnimNodeSequence(RenderingMesh.Animations);
	if( SeqNode != None )
	{
		if( SeqNode.AnimSeqName != InAnimSeqName )
		{
			SeqNode.SetAnim(InAnimSeqName);
		}

		SeqNode.bLooping = bLooping;
		SeqNode.SetPosition(InPosition, bFireNotifies);
	}
}

defaultproperties
{
	BlockRigidBody=TRUE
	bCollideActors=TRUE
	bBlockActors=TRUE

	// no clamp so we can do the gondola switch
	bClampedBaseEnabled=FALSE

	Begin Object Name=MyLightEnvironment
		bEnabled=TRUE
	End Object

	// this obj is for all collision except rbs
	// has low walls, used during mantle sequence
	Begin Object Class=StaticMeshComponent Name=DoorCollision0
	End Object
	Components.Add(DoorCollision0)
	DoorCollision=DoorCollision0

	// this obj is designed solely to provide collision for rigid bodies
	Begin Object Class=StaticMeshComponent Name=RBCollision0
	End Object
	Components.Add(RBCollision0)
}