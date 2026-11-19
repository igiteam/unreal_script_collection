class SpawnMethod_JumpAndFx extends SpawnMethod
    editinlinenew
    collapsecategories
    hidecategories(Object);

var ParticleSystem SpawnFxPS;
var array<SoundCue> SpawnSoundList;
var EvilLightActor SpawnLightActor;
var EvilLightActor SpawnLightArchetype;

function PostCreateActor(Actor NewActor)
{
    local int SpawnSoundIndex;
    local PKPawn PP;

    PP = PKPawn(NewActor);
    // End:0x93
    if(PP != none)
    {
        PP.SpawnFxPS = SpawnFxPS;
        PP.ClientSpawnFXPS();
        PP.bForceNetUpdate = true;
    }
    EvilPawn(NewActor).AIFactory.NotifyFactory(EvilPawn(NewActor), 0);
    NewActor.SetPhysics(2);
    SpawnLightActor = NewActor.Spawn(Class'EvilGame.EvilLightActor', NewActor,, NewActor.Location,, SpawnLightArchetype);
    SpawnLightActor.ServerActivate();
    SpawnSoundIndex = Rand(SpawnSoundList.Length);
    // End:0x1E8
    if(SpawnSoundList[SpawnSoundIndex] != none)
    {
        NewActor.PlaySound(SpawnSoundList[SpawnSoundIndex]);
    }
    //return;    
}

defaultproperties
{
    SpawnFxPS=ParticleSystem'ps_all_Levels.Effects.ps_ch_SpawnMonster01'
    SpawnSoundList[0]=SoundCue'a_Specials.Cue.respawn_m1'
    SpawnSoundList[1]=SoundCue'a_Specials.Cue.respawn_m2'
    SpawnSoundList[2]=SoundCue'a_Specials.Cue.respawn_m3'
    SpawnSoundList[3]=SoundCue'a_Specials.Cue.respawn_m4'
    SpawnSoundList[4]=SoundCue'a_Specials.Cue.respawn_m5'
    SpawnSoundList[5]=SoundCue'a_Specials.Cue.respawn_m6'
    SpawnLightArchetype=EvilLightActor'ps_all_Levels.Archetypes.ar_spawn01Light'
}