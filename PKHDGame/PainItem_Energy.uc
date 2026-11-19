class PainItem_Energy extends PainItem_Health_Base
    placeable
    hidecategories(Navigation)
    classgroup(Pickups,Armor);

var bool bMonsterWasGibbed;

simulated function PreBeginPlay()
{
    local PKEngine PKE;

    // End:0xA2
    if(int(Role) == int(ROLE_Authority))
    {
        TimeToLive *= PKGame(WorldInfo.Game).SoulStayFactor;
        HealthToAdd *= PKGame(WorldInfo.Game).SoulHealthFactor;
    }
    super(PainItemBaseSkelMesh).PreBeginPlay();
    PKE = PKEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x10D
    if(PKE != none)
    {
        PKE.TotalActiveSoulsLights++;
    }
    //return;    
}

simulated function bool CanCreateLight()
{
    local PKEngine PKE;

    // End:0x25
    if(WorldInfo.IsConsoleBuild())
    {
        return false;
    }
    PKE = PKEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0xA5
    if(PKE != none)
    {
        return PKE.TotalActiveSoulsLights < PKE.MaxTotalActiveSoulsLights;
    }
    return true;
    //return ReturnValue;    
}

event BaseChange()
{
    local PKPawn PP;

    PP = PKPawn(Base);
    // End:0x79
    if(PP != none)
    {
        SetOwner(PP);
        bCanPickupWhenOwnerDies = true;
        SetHidden(true);
        // End:0x79
        if(IsTimerActive('TimedDestroy'))
        {
            ClearTimer('TimedDestroy');
        }
    }
    //return;    
}

function bool CanTakeWhenGhost()
{
    return true;
    //return ReturnValue;    
}

function bool CanHealPawn(PKPlayerPawn P, PainPRI PRI)
{
    return int(PRI.Difficulty.default.DifficultyLevel) < int(3);
    //return ReturnValue;    
}

function bool CanPickUp(PKPlayerPawn P, PainPRI PRI)
{
    // End:0x20
    if(bHidden || !bCanPickup)
    {
        return false;
    }
    // End:0x87
    if(((bCanPickupWhenOwnerDies && Owner != none) && EvilPawn(Owner) != none) && EvilPawn(Owner).IsAliveAndWell())
    {
        return false;
    }
    // End:0xED
    if((!ForceMoveToCatchingTarget && !PKGame(WorldInfo.Game).bAttractSouls) || CatchingTarget != none)
    {
        return true;
    }
    return VSize(P.Location - Location) <= ItemTakeDistance;
    //return ReturnValue;    
}

function PlayerTouch(PKPlayerPawn P, PainPRI PRI)
{
    SetCatchingTarget(P);
    CylinderComponent.SetCylinderSize(ItemTakeDistance, CylinderComponent.CollisionHeight);
    //return;    
}

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    super.Pickup(P, PRI);
    // End:0x55
    if(PRI != none)
    {
        PRI.ScoreSoulTaken(,, bMonsterWasGibbed);
    }
    //return;    
}

function float GetTakeDistance()
{
    return ((PKGame(WorldInfo.Game).bAttractSouls) ? ItemTakeDistance + PKGame(WorldInfo.Game).SoulAutoCatchDistance : ItemTakeDistance);
    //return ReturnValue;    
}

simulated function Destroyed()
{
    local PKEngine PKE;

    PKE = PKEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x80
    if(PKE != none)
    {
        --PKEngine(Class'Engine.Engine'.static.GetEngine()).TotalActiveSoulsLights;
    }
    super(PainItemBase).Destroyed();
    //return;    
}

defaultproperties
{
    HealthToAdd=1
    MaxHealthLimit=999
    // Reference: SkeletalMeshComponent'Default__PainItem_Energy.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainItem_Health_Base.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        // Reference: AnimNodeSequence'Default__PainItem_Energy.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainItem_Health_Base.ItemMeshSkelComp0.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        ReplacementPrimitive=none
        Scale=2.1000000
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    BindParticles[0]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_soul',ParticleScale=1.5000000,BoneName="joint3")
    BindParticles[1]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_soul',ParticleScale=1.5000000,BoneName="joint5")
    BindParticles[2]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_soul',ParticleScale=1.5000000,BoneName="joint8")
    BindParticles[3]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_soul',ParticleScale=1.5000000,BoneName="joint10")
    BindParticles[4]=(Particle=ParticleSystem'ps_all_Levels.Effects.ps_all_greenAura',ParticleScale=1.5000000,BoneName="Root666")
    // Reference: CylinderComponent'Default__PainItem_Energy.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItem_Health_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    PickupSound1p=SoundCue'a_HealthPickables.Cue.item-soul-take'
    PickupSound=SoundCue'a_HealthPickables.Cue.item-soul-take'
    // Reference: DynamicLightEnvironmentComponent'Default__PainItem_Energy.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItem_Health_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    TimeToLive=9.0000000
    BindedLightArchetype=EvilLightActor'ps_all_Levels.Archetypes.ar_soulLight'
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    Components[3]=none
    CollisionComponent=CollisionCylinder
}