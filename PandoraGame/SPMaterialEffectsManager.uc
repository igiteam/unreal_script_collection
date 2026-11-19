class SPMaterialEffectsManager extends Actor
    notplaceable;

var SPGameDifficultyTuneGamePlay m_GameplayGDTuneData;
var Canvas m_Canvas;
var DOFEffect m_PlayerDeathDOFEffect;
var Material m_PlayerDeathMaterialEffect;
var MaterialInstanceConstant m_PlayerDeathMaterialEffectConstant;
var bool m_bPlayerDeathMaterialActive;
var bool m_bSprintMaterialActive;
var bool m_bBulletMaterialActive;
var bool m_bFireDamageMaterialActive;
var bool m_bSonicDamageMaterialActive;
var bool m_bTMGMaterialActive;
var bool m_bWeaponDOFMaterialActive;
var bool m_bHitMaterialActive;
var bool m_bAssaultRifleScopeMaterialActive;
var bool m_bFadingOut;
var bool m_bKismetActivatedUsingDelay;
var bool m_bKismetActivatedMaterialActive;
var bool m_bAssaultRifleScopePPEIsActive;
var bool m_bAssaultRifleScopePPEActivating;
var bool m_bAssaultRifleScopePPEDeactivating;
var bool m_bAssaultRifleScopePPETimer;
var bool m_bAssaultRifleScopeEnabled;
var bool m_bUsingWidescreen;
var bool m_bNariDamageMaterialActive;
var LinearColor m_PlayerDeathCurrentColor;
var Material m_SprintMaterialEffect;
var MaterialInstanceConstant m_SprintMaterialEffectConstant;
var Material m_BulletMaterialEffect;
var MaterialInstanceConstant m_BulletMaterialEffectConstant;
var float m_fBulletEffectTime;
var Material m_FireDamageMaterialEffect;
var MaterialInstanceConstant m_FireDamageMaterialEffectConstant;
var float FireDamageEffectTime;
var Material m_SonicDamageMaterialEffect;
var MaterialInstanceConstant m_SonicDamageMaterialEffectConstant;
var float SonicDamageEffectTime;
var float SonicDamageEffectMaxTime;
var MaterialEffect m_TMGMaterialEffect;
var MaterialInstanceConstant m_TMGMaterialEffectConstant;
var MaterialEffect m_TMGMaterialEffectBlur;
var MaterialInstanceConstant m_TMGMaterialEffectBlurConstant;
var MaterialEffect m_WeaponDOFMaterialEffect;
var MaterialInstanceConstant m_WeaponDOFMaterialEffectConstant;
var float m_WeaponDOFScalerParameter;
var MaterialEffect m_HitMaterialEffect;
var MaterialInstanceConstant m_HitMaterialEffectConstant;
var float m_HitMaterialEffectTime;
var Material m_AssaultRifleScopeMaterialEffect;
var MaterialInstanceConstant m_AssaultRifleScopeMaterialEffectConstant;
var Material m_AssaultRifleScopeMaterialEffectWidescreen;
var MaterialInstanceConstant m_AssaultRifleScopeMaterialEffectConstantWidescreen;
var MaterialInstanceConstant m_KismetActivatedEffectConstant;
var name m_KismetActivatedParameterName;
var float m_KismetActivatedParameterValue;
var float m_KismetActivatedFadeOutDelayTime;
var float m_KismetActivatedFadeOutSpeed;
var float m_KismetActivatedFadeInSpeed;
var float m_AssaultRifleScopeScalerValue;
var float m_ScreenRatioX;
var float m_ScreenRatioY;
var Material m_NariDamageMaterialEffect;
var MaterialInstanceConstant m_NariDamageMaterialEffectConstant;
var float NariDamageEffectTime;
var float NariDamageEffectRampUpTime;
var float NariDamageEffectRampDownTime;
var float NariDamageEffectMaxTime;

