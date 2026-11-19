class TurokSeqEvent_DestroyableActorDestroyed extends SequenceEvent
    hidecategories(Object);

var() bool mbOnDestroyed;
var() bool mbOnDamageAmount;
var() float mDamageAmount;

defaultproperties
{
    mbOnDestroyed=true
    mDamageAmount=100.0000000
    bPlayerOnly=false
    ObjName="Dest. Actor Destroyed"
    ObjCategory="Turok Gameplay"
}