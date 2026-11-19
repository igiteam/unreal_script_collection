class EvilKActorSpawnable extends KActorSpawnable
    native(Physics);

var bool bCanFadeOut;
var array<MaterialInstanceConstant> InstanceMaterials;

simulated event SetCanFadeOut(bool bValue)
{
    local int I, numElems;

    // End:0x9E
    if(bValue)
    {
        numElems = StaticMeshComponent.GetNumElements();
        I = 0;
        J0x41:

        // End:0x9B [Loop If]
        if(I < numElems)
        {
            InstanceMaterials.AddItem(StaticMeshComponent.CreateAndSetMaterialInstanceConstant(I));
            I++;
            // [Loop Continue]
            goto J0x41;
        }        
    }
    else
    {
        InstanceMaterials.Length = 0;
    }
    bCanFadeOut = bValue;
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__EvilKActorSpawnable.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    // Archetype: StaticMeshComponent'Engine.Default__KActorSpawnable.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilKActorSpawnable.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__EvilKActorSpawnable.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Engine.Default__KActorSpawnable.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    CollisionComponent=StaticMeshComponent0
}