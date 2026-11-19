class TurokGrassActor extends Actor
    native
    config(Game)
    placeable
    hidecategories(Navigation);

var() const editconst export editinline @NULL TurokGrassComponent;
var export editinline @NULL mSoundController;
var @NULL mGrassLoopSndCue;
var int mAmbientSndIndex;
var bool bPlayingAmbience;
var const config int mMinForceForAudio;
var const config int mMaxForceForAudio;

simulated function DrawCollisionVolumes(@NULL HUD)
{
    TurokGrassComponent.super(TurokGrassActor).DrawCollisionVolumes(HUD);
    //return;    
}

simulated function OnSetMaterial(@NULL Action)
{
    TurokGrassComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    //return;    
}

simulated function TakeRadiusDamage(@NULL InstigatedBy, float BaseDamage, float DamageRadius, class<Class> DamageType, float Momentum, @NULL HurtOrigin, bool bFullDamage, @NULL DamageCauser)
{
    super.TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser);
    TurokGrassComponent.Explosion(HurtOrigin, DamageType.default.DamageRadius);
    //return;    
}

// Export UTurokGrassActor::execPlayAmbientSound(FFrame&, void* const)
native function PlayAmbientSound(float Volume);

simulated event StopAmbientSound()
{
    mSoundController.StopAudioChannel(mAmbientSndIndex);
    bPlayingAmbience = false;
    //return;    
}

defaultproperties
{
    // Reference: TurokGrassComponent'Default__TurokGrassActor.TurokGrassComponent0'
    begin object name=TurokGrassComponent0 class=Class'TurokGrassComponent'
        StaticMesh=StaticMesh'ProxyStaticMesh_DO_NOT_USE.AGAIN_DO_NOT_USE_PLEASE.foliageproxy'
        CastShadow=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object
    TurokGrassComponent=TurokGrassComponent0
    // Reference: TurokSoundController'Default__TurokGrassActor.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent class=Class'TurokSoundController'
    end object
    mSoundController=TurokSoundControllerComponent
    mGrassLoopSndCue=SoundCue'SndBushInteraction.BushLoopSndCue'
    mAmbientSndIndex=-1
    bNoDelete=true
    bGameRelevant=true
    bMovable=false
    bCollideActors=true
    bEdShouldSnap=true
    bRenderStasis=true
    bMultiplayerRenderStasis=true
    // Reference: SpriteComponent'Default__TurokGrassActor.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    Components[1]=TurokGrassComponent0
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=TurokGrassComponent0
}