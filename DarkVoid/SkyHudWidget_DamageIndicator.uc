class SkyHudWidget_DamageIndicator extends SkyUI_HudWidget
    native
    config(UI);

struct native SkyDamageInfo
{
    var float FadeTime;
    var float FadeValue;
    var MaterialInstanceConstant MatConstant;

    structdefaultproperties
    {
        FadeTime=0.0000000
        FadeValue=0.0000000
        MatConstant=none
    }
};

var int MaxNoOfIndicators;
var array<SkyDamageInfo> DamageData;
var(Widget) Material BaseMaterial;
var(Widget) float FadeTime;
var(Widget) name PositionalParamName;
var(Widget) name FadeParamName;
var bool bEnableHitEffect;
var bool bFadeOutHitEffect;
var float MaxHitEffectIntensity;
var LinearColor MaxHitEffectColor;
var float HitEffectFadeTime;
var MaterialEffect HitEffect;
var transient MaterialInstanceConstant HitEffectMaterialInstance;

event Initialized()
{
    local int I;

    super(UIScreenObject).Initialized();
    DamageData.Length = MaxNoOfIndicators;
    I = 0;
    J0x19:

    // End:0xE2 [Loop If]
    if(I < MaxNoOfIndicators)
    {
        DamageData[I].FadeTime = 0.0000000;
        DamageData[I].FadeValue = 0.0000000;
        DamageData[I].MatConstant = new (Outer) Class'Engine.MaterialInstanceConstant';
        // End:0xD8
        if((DamageData[I].MatConstant != none) && BaseMaterial != none)
        {
            DamageData[I].MatConstant.SetParent(BaseMaterial);
        }
        I++;
        // [Loop Continue]
        goto J0x19;
    }
    HitEffect = MaterialEffect(GetPlayerOwner().PlayerPostProcess.FindPostProcessEffect('HitEffect'));
    // End:0x177
    if(HitEffect != none)
    {
        HitEffect.bShowInGame = false;
        HitEffectMaterialInstance = new (none) Class'Engine.MaterialInstanceConstant';
        HitEffectMaterialInstance.SetParent(HitEffect.Material);
        HitEffect.Material = HitEffectMaterialInstance;
    }
    //return;    
}

event WidgetTick(float DeltaTime)
{
    local int I;
    local float HitAmount;
    local LinearColor HitColor;

    super.WidgetTick(DeltaTime);
    I = 0;
    J0x12:

    // End:0xF8 [Loop If]
    if(I < MaxNoOfIndicators)
    {
        // End:0xEE
        if(DamageData[I].FadeTime > float(0))
        {
            DamageData[I].FadeValue += ((float(0) - DamageData[I].FadeValue) * (DeltaTime / DamageData[I].FadeTime));
            DamageData[I].FadeTime -= DeltaTime;
            DamageData[I].MatConstant.SetScalarParameterValue(FadeParamName, DamageData[I].FadeValue);
        }
        I++;
        // [Loop Continue]
        goto J0x12;
    }
    // End:0x1EC
    if(bFadeOutHitEffect)
    {
        HitEffectMaterialInstance.GetScalarParameterValue('HitAmount', HitAmount);
        HitAmount -= ((MaxHitEffectIntensity * DeltaTime) / HitEffectFadeTime);
        // End:0x169
        if(HitAmount <= 0.0000000)
        {
            HitEffect.bShowInGame = false;
            bFadeOutHitEffect = false;            
        }
        else
        {
            HitEffectMaterialInstance.SetScalarParameterValue('HitAmount', HitAmount);
            HitEffectMaterialInstance.GetVectorParameterValue('HitColor', HitColor);
            HitEffectMaterialInstance.SetVectorParameterValue('HitColor', Subtract_LinearColorLinearColor(HitColor, Multiply_LinearColorFloat(MaxHitEffectColor, DeltaTime / HitEffectFadeTime)));
        }
    }
    //return;    
}

