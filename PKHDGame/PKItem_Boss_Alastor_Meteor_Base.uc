class PKItem_Boss_Alastor_Meteor_Base extends PKItem_Boss_Base_Item
    notplaceable
    hidecategories(Navigation);

var export editinline StaticMeshComponent MeteorMesh;
var export editinline StaticMeshComponent MyMeteorMesh;
var float MaxHeight;
var ParticleSystem ParticlesOnFall;
var export editinline ParticleSystemComponent Particles;
var SoundCue SoundOnDestroy;
var SoundCue SoundOnFlight;
var EvilExplosion CrashArchetype;
var PKPawn_Boss_Alastor_Base Boss;
var int MonsterSpawnCount;
var int SpawnedMonstersCount;

simulated event PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    MyMeteorMesh.SetScale(RandRange(5.0000000, 8.0000000));
    Velocity = (vect(0.0000000, 0.0000000, -1.0000000) * RandRange(0.7500000, 1.0000000)) * float(16384);
    Particles = new (self) Class'EvilGame.UTParticleSystemComponent';
    Particles.SetTemplate(ParticlesOnFall);
    AttachComponent(Particles);
    Particles.ActivateSystem();
    SetCollision(true, true);
    bCollideWorld = true;
    //return;    
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local PKDestructibleObject Destructible;
    local PKPlayerPawn PlayerPawn;

    // End:0xBF
    foreach VisibleCollidingActors(Class'PKDestructibleObject', Destructible, 256.0000000, Location)
    {
        Destructible.TakeDamage(64, Boss.MyPKAI, Destructible.Location, Normal(Destructible.Location - Location), Class'PKDmgType_Rocket');        
    }    
    SetCollision(false, false);
    bCollideWorld = false;
    // End:0x1A5
    foreach VisibleActors(Class'PKPlayerPawn', PlayerPawn, float(Boss.MeteorDamageRadius), Location)
    {
        PlayerPawn.TakeDamage(Boss.MeteorDamage, Boss.MyPKAI, PlayerPawn.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'PKDmgType_Rocket');        
    }    
    Boss.PlayArchetypeEffect(CrashArchetype, Location, MakeRotator(int(float(90) * 182.0444000), 0, 0));
    Particles.SetStopSpawning(-1, true);
    MyMeteorMesh.SetHidden(true);
    //return;    
}

auto state BaseState
{Begin:

    // End:0x95
    if(Abs(VSize((Location - GetALocalPlayerController().Pawn.Location) * vect(0.0000000, 0.0000000, 1.0000000))) < float(4096))
    {
        PlaySound(SoundOnFlight,,,, Location);
        SetTimer(10.0000000,, 'Destroy', self);        
    }
    else
    {
        Sleep(0.1000000);
        goto 'Begin';
    }
    stop;                    
}
