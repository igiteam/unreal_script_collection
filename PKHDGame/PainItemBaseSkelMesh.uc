class PainItemBaseSkelMesh extends PainItemBase
    placeable
    hidecategories(Navigation);

struct BindParticleData
{
    var ParticleSystem Particle;
    var float ParticleScale;
    var name BoneName;

    structdefaultproperties
    {
        Particle=none
        ParticleScale=0.0000000
        BoneName="None"
    }
};

var(PainItem) export editinline SkeletalMeshComponent ItemMeshSkel;
var(PainItem) name AnimationName;
var() array<BindParticleData> BindParticles;
var export editinline array<export editinline ParticleSystemComponent> BindParticlesPSC;

simulated function PreBeginPlay()
{
    local BindParticleData BindData;
    local editinline ParticleSystemComponent PSC;

    super.PreBeginPlay();
    // End:0x12D
    foreach BindParticles(BindData)
    {
        PSC = new (self) Class'Engine.ParticleSystemComponent';
        PSC.SetTemplate(BindData.Particle);
        PSC.SetScale(BindData.ParticleScale);
        ItemMeshSkel.AttachComponent(PSC, BindData.BoneName);
        BindParticlesPSC.AddItem(PSC);
        PSC.ActivateSystem();        
    }    
    ItemMeshSkel.PlayAnim(AnimationName,, true);
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    super.ApplyCheckpointRecord(Record);
    ItemMeshSkel.SetHidden(Record.bHidden);
    //return;    
}

simulated function StopEffects()
{
    local editinline ParticleSystemComponent PSC;

    super.StopEffects();
    // End:0x41
    foreach BindParticlesPSC(PSC)
    {
        PSC.DeactivateSystem();        
    }    
    //return;    
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    // End:0x5A
    if(Action.InputLinks[0].bHasImpulse)
    {
        ItemMeshSkel.SetHidden(true);        
    }
    else
    {
        // End:0xB4
        if(Action.InputLinks[1].bHasImpulse)
        {
            ItemMeshSkel.SetHidden(false);            
        }
        else
        {
            ItemMeshSkel.SetHidden(!bHidden);
        }
    }
    super.OnToggleHidden(Action);
    //return;    
}

simulated function SetPickupVisible(bool bVisible)
{
    local editinline ParticleSystemComponent PSC;

    // End:0x69
    if(bVisible)
    {
        // End:0x65
        foreach BindParticlesPSC(PSC)
        {
            PSC.ActivateSystem();
            PSC.SetHidden(false);            
        }                
    }
    else
    {
        // End:0xC0
        foreach BindParticlesPSC(PSC)
        {
            PSC.DeactivateSystem();
            PSC.SetHidden(true);            
        }        
    }
    super.SetPickupVisible(bVisible);
    ItemMeshSkel.SetHidden(!bVisible);
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PainItemBaseSkelMesh.ItemMeshSkelComp0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ItemMeshSkelComp0'
    begin object name="ItemMeshSkelComp0" class=Class'Engine.SkeletalMeshComponent'
        Animations=AnimNodeSequence'Default__PainItemBaseSkelMesh.AnimNodeSeq0'
        ReplacementPrimitive=none
        bIgnoreOwnerHidden=true
        bCastStaticShadow=false
        bAcceptsDynamicDominantLightShadows=false
        LightingChannels=(Dynamic=true,Gameplay_1=true)
    end object
    ItemMeshSkel=ItemMeshSkelComp0
    // Reference: CylinderComponent'Default__PainItemBaseSkelMesh.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItemBase.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__PainItemBaseSkelMesh.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItemBase.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=ItemMeshSkelComp0
    CollisionComponent=CollisionCylinder
}