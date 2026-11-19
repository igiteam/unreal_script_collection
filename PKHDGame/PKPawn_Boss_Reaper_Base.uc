class PKPawn_Boss_Reaper_Base extends PKPawn_Boss_Base
    abstract
    config(Pawn)
    hidecategories(Navigation);

const maxMonsters = 9;

var name StrikeHandBoneName;
var bool bHitAlready;
var bool bVulnurable;
var bool bReadyToStrike;
var bool bIsStriking;
var bool bRoaming;
var bool bReadyToDie;
var repnotify bool bVulnerabilityVisuals;
var name StrafeDirection;
var name LeftHandStrikeBone;
var name RightHandStrikeBone;
var int DmgAccumulator;
var class<Projectile> ProjectileClass;
var Pawn Target;
var array<EvilPawn> currentMonstersList;
var int PissedOff;
var array< class<PKPawn> > MonsterPawnClass;
var array<ParticleSystem> MonsterSpawnEffect;
var int SpawnedMonsterCount;
var int NewMonsters;
var float LastHitByDemon;
var float LastStuckTime;
var float LastThrowTime;
var Vector MoveTarget;
var SoundCue StrikeSound;
var SoundCue SpinSound;
var SoundCue FirebalSound;
var SoundCue SpawnScream;
var SoundCue HurtScream;
var SoundCue LockScream;
var SoundCue TakeSoulSound;
var export editinline AudioComponent HealingSoundLoop;
var config int StrikeDamage;
var config int StrikeDamageRadius;
var config int SpinDamage;
var config int SpinDamageRadius;
var config int ProjectileDamage;
var config float MonsterSpeedModifier;
var repnotify ParticleSystem BoneSocketEffect;
var repnotify PKPawn SpawnedMonster;
var int SpawnedMonsterType;

