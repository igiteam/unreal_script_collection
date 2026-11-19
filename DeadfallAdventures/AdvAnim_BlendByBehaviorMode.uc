class AdvAnim_BlendByBehaviorMode extends AnimNodeBlendList
    native(Anim)
    hidecategories(Object,Object,Object,Object);

var() float BlendTime;
var transient AdvPawn CachedOwner;
var(Editor) editoronly bool bSynchronizeNodesInEditor;

// Export UAdvAnim_BlendByBehaviorMode::execNotifyBehaviorModeChanged(FFrame&, void* const)
native final function NotifyBehaviorModeChanged(EvilTypesNative.EBehaviorMode InNewMode, EvilTypesNative.EBehaviorMode InOldMode);

defaultproperties
{
    BlendTime=0.2000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}