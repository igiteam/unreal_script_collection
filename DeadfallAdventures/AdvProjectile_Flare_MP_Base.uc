class AdvProjectile_Flare_MP_Base extends EvilProjectile_Base
    abstract
    hidecategories(Navigation);

var Actor LastHit;
var() export editinline StaticMeshComponent Mesh;
var() float VelocityDampingFactor;
var() float Bounciness;
var() float StopSimulatingVelocityThreshhold;
var bool bIsMovingNow;
var() int LightDamageDistance;
var() float FreeFlightTime;
var() float MummyDamageMultiplier;

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    HitNormal = HitLocation - Other.Location;
    HitNormal.Z = 0.0000000;
    HitNormal = Normal(HitNormal);
    // End:0x24B
    if((((AdvPlayerControllerMP(Pawn(Other).Controller) != none) && AdvPlayerControllerMP(Pawn(Other).Controller).GetCurrentCharClassInfo() == AdvGRI(WorldInfo.GRI).MummyCharClassInfo) && bIsMovingNow) && LastHit != Other)
    {
        Other.TakeDamage(int(Damage * MummyDamageMultiplier), InstigatorController, HitLocation, MomentumTransfer * -HitNormal, MyDamageType,, self);
        EvilPawn(Other).Knockdown((MomentumTransfer / EvilPawn(Other).Mass) * -HitNormal, VRand() * float(2));
        Explode(HitLocation, HitNormal);        
    }
    else
    {
        // End:0x395
        if(((AdvPlayerControllerMP(Pawn(Other).Controller) != none) && bIsMovingNow) && LastHit != Other)
        {
            Other.TakeDamage(int(Damage), InstigatorController, HitLocation, MomentumTransfer * -HitNormal, MyDamageType,, self);
            EvilPawn(Other).Knockdown((MomentumTransfer / EvilPawn(Other).Mass) * -HitNormal, VRand() * float(2));
            Explode(HitLocation, HitNormal);
        }
    }
    LastHit = Other;
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local Controller C;

    // End:0x221
    if(TimeToExplode > float(0))
    {
        // End:0x1C0
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0x1BF
            if((((C.Pawn != none) && AdvPlayerControllerMP(C).GetCurrentCharClassInfo() == AdvGRI(WorldInfo.GRI).MummyCharClassInfo) && Abs(VSize(self.Location - C.Pawn.Location)) < float(LightDamageDistance)) && !bIsMovingNow)
            {
                C.Pawn.TakeDamage(1, InstigatorController, self.Location, vect(0.0000000, 0.0000000, 0.0000000), self.MyDamageType);
            }            
        }        
        // End:0x221
        if(((default.TimeToExplode - TimeToExplode) > FreeFlightTime) && bIsMovingNow)
        {
            TimeToExplode = 0.0000000;
            Explode(Location, vect(0.0000000, 0.0000000, 1.0000000));
        }
    }
    super.Tick(DeltaTime);
    //return;    
}

simulated event Landed(Vector HitNormal, Actor FloorActor)
{
    super.Landed(HitNormal, FloorActor);
    //return;    
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    local Controller C;

    // End:0x591
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        HitNormal = HitLocation - C.Pawn.Location;
        HitNormal.Z = 0.0000000;
        HitNormal = Normal(HitNormal);
        // End:0x35E
        if(((((C.Pawn != none) && AdvPlayerControllerMP(C).GetCurrentCharClassInfo() == AdvGRI(WorldInfo.GRI).MummyCharClassInfo) && !bIsMovingNow) && Abs(VSize(self.Location - C.Pawn.Location)) < DamageRadius) && Controller(LastHit) != C)
        {
            C.Pawn.TakeDamage(int((Damage * MummyDamageMultiplier) * (float(1) - FClamp(Abs(VSize(self.Location - C.Pawn.Location)) / DamageRadius, 0.0000000, 1.0000000))), InstigatorController, HitLocation, MomentumTransfer * -HitNormal, MyDamageType,, self);
            EvilPawn(C.Pawn).Knockdown((MomentumTransfer / EvilPawn(C.Pawn).Mass) * -HitNormal, VRand() * float(2));
            // End:0x590
            continue;
        }
        // End:0x590
        if((((C.Pawn != none) && !bIsMovingNow) && Abs(VSize(self.Location - C.Pawn.Location)) < DamageRadius) && Controller(LastHit) != C)
        {
            C.Pawn.TakeDamage(int(Damage * (float(1) - FClamp(Abs(VSize(self.Location - C.Pawn.Location)) / DamageRadius, 0.0000000, 1.0000000))), InstigatorController, HitLocation, MomentumTransfer * -HitNormal, MyDamageType,, self);
            EvilPawn(C.Pawn).Knockdown((MomentumTransfer / EvilPawn(C.Pawn).Mass) * -HitNormal, VRand() * float(2));
        }        
    }    
    super.Explode(HitLocation, HitNormal);
    //return;    
}

singular simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local KActorFromStatic NewKActor;
    local editinline StaticMeshComponent HitStaticMesh;

    super(Actor).HitWall(HitNormal, Wall, WallComp);
    // End:0xEA
    if(Wall.bWorldGeometry)
    {
        HitStaticMesh = StaticMeshComponent(WallComp);
        // End:0xEA
        if((HitStaticMesh != none) && HitStaticMesh.CanBecomeDynamic())
        {
            NewKActor = Class'Engine.KActorFromStatic'.static.MakeDynamic(HitStaticMesh);
            // End:0xEA
            if(NewKActor != none)
            {
                Wall = NewKActor;
            }
        }
    }
    ImpactedActor = Wall;
    // End:0x191
    if(!Wall.bStatic && DamageRadius == float(0))
    {
        Wall.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
    }
    // End:0x24D
    if(((Wall != none) && ShouldBounce(Wall, HitNormal)) && int(Physics) == int(2))
    {
        Velocity -= (((1.0000000 + Bounciness) * HitNormal) * (Velocity Dot HitNormal));
        Velocity *= VelocityDampingFactor;
        // End:0x24D
        if(VSize(Velocity) < StopSimulatingVelocityThreshhold)
        {
            bBounce = false;
        }
    }
    ImpactedActor = none;
    // End:0x278
    if(bIsMovingNow)
    {
        TimeToExplode = default.TimeToExplode;
    }
    bIsMovingNow = false;
    //return;    
}

simulated function bool ShouldBounce(Actor Touched, Vector HitNormal, optional PrimitiveComponent HitComponent)
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvProjectile_Flare_MP_Base.StaticMesh'
    begin object name=StaticMesh class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        bOnlyOwnerSee=true
        AlwaysCheckCollision=true
    end object
    Mesh=StaticMesh
    VelocityDampingFactor=0.6000000
    StopSimulatingVelocityThreshhold=300.0000000
    bIsMovingNow=true
    LightDamageDistance=200
    FreeFlightTime=1.5000000
    MummyDamageMultiplier=2.0000000
    TimeToExplode=10.0000000
    TossZ=25.0000000
    Speed=1500.0000000
    MaxSpeed=3000.0000000
    DamageRadius=400.0000000
    MyDamageType=Class'AdvDmgType_FlareGun'
    // Reference: CylinderComponent'Default__AdvProjectile_Flare_MP_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    bNetTemporary=false
    CollisionComponent=StaticMesh
}