function DBG_MsgEM(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

function PostBeginPlay()
{
    m_GameplayGDTuneData = Class'SPTuneManager'.default.Difficulty.GameplayGD;
    CreateMaterialEffects();
    //return;    
}

function DisableAllMaterialEffects()
{
    m_bSprintMaterialActive = false;
    m_bBulletMaterialActive = false;
    m_bFireDamageMaterialActive = false;
    m_bSonicDamageMaterialActive = false;
    m_bTMGMaterialActive = false;
    m_bWeaponDOFMaterialActive = false;
    m_bHitMaterialActive = false;
    m_bAssaultRifleScopeMaterialActive = false;
    m_bKismetActivatedMaterialActive = false;
    m_bNariDamageMaterialActive = false;
    m_bPlayerDeathMaterialActive = false;
    DeActivateWeaponDOFEffect();
    DeActivatePlayerDeathEffect();
    DeActivateTMGEffect();
    DeActivateHitMaterialEffect();
    //return;    
}

function UpdateEffectsManager(HUD H)
{
    DrawAssaultRifleScopeView(H);
    //return;    
}

function Tick(float DeltaTime)
{
    TickBulletEffects(DeltaTime);
    TickFireDamageEffects(DeltaTime);
    TickSonicDamageEffects(DeltaTime);
    UpdateAssaultRifleScopeView();
    UpdateKismetMaterialEffect();
    TickHitMaterialEffect(DeltaTime);
    UpdatePlayerDeathEffect(DeltaTime);
    TickNariDamageEffects(DeltaTime);
    //return;    
}

function TickBulletEffects(float DeltaTime)
{
    m_fBulletEffectTime -= DeltaTime;
    // End:0x27
    if(m_fBulletEffectTime <= float(0))
    {
        ToggleBulletEffect(false);        
    }
    else
    {
        ToggleBulletEffect(true);
        UpdateBulletEffect(m_fBulletEffectTime);
    }
    //return;    
}

function TickFireDamageEffects(float DeltaTime)
{
    FireDamageEffectTime -= DeltaTime;
    // End:0x27
    if(FireDamageEffectTime <= float(0))
    {
        ToggleFireDamageEffect(false);        
    }
    else
    {
        ToggleFireDamageEffect(true);
        UpdateFireDamageEffect(FireDamageEffectTime);
    }
    //return;    
}

function TickSonicDamageEffects(float DeltaTime)
{
    SonicDamageEffectTime -= DeltaTime;
    // End:0x27
    if(SonicDamageEffectTime <= float(0))
    {
        ToggleSonicDamageEffect(false);        
    }
    else
    {
        ToggleSonicDamageEffect(true);
        UpdateSonicDamageEffect(SonicDamageEffectTime / SonicDamageEffectMaxTime);
    }
    //return;    
}

function TickNariDamageEffects(float DeltaTime)
{
    NariDamageEffectTime -= DeltaTime;
    // End:0x27
    if(NariDamageEffectTime <= float(0))
    {
        ToggleNARIDamageEffect(false);        
    }
    //return;    
}

function CreateMaterialEffects()
{
    CreateAssaultRifleEffects();
    CreateSprintEffect();
    CreateBulletEffect();
    CreateTMGEffect();
    CreateFireDamageEffect();
    CreateSonicDamageEffect();
    CreateHitMaterialEffect();
    CreateNARIDamageEffect();
    CreatePlayerDeathEffect();
    //return;    
}

function RenderMaterialEffects(Canvas pCanvas)
{
    m_Canvas = pCanvas;
    // End:0x1E
    if(m_bAssaultRifleScopeMaterialActive)
    {
        RenderAssaultRifleScopeEffect();
    }
    // End:0x31
    if(m_bSprintMaterialActive)
    {
        RenderSprintEffect();
    }
    // End:0x44
    if(m_bFireDamageMaterialActive)
    {
        RenderFireDamageEffect();
    }
    // End:0x57
    if(m_bSonicDamageMaterialActive)
    {
        RenderSonicDamageEffect();
    }
    // End:0x6A
    if(m_bNariDamageMaterialActive)
    {
        RenderNARIDamageEffect();
    }
    // End:0x7D
    if(m_bKismetActivatedMaterialActive)
    {
        RenderKismetMaterialEffect();
    }
    // End:0x90
    if(m_bPlayerDeathMaterialActive)
    {
        RenderPlayerDeathEffect();
    }
    //return;    
}

function CreatePlayerDeathEffect()
{
    local PlayerController PC;
    local LocalPlayer LocPlayer;

    // End:0xC7
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xC6
        if(PC != none)
        {
            LocPlayer = LocalPlayer(PC.Player);
            // End:0xC6
            if(LocPlayer != none)
            {
                // End:0xC6
                if(m_PlayerDeathDOFEffect == none)
                {
                    m_PlayerDeathDOFEffect = DOFEffect(LocPlayer.PlayerPostProcess.FindPostProcessEffect('PlayerDeathDOFEffect'));
                    // End:0xC6
                    if(m_PlayerDeathDOFEffect != none)
                    {
                        m_PlayerDeathMaterialEffectConstant = new (Outer) Class'Engine.MaterialInstanceConstant';
                        m_PlayerDeathMaterialEffectConstant.SetParent(m_PlayerDeathMaterialEffect);
                        m_PlayerDeathDOFEffect.bShowInGame = false;
                    }
                }
            }
        }        
    }    
    //return;    
}

