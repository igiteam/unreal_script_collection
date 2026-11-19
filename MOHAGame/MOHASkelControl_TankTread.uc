class MOHASkelControl_TankTread extends SkelControlBase
    native
    hidecategories(Object);

var(TankTread) float SpaceAbove;
var(TankTread) float SpaceBelow;
var(TankTread) name TreadBone;
var int TreadIndex;
var(TankTread) float CenterOffset;
var(TankTread) array<float> AlternateScanOffsets;
var(TankTread) bool bAlwaysScan;
var transient float Adjustment;
var transient float TargetAdjustment;
var transient bool bInitialized;
var transient bool bDormant;
var transient bool bLastDirWasBackwards;

defaultproperties
{
    SpaceAbove=50.0000000
    SpaceBelow=50.0000000
    bIgnoreWhenNotRendered=true
}