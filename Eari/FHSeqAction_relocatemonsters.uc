// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class FHSeqAction_relocatemonsters extends SequenceAction;

event Activated()
{
	local FHMonster lMonster;

  	ForEach GetWorldInfo().DynamicActors(class'FHMonster', lMonster)
	    {
			lMonster.ReLocate();
	    }
}


// Decompiled with UE Explorer.
defaultproperties
{
    ObjName="FHSeqAction_relocatemonsters"
    ObjCategory="ForeverHunted Actions"
}