class TurokSeqAct_CleanupProjectiles extends SequenceAction
    native
    hidecategories(Object);

var() bool mbCleanupArrows;
var() bool mbCleanupStickyGun;

defaultproperties
{
    mbCleanupArrows=true
    mbCleanupStickyGun=true
    VariableLinks=none
    ObjName="Cleanup Projectiles"
    ObjCategory="Pawn"
}