replication
{
    // Pos:0x000
    if(bNetDirty)
        BoneSocketEffect, SpawnedMonster, 
        SpawnedMonsterType, bVulnerabilityVisuals;
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local PKPawn CurrentPawn;

    // End:0x68
    foreach DynamicActors(Class'PKPawn', CurrentPawn)
    {
        // End:0x67
        if(!CurrentPawn.IsA('PKPlayerPawn') && CurrentPawn != self)
        {
            CurrentPawn.Destroy();
        }        
    }    
    CallKismetEvent(Class'SeqEvent_BossKilled', 0);
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

function CheckMonstersList()
{
    local EvilPawn CurrentMonster;
    local array<EvilPawn> TempMonstersList;

    // End:0xCE
    if(currentMonstersList.Length > 0)
    {
        // End:0xBA
        foreach currentMonstersList(CurrentMonster)
        {
            // End:0xB9
            if((CurrentMonster.Health > 0) && CurrentMonster.AITeamInfo.TeamIndex == AITeamInfo.TeamIndex)
            {
                TempMonstersList.AddItem(CurrentMonster);
            }            
        }        
        currentMonstersList = TempMonstersList;
    }
    //return;    
}

function SpawnFirstWave()
{
    // End:0x11
    if(Health <= 0)
    {
        return;
    }
    CheckMonstersList();
    NewMonsters = 6;
    SpawnedMonsterCount = 0;
    MyPKAI.AbortMoving();
    MyPKAI.SetFocalPoint(Target.Location);
    PlaySound(SpawnScream,,,, Location);
    ServerDoPawnAction(78, true);
    SetTimer(0.5000000, false, 'SpawnNextMonster', self);
    SetTimer(float(NewMonsters) * 1.2500000, false, 'SpawnNextWave', self);
    LastThrowTime = WorldInfo.TimeSeconds;
    HealingSoundLoop.Play();
    //return;    
}

function SpawnNextWave()
{
    // End:0x11
    if(Health <= 0)
    {
        return;
    }
    CheckMonstersList();
    // End:0x125
    if(NewMonsters < 9)
    {
        NewMonsters++;
        SpawnedMonsterCount = 0;
        MyPKAI.AbortMoving();
        MyPKAI.SetFocalPoint(Target.Location);
        PlaySound(SpawnScream,,,, Location);
        ServerDoPawnAction(78, true);
        SetTimer(0.1000000, false, 'SpawnNextMonster', self);
        SetTimer(float(NewMonsters), false, 'SpawnNextWave', self);
        LastThrowTime = WorldInfo.TimeSeconds;        
    }
    else
    {
        HealingSoundLoop.Stop();
        DmgAccumulator = 0;
        ChangeVulnerabiltyVisuals(false);
        bRoaming = false;
    }
    //return;    
}

function SpawnNextMonster()
{
    local Vector CurrentSpawnLocation;
    local PKPawn CurrentMonster;
    local int MonsterType;

    // End:0x13
    if(currentMonstersList.Length >= 9)
    {
        return;
    }
    CurrentSpawnLocation = MyPKAI.GetRandomLocation(4096.0000000, true, Location) - vect(0.0000000, 0.0000000, 192.0000000);
    MonsterType = Rand(MonsterPawnClass.Length);
    CurrentMonster = Spawn(MonsterPawnClass[MonsterType],,, CurrentSpawnLocation, Rotator(CurrentSpawnLocation - Target.Location));
    // End:0x4F8
    if(CurrentMonster != none)
    {
        CurrentMonster.DressUp();
        PlayMonsterSpawnEffects(CurrentMonster, MonsterType);
        CurrentMonster.SetRotation(Rotator(Target.Location - CurrentMonster.Location));
        CurrentMonster.bNotCountable = false;
        // End:0x1E4
        if(!Class'EvilGame.EvilGame'.static.UseLowGore(WorldInfo))
        {
            CurrentMonster.TimeToBodyDisappear = 1.0000000;
        }
        CurrentMonster.SpawnDefaultController();
        CurrentMonster.bThrowSoul = true;
        CurrentMonster.bIsBoss = true;
        EvilGame(WorldInfo.Game).ChangeTeam(CurrentMonster.Controller, int(GetTeamNum()), false);
        EvilAnim_AST(CurrentMonster.MoveModeNode.Children[2].Anim).AnimSeq.RateScale = MonsterSpeedModifier;
        CurrentMonster.GroundSpeed = CurrentMonster.default.GroundSpeed * MonsterSpeedModifier;
        currentMonstersList.AddItem(CurrentMonster);
        CurrentMonster.SightRadius = SightRadius;
        CurrentMonster.MyPKAI.SightRadius = SightRadius;
        CurrentMonster.MyPKAI.SightSenseDistanceThreshold = SightRadius - 400.0000000;
        CurrentMonster.MyPKAI.SetMoveGoal(Target,, true);
        CurrentMonster.MyPKAI.SetEnemy(Target);
        CurrentMonster.MyPKAI.Focus = Target;        
    }
    SpawnedMonsterCount++;
    // End:0x52D
    if(SpawnedMonsterCount < NewMonsters)
    {
        SetTimer(0.5000000, false, 'SpawnNextMonster', self);
    }
    //return;    
}

simulated function PlayMonsterSpawnEffects(PKPawn Monster, int MonsterType)
{
    local ParticleSystem PS;
    local editinline ParticleSystemComponent PSC;

    SpawnedMonster = Monster;
    SpawnedMonsterType = MonsterType;
    PS = MonsterSpawnEffect[MonsterType];
    PSC = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(PS);
    Monster.AttachComponent(PSC);
    PSC.SetActorParameter('BoneSocketActor', Monster);
    PSC.ActivateSystem();
    //return;    
}

simulated function ChangeVulnerabiltyVisuals(bool InValue)
{
    bVulnerabilityVisuals = InValue;
    // End:0x38
    if(bVulnerabilityVisuals)
    {
        SetTimer(0.1000000, true, 'SineVulnerabiltyVisuals');        
    }
    else
    {
        SetParameterForAllMaterials('DissolveAmount', 1.0000000);
        ClearTimer('SineVulnerabiltyVisuals');
    }
    //return;    
}

simulated function SineVulnerabiltyVisuals()
{
    SetParameterForAllMaterials('DissolveAmount', 0.3000000 + (0.0500000 * Sin(WorldInfo.TimeSeconds)));
    //return;    
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0xA9
    if(DamageType == Class'PKDmgType_Demon')
    {
        // End:0xA6
        if((WorldInfo.TimeSeconds - LastHitByDemon) > 0.1000000)
        {
            super.TakeDamage(50, MyPKAI, HitLocation, Momentum, DamageType);
            LastHitByDemon = WorldInfo.TimeSeconds;
        }        
    }
    else
    {
        // End:0x12B
        if(DamageType == Class'PKDmgType_SoulReaperSlow')
        {
            // End:0x128
            if(GroundSpeed > (default.GroundSpeed * 0.5000000))
            {
                GroundSpeed -= float(256);
                // End:0x128
                if(GroundSpeed < (default.GroundSpeed * 0.5000000))
                {
                    GroundSpeed = default.GroundSpeed * 0.5000000;
                }
            }            
        }
        else
        {
            // End:0x2D1
            if(DamageType == Class'PKDmgType_SoulSawCombo')
            {
                super.TakeDamage(int(float(HealthMax) * 0.0500000), InstigatedBy, HitLocation, Momentum, DamageType, HitInfo);
                bVulnurable = true;
                MyPKAI.Focus = none;
                Velocity = vect(0.0000000, 0.0000000, 0.0000000);
                MyPKAI.AbortMoving();
                MyPKAI.SetFocalPoint(Target.Location);
                ClearTimer('Throw');
                ClearTimer('SpawnNextWave');
                HealingSoundLoop.Stop();
                PlaySound(LockScream,,,, Location);
                DmgAccumulator = 0;
                ChangeVulnerabiltyVisuals(false);
                ServerDoPawnAction(77, true);
                SetTimer(8.0000000, false, 'ResetVulnurability');                
            }
            else
            {
                // End:0x3EF
                if(DamageType == Class'PKDmgType_SoulSaw')
                {
                    // End:0x38E
                    if(!bVulnurable)
                    {
                        // End:0x334
                        if((DmgAccumulator + Damage) < (HealthMax / 6))
                        {
                            DmgAccumulator += Damage;                            
                        }
                        else
                        {
                            // End:0x38C
                            if(DmgAccumulator < (HealthMax / 6))
                            {
                                DmgAccumulator = HealthMax / 4;
                                bRoaming = true;
                                SpawnFirstWave();
                                ChangeVulnerabiltyVisuals(true);
                                return;                                
                            }
                            else
                            {
                                return;
                            }
                        }
                    }
                    PlaySound(HurtScream,,,, Location);
                    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo);
                }
            }
        }
    }
    // End:0x454
    if(RandRange(0.0000000, 1.0000000) < 0.1000000)
    {
        // End:0x441
        if(RandRange(0.0000000, 1.0000000) < 0.5000000)
        {
            StrafeDirection = 'Right';            
        }
        else
        {
            StrafeDirection = 'Left';
        }
    }
    //return;    
}

