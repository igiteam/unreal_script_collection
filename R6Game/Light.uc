class Light extends Actor
    native
    notplaceable
    hidecategories(lighting);

enum ELightType_s
{
    ELT_Static,                     // 0
    ELT_Dynamic,                    // 1
    ELT_Custom,                     // 2
    ELT_DynamicCharacters,          // 3
    ELT_MAX                         // 4
};

enum ELightState
{
    ELightState_Disabled,           // 0
    ELightState_Enabled,            // 1
    ELightState_Default,            // 2
    ELightState_MAX                 // 3
};

var const transient int dummyint;
var() Light.ELightType_s m_eLightType;
var repnotify Light.ELightState m_eEnableState;
var() const editconst export editinline LightComponent LightComponent;
var bool m_bDestroyed;
var bool sbEnabled;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_eEnableState;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x39
    if(VarName == 'm_eEnableState')
    {
        // End:0x36
        if(LightComponent != none)
        {
            LightComponent.SetEnabled(int(m_eEnableState) == int(1));
        }        
    }
    else
    {
        ReplicatedEvent(VarName);
    }
    return;
}

// Export ULight::execEnableLight(FFrame&, void* const)
native function EnableLight(bool bEnable);

function SaveOriginalData()
{
    SaveOriginalData();
    sbEnabled = LightComponent.bEnabled;
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    // End:0x27
    if(int(m_eEnableState) != int(2))
    {
        EnableLight(sbEnabled);        
    }
    else
    {
        LightComponent.SetEnabled(sbEnabled);
    }
    return;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x0B
    if(m_bDestroyed)
    {
        return;
    }
    // End:0x65
    if(Action.InputLinks[0].bHasImpulse)
    {
        EnableLight(true);
        RemoteRole = ROLE_SimulatedProxy;
        bAlwaysRelevant = true;
        NetUpdateFrequency = 0.1000000;
        NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;        
    }
    else
    {
        // End:0xBF
        if(Action.InputLinks[1].bHasImpulse)
        {
            EnableLight(false);
            RemoteRole = ROLE_SimulatedProxy;
            bAlwaysRelevant = true;
            NetUpdateFrequency = 0.1000000;
            NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;            
        }
        else
        {
            // End:0x127
            if(Action.InputLinks[2].bHasImpulse)
            {
                EnableLight(!LightComponent.bEnabled);
                RemoteRole = ROLE_SimulatedProxy;
                bAlwaysRelevant = true;
                NetUpdateFrequency = 0.1000000;
                NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
            }
        }
    }
    return;
}

defaultproperties
{
    m_eEnableState=2
    bStatic=true
    bHidden=true
    bNoDelete=true
    bMovable=false
    // Reference: SpriteComponent'Default__Light.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'KellerResource.light_Spot'
    end object
    Components[0]=Sprite
    NetUpdateFrequency=0.1000000
    DrawScale=0.5000000
}