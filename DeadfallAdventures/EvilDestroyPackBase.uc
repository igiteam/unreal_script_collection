class EvilDestroyPackBase extends KActor
    implements(EvilBurningInterface,EvilWeaponFireTargetInterface);

var(DestroyPack) float Mass;
var(DestroyPack) int Health;
var(DestroyPack) bool bIgnoreNormalKActorMomentum;
var repnotify bool bReplicationStartBurning;
var() bool ForceMeleeAction;
var() bool ShowMeleeMessage;
var bool IsDestroyed;
var bool bIsWeaponFireTarget;
var(DestroyPack) float ExplosionLag;
var(DestroyPack) EvilExplosion ExplosionFX;
var EvilExplosion ExplosionTemplate;
var(DestroyPack) float MomentumScale;
var(DestroyPack) float ZMomentumScale;
var(DestroyPack) EvilGoreToDmgTypeSettings GibsInfo;
var(DestroyPack) array<EvilGib> Gibs;
var(DestroyPack) array<StaticMesh> StaticMeshGibs;
var(DestroyPack) EvilGib GibTemplate;
var class<EvilDmgType_Base> dmgType;
var Vector CurrentMomentum;
var EvilDynamicNavMeshObstacle Obstacle;
var() EvilDynamicNavMeshObstacle ObstacleTemplate;
var() array< class<EvilDmgType_Base> > IgnoredDmgTypes;
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
var array<MaterialInstanceConstant> Materials;
var() const editconst export editinline CylinderComponent CylinderComponent;
var array<EvilPawn> TouchingPawns;
var() string MeleeLocKey;

replication
{
    // Pos:0x000
    if(bNetDirty
        CurrentMomentum, bReplicationStartBurning, 
        dmgType;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x43
    if(VarName == 'bReplicationStartBurning')
    {
        Burn(BurningTotalTime, BurningDamageInterval, BurningDamageAmount);        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

simulated event PostBeginPlay()
{
    local int I;

    super.PostBeginPlay();
    // End:0x9A
    if((int(Role) == int(ROLE_Authority)) && ObstacleTemplate != none)
    {
        Obstacle = Spawn(Class'EvilDynamicNavMeshObstacle',,,,, ObstacleTemplate);
        Obstacle.SetLocation(Location);
        Obstacle.RegisterObstacle();
    }
    I = 0;
    J0xA5:

    // End:0x115 [Loop If]
    if(I < StaticMeshComponent.GetNumElements())
    {
        Materials.AddItem(StaticMeshComponent.CreateAndSetMaterialInstanceConstant(I));        
        I++;
        // [Loop Continue]
        goto J0xA5;
    }
    //return;    
}

event OnWakeRBPhysics()
{
    super(Actor).OnWakeRBPhysics();
    CylinderComponent.SetActorCollision(false, false);
    Obstacle.UnRegisterObstacle();
    //return;    
}

event OnSleepRBPhysics()
{
    // End:0x4F
    if(Obstacle != none)
    {
        Obstacle.SetLocation(Location);
        Obstacle.RegisterObstacle();
    }
    CylinderComponent.SetActorCollision(true, false);
    super(Actor).OnSleepRBPhysics();
    //return;    
}

private final function bool DamageClassIsIgnored(class<EvilDmgType_Base> _dmgType)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x54 [Loop If]
    if(I < IgnoredDmgTypes.Length)
    {
        // End:0x46
        if(_dmgType == IgnoredDmgTypes[I])
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return false;
    //return ReturnValue;    
}

event TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x13
    if(Health < 0)
    {
        return;
    }
    CurrentMomentum = (Momentum * MomentumScale) / Mass;
    CurrentMomentum.Z *= ZMomentumScale;
    super.TakeDamage(DamageAmount, EventInstigator, HitLocation, ((bIgnoreNormalKActorMomentum) ? vect(0.0000000, 0.0000000, 0.0000000) : CurrentMomentum), DamageType, HitInfo, DamageCauser);
    dmgType = class<EvilDmgType_Base>(DamageType);
    // End:0x221
    if((Health > 0) && !DamageClassIsIgnored(dmgType))
    {
        // End:0x19A
        if(((int(dmgType.default.ImpactTypeBallisticID) != 0) || dmgType == Class'EvilDmgType_Fire') || dmgType == Class'EvilDmgType_BarrelExplosion')
        {
            Burn(BurningTotalTime, BurningDamageInterval, BurningDamageAmount);
            bReplicationStartBurning = true;
        }
        Health -= DamageAmount;
        // End:0x221
        if(Health <= 0)
        {
            // End:0x217
            if(ExplosionLag > float(0))
            {
                // End:0x214
                if(!IsTimerActive('Explode_T'))
                {
                    SetTimer(ExplosionLag + RandRange(0.1000000, 0.3000000), false, 'Explode_T');
                }                
            }
            else
            {
                Explode_T();
            }
        }
    }
    //return;    
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool _bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0000000)
{
    local float ColRadius, ColHeight, DamageScale, Dist, ScaledDamage;

    local Vector Dir;

    super.TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, (MomentumScale * Momentum) / Mass, HurtOrigin, _bFullDamage, DamageCauser, DamageFalloffExponent);
    dmgType = class<EvilDmgType_Base>(DamageType);
    // End:0x287
    if((Health > 0) && !DamageClassIsIgnored(dmgType))
    {
        GetBoundingCylinder(ColRadius, ColHeight);
        Dir = Location - HurtOrigin;
        Dist = VSize(Dir);
        Dir = Normal(Dir);
        // End:0x143
        if(_bFullDamage)
        {
            DamageScale = 1.0000000;            
        }
        else
        {
            Dist = FMax(Dist - ColRadius, 0.0000000);
            DamageScale = FClamp(1.0000000 - (Dist / DamageRadius), 0.0000000, 1.0000000);
            DamageScale = DamageScale ** DamageFalloffExponent;
        }
        // End:0x1E8
        if(DamageScale > 0.0000000)
        {
            ScaledDamage = DamageScale * BaseDamage;
        }
        Health -= int(ScaledDamage);
        // End:0x287
        if((Health <= 0) && int(Role) == int(ROLE_Authority))
        {
            // End:0x27D
            if(ExplosionLag > float(0))
            {
                // End:0x27A
                if(!IsTimerActive('Explode_T'))
                {
                    SetTimer(ExplosionLag + RandRange(0.1000000, 0.3000000), false, 'Explode_T');
                }                
            }
            else
            {
                Explode_T();
            }
        }
    }
    //return;    
}

function Explode_T()
{
    // End:0x46
    if(Obstacle != none)
    {
        Obstacle.UnRegisterObstacle();
        Obstacle.Destroy();
    }
    Destroy();
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
    // End:0x1EF
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        BurnEffectPSC = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(BurningParticle);
        AttachComponent(BurnEffectPSC);
        BurnEffectPSC.ActivateSystem();
        // End:0x172
        if(LightActorArchetype != none)
        {
            LightActor = Spawn(Class'EvilLightActor', self,, Location,, LightActorArchetype);
            LightActor.SetBase(self);
            LightActor.Activate();
        }
        I = 0;
        J0x17D:

        // End:0x1EF [Loop If]
        if(I < StaticMeshComponent.GetNumElements())
        {
            Materials[I].SetScalarParameterValue('Stan', 1.0000000);
            I++;
            // [Loop Continue]
            goto J0x17D;
        }
    }
    SetTimer(IntensityLag, true, 'IncremenetIntensity');
    SetTimer(InDamageInterval, true, 'DoBurnDamageTimer');
    SetTimer(InTotalTime, false, 'StopBurning');
    //return;    
}