function ActivatePlayerDeathEffect()
{
    m_bPlayerDeathMaterialActive = true;
    // End:0x102
    if((m_PlayerDeathDOFEffect != none) && m_PlayerDeathMaterialEffect != none)
    {
        // End:0xB1
        if(m_PlayerDeathMaterialEffectConstant != none)
        {
            m_PlayerDeathMaterialEffectConstant.SetScalarParameterValue('Alpha', 0.0000000);
            m_PlayerDeathMaterialEffectConstant.SetScalarParameterValue('BlackAlpha', 0.0000000);
            m_PlayerDeathCurrentColor = MakeLinearColor(1.0000000, 0.0000000, 0.0000000, 0.5000000);
            m_PlayerDeathMaterialEffectConstant.SetVectorParameterValue('Color', m_PlayerDeathCurrentColor);
        }
        m_PlayerDeathDOFEffect.MaxNearBlurAmount = 0.0000000;
        m_PlayerDeathDOFEffect.MaxFarBlurAmount = 0.0000000;
        m_PlayerDeathDOFEffect.BlurKernelSize = 0.0000000;
        m_PlayerDeathDOFEffect.bShowInGame = true;
    }
    //return;    
}

function DeActivatePlayerDeathEffect()
{
    m_bPlayerDeathMaterialActive = false;
    // End:0x32
    if((m_PlayerDeathDOFEffect != none) && m_PlayerDeathMaterialEffect != none)
    {
        m_PlayerDeathDOFEffect.bShowInGame = false;
    }
    //return;    
}

function UpdatePlayerDeathEffect(float DeltaTime)
{
    local float BlackAlphaDelta;

    // End:0x195
    if(((m_PlayerDeathDOFEffect != none) && m_PlayerDeathMaterialEffect != none) && m_PlayerDeathMaterialEffectConstant != none)
    {
        // End:0x195
        if(m_bPlayerDeathMaterialActive)
        {
            m_PlayerDeathDOFEffect.MaxNearBlurAmount += (DeltaTime / 3.0000000);
            m_PlayerDeathDOFEffect.MaxFarBlurAmount = m_PlayerDeathDOFEffect.MaxNearBlurAmount;
            // End:0x169
            if(m_PlayerDeathDOFEffect.MaxNearBlurAmount >= float(1))
            {
                m_PlayerDeathDOFEffect.MaxNearBlurAmount = 1.0000000;
                m_PlayerDeathDOFEffect.MaxNearBlurAmount = 1.0000000;
                m_PlayerDeathDOFEffect.BlurKernelSize += ((DeltaTime / 4.0000000) * float(64));
                // End:0xFE
                if(m_PlayerDeathDOFEffect.BlurKernelSize >= float(64))
                {
                    m_PlayerDeathDOFEffect.BlurKernelSize = 64.0000000;                    
                }
                else
                {
                    // End:0x166
                    if(m_PlayerDeathDOFEffect.BlurKernelSize >= float(48))
                    {
                        m_PlayerDeathMaterialEffectConstant.GetScalarParameterValue('BlackAlpha', BlackAlphaDelta);
                        BlackAlphaDelta += DeltaTime;
                        m_PlayerDeathMaterialEffectConstant.SetScalarParameterValue('BlackAlpha', BlackAlphaDelta);
                    }
                }                
            }
            else
            {
                m_PlayerDeathMaterialEffectConstant.SetScalarParameterValue('Alpha', m_PlayerDeathDOFEffect.MaxNearBlurAmount);
            }
        }
    }
    //return;    
}

function RenderPlayerDeathEffect()
{
    m_Canvas.SetPos(0.0000000, 0.0000000);
    // End:0x5C
    if(m_PlayerDeathMaterialEffectConstant != none)
    {
        m_Canvas.DrawMaterialTile(m_PlayerDeathMaterialEffectConstant, m_Canvas.ClipX, m_Canvas.ClipY);
    }
    //return;    
}

function CreateSprintEffect()
{
    m_SprintMaterialEffectConstant = new (Outer) Class'Engine.MaterialInstanceConstant';
    m_SprintMaterialEffectConstant.SetParent(m_SprintMaterialEffect);
    //return;    
}

function RenderSprintEffect()
{
    m_Canvas.SetPos(0.0000000, 0.0000000);
    // End:0x5C
    if(m_SprintMaterialEffectConstant != none)
    {
        m_Canvas.DrawMaterialTile(m_SprintMaterialEffectConstant, m_Canvas.ClipX, m_Canvas.ClipY);
    }
    //return;    
}

function UpdateSprintEffect(float fAmount, float newFAmount)
{
    // End:0x6F
    if(m_SprintMaterialEffectConstant != none)
    {
        // End:0x45
        if(fAmount <= float(0))
        {
            m_bSprintMaterialActive = false;
            m_SprintMaterialEffectConstant.SetScalarParameterValue('FatigueAmount', 0.0000000);            
        }
        else
        {
            m_bSprintMaterialActive = true;
            m_SprintMaterialEffectConstant.SetScalarParameterValue('FatigueAmount', newFAmount);
        }
    }
    //return;    
}

