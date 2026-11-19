class PKItem_Boss_Giant_Tornado_Base extends PKItem_Boss_Base_Item
    notplaceable
    hidecategories(Navigation);

var export editinline SkeletalMeshComponent TornadoMesh;
var export editinline SkeletalMeshComponent MyTornadoMesh;
var ParticleSystem ParticlesTornadoOnGround;
var export editinline ParticleSystemComponent Particles;
var PkPawn_Boss_Giant_Base Boss;
var Pawn Enemy;
var int FlightTime;

simulated function PlayAttack()
{
    self.SetHidden(false);
    MyTornadoMesh.PlayAnim('AttackTwister', 9.0000000, true);
    MyTornadoMesh.SetHidden(false);
    FlightTime = int(Boss.TornadoSuckInterval);
    SetTimer(0.1000000, true, 'SuckPlayer', self);
    SetTimer(0.1000000, true, 'MoveParticles', self);
    // End:0x202
    if(Particles == none)
    {
        Particles = WorldInfo.MyEmitterPool.SpawnEmitter(ParticlesTornadoOnGround, Location);
        Particles.SetActorParameter('BoneSocketActor', self);
        MyTornadoMesh.AttachComponent(Particles, 'T1');
        Particles.SetScale(10.0000000);
        Particles.SetAbsolute(true, true, true);
        Particles.SetRotation(MakeRotator(int(float(90) * 182.0444000), 0, 0));
        MoveParticles();
    }
    //return;    
}

simulated function StopAttack()
{
    MyTornadoMesh.SetHidden(true);
    ClearTimer('SuckPlayer', self);
    ClearTimer('MoveParticles', self);
    MyTornadoMesh.StopAnim();
    // End:0x95
    if(Particles != none)
    {
        Particles.DeactivateSystem();
    }
    //return;    
}

simulated function MoveParticles()
{
    local Vector Current, Best;
    local int LoopIndex;
    local Vector ParticlesLocation;

    Best = MyTornadoMesh.GetBoneLocation('t7') - Boss.FindVerticalPosition(MyTornadoMesh.GetBoneLocation('t7'));
    ParticlesLocation = Boss.FindVerticalPosition(MyTornadoMesh.GetBoneLocation('t7')) + (vect(0.0000000, 0.0000000, 1.0000000) * float(128));
    LoopIndex = 8;
    J0xF0:

    // End:0x2A9 [Loop If]
    if(LoopIndex < 18)
    {
        // End:0x29B
        if(VSize2D(MyTornadoMesh.GetBoneLocation(name("t" $ string(LoopIndex)))) < float(6144))
        {
            Current = MyTornadoMesh.GetBoneLocation(name("t" $ string(LoopIndex))) - Boss.FindVerticalPosition(MyTornadoMesh.GetBoneLocation(name("t" $ string(LoopIndex))));
            // End:0x29B
            if((VSize(Current) < VSize(Best)) && Current.Z > float(0))
            {
                Best = Current;
                ParticlesLocation = Boss.FindVerticalPosition(MyTornadoMesh.GetBoneLocation(name("t" $ string(LoopIndex)))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(128));
            }
        }
        LoopIndex++;
        // [Loop Continue]
        goto J0xF0;
    }
    Particles.SetAbsolute(true, true, true);
    Particles.SetTranslation(ParticlesLocation + (vect(0.0000000, 0.0000000, 1.0000000) * float(128)));
    //return;    
}

function Vector GetDirToTwister()
{
    local Vector Current, Best;
    local int LoopIndex;

    Best = MyTornadoMesh.GetBoneLocation('t7') - Enemy.Location;
    LoopIndex = 8;
    J0x5F:

    // End:0x1A3 [Loop If]
    if(LoopIndex < 18)
    {
        // End:0x195
        if(VSize2D(MyTornadoMesh.GetBoneLocation(name("t" $ string(LoopIndex)))) < float(6144))
        {
            Current = MyTornadoMesh.GetBoneLocation(name("t" $ string(LoopIndex))) - Enemy.Location;
            // End:0x195
            if((VSize(Current) < VSize(Best)) && Current.Z > Enemy.Location.Z)
            {
                Best = Current;
            }
        }
        LoopIndex++;
        // [Loop Continue]
        goto J0x5F;
    }
    return Best;
    //return ReturnValue;    
}

function SuckPlayer()
{
    local Vector DirToTwister;
    local float MinDistance;
    local PKPlayerPawn PlayerPawn;

    FlightTime++;
    // End:0x3C9
    foreach DynamicActors(Class'PKPlayerPawn', PlayerPawn)
    {
        Enemy = PlayerPawn;
        PlayerPawn.GetPC().ClientPlayCameraShake(CameraShake'PP_Resources.PlayerHitCameraShake', RandRange(0.7500000, 1.0000000));
        DirToTwister = GetDirToTwister();
        MinDistance = VSize2D(DirToTwister);
        // End:0x12A
        if(MinDistance < float(Boss.TornadoRadius))
        {
            PlayerPawn.GetPC().PushState('TornadoRotate');
        }
        // End:0x3C8
        if(float(FlightTime) >= (Boss.TornadoSuckInterval * float(10)))
        {
            // End:0x3C8
            if(MinDistance < float(Boss.TornadoRadius))
            {
                // End:0x254
                if(RandRange(0.0000000, 1.0000000) < Boss.TornadoDamageChance)
                {
                    Enemy.TakeDamage(Boss.TornadoDamage, Boss.MyPKAI, Enemy.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Melee');
                }
                // End:0x3C8
                if(Enemy.Location.Z < Boss.Location.Z)
                {
                    Enemy.MoveSmooth(vect(0.0000000, 0.0000000, 1.0000000) * float(256));
                    Enemy.Velocity = Normal(Boss.Location - Enemy.Location) * float(256);
                    Enemy.Velocity.Z = float(Boss.TornadoVelocity);
                    FlightTime = 0;
                    Enemy.SetPhysics(2);
                }
            }
        }        
    }    
    //return;    
}
