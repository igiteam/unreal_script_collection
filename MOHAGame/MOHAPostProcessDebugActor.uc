class MOHAPostProcessDebugActor extends Actor
    native
    placeable
    hidecategories(Navigation);

var export editinline MOHAPostProcessComponent PostProcessComponent;
var(DEBUGING) bool bExplosion;
var(DEBUGING) bool bMeleeHit;
var(DEBUGING) bool bSpotLight;
var(DEBUGING) bool bLowHealth;
var(DEBUGING) bool bDying;
var(DEBUGING) bool bMedkit;
var(DEBUGING) bool bItemPickup;
var(DEBUGING) bool bBulletHit;
var(DEBUGING) bool bGeneric;
var(DEBUGING) float Explosion_Distance;
var(DEBUGING) int LowHealth_Health;
var transient bool bInitialized;
var MOHAPostProcessSettingsAsset defaultPostProcessSettingsAsset;
var() MOHAPostProcessSettingsAsset testPostProcessSettingsAsset;

defaultproperties
{
    // Reference: MOHAPostProcessComponent'Default__MOHAPostProcessDebugActor.PostProcessComponent0'
    begin object name=PostProcessComponent0 class=Class'MOHAPostProcessComponent'
    end object
    PostProcessComponent=PostProcessComponent0
    defaultPostProcessSettingsAsset=MOHAPostProcessSettingsAsset'PostProcessMaterialPackage.DefaultMOHAPostProcessSettings'
    Components[0]=PostProcessComponent0
    // Reference: SpriteComponent'Default__MOHAPostProcessDebugActor.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'EngineResources.S_Note'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[1]=Sprite
    CollisionType=0
}