function ResetVulnurability()
{
    DmgAccumulator = 0;
    MyPKAI.Focus = Target;
    bVulnurable = false;
    GroundSpeed = default.GroundSpeed * 0.5000000;
    LastThrowTime = WorldInfo.TimeSeconds;
    //return;    
}

simulated function TakeSouls()
{
    local PainItem_Energy SoulToTake;

    // End:0x1C0
    foreach DynamicActors(Class'PainItem_Energy', SoulToTake)
    {
        // End:0x108
        if(VSize2D(SoulToTake.Location - Location) < float(128))
        {
            SoulToTake.Destroy();
            PlaySound(TakeSoulSound,,,, Location);
            // End:0xE0
            if((DmgAccumulator > 0) && Health < (HealthMax - 100))
            {
                Health += 100;
                DmgAccumulator -= 100;
                RefreshHealthPercentage();                
            }
            else
            {
                bRoaming = false;
                DmgAccumulator = 0;
                ChangeVulnerabiltyVisuals(false);                
                return;
            }
            // End:0x1BF
            continue;
        }
        // End:0x1BF
        if(!SoulToTake.ForceMoveToCatchingTarget)
        {
            SoulToTake.SetCatchingTarget(self);
            SoulToTake.ForceMoveToCatchingTarget = true;
            SoulToTake.CatchMaxSpeed = default.GroundSpeed * float(2);
            SoulToTake.TimeToLive = 30.0000000;
        }        
    }    
    //return;    
}

function StrikeAttack()
{
    local PKPlayerPawn Enemy;

    // End:0x0F
    if(bHitAlready)
    {
        return;
    }
    // End:0x102
    foreach DynamicActors(Class'PKPlayerPawn', Enemy)
    {
        // End:0x101
        if(VSize(Enemy.Location - Mesh.GetBoneLocation(StrikeHandBoneName)) < float(StrikeDamageRadius))
        {
            bHitAlready = true;
            Enemy.TakeDamage(StrikeDamage, MyPKAI, Mesh.GetBoneLocation(StrikeHandBoneName), vect(0.0000000, 0.0000000, 0.0000000), Class'PKDmgType_GrimReaper',, self);
        }        
    }    
    //return;    
}

