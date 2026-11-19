class MOHAPostProcessComponent extends ActorComponent
    native;

enum PPInterpState
{
    Up,                             // 0
    Flat,                           // 1
    Down,                           // 2
    PPInterpState_MAX               // 3
};

var MOHAPostProcessSettingsAsset PostProcessSettings;
var transient MaterialEffect DoubleVisionEffect;
var transient MaterialInstanceConstant DoubleVisionEffectMaterialInstance;
var transient MaterialEffect ScopeEffect;
var transient MaterialInstanceConstant ScopeEffectMaterialInstance;
var bool bExplosion;
var bool bMeleeHit;
var bool bSpotLight;
var bool bStopSpotLight;
var bool bLowHealth;
var bool bDying;
var bool bMedkit;
var bool bItemPickup;
var bool bBulletHit;
var bool bGeneric;
var bool bDoingCurve;
var bool bUsingBlackCurve;
var bool bDoingFadeIn;
var bool bDoingFadeOut;
var bool ColorCorrectionRunning;
var float ExplosionTimer;
var MOHAPostProcessSettings StoredExplosionSettings;
var float DoubleVisionTimer;
var float MeleeHitTimer;
var float SpotLightTimer;
var float LowHealthTimer;
var MOHAPostProcessSettings StoredLowHealthSettings;
var float DyingTimer;
var float MedkitTimer;
var float ItemPickupTimer;
var float BulletHitTimer;
var float GenericTimer;
var MOHAPostProcessSettings StoredGenericSettings;
var int GenericPriority;
var transient MOHAPostProcessSettings PersistantSettings;
var transient MOHAPostProcessSettings FromSettings;
var MOHAPostProcessSettings IdentitySettings;
var Texture2D SavedCurveTexture;
var WorldInfo pWorldInfo;
var MOHAHeroSearchlightActor blindingSearchLight;
var Texture2D BlackTexture;
var float FadeTimer;
var float FadeDelay;
var float FadeTime;

simulated event Init(PlayerController PlayerOwner)
{
    DoubleVisionEffect = MaterialEffect(LocalPlayer(PlayerOwner.Player).PlayerPostProcess.FindPostProcessEffect('MOHA_DOUBLE_VISION_EFFECT'));
    DoubleVisionEffectMaterialInstance = MaterialInstanceConstant(DoubleVisionEffect.Material);
    DoubleVisionEffect.bShowInGame = false;
    // End:0x6F
    if(DoubleVisionEffectMaterialInstance == none)
    {
    }
    ScopeEffect = MaterialEffect(LocalPlayer(PlayerOwner.Player).PlayerPostProcess.FindPostProcessEffect('ScopeEffect'));
    ScopeEffectMaterialInstance = MaterialInstanceConstant(ScopeEffect.Material);
    IdentitySettings.Desaturation = 0.0000000;
    IdentitySettings.MidTones = vect(1.0000000, 1.0000000, 1.0000000);
    IdentitySettings.HighLights = vect(1.0000000, 1.0000000, 1.0000000);
    IdentitySettings.Shadows = vect(0.0000000, 0.0000000, 0.0000000);
    PersistantSettings.Desaturation = 0.0000000;
    PersistantSettings.MidTones = vect(1.0000000, 1.0000000, 1.0000000);
    PersistantSettings.HighLights = vect(1.0000000, 1.0000000, 1.0000000);
    PersistantSettings.Shadows = vect(0.0000000, 0.0000000, 0.0000000);
    FromSettings.Desaturation = 0.0000000;
    FromSettings.MidTones = vect(1.0000000, 1.0000000, 1.0000000);
    FromSettings.HighLights = vect(1.0000000, 1.0000000, 1.0000000);
    FromSettings.Shadows = vect(0.0000000, 0.0000000, 0.0000000);
    bExplosion = false;
    bMeleeHit = false;
    bSpotLight = false;
    bStopSpotLight = false;
    bLowHealth = false;
    bDying = false;
    bMedkit = false;
    bItemPickup = false;
    bBulletHit = false;
    bGeneric = false;
    blindingSearchLight = none;
    pWorldInfo = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    // End:0x2D2
    if(pWorldInfo.bStartGameInBlack == true)
    {
        bUsingBlackCurve = true;
        FadeTimer = 0.0000000;
        bDoingFadeIn = false;
        bDoingFadeOut = false;
        pWorldInfo.CurveTextureSecondary = BlackTexture;
        pWorldInfo.CurveBlendValue = 1.0000000;
    }
    DisableScopeEffect();
    pWorldInfo.ToggleDOF(false);
    //return;    
}

simulated function Reset()
{
    DoubleVisionEffect.bShowInGame = false;
    ScopeEffect.bShowInGame = false;
    bExplosion = false;
    bMeleeHit = false;
    bSpotLight = false;
    bStopSpotLight = false;
    bLowHealth = false;
    bDying = false;
    bMedkit = false;
    bItemPickup = false;
    bBulletHit = false;
    bGeneric = false;
    blindingSearchLight = none;
    //return;    
}

