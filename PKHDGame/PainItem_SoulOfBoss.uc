class PainItem_SoulOfBoss extends PainItem_Energy
    placeable
    hidecategories(Navigation)
    classgroup(Pickups,Armor);

function bool ValidTouch(Pawn Other)
{
    // End:0x19
    if(Other != CatchingTarget)
    {
        return false;
    }
    return super(PainItemBase).ValidTouch(Other);
    //return ReturnValue;    
}

function PlayerTouch(PKPlayerPawn P, PainPRI PRI)
{
    //return;    
}

function SetCatchingTarget(Pawn Target)
{
    CatchingTarget = Target;
    PKPawn(Target).CallKismetEvent(Class'SeqEvent_BossSoulExtracted', 0);
    PKWeap_SoulReaper_Base(PKPlayerPawn(Target).GetWeapon()).WeaponRange = 2048.0000000;
    PKWeap_SoulReaper_Base(PKPlayerPawn(Target).GetWeapon()).LinkFlexibility = 0.0000000;
    //return;    
}

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    P.CallKismetEvent(Class'SeqEvent_BossSoulCollected', 0);
    PKWeap_SoulReaper_Base(P.GetWeapon()).SoulComboMeter = 6;
    PKWeap_SoulReaper_Base(P.GetWeapon()).ActivateEyesEffects();
    super.Pickup(P, PRI);
    // End:0xFC
    if(PRI != none)
    {
        PRI.ScoreSoulTaken(,, bMonsterWasGibbed);
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PainItem_SoulOfBoss.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    // Archetype: SkeletalMeshComponent'Default__PainItem_Energy.ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0"
        SkeletalMesh=SkeletalMesh'ch_giant_01.Effects.e_GiantSoul_01'
        // Reference: AnimNodeSequence'Default__PainItem_SoulOfBoss.ItemMeshSkelComp0.AnimNodeSeq0'
        // Archetype: AnimNodeSequence'Default__PainItem_Energy.ItemMeshSkelComp0.AnimNodeSeq0'
        begin object name="AnimNodeSeq0"
        end object
        Animations=AnimNodeSeq0
        AnimSets[0]=AnimSet'ch_giant_01.Effects.as_e_GiantSoul_01'
        ReplacementPrimitive=none
        Scale=5.0000000
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    AnimationName="e_GiantSoul_01"
    BindParticles[0]=(Particle=ParticleSystem'ps_ch_GiantBoss.Effects.ps_all_soulGiant',ParticleScale=4.0000000,BoneName="joint3")
    BindParticles[1]=(Particle=ParticleSystem'ps_ch_GiantBoss.Effects.ps_all_soulGiant',ParticleScale=4.0000000,BoneName="joint5")
    BindParticles[2]=(Particle=ParticleSystem'ps_ch_GiantBoss.Effects.ps_all_soulGiant',ParticleScale=4.0000000,BoneName="joint8")
    BindParticles[3]=(Particle=ParticleSystem'ps_ch_GiantBoss.Effects.ps_all_soulGiant',ParticleScale=4.0000000,BoneName="joint10")
    BindParticles[4]=(Particle=ParticleSystem'ps_ch_GiantBoss.Effects.ps_all_soulGiant',ParticleScale=4.0000000,BoneName="joint12")
    BindParticles[5]=(Particle=ParticleSystem'ps_ch_GiantBoss.Effects.ps_all_soulGiant',ParticleScale=4.0000000,BoneName="joint14")
    BindParticles[6]=(Particle=ParticleSystem'ps_ch_GiantBoss.Effects.ps_all_soulGiant',ParticleScale=4.0000000,BoneName="joint16")
    BindParticles[7]=(Particle=ParticleSystem'ps_ch_GiantBoss.Effects.ps_all_soulGiant',ParticleScale=4.0000000,BoneName="joint20")
    BindParticles[8]=(Particle=ParticleSystem'ps_ch_GiantBoss.Effects.ps_all_soulGiant',ParticleScale=4.0000000,BoneName="joint20")
    BindParticles[9]=(Particle=ParticleSystem'ps_ch_GiantBoss.Effects.ps_all_soulGiant',ParticleScale=4.0000000,BoneName="joint22")
    BindParticles[10]=(Particle=ParticleSystem'ps_ch_GiantBoss.Effects.ps_all_greenAuraGiant',ParticleScale=5.5000000,BoneName="Root666")
    // Reference: CylinderComponent'Default__PainItem_SoulOfBoss.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItem_Energy.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__PainItem_SoulOfBoss.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItem_Energy.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    TimeToLive=0.0000000
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    Components[3]=none
    CollisionComponent=CollisionCylinder
}