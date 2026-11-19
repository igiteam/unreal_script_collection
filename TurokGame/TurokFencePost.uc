class TurokFencePost extends Actor
    native
    placeable
    hidecategories(Navigation);

var() bool bTrace;
var() editconst @NULL mNext;
var() editconst @NULL mPrev;
var() editconst @NULL mFence;

defaultproperties
{
    bStatic=true
    bIgnoresVisibilityVolumes=true
    // Reference: SpriteComponent'Default__TurokFencePost.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'TurokEditorResources.TurokFencePost'
        HiddenGame=true
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    // Reference: TurokFencePostRenderingComponent'Default__TurokFencePost.Connections'
    begin object name=Connections class=Class'TurokFencePostRenderingComponent'
        HiddenGame=true
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[1]=Connections
}