function ToggleAssaultRifleScopeView(bool bEnable, float lookDownSiteTransitionTime)
{
    m_bAssaultRifleScopeEnabled = bEnable;
    // End:0x2B
    if(bEnable)
    {
        InitializeAssaultRifleScopePostProcessing();
        m_bAssaultRifleScopeMaterialActive = true;        
    }
    else
    {
        DisableAssaultRifleScopePostProcessing();
        m_bAssaultRifleScopeMaterialActive = false;
    }
    //return;    
}

function ToggleTimerVariableForTransition(bool bEnable)
{
    m_bAssaultRifleScopePPETimer = bEnable;
    //return;    
}

function UpdateAssaultRifleScopeView()
{
    // End:0x0D
    if(!m_bAssaultRifleScopeEnabled)
    {
        return;
    }
    UpdateAssaultRifleScopePostProcessing();
    //return;    
}

function CreateAssaultRifleEffects()
{
    m_AssaultRifleScopeMaterialEffectConstant = new (Outer) Class'Engine.MaterialInstanceConstant';
    m_AssaultRifleScopeMaterialEffectConstant.SetParent(m_AssaultRifleScopeMaterialEffect);
    m_AssaultRifleScopeMaterialEffectConstantWidescreen = new (Outer) Class'Engine.MaterialInstanceConstant';
    m_AssaultRifleScopeMaterialEffectConstantWidescreen.SetParent(m_AssaultRifleScopeMaterialEffectWidescreen);
    //return;    
}

function InitializeAssaultRifleScopePostProcessing()
{
    local float aspect;

    aspect = m_ScreenRatioY * 1.3400000;
    // End:0x2C
    if(aspect > m_ScreenRatioX)
    {
        m_bUsingWidescreen = false;        
    }
    else
    {
        m_bUsingWidescreen = true;
    }
    //return;    
}

function UpdateAssaultRifleScopePostProcessing()
{
    // End:0x7F
    if(!m_bAssaultRifleScopePPEIsActive)
    {
        // End:0x64
        if(m_bAssaultRifleScopePPEActivating)
        {
            // End:0x3B
            if(m_bAssaultRifleScopePPETimer)
            {
                m_AssaultRifleScopeScalerValue = 1.0000000;
                m_bAssaultRifleScopePPEActivating = false;
                m_bAssaultRifleScopePPEIsActive = true;                
            }
            else
            {
                m_AssaultRifleScopeScalerValue += 0.2000000;
                // End:0x61
                if(m_AssaultRifleScopeScalerValue > 1.0000000)
                {
                    m_AssaultRifleScopeScalerValue = 1.0000000;
                }
            }            
        }
        else
        {
            m_bAssaultRifleScopePPEActivating = true;
            m_bAssaultRifleScopePPETimer = false;
            m_AssaultRifleScopeScalerValue = 0.0000000;
        }
    }
    // End:0xDD
    if(m_bUsingWidescreen)
    {
        // End:0xDA
        if(m_AssaultRifleScopeMaterialEffectConstantWidescreen != none)
        {
            m_AssaultRifleScopeMaterialEffectConstantWidescreen.SetScalarParameterValue('AssaultRifleScopeParameter', m_AssaultRifleScopeScalerValue * m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.AssaultRifleScopeScaler));
        }        
    }
    else
    {
        // End:0x12F
        if(m_AssaultRifleScopeMaterialEffectConstant != none)
        {
            m_AssaultRifleScopeMaterialEffectConstant.SetScalarParameterValue('AssaultRifleScopeParameter', m_AssaultRifleScopeScalerValue * m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.AssaultRifleScopeScaler));
        }
    }
    //return;    
}

function DisableAssaultRifleScopePostProcessing()
{
    // End:0x2D
    if(m_AssaultRifleScopeMaterialEffectConstant != none)
    {
        m_AssaultRifleScopeMaterialEffectConstant.SetScalarParameterValue('AssaultRifleScopeParameter', 0.0000000);
    }
    // End:0x5A
    if(m_AssaultRifleScopeMaterialEffectConstantWidescreen != none)
    {
        m_AssaultRifleScopeMaterialEffectConstantWidescreen.SetScalarParameterValue('AssaultRifleScopeParameter', 0.0000000);
    }
    m_AssaultRifleScopeScalerValue = 0.0000000;
    m_bAssaultRifleScopePPEIsActive = false;
    m_bAssaultRifleScopePPEActivating = false;
    m_bAssaultRifleScopePPEDeactivating = false;
    m_bAssaultRifleScopePPETimer = false;
    //return;    
}

