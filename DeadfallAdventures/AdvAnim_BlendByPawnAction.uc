class AdvAnim_BlendByPawnAction extends AnimNodeBlendList
    native(Anim)
    hidecategories(Object,Object,Object,Object);

var() float BlendTime;
var() byte CurrentPawnActionIndex;
var() editoronly const editconst string CurrentPawnActionEnumString;
var() editinline array<editinline byte> PawnActions;
var transient AdvPawn CachedOwner;

defaultproperties
{
    BlendTime=0.1000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}