simulated event InitDebug(Engine theEngine)
{
    DoubleVisionEffect = MaterialEffect(theEngine.DefaultPostProcess.FindPostProcessEffect('MOHA_DOUBLE_VISION_EFFECT'));
    DoubleVisionEffectMaterialInstance = MaterialInstanceConstant(DoubleVisionEffect.Material);
    DoubleVisionEffect.bShowInGame = false;
    // End:0x61
    if(DoubleVisionEffectMaterialInstance == none)
    {
    }
    ScopeEffect = MaterialEffect(theEngine.DefaultPostProcess.FindPostProcessEffect('ScopeEffect'));
    ScopeEffectMaterialInstance = MaterialInstanceConstant(ScopeEffect.Material);
    IdentitySettings.Desaturation = 0.0000000;
    IdentitySettings.MidTones = vect(1.0000000, 1.0000000, 1.0000000);
    IdentitySettings.HighLights = vect(1.0000000, 1.0000000, 1.0000000);
    IdentitySettings.Shadows = vect(0.0000000, 0.0000000, 0.0000000);
    PersistantSettings.Desaturation = 0.0000000;
    PersistantSettings.MidTones = vect(1.0000000, 1.0000000, 1.0000000);
    PersistantSettings.HighLights = vect(1.0000000, 1.0000000, 1.0000000);
    PersistantSettings.Shadows = vect(0.0000000, 0.0000000, 0.0000000);
    FromSettings.Desaturation = 0.0000000;
    FromSettings.MidTones = vect(1.0000000, 1.0000000, 1.0000000);
    FromSettings.HighLights = vect(1.0000000, 1.0000000, 1.0000000);
    FromSettings.Shadows = vect(0.0000000, 0.0000000, 0.0000000);
    bExplosion = false;
    bMeleeHit = false;
    bSpotLight = false;
    bStopSpotLight = false;
    bLowHealth = false;
    bDying = false;
    bMedkit = false;
    bItemPickup = false;
    bBulletHit = false;
    bGeneric = false;
    pWorldInfo = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    // End:0x2AF
    if(pWorldInfo.bStartGameInBlack == true)
    {
        bUsingBlackCurve = true;
        FadeTimer = 0.0000000;
        bDoingFadeIn = false;
        bDoingFadeOut = false;
        pWorldInfo.CurveTextureSecondary = BlackTexture;
        pWorldInfo.CurveBlendValue = 1.0000000;
    }
    //return;    
}

simulated function EnableScopeEffect()
{
    ScopeEffect.bShowInGame = true;
    //return;    
}

simulated function DisableScopeEffect()
{
    ScopeEffect.bShowInGame = false;
    //return;    
}

simulated function FadeIn(float inFadeDelay, float inFadeTime)
{
    bUsingBlackCurve = true;
    FadeTimer = 0.0000000;
    bDoingFadeIn = true;
    bDoingFadeOut = false;
    FadeDelay = inFadeDelay;
    FadeTime = inFadeTime;
    pWorldInfo.CurveTextureSecondary = BlackTexture;
    pWorldInfo.CurveBlendValue = 1.0000000;
    //return;    
}

simulated function FadeOut(float inFadeDelay, float inFadeTime)
{
    bUsingBlackCurve = true;
    FadeTimer = 0.0000000;
    bDoingFadeIn = false;
    bDoingFadeOut = true;
    FadeDelay = inFadeDelay;
    FadeTime = inFadeTime;
    pWorldInfo.CurveTextureSecondary = BlackTexture;
    pWorldInfo.CurveBlendValue = 0.0000000;
    //return;    
}

simulated function SetFromSettingsFromPersistant()
{
    FromSettings.Desaturation = PersistantSettings.Desaturation;
    FromSettings.MidTones = PersistantSettings.MidTones;
    FromSettings.HighLights = PersistantSettings.HighLights;
    FromSettings.Shadows = PersistantSettings.Shadows;
    //return;    
}

simulated function TurnOffCurve()
{
    // End:0x38
    if(bDoingCurve == true)
    {
        bDoingCurve = false;
        pWorldInfo.CurveTextureMain = SavedCurveTexture;
        pWorldInfo.CurveTextureSecondary = none;
    }
    //return;    
}

simulated function InitCurve(Texture2D SecondaryCurve)
{
    // End:0x66
    if((SecondaryCurve != none) && pWorldInfo.bCalcCurves == true)
    {
        bDoingCurve = true;
        SavedCurveTexture = pWorldInfo.CurveTextureMain;
        pWorldInfo.CurveTextureSecondary = SecondaryCurve;
        pWorldInfo.CurveBlendValue = 0.0000000;
    }
    //return;    
}

simulated function startGeneric(MOHAPostProcessSettings inSettings, int Priority)
{
    // End:0x11E
    if((ShouldEffectRun(Priority)) == true)
    {
        ColorCorrectionRunning = true;
        SetFromSettingsFromPersistant();
        bGeneric = true;
        GenericTimer = 0.0000000;
        GenericPriority = Priority;
        StoredGenericSettings.FlatTime = inSettings.FlatTime;
        StoredGenericSettings.InterpInTime = inSettings.InterpInTime;
        StoredGenericSettings.InterpOutTime = inSettings.InterpOutTime;
        StoredGenericSettings.HighLights = inSettings.HighLights;
        StoredGenericSettings.MidTones = inSettings.MidTones;
        StoredGenericSettings.Shadows = inSettings.Shadows;
        StoredGenericSettings.Desaturation = inSettings.Desaturation;
    }
    //return;    
}

simulated function startSpotLight(optional MOHAHeroSearchlightActor searchLight)
{
    // End:0x6F
    if((ShouldEffectRun(PostProcessSettings.SpotLight_Priority)) == true)
    {
        ColorCorrectionRunning = true;
        SetFromSettingsFromPersistant();
        InitCurve(PostProcessSettings.SpotLight_CurveTexture);
        bSpotLight = true;
        bStopSpotLight = false;
        SpotLightTimer = 0.0000000;
        blindingSearchLight = searchLight;
    }
    //return;    
}

