class MOHAGlassManager extends Object
    native;

var native const Pointer pimpl_;
var SoundCue GlassHitSound;
var SoundCue GlassSideHitSound;
var SoundCue GlassExplosionSmall;
var SoundCue GlassExplosionMedium;
var SoundCue GlassExplosionLarge;
var float ExplosionCutoffSmall;
var float ExplosionCutoffMedium;
var float ExplosionCutoffLarge;

// Export UMOHAGlassManager::execUpdate(FFrame&, void* const)
native function Update(float DeltaTime);

// Export UMOHAGlassManager::execPlaySound(FFrame&, void* const)
native function PlaySound(Vector Location, SoundCue Sound, Actor Actor);

// Export UMOHAGlassManager::execPlayGlassCornerSound(FFrame&, void* const)
native function PlayGlassCornerSound(Vector Location, Actor Actor);

// Export UMOHAGlassManager::execPlayGlassHitSound(FFrame&, void* const)
native function PlayGlassHitSound(Vector Location, Actor Actor);

// Export UMOHAGlassManager::execPlayExplosionSound(FFrame&, void* const)
native function PlayExplosionSound(Vector Location, int panes, Actor Actor);

defaultproperties
{
    GlassHitSound=SoundCue'Aud_GCm_FakeWAV.PlaceHolder.PlaceHolder'
    GlassExplosionSmall=SoundCue'Aud_GCm_FakeWAV.PlaceHolder.PlaceHolder'
    GlassExplosionMedium=SoundCue'Aud_GCm_FakeWAV.PlaceHolder.PlaceHolder'
    GlassExplosionLarge=SoundCue'Aud_GCm_FakeWAV.PlaceHolder.PlaceHolder'
    ExplosionCutoffSmall=2.0000000
    ExplosionCutoffMedium=4.0000000
    ExplosionCutoffLarge=7.0000000
}