function SpinAttack()
{
    local PKPlayerPawn Enemy;

    // End:0x0F
    if(bHitAlready)
    {
        return;
    }
    // End:0x1EB
    foreach DynamicActors(Class'PKPlayerPawn', Enemy)
    {
        // End:0x109
        if(VSize2D(Enemy.Location - Mesh.GetBoneLocation(LeftHandStrikeBone)) < float(SpinDamageRadius))
        {
            bHitAlready = true;
            Enemy.TakeDamage(SpinDamage, MyPKAI, Mesh.GetBoneLocation(LeftHandStrikeBone), vect(0.0000000, 0.0000000, 0.0000000), Class'PKDmgType_GrimReaper',, self);
        }
        // End:0x1EA
        if(VSize2D(Enemy.Location - Mesh.GetBoneLocation(RightHandStrikeBone)) < float(SpinDamageRadius))
        {
            bHitAlready = true;
            Enemy.TakeDamage(SpinDamage, MyPKAI, Mesh.GetBoneLocation(RightHandStrikeBone), vect(0.0000000, 0.0000000, 0.0000000), Class'PKDmgType_GrimReaper',, self);
        }        
    }    
    //return;    
}

function bool IsStillWalking()
{
    return MyPKAI.FindCommandOfClass(Class'EvilGame.EvilAICmd_MoveToGoal') != none;
    //return ReturnValue;    
}

protected simulated function ProcessMovementMode(float DeltaSeconds)
{
    // End:0x62
    if(IsStillWalking())
    {
        Mesh.RootMotionMode = 1;
        super(EvilPawn).ProcessMovementMode(DeltaSeconds);
        Mesh.RootMotionMode = 2;
    }
    //return;    
}

function Vector GetBestWanderLocation()
{
    local Vector currentTarget, BestTarget;
    local int LoopIndex;

    BestTarget = Target.Location + ((Normal(vect(1.0000000, 1.0000000, 0.0000000) * VRand()) * float(2048)) * RandRange(0.5000000, 1.0000000));
    LoopIndex = 0;
    J0x68:

    // End:0x177 [Loop If]
    if(LoopIndex < 15)
    {
        currentTarget = Target.Location + ((Normal(vect(1.0000000, 1.0000000, 0.0000000) * VRand()) * float(2048)) * RandRange(0.5000000, 1.0000000));
        // End:0x169
        if(MyPKAI.PointReachable(currentTarget) && RDiff(Rotator(currentTarget - Location), Rotator(Velocity)) < RDiff(Rotator(BestTarget - Location), Rotator(Velocity)))
        {
            BestTarget = currentTarget;
        }
        LoopIndex++;
        // [Loop Continue]
        goto J0x68;
    }
    return BestTarget;
    //return ReturnValue;    
}

simulated function Tick(float Delta)
{
    // End:0x56
    if(!Target.IsPlayerPawn())
    {
        Target = PKPawn(GetALocalPlayerController().Pawn);
    }
    // End:0xA7
    if(int(Physics) == int(0))
    {
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0xA5
        if(bVulnurable)
        {
            SetDesiredRotation(Rotation);
        }
        return;
    }
    super.Tick(Delta);
    MovementLogic(Delta);
    //return;    
}

