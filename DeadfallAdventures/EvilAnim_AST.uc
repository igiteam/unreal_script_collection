class EvilAnim_AST extends AnimNodeSequenceBlendBase
    native(Anim)
    hidecategories(Object,Object,Object);

var(AST) EvilTypesNative.EAnimationSetType AST;
var transient EvilTypesNative.EAnimationSetType LastAST;
var(AST) int Index;
var(AST) editoronly editconst int PreviewNumAnims;
var(AST) editoronly editconst EvilAnimInfo PreviewAnimInfo;
var transient int lastIndex;
var transient EvilPawn MyEvilPawn;
var(AST) bool bResetRootYaw;
var(AST) bool bUseMovementSpeedModifier;
var(AST) bool bPlayBackward;
var(AST) float BlendTime;
var transient int ActiveChildIndex;
var transient float BlendTimeToGo;

// Export UEvilAnim_AST::execForceUpdateFromAnimDef(FFrame&, void* const)
native final simulated function ForceUpdateFromAnimDef(optional float InBlendTime = -1.0000000, optional bool bForceAnimChange = false);

defaultproperties
{
    BlendTime=0.3300000
}