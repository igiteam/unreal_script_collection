class TurokInterestPoint extends Actor
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

var(InterestPoint) float mRadius;
var(InterestPoint) class<Class> mControllerType;
var @NULL mNextInterestPoint;
var export editinline @NULL mDrawSphere;

event PostBeginPlay()
{
    TurokGameInfo(WorldInfo.Game).AddInterestPoint(self);
    //return;    
}

defaultproperties
{
    mRadius=300.0000000
    // Reference: DrawSphereComponent'Default__TurokInterestPoint.DrawSphere'
    begin object name=DrawSphere class=Class'Engine.DrawSphereComponent'
        SphereRadius=300.0000000
    end object
    mDrawSphere=DrawSphere
    // Reference: SpriteComponent'Default__TurokInterestPoint.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'TurokEditorResources.TurokPathNode'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    Components[1]=DrawSphere
}