simulated function IncremenetIntensity()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x81 [Loop If]
    if(I < StaticMeshComponent.GetNumElements())
    {
        Materials[I].SetScalarParameterValue('Intensywnosc', BurningIntensity);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    BurningIntensity += IntensityAmountToAdd;
    //return;    
}

function DoBurnDamageTimer()
{
    TakeDamage(int(BurningDamageAmount), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilDmgType_Fire',, self);
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
    ClearTimer('IncremenetIntensity');
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

simulated event Destroyed()
{
    local int I;
    local EvilGib Gib;
    local array<EvilGib> AdditionalGibsFromStaticMeshes;
    local EvilExplosionActor ExplosionActor;
    local EvilExplosion ExplosionObject;
    local EvilPawn P;
    local EvilPlayerController PC;

    // End:0x21A
    if(dmgType != none)
    {
        // End:0xBD
        if(ExplosionFX != none)
        {
            ExplosionActor = Spawn(Class'EvilExplosionActor', self,, Location);
            ExplosionObject = new Class'EvilExplosion' (ExplosionFX);
            ExplosionObject.HitNormal = vect(0.0000000, 0.0000000, 1.0000000);
            ExplosionActor.Explode(ExplosionObject);
        }
        I = 0;
        J0xC8:

        // End:0x169 [Loop If]
        if(I < StaticMeshGibs.Length)
        {
            Gib = Spawn(Class'EvilGib',,, Location,, GibTemplate);
            Gib.SetNewGibStaticMesh(StaticMeshGibs[I]);
            AdditionalGibsFromStaticMeshes.AddItem(Gib);            
            I++;
            // [Loop Continue]
            goto J0xC8;
        }
        Class'EvilPawnGoreSettings'.static.SpawnGibs(GibsInfo, Gibs, dmgType, Location, CurrentMomentum, self);
        Class'EvilPawnGoreSettings'.static.SpawnGibs(GibsInfo, AdditionalGibsFromStaticMeshes, dmgType, Location, CurrentMomentum, self);
        // End:0x21A
        if(IsBurning())
        {
            StopBurning();
        }
    }
    // End:0x2EA
    if(ForceMeleeAction)
    {
        // End:0x2E9
        foreach TouchingPawns(P)
        {
            PC = EvilPlayerController(P.Controller);
            // End:0x2E8
            if(PC != none)
            {
                PC.GetMeleeActionsManager().Reset();
                PC.GetMeleeActionsManager().StopHintMessage();
            }            
        }        
    }
    IsDestroyed = true;
    super.Destroyed();
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    // End:0x66
    if(((EvilPawn(Other) != none) && EqualEqual_InterfaceInterface(EvilPlayer_interface(Other), EvilPlayer_interface(none))) && VSize(Velocity) > float(1000))
    {
        Explode_T();
    }
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local EvilPawn P;

    P = EvilPawn(Other);
    // End:0x41
    if(P != none)
    {
        TouchingPawns.AddItem(P);        
    }
    // End:0x6D
    if(!IsTimerActive('ForceMeleeTimer'))
    {
        SetTimer(0.0500000, true, 'ForceMeleeTimer');
    }
    //return;    
}

event UnTouch(Actor Other)
{
    local EvilPawn P;
    local EvilPlayerController PC;

    P = EvilPawn(Other);
    // End:0x72
    if(P != none)
    {
        PC = EvilPlayerController(P.Controller);
        TouchingPawns.RemoveItem(P);        
    }
    // End:0x10D
    if(PC != none)
    {
        ShowMeleeMessage = default.ShowMeleeMessage;
        // End:0x10D
        if(ForceMeleeAction)
        {
            PC.GetMeleeActionsManager().Reset();
            PC.GetMeleeActionsManager().StopHintMessage();
        }
    }
    // End:0x131
    if(TouchingPawns.Length == 0)
    {
        ClearTimer('ForceMeleeTimer');
    }
    //return;    
}

simulated function ForceMeleeTimer()
{
    local EvilPawn P;
    local EvilPlayerController PC;
    local Vector X, Y, Z;

    // End:0x1F3
    if(ForceMeleeAction)
    {
        // End:0x1F2
        foreach TouchingPawns(P)
        {
            PC = EvilPlayerController(P.Controller);
            // End:0x1F1
            if(PC != none)
            {
                GetAxes(P.Rotation, X, Y, Z);
                // End:0x172
                if((Normal(X) Dot Normal(Location - P.Location)) >= 0.8000000)
                {
                    PC.GetMeleeActionsManager().ForceKick();
                    // End:0x16F
                    if(ShowMeleeMessage)
                    {
                        PC.GetMeleeActionsManager().ShowLocalizedHintMessage(MeleeLocKey);
                        ShowMeleeMessage = false;
                    }                    
                }
                else
                {
                    PC.GetMeleeActionsManager().Reset();
                    PC.GetMeleeActionsManager().StopHintMessage();
                    ShowMeleeMessage = default.ShowMeleeMessage;
                }
            }            
        }        
    }
    //return;    
}

simulated function bool IsWeaponFireTarget()
{
    return bIsWeaponFireTarget;
    //return ReturnValue;    
}

simulated function SetWeaponFireTarget(bool bInWeaponFireTarget)
{
    bIsWeaponFireTarget = bInWeaponFireTarget;
    //return;    
}

simulated function bool IsFriendlyWeaponFireTarget()
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    Mass=1.0000000
    Health=75
    ForceMeleeAction=true
    ShowMeleeMessage=true
    ExplosionLag=0.0010000
    MomentumScale=1.0000000
    ZMomentumScale=1.0000000
    BurningDamageAmount=5.0000000
    BurningDamageInterval=1.0000000
    BurningTotalTime=999.0000000
    IntensityAmountToAdd=0.1000000
    IntensityLag=0.1000000
    // Reference: CylinderComponent'Default__EvilDestroyPackBase.CollisionCylinder'
    begin object name=CollisionCylinder class=Class'Engine.CylinderComponent'
        CollisionHeight=50.0000000
        CollisionRadius=200.0000000
        bAlwaysRenderIfSelected=true
        ReplacementPrimitive=none
        CollideActors=true
        BlockZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    MeleeLocKey="DestroyPackDefault"
    // Reference: StaticMeshComponent'Default__EvilDestroyPackBase.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilDestroyPackBase.MyLightEnvironment'
        RBCollideWithChannels=(DeadPawn=true)
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__EvilDestroyPackBase.MyLightEnvironment'
    begin object name=MyLightEnvironment
        bCastShadows=false
        bUseBooleanEnvironmentShadowing=false
        OverriddenLightingChannels=(Dynamic=true,Gameplay_1=true)
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=CollisionCylinder
    bNoDelete=false
    bCanStepUpOn=false
    bCanBeDamaged=true
    bNoEncroachCheck=false
    bCallRigidBodyWakeEvents=true
    bPathColliding=false
    CollisionComponent=StaticMeshComponent0
}