simulated function stopSpotLight(optional MOHAHeroSearchlightActor searchLight)
{
    // End:0x82
    if(((blindingSearchLight == searchLight) || searchLight == none) && (ShouldEffectRun(PostProcessSettings.SpotLight_Priority)) == true)
    {
        ColorCorrectionRunning = true;
        SetFromSettingsFromPersistant();
        InitCurve(PostProcessSettings.SpotLight_CurveTexture);
        bSpotLight = true;
        bStopSpotLight = true;
        SpotLightTimer = 0.0000000;
    }
    //return;    
}

simulated function startDying()
{
    // End:0x5B
    if((ShouldEffectRun(PostProcessSettings.Dying_Priority)) == true)
    {
        ColorCorrectionRunning = true;
        SetFromSettingsFromPersistant();
        InitCurve(PostProcessSettings.Dying_CurveTexture);
        bDying = true;
        DyingTimer = 0.0000000;
    }
    //return;    
}

simulated function startDyingFull()
{
    // End:0x5B
    if((ShouldEffectRun(PostProcessSettings.Dying_Priority)) == true)
    {
        ColorCorrectionRunning = true;
        SetFromSettingsFromPersistant();
        InitCurve(PostProcessSettings.Dying_CurveTexture);
        bDying = true;
        DyingTimer = 100.0000000;
    }
    //return;    
}

simulated function stopDying()
{
    bDying = false;
    TurnOffCurve();
    //return;    
}

simulated function startMedkit()
{
    // End:0x5B
    if((ShouldEffectRun(PostProcessSettings.Medkit_Priority)) == true)
    {
        ColorCorrectionRunning = true;
        SetFromSettingsFromPersistant();
        InitCurve(PostProcessSettings.Medkit_CurveTexture);
        bMedkit = true;
        MedkitTimer = 0.0000000;
    }
    //return;    
}

simulated function startItemPickup()
{
    // End:0x5B
    if((ShouldEffectRun(PostProcessSettings.ItemPickup_Priority)) == true)
    {
        ColorCorrectionRunning = true;
        SetFromSettingsFromPersistant();
        InitCurve(PostProcessSettings.ItemPickup_CurveTexture);
        bItemPickup = true;
        ItemPickupTimer = 0.0000000;
    }
    //return;    
}

simulated function startBulletHit()
{
    // End:0x5B
    if((ShouldEffectRun(PostProcessSettings.BulletHit_Priority)) == true)
    {
        ColorCorrectionRunning = true;
        SetFromSettingsFromPersistant();
        InitCurve(PostProcessSettings.BulletHit_CurveTexture);
        bBulletHit = true;
        BulletHitTimer = 0.0000000;
    }
    //return;    
}

event UpdateHealth(int Health, optional int iVergeOfDeathHealth = 50)
{
    local float healthInterpValue, oneMinusHealthInterpValue;

    // End:0x2B3
    if((Health < iVergeOfDeathHealth) && Health > 0)
    {
        ColorCorrectionRunning = true;
        bLowHealth = true;
        healthInterpValue = float(Health) / float(iVergeOfDeathHealth);
        oneMinusHealthInterpValue = 1.0000000 - healthInterpValue;
        StoredLowHealthSettings.InterpInTime = PostProcessSettings.LowHealth_HBSettings.InterpInTime + ((PostProcessSettings.LowHealth_HBSettings.InterpInTime * healthInterpValue) * PostProcessSettings.LowHealth_HBStartSpeed);
        StoredLowHealthSettings.FlatTime = PostProcessSettings.LowHealth_HBSettings.FlatTime + ((PostProcessSettings.LowHealth_HBSettings.InterpInTime * healthInterpValue) * PostProcessSettings.LowHealth_HBStartSpeed);
        StoredLowHealthSettings.InterpOutTime = PostProcessSettings.LowHealth_HBSettings.InterpOutTime + ((PostProcessSettings.LowHealth_HBSettings.InterpInTime * healthInterpValue) * PostProcessSettings.LowHealth_HBStartSpeed);
        StoredLowHealthSettings.HighLights = (healthInterpValue * PostProcessSettings.LowHealth_StartSettings.HighLights) + (oneMinusHealthInterpValue * PostProcessSettings.LowHealth_EndSettings.HighLights);
        StoredLowHealthSettings.MidTones = (healthInterpValue * PostProcessSettings.LowHealth_StartSettings.MidTones) + (oneMinusHealthInterpValue * PostProcessSettings.LowHealth_EndSettings.MidTones);
        StoredLowHealthSettings.Shadows = (healthInterpValue * PostProcessSettings.LowHealth_StartSettings.Shadows) + (oneMinusHealthInterpValue * PostProcessSettings.LowHealth_EndSettings.Shadows);
        StoredLowHealthSettings.Desaturation = (healthInterpValue * PostProcessSettings.LowHealth_StartSettings.Desaturation) + (oneMinusHealthInterpValue * PostProcessSettings.LowHealth_EndSettings.Desaturation);
        LowHealthTimer = 0.0000000;        
    }
    else
    {
        bLowHealth = false;
    }
    //return;    
}

