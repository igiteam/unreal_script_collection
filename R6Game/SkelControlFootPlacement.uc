class SkelControlFootPlacement extends SkelControlLimb
    native
    hidecategories(Object,Effector);

var(FootPlacement) float FootOffset;
var(FootPlacement) Object.EAxis FootUpAxis;
var(FootPlacement) Rotator FootRotOffset;
var(FootPlacement) bool bInvertFootUpAxis;
var(FootPlacement) bool bOrientFootToGround;
var(FootPlacement) bool bOnlyEnableForUpAdjustment;
var(FootPlacement) float MaxUpAdjustment;
var(FootPlacement) float MaxDownAdjustment;
var(FootPlacement) float MaxFootOrientAdjust;

defaultproperties
{
    FootUpAxis=1
    bOrientFootToGround=true
    MaxUpAdjustment=50.0000000
    MaxFootOrientAdjust=45.0000000
}