function TrackDamage(Vector HitDir, int Damage, class<DamageType> DamageType, optional Pawn InstigatedBy)
{
    local Vector Loc;
    local Rotator Rot;
    local float DirOfHit_L;
    local Vector AxisX, AxisY, AxisZ, ShotDirection;
    local bool bIsInFront;
    local Vector2D AngularDist;
    local Pawn P;
    local float PositionInQuadrant, QuadrantStart, Multiplier;

    P = SkyHudSceneOwner.GetPawnOwner();
    // End:0x2FB
    if((P != none) && P.Controller != none)
    {
        P.Controller.GetPlayerViewPoint(Loc, Rot);
        // End:0xBB
        if(InstigatedBy != none)
        {
            P.GetAxes(Rot, AxisX, AxisY, AxisZ);
            ShotDirection = Normal(InstigatedBy.Location - P.Location);            
        }
        else
        {
            P.GetAxes(P.Rotation, AxisX, AxisY, AxisZ);
            ShotDirection = Normal(HitDir - P.Location);
        }
        bIsInFront = GetAngularDistance(AngularDist, ShotDirection, AxisX, AxisY, AxisZ);
        GetAngularDegreesFromRadians(AngularDist);
        Multiplier = 0.2600000 / 90.0000000;
        PositionInQuadrant = Abs(AngularDist.X) * Multiplier;
        // End:0x1C9
        if(bIsInFront == true)
        {
            // End:0x1A9
            if(AngularDist.X > float(0))
            {
                QuadrantStart = 0.0000000;
                DirOfHit_L = QuadrantStart + PositionInQuadrant;                
            }
            else
            {
                QuadrantStart = 0.0000000;
                DirOfHit_L = QuadrantStart - PositionInQuadrant;
            }            
        }
        else
        {
            // End:0x201
            if(AngularDist.X > float(0))
            {
                QuadrantStart = 0.5200000;
                DirOfHit_L = QuadrantStart - PositionInQuadrant;                
            }
            else
            {
                QuadrantStart = 0.5200000;
                DirOfHit_L = QuadrantStart + PositionInQuadrant;
            }
        }
        DirOfHit_L = -1.0000000 * DirOfHit_L;
        FlashDamage(DirOfHit_L);
        // End:0x25E
        if(P.InGodMode())
        {
            Damage = 50;
        }
        // End:0x2FB
        if((Damage > 0) && HitEffect != none)
        {
            HitEffectFadeTime = (default.HitEffectFadeTime * FClamp(float(Damage), 10.0000000, 50.0000000)) / 50.0000000;
            HitEffectMaterialInstance.SetScalarParameterValue('HitAmount', MaxHitEffectIntensity);
            HitEffectMaterialInstance.SetVectorParameterValue('HitColor', MaxHitEffectColor);
            HitEffect.bShowInGame = true;
            bFadeOutHitEffect = true;
        }
    }
    //return;    
}

function FlashDamage(float FlashPosition)
{
    local int I, minindex;
    local float Min;

    Min = 1.0000000;
    I = 0;
    J0x12:

    // End:0x12D [Loop If]
    if(I < MaxNoOfIndicators)
    {
        // End:0xDC
        if(DamageData[I].FadeValue <= 0.0000000)
        {
            DamageData[I].FadeValue = 1.0000000;
            DamageData[I].FadeTime = FadeTime;
            DamageData[I].MatConstant.SetScalarParameterValue(PositionalParamName, FlashPosition);
            DamageData[I].MatConstant.SetScalarParameterValue(FadeParamName, 1.0000000);
            return;
            // [Explicit Continue]
            goto J0x123;
        }
        // End:0x123
        if(DamageData[I].FadeValue < Min)
        {
            minindex = I;
            Min = DamageData[I].FadeValue;
        }
        J0x123:

        I++;
        // [Loop Continue]
        goto J0x12;
    }
    DamageData[minindex].FadeValue = 1.0000000;
    DamageData[minindex].FadeTime = FadeTime;
    DamageData[minindex].MatConstant.SetScalarParameterValue(PositionalParamName, FlashPosition);
    DamageData[minindex].MatConstant.SetScalarParameterValue(FadeParamName, 1.0000000);
    //return;    
}