simulated function float startExplosion(float fDist)
{
    local float DistanceInterpValue, OneMinusDistanceInterpValue, fFlashTime;

    // End:0x1E
    if(fDist > PostProcessSettings.Explosion_DistanceRadius)
    {
        return 0.0000000;
    }
    // End:0x4D8
    if((ShouldEffectRun(PostProcessSettings.Explosion_Priority)) == true)
    {
        ColorCorrectionRunning = true;
        DoubleVisionEffect.bShowInGame = true;
        SetFromSettingsFromPersistant();
        InitCurve(PostProcessSettings.Explosion_FlashCurveTexture);
        bExplosion = true;
        ExplosionTimer = 0.0000000;
        DoubleVisionTimer = (FRand() * 2.0000000) * 3.1415930;
        // End:0x107
        if((PostProcessSettings.Explosion_ScaleTimeBasedOnDistance == true) || PostProcessSettings.Explosion_ScaleEffectStrengthBasedOnDistance == true)
        {
            DistanceInterpValue = fDist / PostProcessSettings.Explosion_DistanceRadius;
            OneMinusDistanceInterpValue = DistanceInterpValue;
            DistanceInterpValue = 1.0000000 - DistanceInterpValue;            
        }
        else
        {
            StoredExplosionSettings.FlatTime = PostProcessSettings.Explosion_LowSettings.FlatTime;
            StoredExplosionSettings.InterpInTime = PostProcessSettings.Explosion_LowSettings.InterpInTime;
            StoredExplosionSettings.InterpOutTime = PostProcessSettings.Explosion_LowSettings.InterpOutTime;
            StoredExplosionSettings.HighLights = PostProcessSettings.Explosion_LowSettings.HighLights;
            StoredExplosionSettings.MidTones = PostProcessSettings.Explosion_LowSettings.MidTones;
            StoredExplosionSettings.Shadows = PostProcessSettings.Explosion_LowSettings.Shadows;
            StoredExplosionSettings.Desaturation = PostProcessSettings.Explosion_LowSettings.Desaturation;
        }
        // End:0x324
        if(PostProcessSettings.Explosion_ScaleTimeBasedOnDistance == true)
        {
            StoredExplosionSettings.FlatTime = (OneMinusDistanceInterpValue * PostProcessSettings.Explosion_LowSettings.FlatTime) + (DistanceInterpValue * PostProcessSettings.Explosion_HighSettings.FlatTime);
            StoredExplosionSettings.InterpInTime = (OneMinusDistanceInterpValue * PostProcessSettings.Explosion_LowSettings.InterpInTime) + (DistanceInterpValue * PostProcessSettings.Explosion_HighSettings.InterpInTime);
            StoredExplosionSettings.InterpOutTime = (OneMinusDistanceInterpValue * PostProcessSettings.Explosion_LowSettings.InterpOutTime) + (DistanceInterpValue * PostProcessSettings.Explosion_HighSettings.InterpOutTime);
        }
        // End:0x479
        if(PostProcessSettings.Explosion_ScaleEffectStrengthBasedOnDistance == true)
        {
            StoredExplosionSettings.HighLights = (OneMinusDistanceInterpValue * PostProcessSettings.Explosion_LowSettings.HighLights) + (DistanceInterpValue * PostProcessSettings.Explosion_HighSettings.HighLights);
            StoredExplosionSettings.MidTones = (OneMinusDistanceInterpValue * PostProcessSettings.Explosion_LowSettings.MidTones) + (DistanceInterpValue * PostProcessSettings.Explosion_HighSettings.MidTones);
            StoredExplosionSettings.Shadows = (OneMinusDistanceInterpValue * PostProcessSettings.Explosion_LowSettings.Shadows) + (DistanceInterpValue * PostProcessSettings.Explosion_HighSettings.Shadows);
            StoredExplosionSettings.Desaturation = (OneMinusDistanceInterpValue * PostProcessSettings.Explosion_LowSettings.Desaturation) + (DistanceInterpValue * PostProcessSettings.Explosion_HighSettings.Desaturation);
        }
        fFlashTime = (PostProcessSettings.Explosion_FlashSettings.InterpInTime + PostProcessSettings.Explosion_FlashSettings.FlatTime) + PostProcessSettings.Explosion_FlashSettings.InterpOutTime;
        return FMax(fFlashTime, DoubleVisionTimer);
    }
    return 0.0000000;
    //return ReturnValue;    
}

simulated function startMeleeHit()
{
    // End:0x82
    if((ShouldEffectRun(PostProcessSettings.MeleeHit_Priority)) == true)
    {
        ColorCorrectionRunning = true;
        DoubleVisionEffect.bShowInGame = true;
        SetFromSettingsFromPersistant();
        InitCurve(PostProcessSettings.MeleeHit_FirstCurveTexture);
        bMeleeHit = true;
        MeleeHitTimer = 0.0000000;
        DoubleVisionTimer = (FRand() * 2.0000000) * 3.1415930;
    }
    //return;    
}

