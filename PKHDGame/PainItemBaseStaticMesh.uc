class PainItemBaseStaticMesh extends PainItemBase
    abstract
    notplaceable
    hidecategories(Navigation);

struct BindParticleData
{
    var ParticleSystem Particle;
    var float ParticleScale;
    var Vector ParticleTranslation;

    structdefaultproperties
    {
        Particle=none
        ParticleScale=0.0000000
        ParticleTranslation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var(PainItem) export editinline StaticMeshComponent PickupMesh;
var() array<BindParticleData> BindParticles;
var export editinline array<export editinline ParticleSystemComponent> BindParticlesPSC;

simulated function PreBeginPlay()
{
    local BindParticleData BindData;
    local editinline ParticleSystemComponent PSC;

    super.PreBeginPlay();
    // End:0x134
    foreach BindParticles(BindData)
    {
        PSC = new (self) Class'Engine.ParticleSystemComponent';
        PSC.SetTemplate(BindData.Particle);
        PSC.SetScale(BindData.ParticleScale);
        AttachComponent(PSC);
        PSC.SetTranslation(BindData.ParticleTranslation);
        BindParticlesPSC.AddItem(PSC);
        PSC.ActivateSystem();        
    }    
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
        PickupMesh.SetHidden(true);        
    }
    else
    {
        // End:0xB4
        if(Action.InputLinks[1].bHasImpulse)
        {
            PickupMesh.SetHidden(false);            
        }
        else
        {
            PickupMesh.SetHidden(!bHidden);
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
    PickupMesh.SetHidden(!bVisible);
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__PainItemBaseStaticMesh.PickupMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMeshComp'
    begin object name="PickupMeshComp" class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        bIgnoreOwnerHidden=true
        bCastStaticShadow=false
        LightingChannels=(Dynamic=true,Gameplay_1=true)
    end object
    PickupMesh=PickupMeshComp
    // Reference: CylinderComponent'Default__PainItemBaseStaticMesh.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItemBase.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__PainItemBaseStaticMesh.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItemBase.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=PickupMeshComp
    CollisionComponent=CollisionCylinder
}