class PKItem_Boss_Giant_Spike_Base extends PKItem_Boss_Base_Item
    notplaceable
    hidecategories(Navigation);

var SoundCue SpikeEmergeSound;
var SoundCue SpikeHideSound;
var export editinline StaticMeshComponent SpikeMesh;
var export editinline StaticMeshComponent MySpikeMesh;
var EvilExplosion EmergeArchetype;
var PkPawn_Boss_Giant_Base Boss;
var int SpawnZ;
var bool bReadyToHide;
var PKPlayerPawn Enemy;

function DealDamage()
{
    local PKPlayerPawn CurrentEnemy;

    // End:0x19A
    foreach DynamicActors(Class'PKPlayerPawn', CurrentEnemy)
    {
        // End:0x199
        if(VSize2D(CurrentEnemy.Location - Location) < float(64))
        {
            CurrentEnemy.TakeDamage(Boss.SpikeDamage, Boss.MyPKAI, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Melee',, self);
            CurrentEnemy.Velocity = (Normal(VRand() * vect(1.0000000, 1.0000000, 0.0000000)) * float(Boss.SpikeVelocity)) / float(2);
            CurrentEnemy.Velocity.Z += float(Boss.SpikeVelocity);
            CurrentEnemy.SetPhysics(2);
        }        
    }    
    //return;    
}

event Tick(float DeltaTime)
{
    // End:0x56
    if(Location.Z > float(SpawnZ + 512))
    {
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        bReadyToHide = true;
    }
    // End:0x93
    if(bReadyToHide)
    {
        Velocity.Z -= (float(2048) * DeltaTime);
    }
    super(Actor).Tick(DeltaTime);
    //return;    
}

auto simulated state Emerging
{Begin:

    Sleep(RandRange(0.1500000, 0.2500000));
    SetLocation(Boss.FindVerticalPosition((Enemy.Location + ((VRand() * vect(1.0000000, 1.0000000, 0.0000000)) * float(6))) + (Enemy.Velocity * 0.5000000)));
    SpawnZ = int(Location.Z);
    Sleep(0.5000000);
    DealDamage();
    PlaySound(SpikeEmergeSound,,,, Location);
    Boss.PlayArchetypeEffect(EmergeArchetype, Location, MakeRotator(int(float(90) * 182.0444000), 0, 0));
    MySpikeMesh.SetTranslation(vect(0.0000000, 0.0000000, 1.0000000) * float(-768));
    SetHidden(false);
    Velocity = vect(0.0000000, 0.0000000, 1.0000000) * float(2048);
    Sleep(1.0000000);
    PlaySound(SpikeHideSound,,,, Location);
    stop;                
}
