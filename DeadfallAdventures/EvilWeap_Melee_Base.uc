class EvilWeap_Melee_Base extends EvilWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var() bool bIsSwitchableAsMelee;
var() bool bIsSwitchableAsThrow;
var() bool bEquipClothWeapon;
var() config bool AutoAimPhysicObjects;
var() bool bIgnoreAimDot;
var() config float ForceTossZ;
var() config float ForceTossZPhys;
var() config float AutoAimDistance;
var() config float AutoAimDot;
var() config float AimDot;
var() config float DestructibleDamageScale;
var array<EvilPawn> KnockedPawns;

simulated function Activate()
{
    // End:0x1A
    if(bSelectable)
    {
        super.Activate();        
    }
    else
    {
        super(Weapon).Activate();
    }
    //return;    
}

simulated function bool IsSomethingInRange()
{
    local EvilPawn P;
    local Vector X, Y, Z;
    local Actor Other;

    P = EvilPawn(Instigator);
    // End:0x2D
    if(P == none)
    {
        return false;
    }
    GetAxes(P.Rotation, X, Y, Z);
    // End:0x13A
    foreach P.OverlappingActors(Class'Engine.Actor', Other, WeaponRange)
    {
        // End:0x139
        if(((KActor(Other) != none) || EvilPawn(Other) != none) && (Normal(X) Dot Normal(Other.Location - P.Location)) >= AimDot)
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

reliable server function ServerDoMeleeDamage(float DamageScale, optional Actor Target = none, optional Vector HitLocaltion = vect(0.0000000, 0.0000000, 0.0000000))
{
    DoMeleeDamage(DamageScale, Target, HitLocaltion);
    //return;    
}

simulated function DoMeleeDamage(float DamageScale, optional Actor Target = none, optional Vector HitLocaltion = vect(0.0000000, 0.0000000, 0.0000000))
{
    local Actor Other;
    local array<Actor> OtherActors;
    local EvilPawn P, OtherPawn;
    local EvilCreature OtherPawnCreature;
    local Vector X, Y, Z, Dist, HitNorm, HitLoc,
	    TraceStart, TraceEnd, ForceNorm;

    local float Radius, Force;
    local int I;
    local array<ImpactInfo> Impacts;
    local array<Vector> FlashLocationArray;
    local Vector FakeLoc;
    local float MinDist;
    local EvilPawn MinPawn;

    // End:0x51
    if(int(Role) < int(ROLE_Authority))
    {
        ServerDoMeleeDamage(DamageScale, Target, HitLocaltion);
        return;
    }
    P = EvilPawn(Instigator);
    // End:0x232B
    if(P != none)
    {
        GetAxes(P.GetAdjustedAimFor(self, vect(0.0000000, 0.0000000, 0.0000000)), X, Y, Z);
        Force = InstantHitMomentum[0];
        // End:0x1DE9
        if(Target == none)
        {
            // End:0x140
            foreach P.OverlappingActors(Class'Engine.Actor', Other, WeaponRange)
            {
                OtherActors.AddItem(Other);                                
            }            
            // End:0x1DE5
            foreach OtherActors(Other)
            {
                OtherPawn = EvilPawn(Other);
                // End:0x19F
                if(OtherPawn == none)
                {
                    OtherPawnCreature = EvilCreature(Other);
                }
                // End:0x79A
                if(((OtherPawn != none) && OtherPawn != P) && (P.MyEvilAI == none) || P.MyEvilAI.GetAIEnemyInfoIdx(OtherPawn) > -1)
                {
                    TraceStart = P.GetWeaponStartTraceLocation();
                    TraceEnd = TraceStart + (Vector(GetAdjustedAim(TraceStart)) * WeaponRange);                    
                    CalcWeaponFire(TraceStart, TraceEnd, Impacts);
                    I = 0;
                    J0x2CF:

                    // End:0x38E [Loop If]
                    if(I < Impacts.Length)
                    {
                        // End:0x380
                        if(Impacts[I].HitActor == Other)
                        {
                            HitLoc = Impacts[I].HitLocation;
                            HitNorm = -Impacts[I].HitNormal;
                            // [Explicit Break]
                            goto J0x38E;
                        }
                        I++;
                        // [Loop Continue]
                        goto J0x2CF;
                    }
                    J0x38E:

                    // End:0x534
                    if(IsZero(HitLoc) && (Normal(X) Dot Normal(OtherPawn.Location - P.Location)) >= AimDot)
                    {
                        Radius = 0.0000000;
                        // End:0x46A
                        if(OtherPawn.CylinderComponent != none)
                        {
                            Radius = OtherPawn.CylinderComponent.CollisionRadius;
                        }
                        Dist = OtherPawn.Location - P.Location;
                        HitNorm = Normal(Dist);
                        // End:0x534
                        if(FastTrace(OtherPawn.Location, TraceStart,, true))
                        {
                            HitLoc = OtherPawn.Location - (HitNorm * Radius);
                        }
                    }
                    // End:0x742
                    if(!IsZero(HitLoc))
                    {
                        // End:0x5E1
                        if(EqualEqual_InterfaceInterface(EvilPlayer_interface(OtherPawn), EvilPlayer_interface(none)) && OtherPawn.IsAliveAndWell())
                        {
                            ForceNorm = HitNorm;
                            ForceNorm.Z += ForceTossZ;
                            ForceNorm = Normal(ForceNorm);
                        }
                        GiveDamageTo(OtherPawn, int(InstantHitDamage[int(CurrentFireMode)] * DamageScale), Instigator.Controller, HitLoc, Force * HitNorm, InstantHitDamageTypes[0], ((Impacts.Length > I) ? Impacts[I].HitInfo : Impacts[0].HitInfo), self);
                        // End:0x713
                        if(P.MyEvilAI != none)
                        {
                            P.MyEvilAI.NotifyDoMeleeDamageHit();
                        }
                        KnockedPawns.AddItem(OtherPawn);                        
                        FlashLocationArray.AddItem(HitLoc);                                                
                    }
                    else
                    {
                        // End:0x79A
                        if(P.MyEvilAI != none)
                        {
                            P.MyEvilAI.NotifyDoMeleeDamageMissed();
                        }
                    }
                }
                // End:0xC60
                if((OtherPawn != P) && OtherPawnCreature != none)
                {
                    TraceStart = P.GetWeaponStartTraceLocation();
                    TraceEnd = TraceStart + (Vector(GetAdjustedAim(TraceStart)) * WeaponRange);                    
                    CalcWeaponFire(TraceStart, TraceEnd, Impacts);
                    I = 0;
                    J0x85B:

                    // End:0x91A [Loop If]
                    if(I < Impacts.Length)
                    {
                        // End:0x90C
                        if(Impacts[I].HitActor == Other)
                        {
                            HitLoc = Impacts[I].HitLocation;
                            HitNorm = -Impacts[I].HitNormal;
                            // [Explicit Break]
                            goto J0x91A;
                        }
                        I++;
                        // [Loop Continue]
                        goto J0x85B;
                    }
                    J0x91A:

                    // End:0xAC0
                    if(IsZero(HitLoc) && (Normal(X) Dot Normal(OtherPawnCreature.Location - P.Location)) >= AimDot)
                    {
                        Radius = 0.0000000;
                        // End:0x9F6
                        if(OtherPawnCreature.CylinderComponent != none)
                        {
                            Radius = OtherPawnCreature.CylinderComponent.CollisionRadius;
                        }
                        Dist = OtherPawnCreature.Location - P.Location;
                        HitNorm = Normal(Dist);
                        // End:0xAC0
                        if(FastTrace(OtherPawnCreature.Location, TraceStart,, true))
                        {
                            HitLoc = OtherPawnCreature.Location - (HitNorm * Radius);
                        }
                    }
                    // End:0xC5D
                    if(!IsZero(HitLoc))
                    {
                        // End:0xB6D
                        if(EqualEqual_InterfaceInterface(EvilPlayer_interface(OtherPawnCreature), EvilPlayer_interface(none)) && OtherPawnCreature.IsAliveAndWell())
                        {
                            ForceNorm = HitNorm;
                            ForceNorm.Z += ForceTossZ;
                            ForceNorm = Normal(ForceNorm);
                        }
                        GiveDamageTo(OtherPawnCreature, int(InstantHitDamage[int(CurrentFireMode)] * DamageScale), Instigator.Controller, HitLoc, Force * HitNorm, InstantHitDamageTypes[0], ((Impacts.Length > I) ? Impacts[I].HitInfo : Impacts[0].HitInfo), self);
                        FlashLocationArray.AddItem(HitLoc);                        
                    }                    
                }
                else
                {
                    // End:0x12A9
                    if(EvilDestroyPackBase(Other) != none)
                    {
                        // End:0x12A6
                        if((Normal(X) Dot Normal(EvilDestroyPackBase(Other).Location - P.Location)) >= AimDot)
                        {
                            TraceStart = P.GetWeaponStartTraceLocation();
                            TraceEnd = TraceStart + (Vector(GetAdjustedAim(TraceStart)) * WeaponRange);                            
                            CalcWeaponFire(TraceStart, TraceEnd, Impacts);
                            I = 0;
                            J0xD75:

                            // End:0xE35 [Loop If]
                            if(I < Impacts.Length)
                            {
                                // End:0xE27
                                if(EvilDestroyPackBase(Impacts[I].HitActor) != none)
                                {
                                    HitLoc = Impacts[I].HitLocation;
                                    HitNorm = -Impacts[I].HitNormal;
                                    // [Explicit Break]
                                    goto J0xE35;
                                }
                                I++;
                                // [Loop Continue]
                                goto J0xD75;
                            }
                            J0xE35:

                            // End:0xFA9
                            if(HitNorm == vect(0.0000000, 0.0000000, 0.0000000))
                            {
                                FakeLoc.X = P.Location.X;
                                FakeLoc.Y = P.Location.Y;
                                FakeLoc.Z = Other.Location.Z;
                                Dist = Other.Location - FakeLoc;
                                Dist.Z += ForceTossZPhys;
                                HitNorm = Normal(Dist);
                            }
                            // End:0xFFD
                            if(HitLoc == vect(0.0000000, 0.0000000, 0.0000000))
                            {
                                HitLoc = Other.Location - (HitNorm * float(10));
                            }
                            MinDist = AutoAimDistance;
                            MinPawn = none;
                            // End:0x1180
                            if(AutoAimPhysicObjects)
                            {
                                // End:0x117F
                                foreach P.VisibleActors(Class'EvilPawn', OtherPawn, AutoAimDistance)
                                {
                                    // End:0x117E
                                    if((Normal(X) Dot Normal(OtherPawn.Location - P.Location)) >= AutoAimDot)
                                    {
                                        // End:0x117E
                                        if((OtherPawn != P) && VSize(OtherPawn.Location - Other.Location) < MinDist)
                                        {
                                            MinDist = VSize(OtherPawn.Location - Other.Location);
                                            MinPawn = OtherPawn;
                                        }
                                    }                                    
                                }                                
                            }
                            // End:0x1213
                            if(MinPawn != none)
                            {
                                Dist = MinPawn.Location - Other.Location;
                                Dist.Z += ForceTossZPhys;
                                HitNorm = Normal(Dist);
                            }
                            GiveDamageTo(Other, int(InstantHitDamage[int(CurrentFireMode)] * DamageScale), Instigator.Controller, HitLoc, Force * HitNorm, InstantHitDamageTypes[0],, self);
                            FlashLocationArray.AddItem(HitLoc);                            
                        }                        
                    }
                    else
                    {
                        // End:0x169A
                        if(KActor(Other) != none)
                        {
                            // End:0x1697
                            if((Normal(X) Dot Normal(KActor(Other).Location - P.Location)) >= AimDot)
                            {
                                TraceStart = P.GetWeaponStartTraceLocation();
                                TraceEnd = TraceStart + (Vector(GetAdjustedAim(TraceStart)) * WeaponRange);                                
                                CalcWeaponFire(TraceStart, TraceEnd, Impacts);
                                I = 0;
                                J0x13BE:

                                // End:0x147C [Loop If]
                                if(I < Impacts.Length)
                                {
                                    // End:0x146E
                                    if(KActor(Impacts[I].HitActor) != none)
                                    {
                                        HitLoc = Impacts[I].HitLocation;
                                        HitNorm = Impacts[I].HitNormal;
                                        // [Explicit Break]
                                        goto J0x147C;
                                    }
                                    I++;
                                    // [Loop Continue]
                                    goto J0x13BE;
                                }
                                J0x147C:

                                // End:0x14F4
                                if(HitNorm == vect(0.0000000, 0.0000000, 0.0000000))
                                {
                                    HitNorm = Other.Location - P.Location;
                                    HitNorm = Normal(HitNorm);
                                }
                                // End:0x1548
                                if(HitLoc == vect(0.0000000, 0.0000000, 0.0000000))
                                {
                                    HitLoc = Other.Location - (HitNorm * float(10));
                                }
                                GiveDamageTo(Other, int(InstantHitDamage[int(CurrentFireMode)] * DamageScale), Instigator.Controller, HitLoc, Force * -HitNorm, InstantHitDamageTypes[0],, self);
                                // End:0x1681
                                if(int(KActor(Other).Physics) == int(14))
                                {
                                    KActor(Other).SetPhysics(10);
                                    KActor(Other).StaticMeshComponent.AddImpulse((Force * 0.0100000) * -HitNorm, HitLoc);
                                }
                                FlashLocationArray.AddItem(HitLoc);                                
                            }                            
                        }
                        else
                        {
                            // End:0x19EB
                            if(EvilDestructibleObject(Other) != none)
                            {
                                // End:0x19E8
                                if(bIgnoreAimDot || (Normal(X) Dot Normal(EvilDestructibleObject(Other).Location - P.Location)) >= AimDot)
                                {
                                    TraceStart = P.GetWeaponStartTraceLocation();
                                    TraceEnd = TraceStart + (Vector(GetAdjustedAim(TraceStart)) * WeaponRange);                                    
                                    CalcWeaponFire(TraceStart, TraceEnd, Impacts);
                                    I = 0;
                                    J0x17BE:

                                    // End:0x187C [Loop If]
                                    if(I < Impacts.Length)
                                    {
                                        // End:0x186E
                                        if(EvilDestructibleObject(Impacts[I].HitActor) != none)
                                        {
                                            HitLoc = Impacts[I].HitLocation;
                                            HitNorm = Impacts[I].HitNormal;
                                            // [Explicit Break]
                                            goto J0x187C;
                                        }
                                        I++;
                                        // [Loop Continue]
                                        goto J0x17BE;
                                    }
                                    J0x187C:

                                    // End:0x18F4
                                    if(HitNorm == vect(0.0000000, 0.0000000, 0.0000000))
                                    {
                                        HitNorm = Other.Location - P.Location;
                                        HitNorm = Normal(HitNorm);
                                    }
                                    // End:0x1948
                                    if(HitLoc == vect(0.0000000, 0.0000000, 0.0000000))
                                    {
                                        HitLoc = Other.Location - (HitNorm * float(10));
                                    }
                                    GiveDamageTo(Other, int((InstantHitDamage[int(CurrentFireMode)] * DamageScale) * DestructibleDamageScale), Instigator.Controller, HitLoc, Force * -HitNorm, InstantHitDamageTypes[0],, self);
                                    FlashLocationArray.AddItem(HitLoc);                                    
                                }                                
                            }
                            else
                            {
                                // End:0x1DE4
                                if(EvilDynamicDestructibleObject(Other) != none)
                                {
                                    // End:0x1DE4
                                    if((Normal(X) Dot Normal(EvilDynamicDestructibleObject(Other).Location - P.Location)) >= AimDot)
                                    {
                                        TraceStart = P.GetWeaponStartTraceLocation();
                                        TraceEnd = TraceStart + (Vector(GetAdjustedAim(TraceStart)) * WeaponRange);                                        
                                        CalcWeaponFire(TraceStart, TraceEnd, Impacts);
                                        I = 0;
                                        J0x1B00:

                                        // End:0x1BBE [Loop If]
                                        if(I < Impacts.Length)
                                        {
                                            // End:0x1BB0
                                            if(EvilDynamicDestructibleObject(Impacts[I].HitActor) != none)
                                            {
                                                HitLoc = Impacts[I].HitLocation;
                                                HitNorm = Impacts[I].HitNormal;
                                                // [Explicit Break]
                                                goto J0x1BBE;
                                            }
                                            I++;
                                            // [Loop Continue]
                                            goto J0x1B00;
                                        }
                                        J0x1BBE:

                                        // End:0x1C36
                                        if(HitNorm == vect(0.0000000, 0.0000000, 0.0000000))
                                        {
                                            HitNorm = Other.Location - P.Location;
                                            HitNorm = Normal(HitNorm);
                                        }
                                        // End:0x1C8A
                                        if(HitLoc == vect(0.0000000, 0.0000000, 0.0000000))
                                        {
                                            HitLoc = Other.Location - (HitNorm * float(10));
                                        }
                                        GiveDamageTo(Other, int((InstantHitDamage[int(CurrentFireMode)] * DamageScale) * DestructibleDamageScale), Instigator.Controller, HitLoc, Force * -HitNorm, InstantHitDamageTypes[0],, self);
                                        // End:0x1DCE
                                        if(int(EvilDynamicDestructibleObject(Other).Physics) == int(14))
                                        {
                                            EvilDynamicDestructibleObject(Other).SetPhysics(10);
                                            EvilDynamicDestructibleObject(Other).StaticMeshComponent.AddImpulse((Force * 0.0100000) * -HitNorm, HitLoc);
                                        }
                                        FlashLocationArray.AddItem(HitLoc);                                        
                                    }
                                }
                            }
                        }
                    }
                }                
            }                        
        }
        else
        {
            // End:0x22BF
            if((Normal(X) Dot Normal(Target.Location - P.Location)) >= AimDot)
            {
                Radius = 0.0000000;
                // End:0x1EE0
                if((EvilPawn(Target) != none) && EvilPawn(Target).CylinderComponent != none)
                {
                    Radius = EvilPawn(Target).CylinderComponent.CollisionRadius;
                }
                // End:0x1F46
                if(HitLocaltion == vect(0.0000000, 0.0000000, 0.0000000))
                {
                    Dist = Target.Location - P.Location;                    
                }
                else
                {
                    Dist = HitLocaltion - P.Location;
                }
                // End:0x2264
                if(VSize(Dist) < WeaponRange)
                {
                    HitNorm = Normal(Dist);
                    // End:0x2003
                    if(HitLocaltion == vect(0.0000000, 0.0000000, 0.0000000))
                    {
                        HitLoc = Target.Location - (HitNorm * Radius);                        
                    }
                    else
                    {
                        HitLoc = HitLocaltion - HitNorm;
                    }
                    // End:0x213D
                    if(EqualEqual_InterfaceInterface(EvilPlayer_interface(Target), EvilPlayer_interface(none)))
                    {
                        ForceNorm = HitNorm;
                        ForceNorm.Z += ForceTossZ;
                        ForceNorm = Normal(ForceNorm);
                        // End:0x213D
                        if((Instigator == none) || Instigator.IsPlayerPawn())
                        {
                            EvilPawn(Target).Knockdown((Force / EvilPawn(Target).Mass) * ForceNorm, VRand() * float(4));
                        }
                    }
                    // End:0x2195
                    if(P.MyEvilAI != none)
                    {
                        P.MyEvilAI.NotifyDoMeleeDamageHit();
                    }
                    GiveDamageTo(Target, int(InstantHitDamage[int(CurrentFireMode)] * DamageScale), Instigator.Controller, HitLoc, InstantHitMomentum[0] * HitNorm, InstantHitDamageTypes[0],, self);
                    // End:0x224B
                    if(EvilPawn(Target) != none)
                    {
                        KnockedPawns.AddItem(EvilPawn(Target));                        
                    }
                    FlashLocationArray.AddItem(HitLoc);                                        
                }
                else
                {
                    // End:0x22BC
                    if(P.MyEvilAI != none)
                    {
                        P.MyEvilAI.NotifyDoMeleeDamageMissed();
                    }
                }                
            }
            else
            {
                // End:0x2317
                if(P.MyEvilAI != none)
                {
                    P.MyEvilAI.NotifyDoMeleeDamageMissed();
                }
            }
        }
        SetFlashLocationArray(FlashLocationArray, true);
    }
    //return;    
}

function GiveDamageTo(Actor Target, int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Target.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

simulated function CustomFire()
{
    PlayFireEffects(CurrentFireMode);
    //return;    
}

simulated function Projectile ProjectileFire()
{
    local Vector RealStartLoc;
    local Projectile SpawnedProjectile;

    IncrementFlashCountEvil(true);
    // End:0x13B
    if(int(Role) == int(ROLE_Authority))
    {
        RealStartLoc = GetPhysicalFireStartLoc();
        SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
        // End:0x131
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Init(Vector(GetAdjustedAim(RealStartLoc)));
            SpawnedProjectile.Damage = WeaponDamage[int(CurrentFireMode)];
            SpawnedProjectile.MomentumTransfer = WeaponMomentum[int(CurrentFireMode)];
        }
        return SpawnedProjectile;
    }
    return none;
    //return ReturnValue;    
}

simulated function bool ShouldRefire()
{
    return false;
    //return ReturnValue;    
}

simulated function HandleFinishedFiring()
{
    StopFire(CurrentFireMode);
    // End:0x2F
    if(!bSelectable)
    {
        PutDownWeapon();        
    }
    else
    {
        super.HandleFinishedFiring();
    }
    //return;    
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    local EvilPawn UTP;

    super.AttachWeaponTo(MeshCpnt, SocketName);
    UTP = EvilPawn(Instigator);
    // End:0x1AF
    if((int(Role) == int(ROLE_Authority)) && UTP != none)
    {
        // End:0x96
        if(bIsSwitchableAsThrow)
        {
            UTP.CurrentThrowWeaponAttachmentClass = AttachmentClass;            
        }
        else
        {
            UTP.CurrentMeleeWeaponAttachmentClass = AttachmentClass;
        }
        // End:0x1AF
        if(((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || (int(WorldInfo.NetMode) == int(NM_Client)) && Instigator.IsLocallyControlled())
        {
            // End:0x190
            if(bIsSwitchableAsThrow)
            {
                UTP.WeaponThrowAttachmentChanged();                
            }
            else
            {
                UTP.WeaponMeleeAttachmentChanged();
            }
        }
    }
    //return;    
}

simulated function TimeWeaponEquipping()
{
    // End:0x1A
    if(bSelectable)
    {
        super.TimeWeaponEquipping();        
    }
    else
    {
        AttachWeaponTo(Instigator.Mesh);
        SetTimer(EquipTime, false, 'WeaponEquipped');
    }
    //return;    
}

simulated function TimeWeaponPutDown()
{
    // End:0x1A
    if(bSelectable)
    {
        super.TimeWeaponPutDown();        
    }
    else
    {
        SetTimer(PutDownTime, false, 'WeaponIsDown');
    }
    //return;    
}

simulated function PerformWeaponChange()
{
    // End:0x1A
    if(bSelectable)
    {
        super.PerformWeaponChange();        
    }
    else
    {
        SetTimer(GetEquipTime(), false, 'PerformWeaponChange_T');
    }
    //return;    
}

simulated function PerformWeaponChange_T()
{
    PerformWeaponChange();
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0xAD
    if(bEquipClothWeapon && !EvilPawn(Owner).IsPlayerPawn())
    {
        EvilPawn(Owner).EquipWeapon(self.Class);
        EvilPawn(Owner).MeleeWeapon = self;
    }
    //return;    
}

simulated state WeaponEquipping
{
    simulated function WeaponEquipped()
    {
        // End:0x28
        if(!bSelectable)
        {
            SetupArmsAnim();
            SendToFiringState(0);            
        }
        else
        {
            super.WeaponEquipped();
        }
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function MeleeAttack()
    {
        DoMeleeDamage(1.0000000);
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        super(EvilWeap_Base).Tick(DeltaTime);
        // End:0x3E
        if(!bSelectable)
        {
            SetPosition(UDKPawn(Instigator));
        }
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        ClearFlashCountEvil(true);
        ClearFlashLocationArray(true);
        // End:0x4C
        if((int(CurrentFireMode) == int(1)) && IsAltInCooldown)
        {
            StopFire(CurrentFireMode);
        }
        CurrentShotCount = 0;
        ShotSpreadHelper = 0.0000000;
        ShotDistortion = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0x307
        if((int(CurrentFireMode) < AfterShotEffect.Length) && AfterShotEffect[int(CurrentFireMode)] != none)
        {
            // End:0xF6
            if(int(CurrentFireMode) >= AfterShotEffectComponent.Length)
            {
                AfterShotEffectComponent.Add((int(CurrentFireMode) + int(1)) - AfterShotEffectComponent.Length);                
            }
            // End:0x251
            if(AfterShotEffectComponent[int(CurrentFireMode)] == none)
            {
                AfterShotEffectComponent[int(CurrentFireMode)] = new (Outer) Class'UTParticleSystemComponent';
                AfterShotEffectComponent[int(CurrentFireMode)].SetTemplate(AfterShotEffect[int(CurrentFireMode)]);
                AfterShotEffectComponent[int(CurrentFireMode)].SetDepthPriorityGroup(2);
                AfterShotEffectComponent[int(CurrentFireMode)].SetFOV(UDKSkeletalMeshComponent(Mesh).FOV);
                UDKSkeletalMeshComponent(Mesh).AttachComponentToSocket(AfterShotEffectComponent[int(CurrentFireMode)], AfterShotEffectSocket[int(CurrentFireMode)]);                
            }
            else
            {
                // End:0x2B0
                if(!AfterShotEffectComponent[int(CurrentFireMode)].bIsActive)
                {
                    AfterShotEffectComponent[int(CurrentFireMode)].ActivateSystem();                    
                }
                else
                {
                    AfterShotEffectComponent[int(CurrentFireMode)].DeactivateSystem();
                    AfterShotEffectComponent[int(CurrentFireMode)].ActivateSystem();
                }
            }
        }
        super.EndState(NextStateName);
        SetCurrentFireMode(0);
        // End:0x34F
        if(KnockedPawns.Length > 0)
        {
            KnockedPawns.Remove(0, KnockedPawns.Length - 1);            
        }
        // End:0x386
        if(!bSelectable)
        {
            EvilPawn(Instigator).EndMelee();
        }
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function WeaponIsDown()
    {
        // End:0x4E
        if(!bSelectable)
        {
            // End:0x33
            if(InvManager.CancelWeaponChange())
            {
                return;
            }
            DetachWeapon();
            GotoState('Inactive');            
        }
        else
        {
            super.WeaponIsDown();
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    AutoAimPhysicObjects=true
    ForceTossZ=0.5000000
    ForceTossZPhys=15.0000000
    AutoAimDistance=2000.0000000
    AutoAimDot=0.9400000
    AimDot=0.9000000
    DestructibleDamageScale=6.0000000
    bSelectable=false
    WeaponHitRange=150.0000000
    WeaponDamage[0]=5.0000000
    WeaponDamage[1]=0.0000000
    WeaponMomentum[0]=50000.0000000
    WeaponMomentum[1]=0.0000000
    ShotCost[0]=0
    ShotCost[1]=0
    // Reference: ForceFeedbackWaveform'Default__EvilWeap_Melee_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AttachmentClass=Class'EvilAttachment_Weap_Melee_Dummy'
    // Reference: AudioComponent'Default__EvilWeap_Melee_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__EvilWeap_Melee_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponFireTypes=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.0100000
    PutDownTime=0.0100000
    bCanThrow=false
    bMeleeWeapon=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__EvilWeap_Melee_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.1000000
    MaxDesireability=0.1000000
    // Reference: SkeletalMeshComponent'Default__EvilWeap_Melee_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}