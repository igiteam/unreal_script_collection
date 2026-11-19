class DynamicProjector extends Projector;

auto state() Active
{
	function Tick(float DeltaTime)
	{
		DetachProjector();
		AttachProjector();
	}
	
	function Trigger( actor Other, pawn EventInstigator )
	{
			DetachProjector();
			GotoState('InActive');
	}	
}

state() Inactive
{
	ignores Tick;
	
	function Trigger( actor Other, pawn EventInstigator )
	{
		AttachProjector();
		GotoState('InActive');
	}	
}


// Decompiled with UE Explorer.
defaultproperties
{
    bDynamicAttach=true
    bStatic=false
}