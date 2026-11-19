class MOHAShootableActor extends DynamicSMActor
    native
    hidecategories(Navigation);

var() bool bShootMeShaderEnabled;
var transient array<MaterialInstanceConstant> ShootMe_MIC_Array;

simulated function ClearShootMeMaterials()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4F [Loop If]
    if(I < StaticMeshComponent.GetNumElements())
    {
        StaticMeshComponent.SetMaterial(I, none);
        ShootMe_MIC_Array.Length = 0;
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function BuildShootMeMaterials()
{
    local int I;
    local MaterialInstanceConstant newMIC;

    I = 0;
    J0x07:

    // End:0x94 [Loop If]
    if(I < StaticMeshComponent.GetNumElements())
    {
        newMIC = new (none) Class'Engine.MaterialInstanceConstant';
        newMIC.SetParent(StaticMeshComponent.GetMaterial(I));
        StaticMeshComponent.SetMaterial(I, newMIC);
        ShootMe_MIC_Array[ShootMe_MIC_Array.Length] = newMIC;
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function UpdateShootMeMaterials(name ParameterName, float newSwitchValue)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x40 [Loop If]
    if(I < ShootMe_MIC_Array.Length)
    {
        ShootMe_MIC_Array[I].SetScalarParameterValue(ParameterName, newSwitchValue);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x1F
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
    }
    InitShootMeMaterials();
    //return;    
}

simulated function InitShootMeMaterials()
{
    // End:0x0D
    if(ReplicatedMesh == none)
    {
        return;
    }
    BuildShootMeMaterials();
    // End:0x5C
    if(bShootMeShaderEnabled)
    {
        UpdateShootMeMaterials('ShootMeSwitch', 1.0000000);
        UpdateShootMeMaterials('StartTime', WorldInfo.TimeSeconds);        
    }
    else
    {
        UpdateShootMeMaterials('ShootMeSwitch', 0.0000000);
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    super.ReplicatedEvent(VarName);
    // End:0x28
    if(VarName == 'ReplicatedMesh')
    {
        InitShootMeMaterials();
    }
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    local bool bWasEnabled;

    bWasEnabled = bShootMeShaderEnabled;
    // End:0x36
    if(Action.InputLinks[0].bHasImpulse)
    {
        bShootMeShaderEnabled = true;        
    }
    else
    {
        // End:0x5F
        if(Action.InputLinks[1].bHasImpulse)
        {
            bShootMeShaderEnabled = false;            
        }
        else
        {
            // End:0x8D
            if(Action.InputLinks[2].bHasImpulse)
            {
                bShootMeShaderEnabled = !bShootMeShaderEnabled;
            }
        }
    }
    // End:0xFB
    if(bWasEnabled != bShootMeShaderEnabled)
    {
        // End:0xE3
        if(bShootMeShaderEnabled)
        {
            UpdateShootMeMaterials('ShootMeSwitch', 1.0000000);
            UpdateShootMeMaterials('StartTime', WorldInfo.TimeSeconds);            
        }
        else
        {
            UpdateShootMeMaterials('ShootMeSwitch', 0.0000000);
        }
    }
    //return;    
}

function DisableShootMeShader()
{
    bShootMeShaderEnabled = false;
    UpdateShootMeMaterials('ShootMeSwitch', 0.0000000);
    //return;    
}

defaultproperties
{
    bShootMeShaderEnabled=true
    // Reference: StaticMeshComponent'Default__MOHAShootableActor.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAShootableActor.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAShootableActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    bWorldGeometry=true
    bTakesRadiusDamage=true
    bCollideActors=true
    bBlockActors=true
    CollisionComponent=StaticMeshComponent0
    CollisionType=2
}