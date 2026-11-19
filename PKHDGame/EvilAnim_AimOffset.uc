class EvilAnim_AimOffset extends AnimNodeAimOffset
    native(Anim)
    hidecategories(Object,Object,Object,Object);

enum EAimInput
{
    AI_PawnAimOffset,               // 0
    AI_MAX                          // 1
};

var const transient EvilPawn EvilPawnOwner;
var() const transient float TurnInPlaceOffset;
var() bool bUseInteractionPawnAim;
var() bool bTurnOffWhenReloadingWeapon;
var const transient bool bDoingWeaponReloadInterp;
var() float ReloadingBlendTime;
var const transient float ReloadingBlendTimeToGo;
var const transient Vector2D LastAimOffset;
var const transient Vector2D LastPostProcessedAimOffset;
var const transient float TurnAroundTimeToGo;
var() float TurnAroundBlendTime;
var() EvilAnim_AimOffset.EAimInput AimInput;

defaultproperties
{
    ReloadingBlendTime=0.3300000
    TurnAroundBlendTime=0.4200000
}