function DrawAssaultRifleScopeView(HUD H)
{
    m_ScreenRatioX = H.SizeX;
    m_ScreenRatioY = H.SizeY;
    //return;    
}

function RenderAssaultRifleScopeEffect()
{
    m_Canvas.SetPos(0.0000000, 0.0000000);
    // End:0xAC
    if((m_AssaultRifleScopeMaterialEffectConstantWidescreen != none) || m_AssaultRifleScopeMaterialEffectConstant != none)
    {
        // End:0x75
        if(m_bUsingWidescreen)
        {
            m_Canvas.DrawMaterialTile(m_AssaultRifleScopeMaterialEffectConstantWidescreen, m_Canvas.ClipX, m_Canvas.ClipY);            
        }
        else
        {
            m_Canvas.DrawMaterialTile(m_AssaultRifleScopeMaterialEffectConstant, m_Canvas.ClipX, m_Canvas.ClipY);
        }
    }
    //return;    
}

function ActivateBulletEffect()
{
    m_bBulletMaterialActive = true;
    m_fBulletEffectTime = 1.0000000;
    //return;    
}

function UpdateBulletEffect(float fAmount)
{
    // End:0x2D
    if(m_BulletMaterialEffectConstant != none)
    {
        m_BulletMaterialEffectConstant.SetScalarParameterValue('MaterialAmount', fAmount);
    }
    //return;    
}

function ToggleBulletEffect(bool bEnable)
{
    m_bBulletMaterialActive = bEnable;
    //return;    
}

function CreateBulletEffect()
{
    m_BulletMaterialEffectConstant = new (Outer) Class'Engine.MaterialInstanceConstant';
    m_BulletMaterialEffectConstant.SetParent(m_BulletMaterialEffect);
    //return;    
}

function RenderBulletEffect()
{
    m_Canvas.SetPos(0.0000000, 0.0000000);
    // End:0x5C
    if(m_BulletMaterialEffectConstant != none)
    {
        m_Canvas.DrawMaterialTile(m_BulletMaterialEffectConstant, m_Canvas.ClipX, m_Canvas.ClipY);
    }
    //return;    
}

function ActivateFireDamageEffect()
{
    m_bFireDamageMaterialActive = true;
    FireDamageEffectTime = 1.0000000;
    //return;    
}

function UpdateFireDamageEffect(float fAmount)
{
    // End:0x2D
    if(m_FireDamageMaterialEffectConstant != none)
    {
        m_FireDamageMaterialEffectConstant.SetScalarParameterValue('MaterialAmount', fAmount);
    }
    //return;    
}

function ToggleFireDamageEffect(bool bEnable)
{
    m_bFireDamageMaterialActive = bEnable;
    //return;    
}

function CreateFireDamageEffect()
{
    m_FireDamageMaterialEffectConstant = new (Outer) Class'Engine.MaterialInstanceConstant';
    m_FireDamageMaterialEffectConstant.SetParent(m_FireDamageMaterialEffect);
    //return;    
}

function RenderFireDamageEffect()
{
    m_Canvas.SetPos(0.0000000, 0.0000000);
    // End:0x5C
    if(m_FireDamageMaterialEffectConstant != none)
    {
        m_Canvas.DrawMaterialTile(m_FireDamageMaterialEffectConstant, m_Canvas.ClipX, m_Canvas.ClipY);
    }
    //return;    
}

function ActivateSonicDamageEffect()
{
    m_bSonicDamageMaterialActive = true;
    SonicDamageEffectTime = 2.0000000;
    //return;    
}

function UpdateSonicDamageEffect(float fAmount)
{
    // End:0x2D
    if(m_SonicDamageMaterialEffectConstant != none)
    {
        m_SonicDamageMaterialEffectConstant.SetScalarParameterValue('FatigueAmount', fAmount);
    }
    //return;    
}

function ToggleSonicDamageEffect(bool bEnable)
{
    m_bSonicDamageMaterialActive = bEnable;
    //return;    
}

function CreateSonicDamageEffect()
{
    m_SonicDamageMaterialEffectConstant = new (Outer) Class'Engine.MaterialInstanceConstant';
    m_SonicDamageMaterialEffectConstant.SetParent(m_SonicDamageMaterialEffect);
    //return;    
}

function RenderSonicDamageEffect()
{
    m_Canvas.SetPos(0.0000000, 0.0000000);
    // End:0x5C
    if(m_SonicDamageMaterialEffectConstant != none)
    {
        m_Canvas.DrawMaterialTile(m_SonicDamageMaterialEffectConstant, m_Canvas.ClipX, m_Canvas.ClipY);
    }
    //return;    
}

