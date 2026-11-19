class ADVDynamicDestructibleObject extends EvilDynamicDestructibleObject
    hidecategories(Navigation)
    implements(EvilBurningInterface);

var repnotify bool bReplicationStartBurning;
var repnotify bool bExtunguish;
var array<MaterialInstanceConstant> InstanceMaterials;
var export editinline ParticleSystemComponent BurnEffectPSC;
var EvilLightActor LightActor;
var() EvilLightActor LightActorArchetype;
var() ParticleSystem BurningParticle;
var() float BurningDamageAmount;
var() float BurningDamageInterval;
var() float BurningTotalTime;
var float BurningIntensity;
var() float IntensityAmountToAdd;
var() float IntensityLag;
var() export editinline AudioComponent BurningAudioComp;

replication
{
    // Pos:0x000
    if(bNetDirty || bNetInitial
        bReplicationStartBurning;

    // Pos:0x019
    if(bNetDirty
        bExtunguish;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x50
    if(VarName == 'bReplicationStartBurning')
    {
        // End:0x4D
        if(bReplicationStartBurning)
        {
            Burn(BurningTotalTime, BurningDamageInterval, BurningDamageAmount);
        }        
    }
    else
    {
        // End:0x74
        if(VarName == 'bExtunguish')
        {
            StopBurning();            
        }
        else
        {
            super.ReplicatedEvent(VarName);
        }
    }
    //return;    
}

simulated event PostBeginPlay()
{
    local int I;

    super.PostBeginPlay();
    I = 0;
    J0x15:

    // End:0x85 [Loop If]
    if(I < StaticMeshComponent.GetNumElements())
    {
        InstanceMaterials.AddItem(StaticMeshComponent.CreateAndSetMaterialInstanceConstant(I));        
        I++;
        // [Loop Continue]
        goto J0x15;
    }
    //return;    
}

simulated function UnDestroy()
{
    super.UnDestroy();
    bExtunguish = false;
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int OldHealth;
    local class<EvilDmgType_Base> dmgType;

    OldHealth = Health;
    dmgType = class<EvilDmgType_Base>(DamageType);
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x132
    if((OldHealth != Health) && !bDestroyed)
    {
        // End:0x132
        if(((int(dmgType.default.ImpactTypeBallisticID) != int(0)) || dmgType == Class'EvilGame.EvilDmgType_Fire') || dmgType == Class'EvilGame.EvilDmgType_BarrelExplosion')
        {
            Burn(BurningTotalTime, BurningDamageInterval, BurningDamageAmount);
            bReplicationStartBurning = true;
        }
    }
    //return;    
}

simulated function Burn(float InTotalTime, float InDamageInterval, float InDamageAmount, optional bool bMaterialsBlackEffects = true, optional bool bMaterialsDotEffects = true, optional bool bResetActualBlackMaterialValue = true, optional bool bResetActualDotsMaterialValue = true)
{
    local int I;

    // End:0x34
    if((IsBurning()) || BurningParticle == none)
    {
        return;
    }
    // End:0x21D
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        BurnEffectPSC = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(BurningParticle);
        AttachComponent(BurnEffectPSC);
        BurnEffectPSC.ActivateSystem();
        // End:0x172
        if(LightActorArchetype != none)
        {
            LightActor = Spawn(Class'EvilGame.EvilLightActor', self,, Location,, LightActorArchetype);
            LightActor.SetBase(self);
            LightActor.Activate();
        }
        I = 0;
        J0x17D:

        // End:0x1DA [Loop If]
        if(I < InstanceMaterials.Length)
        {
            InstanceMaterials[I].SetScalarParameterValue('Stan', 1.0000000);
            I++;
            // [Loop Continue]
            goto J0x17D;
        }
        // End:0x21D
        if(BurningAudioComp.SoundCue != none)
        {
            BurningAudioComp.Play();
        }
    }
    SetTimer(IntensityLag, true, 'IncrementIntensity');
    SetTimer(InDamageInterval, true, 'DoBurnDamageTimer');
    SetTimer(InTotalTime, false, 'StopBurning');
    //return;    
}

function DoBurnDamageTimer()
{
    TakeDamage(int(BurningDamageAmount), LastDamageInstingator, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Fire',, self);
    //return;    
}

simulated function IncrementIntensity()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x81 [Loop If]
    if(I < StaticMeshComponent.GetNumElements())
    {
        InstanceMaterials[I].SetScalarParameterValue('Intensywnosc', BurningIntensity);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    BurningIntensity += IntensityAmountToAdd;
    //return;    
}

simulated function bool IsBurning()
{
    return IsTimerActive('DoBurnDamageTimer') || BurnEffectPSC != none;
    //return ReturnValue;    
}

simulated function StopBurning()
{
    ClearTimer('DoBurnDamageTimer');
    ClearTimer('IncrementIntensity');
    // End:0x61
    if(BurnEffectPSC != none)
    {
        BurnEffectPSC.DeactivateSystem();
        BurnEffectPSC = none;
    }
    // End:0x93
    if(LightActor != none)
    {
        LightActor.Destroy();
        LightActor = none;
    }
    // End:0xD6
    if(BurningAudioComp.SoundCue != none)
    {
        BurningAudioComp.Stop();
    }
    //return;    
}

function OnBurn(SeqAct_Burn Action)
{
    // End:0xA2
    if(Action.InputLinks[0].bHasImpulse)
    {
        Burn(Action.InTotalTime, Action.InDamageInterval, Action.InDamageAmount);        
    }
    else
    {
        // End:0xE3
        if(Action.InputLinks[1].bHasImpulse)
        {
            StopBurning();
        }
    }
    //return;    
}

function DestructibleDestroyed(Controller EventInstigator)
{
    super.DestructibleDestroyed(EventInstigator);
    StopBurning();
    bExtunguish = true;
    bReplicationStartBurning = false;
    //return;    
}

defaultproperties
{
    BurningDamageAmount=5.0000000
    BurningDamageInterval=1.0000000
    BurningTotalTime=999.0000000
    IntensityAmountToAdd=0.1000000
    IntensityLag=0.1000000
    // Reference: AudioComponent'Default__ADVDynamicDestructibleObject.BurningAudioComponent0'
    begin object name=BurningAudioComponent0 class=Class'Engine.AudioComponent'
        FadeInStartTime=0.2000000
        FadeOutStartTime=0.2000000
    end object
    BurningAudioComp=BurningAudioComponent0
    // Reference: StaticMeshComponent'Default__ADVDynamicDestructibleObject.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__ADVDynamicDestructibleObject.MyLightEnvironment'
        BlockRigidBody=true
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: SkeletalMeshComponent'Default__ADVDynamicDestructibleObject.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: AnimNodeSequence'Default__ADVDynamicDestructibleObject.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__ADVDynamicDestructibleObject.MyLightEnvironment'
        BlockRigidBody=true
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__ADVDynamicDestructibleObject.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: RB_RadialImpulseComponent'Default__ADVDynamicDestructibleObject.ImpulseComponent0'
    begin object name=ImpulseComponent0
        ReplacementPrimitive=none
    end object
    RadialImpulseComponent=ImpulseComponent0
    // Reference: SpriteComponent'Default__ADVDynamicDestructibleObject.Sprite'
    begin object name=Sprite
        ReplacementPrimitive=none
    end object
    Components[0]=Sprite
    Components[1]=MyLightEnvironment
    Components[2]=SkeletalMeshComponent0
    Components[3]=StaticMeshComponent0
    Components[4]=BurningAudioComponent0
    CollisionComponent=StaticMeshComponent0
}