function MovementLogic(float Delta)
{
    local Vector AccelDirection;

    Mesh.SetTranslation(Mesh.default.Translation);
    AccelDirection = vect(0.0000000, 0.0000000, 0.0000000);
    // End:0x767
    if(int(Physics) == int(1))
    {
        // End:0x767
        if((!bVulnurable && !IsStillWalking()) && GroundSpeed > float(0))
        {
            // End:0xBC
            if(int(CurrentMoveMode) != int(2))
            {
                ChangeMoveMode(2);
            }
            // End:0x4C0
            if(!bRoaming)
            {
                // End:0x138
                if((StrafeDirection == 'None') && bReadyToStrike)
                {
                    // End:0x125
                    if(RandRange(0.0000000, 1.0000000) < 0.5000000)
                    {
                        StrafeDirection = 'Right';                        
                    }
                    else
                    {
                        StrafeDirection = 'Left';
                    }
                }
                // End:0x214
                if((VSize2D(Velocity) < (default.GroundSpeed * 0.1000000)) && (WorldInfo.TimeSeconds - LastStuckTime) > float(1))
                {
                    LastStuckTime = WorldInfo.TimeSeconds;
                    MoveTarget = GetBestWanderLocation();
                    StrafeDirection = 'None';
                    Velocity = VRand() * default.GroundSpeed;
                    // End:0x208
                    if(PissedOff == 0)
                    {
                    }
                    bRoaming = true;
                }
                MoveTarget = Location;
                // End:0x284
                if(StrafeDirection == 'Left')
                {
                    AccelDirection += Vector(MakeRotator(0, int(float(Rotation.Yaw) - (float(90) * 182.0444000)), 0));
                }
                // End:0x2E1
                if(StrafeDirection == 'Right')
                {
                    AccelDirection += Vector(MakeRotator(0, int(float(Rotation.Yaw) + (float(90) * 182.0444000)), 0));
                }
                // End:0x460
                if(bReadyToStrike)
                {
                    // End:0x384
                    if(VSize2D(Location - Target.Location) > float(384))
                    {
                        AccelDirection += (Vector(Rotation) * (float(2048) / VSize2D(Location - Target.Location)));                        
                    }
                    else
                    {
                        bReadyToStrike = false;
                        bIsStriking = true;
                        GroundSpeed = default.GroundSpeed * 0.5000000;
                        Controller.SetFocalPoint(Target.Location);
                        // End:0x425
                        if(RandRange(0.0000000, 1.0000000) < 0.7500000)
                        {
                            ServerDoPawnAction(74);                            
                        }
                        else
                        {
                            ServerDoPawnAction(76);
                        }
                        LastThrowTime = WorldInfo.TimeSeconds;
                    }                    
                }
                else
                {
                    AccelDirection += ((Vector(Rotation) * (VSize2D(Location - Target.Location) - float(1536))) / float(256));
                }                
            }
            else
            {
                // End:0x585
                if((VSize2D(MoveTarget - Location) < float(512)) || (VSize2D(Velocity) < (GroundSpeed * 0.1000000)) && WorldInfo.TimeSeconds > (LastStuckTime + 2.0000000))
                {
                    LastStuckTime = WorldInfo.TimeSeconds;
                    MoveTarget = GetBestWanderLocation();
                }
                // End:0x5CC
                if(MyPKAI.PointReachable(MoveTarget))
                {
                    AccelDirection = Normal(MoveTarget - Location);                    
                }
                else
                {
                    MyPKAI.SetMoveGoal(Target, 1024.0000000, true, true);
                }
            }
            Acceleration = (Normal(AccelDirection) * AccelRate) * Delta;
            // End:0x767
            if((((LastThrowTime + 5.0000000) < WorldInfo.TimeSeconds) && !bReadyToStrike) && !bIsStriking)
            {
                Target = MyPKAI.Enemy;
                // End:0x767
                if((VSize2D(Location - Target.Location) > float(1024)) && RandRange(0.0000000, 100.0000000) < float(5))
                {
                    LastThrowTime = WorldInfo.TimeSeconds;
                    GroundSpeed = default.GroundSpeed * 0.5000000;
                    ServerDoPawnAction(78, true);
                    SetTimer(0.5000000, false, 'Throw', self);
                }
            }
        }
    }
    // End:0x790
    if(IsStillWalking())
    {
        GroundSpeed = default.GroundSpeed * float(4);        
    }
    else
    {
        // End:0x7F8
        if(PissedOff > 0)
        {
            // End:0x7DC
            if(GroundSpeed < (default.GroundSpeed * float(2)))
            {
                GroundSpeed += (float(1024) * Delta);                
            }
            else
            {
                GroundSpeed = default.GroundSpeed * float(2);
            }            
        }
        else
        {
            // End:0x82C
            if(GroundSpeed < default.GroundSpeed)
            {
                GroundSpeed += (float(64) * Delta);                
            }
            else
            {
                GroundSpeed = default.GroundSpeed;
            }
        }
    }
    //return;    
}

function Throw()
{
    local Projectile SpawnedProjectile;

    // End:0x11
    if(Health <= 0)
    {
        return;
    }
    SpawnedProjectile = Spawn(ProjectileClass,,, Mesh.GetBoneLocation('ForwardSculpture') + (Vector(Rotation) * float(256)));
    // End:0x139
    if(SpawnedProjectile != none)
    {
        PlaySound(FirebalSound,,,, Location);
        SpawnedProjectile.Init(Normal((Target.Location - SpawnedProjectile.Location) - vect(0.0000000, 0.0000000, 64.0000000)));
        SpawnedProjectile.Damage = float(ProjectileDamage);
    }
    //return;    
}

