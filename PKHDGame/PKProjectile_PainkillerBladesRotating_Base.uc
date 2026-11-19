class PKProjectile_PainkillerBladesRotating_Base extends PKProjectile_PainkillerBlades_Base
    abstract
    hidecategories(Navigation);

struct TToDamage
{
    var Actor Victim;
    var Vector HitLoc;
    var Vector HitNorm;

    structdefaultproperties
    {
        Victim=none
        HitLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        HitNorm=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var float DamageInterval;
var array<TToDamage> VictimsList;

simulated function RepInit()
{
    super(EvilProjectile_Base).RepInit();
    Mesh.PlayAnim('BladesIdle',, true);
    SetTimer(DamageInterval, true, 'DoDamage');
    //return;    
}

simulated function DoDamage()
{
    local TToDamage DamageInfo;

    // End:0x22C
    foreach VictimsList(DamageInfo)
    {
        // End:0xC3
        if(((DamageInfo.Victim == none) || DamageInfo.Victim.bDeleteMe) || VSize(DamageInfo.HitLoc - Location) > DamageRadius)
        {
            VictimsList.RemoveItem(DamageInfo);
            continue;            
        }
        else
        {
            // End:0x149
            if(EvilWeap_Base(Instigator.Weapon) != none)
            {
                EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(DamageInfo.Victim);
            }
            DamageInfo.Victim.TakeDamage(int(Damage), Instigator.Controller, DamageInfo.HitLoc, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
            // End:0x22B
            if(PainkillerWeap != none)
            {
                PainkillerWeap.SetFlashLocation(DamageInfo.HitLoc);
            }            
        }
    }    
    //return;    
}

simulated function ReturnToInstigator()
{
    Mesh.PlayAnim('BladesClose');
    // End:0x78
    if(AmbientComponent.IsPlaying())
    {
        AmbientComponent.FadeOut(0.1000000, 0.0000000);
    }
    ClearTimer('DoDamage');
    super.ReturnToInstigator();
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local TToDamage DamageInfo;

    // End:0x7D
    if((Other == Instigator) || WorldInfo.GRI.IsCoopMultiplayerGame() && NotEqual_InterfaceInterface(EvilPlayer_interface(Other), EvilPlayer_interface(none)))
    {
        return;
    }
    Trace(HitLocation, HitNormal, HitLocation + Velocity, HitLocation, true, vect(20.0000000, 20.0000000, 20.0000000));
    DamageInfo.Victim = Other;
    DamageInfo.HitLoc = HitLocation;
    DamageInfo.HitNorm = HitNormal;
    VictimsList.AddItem(DamageInfo);
    //return;    
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    super(Actor).HitWall(HitNormal, Wall, WallComp);
    // End:0x93
    if(Wall.bStatic || InterpActor(Wall) != none)
    {
        // End:0x90
        if(!bIsReturning && int(Role) == int(ROLE_Authority))
        {
            ReturnToInstigator();
        }        
    }
    else
    {
        // End:0x174
        if(Damage > float(0))
        {
            // End:0x117
            if(EvilWeap_Base(Instigator.Weapon) != none)
            {
                EvilWeap_Base(Instigator.Weapon).CheckAndUpdateHitEnemyIndicator(Wall);
            }
            Wall.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
        }
    }
    //return;    
}

defaultproperties
{
    DamageInterval=0.0660000
    // Reference: SkeletalMeshComponent'Default__PKProjectile_PainkillerBladesRotating_Base.SkeletalMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMesh'
    // Archetype: SkeletalMeshComponent'Default__PKProjectile_PainkillerBlades_Base.SkeletalMesh'
    begin object name="SkeletalMesh"
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMesh
    Speed=600.0000000
    DamageRadius=100.0000000
    MyDamageType=Class'PKDmgType_PainkillerBladesRotating'
    // Reference: CylinderComponent'Default__PKProjectile_PainkillerBladesRotating_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKProjectile_PainkillerBlades_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=20.0000000
        CollisionRadius=20.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=SkeletalMesh
    CollisionComponent=CollisionCylinder
}