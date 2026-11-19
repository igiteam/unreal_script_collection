class PKProjectile_Crossbow_Base extends EvilProjectile_Pinnable_Base
    abstract
    hidecategories(Navigation);

var transient bool bDirectHit;

function Init(Vector Direction)
{
    super(EvilProjectile_Base).Init(Direction);
    SetTimer(0.1000000, false, 'DisableTracking');
    //return;    
}

function DisableTracking()
{
    BaseTrackingStrength = 0.0000000;
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local TraceHitInfo THitInfo;

    // End:0x148
    if(EvilPawn(Other) != none)
    {
        EvilPawn(Other).DirectHitByProjectile();
        bDirectHit = true;
        // End:0x7E
        if(DamageRadius > 0.0000000)
        {
            Explode(HitLocation, HitNormal);            
        }
        else
        {
            // End:0x13E
            if(Damage > float(0))
            {
                Trace(HitLocation, HitNormal, HitLocation + Velocity, HitLocation, true, vect(0.0000000, 0.0000000, 0.0000000), THitInfo);
                Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, THitInfo, self);
            }
            ShutDown();
        }
    }
    //return;    
}

simulated function ShutDown()
{
    local Vector HitLocation, HitNormal;

    // End:0x19
    if(bDirectHit)
    {
        super.ShutDown();
        return;
    }
    LifeSpan = 1.0000000;
    bShuttingDown = true;
    HitNormal = Normal(Velocity * float(-1));
    Trace(HitLocation, HitNormal, Location + (HitNormal * float(-32)), Location + (HitNormal * float(32)), true, vect(0.0000000, 0.0000000, 0.0000000));
    SetPhysics(0);
    // End:0xEB
    if(AmbientComponent != none)
    {
        AmbientComponent.FadeOut(0.1000000, 0.0000000);
    }
    // End:0x141
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bSuppressExplosionFX)
    {
        SpawnExplosionEffects(Location, HitNormal);
    }
    SetCollision(false, false);
    // End:0x177
    if(!IsTimerActive('FinalClean'))
    {
        SetTimer(DurationOfDecal, false, 'FinalClean');
    }
    //return;    
}

simulated function FinalClean()
{
    // End:0x2E
    if(ProjEffects != none)
    {
        ProjEffects.DeactivateSystem();
    }
    HideProjectile();
    // End:0x10E
    if(bWaitForEffects)
    {
        // End:0xAA
        if(bNetTemporary)
        {
            // End:0x81
            if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
            {
                Destroy();                
            }
            else
            {
                RemoteRole = ROLE_None;
                LifeSpan = FMax(LifeSpan, 2.0000000);
            }            
        }
        else
        {
            bTearOff = true;
            // End:0xF1
            if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
            {
                LifeSpan = 0.1500000;                
            }
            else
            {
                LifeSpan = FMax(LifeSpan, 2.0000000);
            }
        }        
    }
    else
    {
        Destroy();
    }
    //return;    
}

defaultproperties
{
    // Reference: EvilDissolvingStaticMeshComponent'Default__PKProjectile_Crossbow_Base.StaticMesh'
    // Archetype: EvilDissolvingStaticMeshComponent'EvilGame.Default__EvilProjectile_Pinnable_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    TossZ=20.0000000
    BaseTrackingStrength=0.0500000
    CustomGravityScaling=0.1000000
    Speed=1000.0000000
    MaxSpeed=1500.0000000
    MyDamageType=Class'PKDmgType_Bolt'
    // Reference: CylinderComponent'Default__PKProjectile_Crossbow_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Pinnable_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=5.0000000
        CollisionRadius=5.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    CollisionComponent=CollisionCylinder
}