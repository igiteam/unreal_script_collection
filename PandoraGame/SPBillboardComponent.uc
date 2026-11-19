class SPBillboardComponent extends StaticMeshComponent
    native
    editinlinenew
    hidecategories(Collision,Rendering,Lighting);

enum FadeMode
{
    FMSP_FADEIN,                    // 0
    FMSP_FADEOUT,                   // 1
    FMSP_NONE,                      // 2
    FMSP_MAX                        // 3
};

var PlayerController m_LocalPC;
var string m_Text;
var float TextScaleX;
var float TextScaleY;
var TextureRenderTarget2D m_PlayerNameRT;
var LinearColor m_color;
var LinearColor m_LastColor;
var float m_FadeInIncr;
var float m_FadeOutIncr;
var SPBillboardComponent.FadeMode m_FadeMode;
var float m_NameRenderMidpoint;
var array<MaterialInstanceConstant> m_MtlInstances;
var Texture2D TalkingIcon;
var LinearColor TalkingIconColor;
var float TalkingIconWidth;
var float TalkingIconHeight;
//var delegate<funcUpdateText> __funcUpdateText__Delegate;

delegate string funcUpdateText()
{
    //return ReturnValue;    
}

// Export USPBillboardComponent::execBuildMPRTName(FFrame&, void* const)
native function bool BuildMPRTName(TextureRenderTarget2D Target, string Str);

// Export USPBillboardComponent::execInitNameRT(FFrame&, void* const)
native function InitNameRT(TextureRenderTarget2D Target, int Width, int Height);

// Export USPBillboardComponent::execIsRTAvail(FFrame&, void* const)
native function bool IsRTAvail(TextureRenderTarget2D Target);

// Export USPBillboardComponent::execGetWorldInfo(FFrame&, void* const)
native final function WorldInfo GetWorldInfo();

simulated function InitMaterialInstances()
{
    local int NumElems, I;

    NumElems = GetNumElements();
    m_MtlInstances.Length = 0;
    m_MtlInstances.Insert(0, NumElems);
    I = 0;
    J0x2B:

    // End:0x9D [Loop If]
    if(I < NumElems)
    {
        m_MtlInstances[I] = new (none) Class'Engine.MaterialInstanceConstant';
        m_MtlInstances[I].SetParent(GetMaterial(I));
        SetMaterial(I, m_MtlInstances[I]);
        I++;
        // [Loop Continue]
        goto J0x2B;
    }
    //return;    
}

simulated function AssignRTTexture()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x49 [Loop If]
    if(I < m_MtlInstances.Length)
    {
        m_MtlInstances[I].SetTextureParameterValue('MPName', m_PlayerNameRT);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function AssignColor(LinearColor clr)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x49 [Loop If]
    if(I < m_MtlInstances.Length)
    {
        m_MtlInstances[I].SetVectorParameterValue('MPColor', clr);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function PlayerController GetFirstLocalPlayer()
{
    local PlayerController PC;

    // End:0x26
    foreach GetWorldInfo().LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {        
        return PC;        
    }    
    return none;
    //return ReturnValue;    
}

simulated function InitBillboard()
{
    m_LocalPC = GetFirstLocalPlayer();
    InitMaterialInstances();
    InitMPName();
    //return;    
}

simulated function InitMPName()
{
    m_PlayerNameRT = Class'Engine.TextureRenderTarget2D'.static.Create(512, 256,, MakeLinearColor(0.0000000, 0.0000000, 0.0000000, 1.0000000), false);
    m_PlayerNameRT.Filter = 0;
    InitNameRT(m_PlayerNameRT, 512, 256);
    //return;    
}

simulated function CreateMPNameSprite()
{
    // End:0x43
    if(IsRTAvail(m_PlayerNameRT))
    {
        // End:0x2F
        if(Len(m_Text) == 0)
        {
            m_Text = "Untitled";
        }
        BuildMPRTName(m_PlayerNameRT, m_Text);
    }
    //return;    
}

simulated function SetColor(LinearColor clr)
{
    m_color = clr;
    UpdateColor();
    //return;    
}

simulated function UpdateColor()
{
    // End:0x2C
    if(m_LastColor != m_color)
    {
        AssignColor(m_color);
        m_LastColor = m_color;
    }
    //return;    
}

simulated function UpdateFade(float DeltaTime)
{
    switch(m_FadeMode)
    {
        // End:0x66
        case 0:
            m_color.A += (m_FadeInIncr * DeltaTime);
            // End:0x63
            if(m_color.A > 1.0000000)
            {
                m_color.A = 1.0000000;
                m_FadeMode = 2;
            }
            // End:0xC7
            break;
        // End:0xC4
        case 1:
            m_color.A -= (m_FadeOutIncr * DeltaTime);
            // End:0xC1
            if(m_color.A < 0.0000000)
            {
                m_color.A = 0.0000000;
                m_FadeMode = 2;
            }
            // End:0xC7
            break;
        // End:0xFFFF
        default:
            break;
    }
    UpdateColor();
    //return;    
}

simulated function Update(float DeltaTime)
{
    local Vector TargetLoc;
    local Rotator CurRot, TargetRot;
    local string NewText;

    // End:0x40
    if((Pawn(Owner) != none) && Pawn(Owner).Health <= 0)
    {
        m_Text = "";
        CreateMPNameSprite();
        return;
    }
    // End:0x12D
    if(Owner != none)
    {
        NewText = funcUpdateText();
        // End:0x84
        if(NewText != m_Text)
        {
            m_Text = NewText;
            CreateMPNameSprite();
        }
        // End:0x12D
        if(m_LocalPC != none)
        {
            CurRot.Pitch = 32768;
            CurRot.Roll = 49152;
            m_LocalPC.GetPlayerViewPoint(TargetLoc, TargetRot);
            CurRot.Yaw = TargetRot.Yaw - 16384;
            CurRot = CurRot - Owner.Rotation;
            SetRotation(CurRot);
        }
    }
    // End:0x14C
    if(int(m_FadeMode) != int(2))
    {
        UpdateFade(DeltaTime);
    }
    CreateMPNameSprite();
    AssignRTTexture();
    //return;    
}

simulated function Show()
{
    m_color.A = 1.0000000;
    UpdateColor();
    //return;    
}

simulated function hide()
{
    m_color.A = 0.0000000;
    UpdateColor();
    //return;    
}

simulated function FadeIn()
{
    m_FadeMode = 0;
    //return;    
}

simulated function FadeOut()
{
    m_FadeMode = 1;
    //return;    
}