simulated function bool ShouldEffectRun(int Priority)
{
    // End:0x3A
    if(bExplosion == true)
    {
        // End:0x38
        if(PostProcessSettings.Explosion_Priority <= Priority)
        {
            bExplosion = false;
            TurnOffCurve();
            return true;
        }
        return false;
    }
    // End:0x74
    if(bMeleeHit == true)
    {
        // End:0x72
        if(PostProcessSettings.MeleeHit_Priority <= Priority)
        {
            bMeleeHit = false;
            TurnOffCurve();
            return true;
        }
        return false;
    }
    // End:0xAE
    if(bSpotLight == true)
    {
        // End:0xAC
        if(PostProcessSettings.SpotLight_Priority <= Priority)
        {
            bSpotLight = false;
            TurnOffCurve();
            return true;
        }
        return false;
    }
    // End:0xE8
    if(bDying == true)
    {
        // End:0xE6
        if(PostProcessSettings.Dying_Priority <= Priority)
        {
            bDying = false;
            TurnOffCurve();
            return true;
        }
        return false;
    }
    // End:0x122
    if(bMedkit == true)
    {
        // End:0x120
        if(PostProcessSettings.Medkit_Priority <= Priority)
        {
            bMedkit = false;
            TurnOffCurve();
            return true;
        }
        return false;
    }
    // End:0x15C
    if(bItemPickup == true)
    {
        // End:0x15A
        if(PostProcessSettings.ItemPickup_Priority <= Priority)
        {
            bItemPickup = false;
            TurnOffCurve();
            return true;
        }
        return false;
    }
    // End:0x196
    if(bBulletHit == true)
    {
        // End:0x194
        if(PostProcessSettings.BulletHit_Priority <= Priority)
        {
            bBulletHit = false;
            TurnOffCurve();
            return true;
        }
        return false;
    }
    // End:0x1C7
    if(bGeneric == true)
    {
        // End:0x1C5
        if(GenericPriority <= Priority)
        {
            bGeneric = false;
            TurnOffCurve();
            return true;
        }
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function CalcValuesLinearInterp(float InterpValue, MOHAPostProcessSettings From, MOHAPostProcessSettings To, out MOHAPostProcessSettings ReturnValue)
{
    local float OneMinusInterpValue;

    OneMinusInterpValue = 1.0000000 - InterpValue;
    ReturnValue.HighLights = (OneMinusInterpValue * From.HighLights) + (InterpValue * To.HighLights);
    ReturnValue.MidTones = (OneMinusInterpValue * From.MidTones) + (InterpValue * To.MidTones);
    ReturnValue.Shadows = (OneMinusInterpValue * From.Shadows) + (InterpValue * To.Shadows);
    ReturnValue.Desaturation = (OneMinusInterpValue * From.Desaturation) + (InterpValue * To.Desaturation);
    //return;    
}

simulated function CalcValuesDifference(float InterpValue, MOHAPostProcessSettings From, MOHAPostProcessSettings To, out MOHAPostProcessSettings ReturnValue)
{
    ReturnValue.HighLights = From.HighLights + (InterpValue * To.HighLights);
    ReturnValue.MidTones = From.MidTones + (InterpValue * To.MidTones);
    ReturnValue.Shadows = From.Shadows + (InterpValue * To.Shadows);
    ReturnValue.Desaturation = From.Desaturation + (InterpValue * To.Desaturation);
    //return;    
}

simulated function bool GetInterpValueDies(float Time, MOHAPostProcessSettings PPSettings, out float InterpValue, out MOHAPostProcessComponent.PPInterpState InterpState)
{
    InterpValue = 0.0000000;
    // End:0x53
    if(Time > ((PPSettings.InterpInTime + PPSettings.FlatTime) + PPSettings.InterpOutTime))
    {
        InterpState = 2;
        return false;        
    }
    else
    {
        // End:0xE3
        if(Time > (PPSettings.InterpInTime + PPSettings.FlatTime))
        {
            InterpState = 2;
            InterpValue = (Time - PPSettings.InterpInTime) - PPSettings.FlatTime;
            InterpValue = InterpValue / PPSettings.InterpOutTime;
            InterpValue = 1.0000000 - InterpValue;            
        }
        else
        {
            // End:0x112
            if(Time > PPSettings.InterpInTime)
            {
                InterpState = 1;
                InterpValue = 1.0000000;                
            }
            else
            {
                InterpState = 0;
                InterpValue = Time / PPSettings.InterpInTime;
            }
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function bool GetInterpValueNoDie(float Time, MOHAPostProcessSettings PPSettings, out float InterpValue)
{
    InterpValue = 1.0000000;
    // End:0x29
    if(Time > PPSettings.InterpInTime)
    {
        return false;        
    }
    else
    {
        InterpValue = Time / PPSettings.InterpInTime;
    }
    return true;
    //return ReturnValue;    
}

simulated event Update(float DeltaTime)
{
    local float InterpValue, SinVal, DoubleVisionIntensity, CalcSinVal;
    local MOHAPostProcessComponent.PPInterpState InterpState;
    local MOHAPostProcessSettings ResultSettings;

    // End:0x0D
    if(DoubleVisionEffect == none)
    {
        return;
    }
    // End:0xE82
    if((ColorCorrectionRunning == true) || DoubleVisionEffect.bShowInGame == true)
    {
        ResultSettings.Desaturation = 0.0000000;
        ResultSettings.MidTones = vect(1.0000000, 1.0000000, 1.0000000);
        ResultSettings.HighLights = vect(1.0000000, 1.0000000, 1.0000000);
        ResultSettings.Shadows = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0x128
        if(bGeneric == true)
        {
            GenericTimer += DeltaTime;
            bGeneric = GetInterpValueDies(GenericTimer, StoredGenericSettings, InterpValue, InterpState);
            // End:0x10A
            if(int(InterpState) == int(2))
            {
                CalcValuesLinearInterp(InterpValue, IdentitySettings, StoredGenericSettings, ResultSettings);                
            }
            else
            {
                CalcValuesLinearInterp(InterpValue, FromSettings, StoredGenericSettings, ResultSettings);
            }
        }
        // End:0x4B8
        if(bExplosion == true)
        {
            ExplosionTimer += DeltaTime;
            bExplosion = GetInterpValueDies(ExplosionTimer, PostProcessSettings.Explosion_FlashSettings, InterpValue, InterpState);
            // End:0x1AF
            if(bExplosion == true)
            {
                CalcValuesLinearInterp(InterpValue, FromSettings, PostProcessSettings.Explosion_FlashSettings, ResultSettings);
                DoubleVisionIntensity = InterpValue;                
            }
            else
            {
                bExplosion = GetInterpValueDies(ExplosionTimer - ((PostProcessSettings.Explosion_FlashSettings.InterpInTime + PostProcessSettings.Explosion_FlashSettings.FlatTime) + PostProcessSettings.Explosion_FlashSettings.InterpOutTime), StoredExplosionSettings, InterpValue, InterpState);
                // End:0x29B
                if(int(InterpState) == int(2))
                {
                    CalcValuesLinearInterp(InterpValue, IdentitySettings, StoredExplosionSettings, ResultSettings);
                    // End:0x28D
                    if(bDoingCurve == true)
                    {
                        pWorldInfo.CurveTextureMain = SavedCurveTexture;
                        pWorldInfo.CurveTextureSecondary = PostProcessSettings.Explosion_SecondCurveTexture;
                    }
                    DoubleVisionIntensity = InterpValue;                    
                }
                else
                {
                    CalcValuesLinearInterp(InterpValue, PostProcessSettings.Explosion_FlashSettings, StoredExplosionSettings, ResultSettings);
                    // End:0x308
                    if(bDoingCurve == true)
                    {
                        pWorldInfo.CurveTextureMain = PostProcessSettings.Explosion_FlashCurveTexture;
                        pWorldInfo.CurveTextureSecondary = PostProcessSettings.Explosion_SecondCurveTexture;
                    }
                    DoubleVisionIntensity = 1.0000000;
                }
            }
            DoubleVisionTimer += DeltaTime;
            // End:0x359
            if(int(InterpState) == int(2))
            {
                DoubleVisionTimer += ((DeltaTime * (1.0000000 - DoubleVisionIntensity)) * PostProcessSettings.Explosion_DoubleVisionSpeedUp);
            }
            // End:0x4B8
            if(bExplosion == true)
            {
                SinVal = DoubleVisionTimer * (2.0000000 * 3.1415930);
                DoubleVisionIntensity = DoubleVisionIntensity * (PostProcessSettings.Explosion_DoubleVisionExtreme + (Sin(SinVal * PostProcessSettings.Explosion_VarianceFrequency) * PostProcessSettings.Explosion_DoubleVisionVariance));
                DoubleVisionIntensity = Abs(DoubleVisionIntensity);
                SinVal = SinVal * PostProcessSettings.Explosion_Frequency;
                CalcSinVal = Sin(SinVal);
                DoubleVisionEffectMaterialInstance.SetScalarParameterValue('DoubleVision1V', CalcSinVal * DoubleVisionIntensity);
                DoubleVisionEffectMaterialInstance.SetScalarParameterValue('DoubleVision2V', (-1.0000000 * CalcSinVal) * DoubleVisionIntensity);
                CalcSinVal = Cos(SinVal);
                DoubleVisionEffectMaterialInstance.SetScalarParameterValue('DoubleVision1U', 0.0000000);
                DoubleVisionEffectMaterialInstance.SetScalarParameterValue('DoubleVision2U', 0.0000000);
                DoubleVisionEffectMaterialInstance.SetScalarParameterValue('DoubleVisionOffset', 1.0000000 / (1.0000000 + DoubleVisionIntensity));
            }
        }
        // End:0x519
        if(bDying == true)
        {
            DyingTimer += DeltaTime;
            GetInterpValueNoDie(DyingTimer, PostProcessSettings.Dying_Settings, InterpValue);
            CalcValuesLinearInterp(InterpValue, FromSettings, PostProcessSettings.Dying_Settings, ResultSettings);
        }
        // End:0x859
        if(bMeleeHit == true)
        {
            MeleeHitTimer += DeltaTime;
            bMeleeHit = GetInterpValueDies(MeleeHitTimer, PostProcessSettings.MeleeHit_FirstSettings, InterpValue, InterpState);
            // End:0x5A0
            if(bMeleeHit == true)
            {
                CalcValuesLinearInterp(InterpValue, FromSettings, PostProcessSettings.MeleeHit_FirstSettings, ResultSettings);
                DoubleVisionIntensity = InterpValue;                
            }
            else
            {
                bMeleeHit = GetInterpValueDies(MeleeHitTimer - ((PostProcessSettings.MeleeHit_FirstSettings.InterpInTime + PostProcessSettings.MeleeHit_FirstSettings.FlatTime) + PostProcessSettings.MeleeHit_FirstSettings.InterpOutTime), PostProcessSettings.MeleeHit_SecondSettings, InterpValue, InterpState);
                // End:0x661
                if(int(InterpState) == int(2))
                {
                    CalcValuesLinearInterp(InterpValue, IdentitySettings, PostProcessSettings.MeleeHit_SecondSettings, ResultSettings);
                    DoubleVisionIntensity = InterpValue;                    
                }
                else
                {
                    CalcValuesLinearInterp(InterpValue, PostProcessSettings.MeleeHit_FirstSettings, PostProcessSettings.MeleeHit_SecondSettings, ResultSettings);
                    DoubleVisionIntensity = 1.0000000;
                }
            }
            // End:0x859
            if(bMeleeHit == true)
            {
                DoubleVisionTimer += DeltaTime;
                // End:0x6EE
                if(int(InterpState) == int(2))
                {
                    DoubleVisionTimer += ((DeltaTime * (1.0000000 - DoubleVisionIntensity)) * PostProcessSettings.MeleeHit_DoubleVisionSpeedUp);
                }
                SinVal = DoubleVisionTimer * (2.0000000 * 3.1415930);
                DoubleVisionIntensity = DoubleVisionIntensity * (PostProcessSettings.MeleeHit_DoubleVisionExtreme + (Sin(SinVal * PostProcessSettings.MeleeHit_VarianceFrequency) * PostProcessSettings.MeleeHit_DoubleVisionVariance));
                DoubleVisionIntensity = Abs(DoubleVisionIntensity);
                SinVal = SinVal * PostProcessSettings.MeleeHit_Frequency;
                CalcSinVal = Sin(SinVal);
                DoubleVisionEffectMaterialInstance.SetScalarParameterValue('DoubleVision1V', CalcSinVal * DoubleVisionIntensity);
                DoubleVisionEffectMaterialInstance.SetScalarParameterValue('DoubleVision2V', (-1.0000000 * CalcSinVal) * DoubleVisionIntensity);
                CalcSinVal = Cos(SinVal);
                DoubleVisionEffectMaterialInstance.SetScalarParameterValue('DoubleVision1U', CalcSinVal * DoubleVisionIntensity);
                DoubleVisionEffectMaterialInstance.SetScalarParameterValue('DoubleVision2U', (-1.0000000 * CalcSinVal) * DoubleVisionIntensity);
                DoubleVisionEffectMaterialInstance.SetScalarParameterValue('DoubleVisionOffset', 1.0000000 / (1.0000000 + DoubleVisionIntensity));                
            }
        }
        // End:0x92B
        if(bSpotLight == true)
        {
            SpotLightTimer += DeltaTime;
            // End:0x8E2
            if(bStopSpotLight == true)
            {
                bSpotLight = GetInterpValueNoDie(SpotLightTimer, PostProcessSettings.SpotLight_Settings, InterpValue);
                InterpValue = 1.0000000 - InterpValue;
                CalcValuesLinearInterp(InterpValue, IdentitySettings, PostProcessSettings.SpotLight_Settings, ResultSettings);                
            }
            else
            {
                GetInterpValueNoDie(SpotLightTimer, PostProcessSettings.SpotLight_Settings, InterpValue);
                CalcValuesLinearInterp(InterpValue, FromSettings, PostProcessSettings.SpotLight_Settings, ResultSettings);
            }
        }
        // End:0x9D2
        if(bMedkit == true)
        {
            MedkitTimer += DeltaTime;
            bMedkit = GetInterpValueDies(MedkitTimer, PostProcessSettings.Medkit_Settings, InterpValue, InterpState);
            // End:0x9AB
            if(int(InterpState) == int(2))
            {
                CalcValuesLinearInterp(InterpValue, IdentitySettings, PostProcessSettings.Medkit_Settings, ResultSettings);                
            }
            else
            {
                CalcValuesLinearInterp(InterpValue, FromSettings, PostProcessSettings.Medkit_Settings, ResultSettings);
            }
        }
        // End:0xA79
        if(bItemPickup == true)
        {
            ItemPickupTimer += DeltaTime;
            bItemPickup = GetInterpValueDies(ItemPickupTimer, PostProcessSettings.ItemPickup_Settings, InterpValue, InterpState);
            // End:0xA52
            if(int(InterpState) == int(2))
            {
                CalcValuesLinearInterp(InterpValue, IdentitySettings, PostProcessSettings.ItemPickup_Settings, ResultSettings);                
            }
            else
            {
                CalcValuesLinearInterp(InterpValue, FromSettings, PostProcessSettings.ItemPickup_Settings, ResultSettings);
            }
        }
        // End:0xB20
        if(bBulletHit == true)
        {
            BulletHitTimer += DeltaTime;
            bBulletHit = GetInterpValueDies(BulletHitTimer, PostProcessSettings.BulletHit_Settings, InterpValue, InterpState);
            // End:0xAF9
            if(int(InterpState) == int(2))
            {
                CalcValuesLinearInterp(InterpValue, IdentitySettings, PostProcessSettings.BulletHit_Settings, ResultSettings);                
            }
            else
            {
                CalcValuesLinearInterp(InterpValue, FromSettings, PostProcessSettings.BulletHit_Settings, ResultSettings);
            }
        }
        PersistantSettings.Desaturation = ResultSettings.Desaturation;
        PersistantSettings.MidTones = ResultSettings.MidTones;
        PersistantSettings.HighLights = ResultSettings.HighLights;
        PersistantSettings.Shadows = ResultSettings.Shadows;
        // End:0xBBC
        if(bDoingCurve == true)
        {
            pWorldInfo.CurveBlendValue = InterpValue;
        }
        // End:0xCAA
        if(bLowHealth == true)
        {
            LowHealthTimer += DeltaTime;
            bLowHealth = GetInterpValueDies(LowHealthTimer, StoredLowHealthSettings, InterpValue, InterpState);
            J0xBF9:

            // End:0xC65 [Loop If]
            if(bLowHealth == false)
            {
                LowHealthTimer -= ((StoredLowHealthSettings.InterpInTime + StoredLowHealthSettings.FlatTime) + StoredLowHealthSettings.InterpOutTime);
                bLowHealth = GetInterpValueDies(LowHealthTimer, StoredLowHealthSettings, InterpValue, InterpState);
                // [Loop Continue]
                goto J0xBF9;
            }
            CalcValuesDifference(1.0000000, PersistantSettings, StoredLowHealthSettings, ResultSettings);
            CalcValuesDifference(InterpValue, ResultSettings, PostProcessSettings.LowHealth_HBSettings, ResultSettings);
        }
        pWorldInfo.GameModified_Scene_Desaturation = ResultSettings.Desaturation;
        pWorldInfo.GameModified_Scene_HighLights = ResultSettings.HighLights;
        pWorldInfo.GameModified_Scene_MidTones = ResultSettings.MidTones;
        pWorldInfo.GameModified_Scene_Shadows = ResultSettings.Shadows;
        // End:0xDBD
        if(ColorCorrectionRunning == true)
        {
            // End:0xDB5
            if(((((((((bExplosion == true) || bMeleeHit == true) || bSpotLight == true) || bLowHealth == true) || bDying == true) || bMedkit == true) || bBulletHit == true) || bItemPickup == true) || bGeneric == true)
            {
                ColorCorrectionRunning = true;                
            }
            else
            {
                ColorCorrectionRunning = false;
            }
        }
        // End:0xE07
        if(DoubleVisionEffect != none)
        {
            // End:0xDF6
            if((bMeleeHit == true) || bExplosion == true)
            {
                DoubleVisionEffect.bShowInGame = true;                
            }
            else
            {
                DoubleVisionEffect.bShowInGame = false;
            }
        }
        // End:0xE78
        if((((((((bExplosion == true) || bMeleeHit == true) || bSpotLight == true) || bDying == true) || bMedkit == true) || bBulletHit == true) || bItemPickup == true) || bGeneric == true)
        {            
        }
        else
        {
            TurnOffCurve();
        }
    }
    // End:0x1005
    if(bUsingBlackCurve == true)
    {
        pWorldInfo.CurveTextureSecondary = BlackTexture;
        // End:0xF59
        if(bDoingFadeIn == true)
        {
            FadeTimer += DeltaTime;
            // End:0xEE0
            if(FadeTimer < FadeDelay)
            {
                pWorldInfo.CurveBlendValue = 1.0000000;                
            }
            else
            {
                // End:0xF2D
                if(FadeTimer > (FadeDelay + FadeTime))
                {
                    bUsingBlackCurve = false;
                    bDoingFadeIn = false;
                    pWorldInfo.CurveTextureSecondary = none;
                    pWorldInfo.CurveBlendValue = 0.0000000;                    
                }
                else
                {
                    pWorldInfo.CurveBlendValue = 1.0000000 - ((FadeTimer - FadeDelay) / FadeTime);
                }
            }            
        }
        else
        {
            // End:0xFF1
            if(bDoingFadeOut == true)
            {
                FadeTimer += DeltaTime;
                // End:0xF97
                if(FadeTimer < FadeDelay)
                {
                    pWorldInfo.CurveBlendValue = 0.0000000;                    
                }
                else
                {
                    // End:0xFCC
                    if(FadeTimer > (FadeDelay + FadeTime))
                    {
                        bDoingFadeOut = false;
                        pWorldInfo.CurveBlendValue = 1.0000000;                        
                    }
                    else
                    {
                        pWorldInfo.CurveBlendValue = (FadeTimer - FadeDelay) / FadeTime;
                    }
                }                
            }
            else
            {
                pWorldInfo.CurveBlendValue = 1.0000000;
            }
        }
    }
    //return;    
}

event DebugExplosion(bool bDebug, float Value)
{
    // End:0x1B
    if(bDebug == true)
    {
        startExplosion(Value);
    }
    //return;    
}

event DebugMeleeHit(bool bDebug)
{
    // End:0x16
    if(bDebug == true)
    {
        startMeleeHit();
    }
    //return;    
}

event DebugSpotLight(bool bDebug)
{
    // End:0x28
    if((bSpotLight == true) && bDebug == false)
    {
        stopSpotLight();        
    }
    else
    {
        // End:0x3F
        if(bDebug == true)
        {
            startSpotLight();
        }
    }
    //return;    
}

event DebugLowHealth(bool bDebug, int Value)
{
    // End:0x1F
    if(bDebug == true)
    {
        UpdateHealth(Value);        
    }
    else
    {
        bLowHealth = false;
    }
    //return;    
}

event DebugDying(bool bDebug)
{
    // End:0x19
    if(bDebug == true)
    {
        startDying();        
    }
    else
    {
        bDying = false;
    }
    //return;    
}

event DebugMedkit(bool bDebug)
{
    // End:0x16
    if(bDebug == true)
    {
        startMedkit();
    }
    //return;    
}

event DebugItemPickup(bool bDebug)
{
    // End:0x16
    if(bDebug == true)
    {
        startItemPickup();
    }
    //return;    
}

event DebugBulletHit(bool bDebug)
{
    // End:0x16
    if(bDebug == true)
    {
        startBulletHit();
    }
    //return;    
}

event DebugGeneric(bool bDebug)
{
    local MOHAPostProcessSettings inSettings;

    // End:0xC7
    if(bDebug == true)
    {
        inSettings.FlatTime = 0.5000000;
        inSettings.InterpInTime = 0.2500000;
        inSettings.InterpOutTime = 0.2500000;
        inSettings.HighLights = vect(1.0000000, 1.0000000, 1.0000000);
        inSettings.MidTones = vect(1.0000000, 1.0000000, 1.0000000);
        inSettings.Shadows = vect(0.1000000, -0.1000000, 0.0000000);
        inSettings.Desaturation = 0.2500000;
        startGeneric(inSettings, 0);
    }
    //return;    
}

event SetDebugState()
{
    // End:0x2E
    if((bMeleeHit == true) || bExplosion == true)
    {
        DoubleVisionEffect.bShowInEditor = true;        
    }
    else
    {
        DoubleVisionEffect.bShowInEditor = false;
    }
    //return;    
}

defaultproperties
{
    PostProcessSettings=MOHAPostProcessSettingsAsset'PostProcessMaterialPackage.DefaultMOHAPostProcessSettings'
    StoredExplosionSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    StoredLowHealthSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    StoredGenericSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    PersistantSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    FromSettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    IdentitySettings=(HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Desaturation=0.0000000,InterpInTime=0.2500000,FlatTime=0.5000000,InterpOutTime=0.2500000)
    BlackTexture=Texture2D'EngineCurveTextures.Black'
}