function CreateTMGEffect()
{
    local PlayerController PC;
    local LocalPlayer LocPlayer;

    // End:0x1C4
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x1C3
        if(PC != none)
        {
            LocPlayer = LocalPlayer(PC.Player);
            // End:0x1C3
            if(LocPlayer != none)
            {
                // End:0x103
                if(m_TMGMaterialEffect == none)
                {
                    m_TMGMaterialEffect = MaterialEffect(LocPlayer.PlayerPostProcess.FindPostProcessEffect('TMGEffect'));
                    // End:0x103
                    if(m_TMGMaterialEffect != none)
                    {
                        m_TMGMaterialEffectConstant = new (none) Class'Engine.MaterialInstanceConstant';
                        m_TMGMaterialEffectConstant.SetParent(m_TMGMaterialEffect.Material);
                        m_TMGMaterialEffectConstant.SetScalarParameterValue('wwtmg', 0.0000000);
                        m_TMGMaterialEffect.Material = m_TMGMaterialEffectConstant;
                        m_TMGMaterialEffect.bShowInGame = false;
                    }
                }
                // End:0x1C3
                if(m_TMGMaterialEffectBlur == none)
                {
                    m_TMGMaterialEffectBlur = MaterialEffect(LocPlayer.PlayerPostProcess.FindPostProcessEffect('TMGBlurEffect'));
                    // End:0x1C3
                    if(m_TMGMaterialEffectBlur != none)
                    {
                        m_TMGMaterialEffectBlurConstant = new (none) Class'Engine.MaterialInstanceConstant';
                        m_TMGMaterialEffectBlurConstant.SetParent(m_TMGMaterialEffectBlur.Material);
                        m_TMGMaterialEffectBlurConstant.SetScalarParameterValue('wwtmg', 0.0000000);
                        m_TMGMaterialEffectBlur.Material = m_TMGMaterialEffectBlurConstant;
                        m_TMGMaterialEffectBlur.bShowInGame = false;
                    }
                }
            }
        }        
    }    
    //return;    
}

function UpdateTMGEffect(float fAmount)
{
    // End:0x63
    if(m_bTMGMaterialActive)
    {
        // End:0x36
        if(m_TMGMaterialEffectConstant != none)
        {
            m_TMGMaterialEffectConstant.SetScalarParameterValue('wwtmg', fAmount);
        }
        // End:0x63
        if(m_TMGMaterialEffectBlurConstant != none)
        {
            m_TMGMaterialEffectBlurConstant.SetScalarParameterValue('wwtmg', fAmount);
        }
    }
    //return;    
}

function ActivateTMGEffect()
{
    m_bTMGMaterialActive = true;
    // End:0x25
    if(m_TMGMaterialEffect != none)
    {
        m_TMGMaterialEffect.bShowInGame = true;
    }
    // End:0x42
    if(m_TMGMaterialEffectBlur != none)
    {
        m_TMGMaterialEffectBlur.bShowInGame = true;
    }
    UpdateTMGEffect(0.0000000);
    //return;    
}

function DeActivateTMGEffect()
{
    UpdateTMGEffect(0.0000000);
    m_bTMGMaterialActive = false;
    // End:0x34
    if(m_TMGMaterialEffect != none)
    {
        m_TMGMaterialEffect.bShowInGame = false;
    }
    // End:0x51
    if(m_TMGMaterialEffectBlur != none)
    {
        m_TMGMaterialEffectBlur.bShowInGame = false;
    }
    //return;    
}

function UpdateDOFScalerParameter(float Param)
{
    m_WeaponDOFScalerParameter = Param;
    //return;    
}

function ActivateWeaponDOFEffect(Material mat)
{
    m_bWeaponDOFMaterialActive = true;
    // End:0x25
    if(m_WeaponDOFMaterialEffect != none)
    {
        m_WeaponDOFMaterialEffect.bShowInGame = true;
    }
    // End:0x8D
    if(m_WeaponDOFMaterialEffectConstant != none)
    {
        m_WeaponDOFMaterialEffectConstant.SetParent(mat);
        m_WeaponDOFMaterialEffectConstant.SetScalarParameterValue('DOFScaler', 0.0000000);
        m_WeaponDOFMaterialEffectConstant.SetScalarParameterValue('DOFWeaponScaler', 0.0000000);
    }
    m_WeaponDOFScalerParameter = 0.0000000;
    //return;    
}

function DeActivateWeaponDOFEffect()
{
    m_bWeaponDOFMaterialActive = false;
    // End:0x25
    if(m_WeaponDOFMaterialEffect != none)
    {
        m_WeaponDOFMaterialEffect.bShowInGame = false;
    }
    m_WeaponDOFScalerParameter = 0.0000000;
    //return;    
}

