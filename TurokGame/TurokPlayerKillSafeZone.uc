class TurokPlayerKillSafeZone extends Actor
    native
    placeable
    hidecategories(Navigation);

var export editinline @NULL mLightEnvironmentComponent;
var export editinline @NULL mSprite;
var editoronly export editinline @NULL mPrimarySkelMesh;
var editoronly export editinline @NULL mSecondarySkelMesh;
var() editoronly @NULL mGraphSet;
var() editoronly name mGraphName;
var editoronly bool mComponentsPlaced;

defaultproperties
{
    // Reference: SpriteComponent'Default__TurokPlayerKillSafeZone.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'TurokEditorResources.TurokLocationMarker'
        HiddenGame=true
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    mSprite=Sprite
    // Reference: SkeletalMeshComponent'Default__TurokPlayerKillSafeZone.PrimaryMeshComponent'
    begin object name=PrimaryMeshComponent class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'CinematicCameraMesh.CameraBox'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPlayerKillSafeZone.MyLightEnvironment'
        HiddenGame=true
        CastShadow=false
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    mPrimarySkelMesh=PrimaryMeshComponent
    // Reference: SkeletalMeshComponent'Default__TurokPlayerKillSafeZone.SecondaryMeshComponent'
    begin object name=SecondaryMeshComponent class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'CinematicCameraMesh.CameraBox'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPlayerKillSafeZone.MyLightEnvironment'
        HiddenGame=true
        CastShadow=false
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    mSecondarySkelMesh=SecondaryMeshComponent
    bStatic=true
    bNoDelete=true
    bCollideWhenPlacing=true
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPlayerKillSafeZone.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=MyLightEnvironment
    Components[1]=Sprite
    Components[2]=PrimaryMeshComponent
    Components[3]=SecondaryMeshComponent
}