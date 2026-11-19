class PKItem_Boss_Giant_Meteor_Base extends PKItem_Boss_Base_Item
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
var PkPawn_Boss_Giant_Base Boss;

simulated event PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    MyMeteorMesh.SetScale(RandRange(5.0000000, 8.0000000));
    //return;    
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local PKDestructibleObject Destructible;
    local PKPlayerPawn PlayerPawn;

    // End:0x273
    if(Location.Z < float(-2700))
    {
        SetCollision(false, false);
        bCollideWorld = false;
        // End:0xF9
        foreach VisibleCollidingActors(Class'PKDestructibleObject', Destructible, 512.0000000, Location)
        {
            Destructible.TakeDamage(64, Boss.MyPKAI, Destructible.Location, Normal(Destructible.Location - Location), Class'PKDmgType_Rocket');            
        }        
        // End:0x1CD
        foreach VisibleActors(Class'PKPlayerPawn', PlayerPawn, float(Boss.MeteorDamageRadius), Location)
        {
            PlayerPawn.TakeDamage(Boss.MeteorDamage, Boss.MyPKAI, PlayerPawn.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'PKDmgType_Rocket');            
        }        
        Boss.PlayArchetypeEffect(CrashArchetype, Location, MakeRotator(int(float(90) * 182.0444000), 0, 0));
        Particles.SetStopSpawning(-1, true);
        MyMeteorMesh.SetHidden(true);
        SetTimer(0.5000000,, 'Destroy', self);        
    }
    else
    {
        SetLocation((Location + (Normal(Velocity) * float(256))) + (Normal(Location * vect(1.0000000, 1.0000000, 0.0000000)) * float(64)));
    }
    //return;    
}

auto simulated state BaseState
{
    function SetInitialVelocity()
    {
        Velocity = (((vect(1.0000000, 0.0000000, 0.0000000) * RandRange(-0.2000000, 0.2000000)) * float(5600)) + ((vect(0.0000000, 1.0000000, 0.0000000) * RandRange(-0.2000000, 0.2000000)) * float(5600))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(5600));
        //return;        
    }

    function SetNewVelocity()
    {
        local Vector NewVelocity;

        NewVelocity = GetALocalPlayerController().Pawn.Location - Location;
        NewVelocity.X += RandRange(-1000.0000000, 1000.0000000);
        NewVelocity.Z += RandRange(50.0000000, 100.0000000);
        NewVelocity.Y += RandRange(-1000.0000000, 1000.0000000);
        NewVelocity = Normal(NewVelocity);
        Velocity = (NewVelocity * RandRange(0.7000000, 1.0000000)) * float(5600);
        //return;        
    }
Begin:

    MaxHeight = RandRange(48000.0000000, 64000.0000000);
UpdateSpeed:


    // End:0x4C
    if(Velocity.Z < float(1))
    {
        SetInitialVelocity();
    }
    // End:0x8B
    if(Location.Z < MaxHeight)
    {
        Sleep(1.0000000);
        goto 'UpdateSpeed';        
    }
    else
    {
        SetNewVelocity();
        Particles = new (self) Class'Engine.ParticleSystemComponent';
        Particles.SetTemplate(ParticlesOnFall);
        AttachComponent(Particles);
        Particles.ActivateSystem();
        SetCollision(true, true);
        bCollideWorld = true;
        goto 'WaitForSound';
    }
    J0x124:

    // End:0x1B1
    if((Abs(VSize(Location - GetALocalPlayerController().Pawn.Location)) / Velocity.Z) < float(4))
    {
        PlaySound(SoundOnFlight,,,, Location);        
    }
    else
    {
        Sleep(0.1000000);
        goto 'WaitForSound';
    }
    stop;                    
}