function UpdateWeaponDOFEffect()
{
    // End:0x9F
    if(m_WeaponDOFMaterialEffectConstant != none)
    {
        // End:0x5B
        if(m_bWeaponDOFMaterialActive)
        {
            m_WeaponDOFMaterialEffectConstant.SetScalarParameterValue('DOFScaler', m_WeaponDOFScalerParameter);
            m_WeaponDOFMaterialEffectConstant.SetScalarParameterValue('DOFWeaponScaler', m_WeaponDOFScalerParameter);            
        }
        else
        {
            m_WeaponDOFMaterialEffectConstant.SetScalarParameterValue('DOFScaler', 0.0000000);
            m_WeaponDOFMaterialEffectConstant.SetScalarParameterValue('DOFWeaponScaler', 0.0000000);
        }
    }
    //return;    
}

function CreateWeaponDOFEffect()
{
    local PlayerController PC;
    local LocalPlayer LocPlayer;

    // End:0xBF
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xBE
        if(PC != none)
        {
            LocPlayer = LocalPlayer(PC.Player);
            // End:0xBE
            if(LocPlayer != none)
            {
                // End:0xBE
                if(m_WeaponDOFMaterialEffect == none)
                {
                    m_WeaponDOFMaterialEffect = MaterialEffect(LocPlayer.PlayerPostProcess.FindPostProcessEffect('WeaponDOFEffect'));
                    // End:0xBE
                    if(m_WeaponDOFMaterialEffect != none)
                    {
                        m_WeaponDOFMaterialEffectConstant = new (none) Class'Engine.MaterialInstanceConstant';
                        m_WeaponDOFMaterialEffect.Material = m_WeaponDOFMaterialEffectConstant;
                        m_WeaponDOFMaterialEffect.bShowInGame = false;
                    }
                }
            }
        }        
    }    
    //return;    
}

function ActivateNARIDamageEffect()
{
    m_bNariDamageMaterialActive = true;
    NariDamageEffectTime = NariDamageEffectMaxTime;
    //return;    
}

function UpdateNARIDamageEffect(float fAmount)
{
    // End:0xB1
    if(m_NariDamageMaterialEffectConstant != none)
    {
        // End:0x46
        if(fAmount > NariDamageEffectRampUpTime)
        {
            m_NariDamageMaterialEffectConstant.SetScalarParameterValue('nari_scream', fAmount / NariDamageEffectRampUpTime);            
        }
        else
        {
            // End:0x7A
            if(fAmount > NariDamageEffectRampUpTime)
            {
                m_NariDamageMaterialEffectConstant.SetScalarParameterValue('nari_scream', 1.0000000);                
            }
            else
            {
                m_NariDamageMaterialEffectConstant.SetScalarParameterValue('nari_scream', (fAmount - NariDamageEffectRampDownTime) / (NariDamageEffectMaxTime - NariDamageEffectRampDownTime));
            }
        }
    }
    //return;    
}

function ToggleNARIDamageEffect(bool bEnable)
{
    m_bNariDamageMaterialActive = bEnable;
    //return;    
}

function CreateNARIDamageEffect()
{
    m_NariDamageMaterialEffectConstant = new (Outer) Class'Engine.MaterialInstanceConstant';
    m_NariDamageMaterialEffectConstant.SetParent(m_NariDamageMaterialEffect);
    //return;    
}

function RenderNARIDamageEffect()
{
    m_Canvas.SetPos(0.0000000, 0.0000000);
    // End:0x5C
    if(m_NariDamageMaterialEffectConstant != none)
    {
        m_Canvas.DrawMaterialTile(m_NariDamageMaterialEffectConstant, m_Canvas.ClipX, m_Canvas.ClipY);
    }
    //return;    
}

function CreateKismetMaterialEffect(MaterialInterface NewMaterial, name MaterialParameterName, float FadeOutDelayTime, float FadeOutSpeed, float FadeInValue, float FadeInSpeed)
{
    m_KismetActivatedEffectConstant = new (Outer) Class'Engine.MaterialInstanceConstant';
    m_KismetActivatedEffectConstant.SetParent(NewMaterial);
    m_KismetActivatedParameterName = MaterialParameterName;
    m_KismetActivatedFadeOutDelayTime = FadeOutDelayTime;
    m_KismetActivatedFadeOutSpeed = FadeOutSpeed;
    m_KismetActivatedFadeInSpeed = FadeInSpeed;
    m_KismetActivatedParameterValue = FadeInValue;
    m_bFadingOut = false;
    // End:0x86
    if(m_KismetActivatedFadeOutDelayTime > 0.0000000)
    {
        m_bKismetActivatedUsingDelay = true;        
    }
    else
    {
        m_bKismetActivatedUsingDelay = false;
    }
    m_bKismetActivatedMaterialActive = true;
    //return;    
}

function KismetMaterialEffectDelayTimer()
{
    m_bKismetActivatedUsingDelay = false;
    //return;    
}

