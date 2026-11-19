class AdvExplodingSphere extends KActor
    classgroup(Adventurer);

var() protected float DetonationTime;
var() protected bool bActiveAtStart;
var protected bool bIsActive;
var protected bool bDestroyed;
var() protected int HorizontalFireSplit;
var() protected int VerticalFireSplit;
var() class<Projectile> ProjectileType;

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x2C
    if(!bIsActive && !bDestroyed)
    {
        Activate();
    }
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0000000)
{
    // End:0x33
    if(!bIsActive && !bDestroyed)
    {
        Activate();
    }
    super.TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent);
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x21
    if(bActiveAtStart)
    {
        Activate();
    }
    //return;    
}

function Activate()
{
    // End:0x1E
    if(bIsActive || bDestroyed)
    {
        return;
    }
    bIsActive = true;
    SetTimer(DetonationTime, false, 'PerformExplosion');
    //return;    
}

function Deactivate()
{
    bIsActive = false;
    bDestroyed = false;
    self.Reset();
    self.SetHidden(false);
    self.SetCollision(true, true);
    //return;    
}

function PerformExplosion()
{
    local int I, J;
    local Rotator CurRot;
    local float VSplit, HSplit;
    local Projectile Proj;

    VSplit = (32768.0000000 / float(VerticalFireSplit)) + float(1);
    HSplit = (32768.0000000 / float(HorizontalFireSplit)) + float(1);
    CurRot.Yaw = -16384;
    CurRot.Pitch = -16394;
    I = 0;
    J0x93:

    // End:0x1A6 [Loop If]
    if(I < VerticalFireSplit)
    {
        J = 0;
        J0xB5:

        // End:0x16F [Loop If]
        if(J < HorizontalFireSplit)
        {
            Proj = Spawn(ProjectileType, self,, Location, CurRot,, true);
            // End:0x138
            if(Proj != none)
            {
                Proj.Init(Vector(CurRot));
            }
            CurRot.Yaw += int(HSplit);
            J++;
            // [Loop Continue]
            goto J0xB5;
        }
        CurRot.Pitch += int(VSplit);
        I++;
        // [Loop Continue]
        goto J0x93;
    }
    self.Reset();
    self.SetHidden(true);
    self.SetCollision(false, false);
    self.StaticMeshComponent.SetRBChannel(1);
    bDestroyed = true;
    bIsActive = false;
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x126
    if(!bStatic)
    {
        // End:0x53
        if(Action.InputLinks[0].bHasImpulse)
        {
            Activate();            
        }
        else
        {
            // End:0x97
            if(Action.InputLinks[1].bHasImpulse)
            {
                Deactivate();                
            }
            else
            {
                // End:0xF3
                if(Action.InputLinks[2].bHasImpulse)
                {
                    // End:0xE9
                    if(bIsActive)
                    {
                        Deactivate();                        
                    }
                    else
                    {
                        Activate();
                    }
                }
            }
        }
        ForceNetRelevant();
        SetForcedInitialReplicatedProperty(BoolProperty'AdvExplodingSphere.bIsActive', bIsActive == default.bIsActive);
    }
    //return;    
}

defaultproperties
{
    DetonationTime=0.3000000
    HorizontalFireSplit=6
    VerticalFireSplit=6
    bWakeOnLevelStart=true
    // Reference: StaticMeshComponent'Default__AdvExplodingSphere.StaticMeshComponent'
    begin object name=StaticMeshComponent class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'adv_en_TestLevels.Meshes.sm_en_Sphere_01'
        ReplacementPrimitive=none
        RBChannel=ERBCollisionChannel.RBCC_GameplayPhysics
        RBCollideWithChannels=(Default=true,GameplayPhysics=true,EffectPhysics=true,BlockingVolume=true)
        Scale3D=(X=0.1500000,Y=0.1500000,Z=0.1500000)
    end object
    StaticMeshComponent=StaticMeshComponent
    // Reference: DynamicLightEnvironmentComponent'Default__AdvExplodingSphere.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    // Reference: StaticMeshComponent'Default__AdvExplodingSphere.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvExplodingSphere.MyLightEnvironment'
    end object
    Components[1]=StaticMeshComponent0
    Components[2]=StaticMeshComponent
    bNoDelete=false
    bNoEncroachCheck=false
    CollisionComponent=StaticMeshComponent
}