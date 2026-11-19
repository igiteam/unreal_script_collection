class TurokCinematicAnchor extends Actor
    native
    placeable
    hidecategories(Navigation,Actor);

var deprecated @NULL mCinematicAsset;
var(CinematicAsset) array mCinematicAssets;
var(CinematicAsset) int mDisplayedAssetNumber;
var(CinematicAsset) float mDisplayedAssetAnimTime;
var private const export editinline transient @NULL mLightEnvironmentComponent;
var private const export editinline transient array mSkeletalMeshComponents;

defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__TurokCinematicAnchor.LightEnvironment'
    begin object name=LightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    mLightEnvironmentComponent=LightEnvironment
    bStatic=true
    bHidden=true
    bCollideActors=true
    // Reference: SpriteComponent'Default__TurokCinematicAnchor.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    Components[1]=LightEnvironment
}