function UpdateKismetMaterialEffect()
{
    local PandoraPlayerController PC;

    // End:0x120
    if(m_KismetActivatedEffectConstant != none)
    {
        // End:0xEF
        if(m_KismetActivatedParameterValue < 1.0000000)
        {
            // End:0x68
            if(!m_bFadingOut)
            {
                m_KismetActivatedParameterValue += (m_KismetActivatedFadeInSpeed * 0.0010000);
                // End:0x65
                if((m_KismetActivatedParameterValue >= 1.0000000) && m_bKismetActivatedUsingDelay)
                {
                    SetTimer(m_KismetActivatedFadeOutDelayTime, false, 'KismetMaterialEffectDelayTimer');
                }                
            }
            else
            {
                // End:0xEC
                if(!m_bKismetActivatedUsingDelay)
                {
                    m_KismetActivatedParameterValue -= (m_KismetActivatedFadeOutSpeed * 0.0010000);
                    // End:0xEC
                    if(m_KismetActivatedParameterValue <= 0.0000000)
                    {
                        // End:0xEB
                        foreach WorldInfo.AllControllers(Class'PandoraPlayerController', PC)
                        {
                            PC.ClearLatentAction(Class'SeqAct_CreateMaterialEffect', false);
                            m_bKismetActivatedMaterialActive = false;
                            m_KismetActivatedParameterName = 'None';
                            m_KismetActivatedEffectConstant = none;                            
                            return;                            
                        }                        
                    }
                }
            }            
        }
        else
        {
            m_bFadingOut = true;
            m_KismetActivatedParameterValue = 0.9900000;
        }
        m_KismetActivatedEffectConstant.SetScalarParameterValue(m_KismetActivatedParameterName, m_KismetActivatedParameterValue);
    }
    //return;    
}

function RenderKismetMaterialEffect()
{
    m_Canvas.SetPos(0.0000000, 0.0000000);
    // End:0x5C
    if(m_KismetActivatedEffectConstant != none)
    {
        m_Canvas.DrawMaterialTile(m_KismetActivatedEffectConstant, m_Canvas.ClipX, m_Canvas.ClipY);
    }
    //return;    
}

function ActivateHitMaterialEffect(float FadeTime)
{
    m_bHitMaterialActive = true;
    // End:0x25
    if(m_HitMaterialEffect != none)
    {
        m_HitMaterialEffect.bShowInGame = true;
    }
    m_HitMaterialEffectTime = FadeTime;
    UpdateHitMaterialEffect();
    //return;    
}

function DeActivateHitMaterialEffect()
{
    UpdateHitMaterialEffect();
    m_bHitMaterialActive = false;
    // End:0x2F
    if(m_HitMaterialEffect != none)
    {
        m_HitMaterialEffect.bShowInGame = false;
    }
    //return;    
}

function TickHitMaterialEffect(float DeltaTime)
{
    // End:0x0D
    if(!m_bHitMaterialActive)
    {
        return;
    }
    m_HitMaterialEffectTime -= DeltaTime;
    // End:0x40
    if(m_HitMaterialEffectTime <= 0.0000000)
    {
        m_HitMaterialEffectTime = 0.0000000;
        DeActivateHitMaterialEffect();        
    }
    else
    {
        UpdateHitMaterialEffect();
    }
    //return;    
}

function UpdateHitMaterialEffect()
{
    // End:0x2D
    if(m_HitMaterialEffectConstant != none)
    {
        m_HitMaterialEffectConstant.SetScalarParameterValue('Alpha', m_HitMaterialEffectTime);
    }
    //return;    
}

function CreateHitMaterialEffect()
{
    local PlayerController PC;
    local LocalPlayer LocPlayer;

    // End:0x104
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x103
        if(PC != none)
        {
            LocPlayer = LocalPlayer(PC.Player);
            // End:0x103
            if(LocPlayer != none)
            {
                // End:0x103
                if(m_HitMaterialEffect == none)
                {
                    m_HitMaterialEffect = MaterialEffect(LocPlayer.PlayerPostProcess.FindPostProcessEffect('GriffonHitMaterialEffect'));
                    // End:0x103
                    if(m_HitMaterialEffect != none)
                    {
                        m_HitMaterialEffectConstant = new (none) Class'Engine.MaterialInstanceConstant';
                        m_HitMaterialEffectConstant.SetParent(m_HitMaterialEffect.Material);
                        m_HitMaterialEffectConstant.SetScalarParameterValue('Alpha', 0.0000000);
                        m_HitMaterialEffect.Material = m_HitMaterialEffectConstant;
                        m_HitMaterialEffect.bShowInGame = false;
                    }
                }
            }
        }        
    }    
    //return;    
}

function UpdateScreenRatio(float X, float Y)
{
    m_ScreenRatioX = X;
    m_ScreenRatioY = Y;
    //return;    
}