simulated event PostBeginPlay()
{
    AttachBoneSocketEffect();
    super(PKPawn).PostBeginPlay();
    SpawnFirstWave();
    ClearTimer('SpawnNextWave');
    LastHitByDemon = WorldInfo.TimeSeconds;
    //return;    
}

simulated function AttachBoneSocketEffect()
{
    local editinline ParticleSystemComponent PSC;

    BoneSocketEffect = ParticleSystem'ps_ch_GrimReaper.Effects.ps_ch_SuckinSoul';
    PSC = new (self) Class'EvilGame.UTParticleSystemComponent';
    PSC.SetTemplate(BoneSocketEffect);
    AttachComponent(PSC);
    PSC.SetActorParameter('BoneSocketActor', self);
    PSC.ActivateSystem();
    SetVectorParameterForAllMaterials('BurnColor', MakeLinearColor(1.0000000, 2.0000000, 0.1000000, 1.0000000));
    SetTimer(0.1000000, true, 'TakeSouls', self);
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x2C
        case 'BoneSocketEffect':
            AttachBoneSocketEffect();
            // End:0x90
            break;
        // End:0x57
        case 'SpawnedMonster':
            PlayMonsterSpawnEffects(SpawnedMonster, SpawnedMonsterType);
            // End:0x90
            break;
        // End:0x7A
        case 'bVulnerabilityVisuals':
            ChangeVulnerabiltyVisuals(bVulnerabilityVisuals);
            // End:0x90
            break;
        // End:0xFFFF
        default:
            super(PKPawn).ReplicatedEvent(VarName);
            break;
    }
    //return;    
}

simulated function SetVectorParameterForAllMaterials(name InParamName, LinearColor Value)
{
    local int I, numElems;
    local editinline SkeletalMeshComponent SKComp;

    // End:0x148
    if(PawnMaterials.Length > 0)
    {
        SKComp = GetSkeletalMeshComponent();
        numElems = SKComp.GetNumElements();
        I = 0;
        J0x58:

        // End:0xB8 [Loop If]
        if(I < numElems)
        {
            PawnMaterials[I].SetVectorParameterValue(InParamName, Value);
            ++I;
            // [Loop Continue]
            goto J0x58;
        }
        // End:0x148
        if(HeadSkeletalMeshComp != none)
        {
            I = 0;
            J0xD2:

            // End:0x148 [Loop If]
            if(I < HeadSkeletalMeshComp.GetNumElements())
            {
                PawnHeadMaterials[I].SetVectorParameterValue(InParamName, Value);
                I++;
                // [Loop Continue]
                goto J0xD2;
            }
        }
    }
    //return;    
}

defaultproperties
{
    StrikeDamage=30
    StrikeDamageRadius=256
    SpinDamage=30
    SpinDamageRadius=512
    ProjectileDamage=30
    MonsterSpeedModifier=1.3500000
    bIsBoss=true
    bThrowSoul=false
    bCanBeFrozen=false
    KillScoreSV=3.0000000
    // Reference: StaticMeshComponent'Default__PKPawn_Boss_Reaper_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn_Boss_Base.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn_Boss_Reaper_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn_Boss_Base.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    DefaultHealth=4000.0000000
    PawnActionClasses=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Reaper_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPawn_Boss_Reaper_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn_Boss_Base.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    bSmoothNetUpdates=false
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Boss_Reaper_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn_Boss_Base.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Boss_Reaper_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn_Boss_Base.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPawn_Boss_Reaper_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn_Boss_Base.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    MaxLeanRoll=0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Reaper_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Base.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn_Boss_Reaper_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn_Boss_Base.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Reaper_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Base.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn_Boss_Reaper_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn_Boss_Base.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    MaxStepHeight=128.0000000
    LedgeCheckThreshold=1024.0000000
    SightRadius=102400.0000000
    Mass=10000.0000000
    GroundSpeed=1024.0000000
    AccelRate=1024.0000000
    // Reference: SkeletalMeshComponent'Default__PKPawn_Boss_Reaper_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn_Boss_Base.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Reaper_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn_Boss_Reaper_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn_Boss_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPawn_Boss_Reaper_Base.FaceAudioComponent'
    // Archetype: EvilAudioComponent'Default__PKPawn_Boss_Base.FaceAudioComponent'
    begin object name="FaceAudioComponent"
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=FaceAudioComponent
    CollisionComponent=CollisionCylinder
}