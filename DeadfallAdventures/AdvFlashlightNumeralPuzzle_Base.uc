class AdvFlashlightNumeralPuzzle_Base extends DynamicSMActor
    abstract
    hidecategories(Navigation);

enum Preset
{
    Blue_Lightblue,                 // 0
    Red_Yellow,                     // 1
    Preset_MAX                      // 2
};

enum NumeralPuzzleNumber
{
    One,                            // 0
    Two,                            // 1
    Three,                          // 2
    four,                           // 3
    five,                           // 4
    six,                            // 5
    seven,                          // 6
    Eight,                          // 7
    Nine,                           // 8
    ten,                            // 9
    eleven,                         // 10
    twelve,                         // 11
    thirteen,                       // 12
    fourteen,                       // 13
    fifteen,                        // 14
    sixteen,                        // 15
    seventeen,                      // 16
    eighteen,                       // 17
    nineteen,                       // 18
    twenty,                         // 19
    NumeralPuzzleNumber_MAX         // 20
};

var() float LightTimeout;
var() AdvFlashlightNumeralPuzzle_Base.NumeralPuzzleNumber CorrectPuzzleNumber;
var() AdvFlashlightNumeralPuzzle_Base.Preset CurrentPreset;
var int CorrectNumber;
var() float LightPowerThreshold;
var() float LightGainer;
var() float LightWaster;
var() float EndingGlowSpeeder;
var() float LightThresholdInnerDividor;
var() float LightThresholdOuterDividor;
var() float DelayerThreshold;
var Trigger PlayerDetector;
var() float DelayForMinis;
var int GlowablePointsLength;
var int GlowableBarsLength;
var AdvFlashlight_GlowablePoint_base GlowablePoints[16];
var AdvFlashlight_GlowableBar_base GlowableBars[4];
var() AdvFlashlight_GlowablePoint_base Row1[4];
var array<AdvFlashlight_GlowableMini_base> MiniRow1;
var() AdvFlashlight_GlowablePoint_base Row2[4];
var array<AdvFlashlight_GlowableMini_base> MiniRow2;
var() AdvFlashlight_GlowablePoint_base Row3[4];
var array<AdvFlashlight_GlowableMini_base> MiniRow3;
var() AdvFlashlight_GlowablePoint_base Row4[4];
var array<AdvFlashlight_GlowableMini_base> MiniRow4;
var() AdvFlashlight_GlowableBar_base End_rows[4];
var bool bSymbolMadeCorrectly;
var bool bIsPuzzleActive;
var bool bCallingForEvent;
var float CheckEndTime;
var float CheckEndTimeThreshold;
var Rotator PreviousRotation;
var Vector PreviousLocation;
var() SoundCue AlightSoundComponent;
var int BarsWereLit[4];
var int PointsWereLit[4];
var int PointsToLit[4];
var AdvPlayerPawn playerDetected;
var AdvPlayerPawn playerReference;
var AdvPlayerController currentPlayerController;
var AdvWeap_Base PreviousWeapon;

function SetPreset(MaterialInstanceConstant ParentMaterial)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0xDF [Loop If]
    if(I < GlowablePointsLength)
    {
        GlowablePoints[I].HighlightingMaterial = GlowablePoints[I].StaticMeshComponent.CreateAndSetMaterialInstanceConstant(0);
        GlowablePoints[I].HighlightingMaterial.SetParent(ParentMaterial);
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0xEA:

    // End:0x1BE [Loop If]
    if(I < GlowableBarsLength)
    {
        GlowableBars[I].HighlightingMaterial = GlowableBars[I].StaticMeshComponent.CreateAndSetMaterialInstanceConstant(0);
        GlowableBars[I].HighlightingMaterial.SetParent(ParentMaterial);
        ++I;
        // [Loop Continue]
        goto J0xEA;
    }
    SetPresetMini(ParentMaterial, MiniRow1);
    SetPresetMini(ParentMaterial, MiniRow2);
    SetPresetMini(ParentMaterial, MiniRow3);
    SetPresetMini(ParentMaterial, MiniRow4);
    //return;    
}

function SetPresetMini(MaterialInstanceConstant ParentMaterial, array<AdvFlashlight_GlowableMini_base> miniRow)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0xE0 [Loop If]
    if(I < miniRow.Length)
    {
        miniRow[I].HighlightingMaterial = miniRow[I].StaticMeshComponent.CreateAndSetMaterialInstanceConstant(0);
        miniRow[I].HighlightingMaterial.SetParent(ParentMaterial);
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function InitializePreset()
{
    switch(CurrentPreset)
    {
        // End:0x2E
        case 0:
            SetPreset(MaterialInstanceConstant'adv_en_mini_Crystal_01.Materials.mi_en_puzzlehighlight_01');
            // End:0x4C
            break;
        // End:0x49
        case 1:
            SetPreset(MaterialInstanceConstant'adv_en_mini_Crystal_01.Materials.mi_en_puzzlehighlight_02');
            // End:0x4C
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function InitializeNumber()
{
    CorrectNumber = int(CorrectPuzzleNumber) + int(1);
    // End:0x5B
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
    {
        // End:0x5B
        if(CorrectNumber == 8)
        {
            CorrectNumber = 6;
        }
    }
    // End:0x7B
    if(LightTimeout < float(0))
    {
        LightTimeout = 0.0000000;
    }
    //return;    
}

function RelocateGlowableElements()
{
    local int I;
    local Vector tmpPos;

    PreviousRotation = self.Rotation;
    PreviousLocation = self.Location;
    I = 0;
    J0x4B:

    // End:0x14B [Loop If]
    if(I < GlowablePointsLength)
    {
        tmpPos = self.TransformVectorByRotation(self.Rotation, GlowablePoints[I].Location);
        GlowablePoints[I].SetRotation(self.Rotation);
        GlowablePoints[I].SetLocation(self.Location + tmpPos);
        ++I;
        // [Loop Continue]
        goto J0x4B;
    }
    I = 0;
    J0x156:

    // End:0x256 [Loop If]
    if(I < GlowableBarsLength)
    {
        tmpPos = self.TransformVectorByRotation(self.Rotation, GlowableBars[I].Location);
        GlowableBars[I].SetRotation(self.Rotation);
        GlowableBars[I].SetLocation(self.Location + tmpPos);
        ++I;
        // [Loop Continue]
        goto J0x156;
    }
    //return;    
}

simulated function PostBeginPlay()
{
    CheckEndTime = 0.0000000;
    CheckEndTimeThreshold = 0.1000000;
    InitializeNumber();
    super.PostBeginPlay();
    //return;    
}

function TurnOffAll()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x6D [Loop If]
    if(I < GlowableBarsLength)
    {
        GlowableBars[I].TurnOff();
        ChangeMiniRow(I, false);
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x78:

    // End:0xC6 [Loop If]
    if(I < GlowablePointsLength)
    {
        GlowablePoints[I].TurnOff();
        ++I;
        // [Loop Continue]
        goto J0x78;
    }
    //return;    
}

function TurnOnCorrectOnly()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x10B [Loop If]
    if(I < GlowablePointsLength)
    {
        // End:0xA8
        if(GlowablePoints[I].bShouldBeLit)
        {
            // End:0xA5
            if(!GlowablePoints[I].bIsLit)
            {
                GlowablePoints[I].TurnOn();
            }            
        }
        else
        {
            // End:0xFD
            if(GlowablePoints[I].bIsLit)
            {
                GlowablePoints[I].TurnOff();
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x116:

    // End:0x216 [Loop If]
    if(I < GlowableBarsLength)
    {
        // End:0x1B3
        if(GlowableBars[I].bShouldBeLit)
        {
            // End:0x1B0
            if(!GlowableBars[I].bIsLit)
            {
                GlowableBars[I].TurnOn();
            }            
        }
        else
        {
            // End:0x208
            if(GlowableBars[I].bIsLit)
            {
                GlowableBars[I].TurnOff();
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x116;
    }
    //return;    
}

function CheckBarsForBeams()
{
    local int I, J;

    I = 0;
    J0x0B:

    // End:0x268 [Loop If]
    if(I < GlowableBarsLength)
    {
        // End:0x154
        if(GlowableBars[I].bIsLit)
        {
            J = I * 4;
            J0x65:

            // End:0x13D [Loop If]
            if(J < ((I * 4) + 4))
            {
                // End:0x106
                if(!GlowablePoints[J].bIsLit)
                {
                    GlowablePoints[J].bIsLit = true;
                    GlowablePoints[J].TurnOn();
                }
                GlowablePoints[J].ActivateBeams();
                ++J;
                // [Loop Continue]
                goto J0x65;
            }
            ChangeMiniRow(I, true);            
        }
        else
        {
            J = I * 4;
            J0x16B:

            // End:0x246 [Loop If]
            if(J < ((I * 4) + 4))
            {
                // End:0x238
                if(GlowablePoints[J].bIsLit && GlowablePoints[J].bIsBeamEmitterActive)
                {
                    GlowablePoints[J].bIsLit = false;
                    GlowablePoints[J].TurnOff();
                }
                ++J;
                // [Loop Continue]
                goto J0x16B;
            }
            ChangeMiniRow(I, false);
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function ChangeMiniRow(int Row, bool Activate)
{
    local int I;

    switch(Row)
    {
        // End:0x1ED
        case 0:
            I = 0;
            J0x22:

            // End:0x1EA [Loop If]
            if(I < MiniRow1.Length)
            {
                // End:0x12A
                if(Activate)
                {
                    // End:0xF1
                    if(!MiniRow1[I].bLoopedSetLightAffection)
                    {
                        MiniRow1[I].SetTimer(float((I * I) + 1) * DelayForMinis, false, 'LoopedSetLightAffectionFromFlashLight_T');
                        MiniRow1[I].bLoopedSetLightAffection = true;
                    }
                    // End:0x127
                    if(bSymbolMadeCorrectly)
                    {
                        MiniRow1[I].TurnOn();
                    }                    
                }
                else
                {
                    // End:0x1DC
                    if(MiniRow1[I].bIsLit)
                    {
                        MiniRow1[I].SetTimer(0.0000000, false, 'SetLightAffectionFromFlashLight_T');
                        MiniRow1[I].bLoopedSetLightAffection = false;
                        MiniRow1[I].TurnOff();
                    }
                }
                ++I;
                // [Loop Continue]
                goto J0x22;
            }
            // End:0x780
            break;
        // End:0x3C7
        case 1:
            I = 0;
            J0x1FC:

            // End:0x3C4 [Loop If]
            if(I < MiniRow2.Length)
            {
                // End:0x304
                if(Activate)
                {
                    // End:0x2CB
                    if(!MiniRow2[I].bLoopedSetLightAffection)
                    {
                        MiniRow2[I].SetTimer(float((I * I) + 1) * DelayForMinis, false, 'LoopedSetLightAffectionFromFlashLight_T');
                        MiniRow2[I].bLoopedSetLightAffection = true;
                    }
                    // End:0x301
                    if(bSymbolMadeCorrectly)
                    {
                        MiniRow2[I].TurnOn();
                    }                    
                }
                else
                {
                    // End:0x3B6
                    if(MiniRow2[I].bIsLit)
                    {
                        MiniRow2[I].SetTimer(0.0000000, false, 'SetLightAffectionFromFlashLight_T');
                        MiniRow2[I].bLoopedSetLightAffection = false;
                        MiniRow2[I].TurnOff();
                    }
                }
                ++I;
                // [Loop Continue]
                goto J0x1FC;
            }
            // End:0x780
            break;
        // End:0x5A2
        case 2:
            I = 0;
            J0x3D7:

            // End:0x59F [Loop If]
            if(I < MiniRow3.Length)
            {
                // End:0x4DF
                if(Activate)
                {
                    // End:0x4A6
                    if(!MiniRow3[I].bLoopedSetLightAffection)
                    {
                        MiniRow3[I].SetTimer(float((I * I) + 1) * DelayForMinis, false, 'LoopedSetLightAffectionFromFlashLight_T');
                        MiniRow3[I].bLoopedSetLightAffection = true;
                    }
                    // End:0x4DC
                    if(bSymbolMadeCorrectly)
                    {
                        MiniRow3[I].TurnOn();
                    }                    
                }
                else
                {
                    // End:0x591
                    if(MiniRow3[I].bIsLit)
                    {
                        MiniRow3[I].SetTimer(0.0000000, false, 'SetLightAffectionFromFlashLight_T');
                        MiniRow3[I].bLoopedSetLightAffection = false;
                        MiniRow3[I].TurnOff();
                    }
                }
                ++I;
                // [Loop Continue]
                goto J0x3D7;
            }
            // End:0x780
            break;
        // End:0x77D
        case 3:
            I = 0;
            J0x5B2:

            // End:0x77A [Loop If]
            if(I < MiniRow4.Length)
            {
                // End:0x6BA
                if(Activate)
                {
                    // End:0x681
                    if(!MiniRow4[I].bLoopedSetLightAffection)
                    {
                        MiniRow4[I].SetTimer(float((I * I) + 1) * DelayForMinis, false, 'LoopedSetLightAffectionFromFlashLight_T');
                        MiniRow4[I].bLoopedSetLightAffection = true;
                    }
                    // End:0x6B7
                    if(bSymbolMadeCorrectly)
                    {
                        MiniRow4[I].TurnOn();
                    }                    
                }
                else
                {
                    // End:0x76C
                    if(MiniRow4[I].bIsLit)
                    {
                        MiniRow4[I].SetTimer(0.0000000, false, 'SetLightAffectionFromFlashLight_T');
                        MiniRow4[I].bLoopedSetLightAffection = false;
                        MiniRow4[I].TurnOff();
                    }
                }
                ++I;
                // [Loop Continue]
                goto J0x5B2;
            }
            // End:0x780
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function EndingAnimationMini(array<AdvFlashlight_GlowableMini_base> miniRow, bool bPuzActive, bool bEndAnim, bool bFullEndAnim)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x19F [Loop If]
    if(I < miniRow.Length)
    {
        // End:0x65
        if(bPuzActive)
        {
            miniRow[I].LightTimeout = LightTimeout;            
        }
        else
        {
            miniRow[I].FlashlightBeamElsewhere_T();
            miniRow[I].ClearAllTimers();
            miniRow[I].LightTimeout = 0.0000000;
        }
        // End:0x129
        if(!bFullEndAnim)
        {
            miniRow[I].bIsPuzzleActive = bPuzActive;
        }
        miniRow[I].bEndingAnimationActive = bEndAnim;
        miniRow[I].bFullEndingAnimation = bFullEndAnim;
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function bool CheckForSymbol()
{
    local bool Result;
    local int lastRowPointsToLit, barsToLit, I, J, Counter;

    Result = false;
    barsToLit = CorrectNumber / 5;
    lastRowPointsToLit = CorrectNumber % 5;
    Counter = 0;
    I = 0;
    J0x50:

    // End:0xC9 [Loop If]
    if(I < GlowableBarsLength)
    {
        // End:0xBB
        if(GlowableBars[I].bIsLit)
        {
            BarsWereLit[Counter] = I;
            ++Counter;
        }
        ++I;
        // [Loop Continue]
        goto J0x50;
    }
    // End:0xE2
    if(Counter != barsToLit)
    {
        return false;
    }
    I = 0;
    J0xED:

    // End:0x28F [Loop If]
    if(I < GlowableBarsLength)
    {
        // End:0x281
        if(!GlowableBars[I].bIsLit)
        {
            Counter = 0;
            J = I * 4;
            J0x154:

            // End:0x1D5 [Loop If]
            if(J < ((I * 4) + 4))
            {
                // End:0x1C7
                if(GlowablePoints[J].bIsLit)
                {
                    PointsWereLit[Counter] = J;
                    ++Counter;
                }
                ++J;
                // [Loop Continue]
                goto J0x154;
            }
            // End:0x1FF
            if((Counter != lastRowPointsToLit) && Counter != 0)
            {
                return false;
            }
            // End:0x281
            if(Counter == lastRowPointsToLit)
            {
                // End:0x225
                if(Result)
                {
                    return false;
                }
                Result = true;
                J = 0;
                J0x23C:

                // End:0x281 [Loop If]
                if(J < 4)
                {
                    PointsToLit[J] = PointsWereLit[J];
                    ++J;
                    // [Loop Continue]
                    goto J0x23C;
                }
            }
        }
        ++I;
        // [Loop Continue]
        goto J0xED;
    }
    // End:0x484
    if(Result)
    {
        I = 0;
        J0x2A7:

        // End:0x2F7 [Loop If]
        if(I < GlowableBarsLength)
        {
            GlowableBars[I].bShouldBeLit = false;
            ++I;
            // [Loop Continue]
            goto J0x2A7;
        }
        I = 0;
        J0x302:

        // End:0x35C [Loop If]
        if(I < GlowableBarsLength)
        {
            GlowableBars[BarsWereLit[I]].bShouldBeLit = true;
            ++I;
            // [Loop Continue]
            goto J0x302;
        }
        I = 0;
        J0x367:

        // End:0x41F [Loop If]
        if(I < GlowablePointsLength)
        {
            // End:0x3E6
            if(GlowableBars[BarsWereLit[I / 5]].bShouldBeLit)
            {
                GlowablePoints[I].bShouldBeLit = true;                
            }
            else
            {
                GlowablePoints[I].bShouldBeLit = false;
            }
            ++I;
            // [Loop Continue]
            goto J0x367;
        }
        I = 0;
        J0x42A:

        // End:0x484 [Loop If]
        if(I < lastRowPointsToLit)
        {
            GlowablePoints[PointsToLit[I]].bShouldBeLit = true;
            ++I;
            // [Loop Continue]
            goto J0x42A;
        }
    }
    return Result;
    //return ReturnValue;    
}

function CheckEndPuzzle()
{
    local int I;

    bSymbolMadeCorrectly = CheckForSymbol();
    I = 0;
    J0x20:

    // End:0x146 [Loop If]
    if(I < GlowablePointsLength)
    {
        // End:0xD5
        if(GlowablePoints[I].bIsPuzzleActive != bIsPuzzleActive)
        {
            GlowablePoints[I].bIsPuzzleActive = bIsPuzzleActive;
            GlowablePoints[I].LightTimeout = LightTimeout;
        }
        // End:0x138
        if(GlowablePoints[I].bCallsForEndcheck)
        {
            bCallingForEvent = true;
            GlowablePoints[I].bCallsForEndcheck = false;
        }
        ++I;
        // [Loop Continue]
        goto J0x20;
    }
    I = 0;
    J0x151:

    // End:0x277 [Loop If]
    if(I < GlowableBarsLength)
    {
        // End:0x206
        if(GlowableBars[I].bIsPuzzleActive != bIsPuzzleActive)
        {
            GlowableBars[I].bIsPuzzleActive = bIsPuzzleActive;
            GlowableBars[I].LightTimeout = LightTimeout;
        }
        // End:0x269
        if(GlowableBars[I].bCallsForEndcheck)
        {
            bCallingForEvent = true;
            GlowableBars[I].bCallsForEndcheck = false;
        }
        ++I;
        // [Loop Continue]
        goto J0x151;
    }
    // End:0x585
    if(bSymbolMadeCorrectly)
    {
        bIsPuzzleActive = false;
        I = 0;
        J0x29B:

        // End:0x3CB [Loop If]
        if(I < GlowablePointsLength)
        {
            GlowablePoints[I].ClearAllTimers();
            GlowablePoints[I].LightTimeout = 0.0000000;
            GlowablePoints[I].bIsPuzzleActive = bIsPuzzleActive;
            GlowablePoints[I].bEndingAnimationActive = true;
            GlowablePoints[I].bFullEndingAnimation = false;
            GlowablePoints[I].FlashlightBeamElsewhere_T();
            ++I;
            // [Loop Continue]
            goto J0x29B;
        }
        I = 0;
        J0x3D6:

        // End:0x506 [Loop If]
        if(I < GlowableBarsLength)
        {
            GlowableBars[I].ClearAllTimers();
            GlowableBars[I].LightTimeout = 0.0000000;
            GlowableBars[I].bIsPuzzleActive = bIsPuzzleActive;
            GlowableBars[I].bEndingAnimationActive = true;
            GlowableBars[I].bFullEndingAnimation = false;
            GlowableBars[I].FlashlightBeamElsewhere_T();
            ++I;
            // [Loop Continue]
            goto J0x3D6;
        }
        EndingAnimationMini(MiniRow1, bIsPuzzleActive, true, false);
        EndingAnimationMini(MiniRow2, bIsPuzzleActive, true, false);
        EndingAnimationMini(MiniRow3, bIsPuzzleActive, true, false);
        EndingAnimationMini(MiniRow4, bIsPuzzleActive, true, false);        
    }
    else
    {
        EndingAnimationMini(MiniRow1, bIsPuzzleActive, false, false);
        EndingAnimationMini(MiniRow2, bIsPuzzleActive, false, false);
        EndingAnimationMini(MiniRow3, bIsPuzzleActive, false, false);
        EndingAnimationMini(MiniRow4, bIsPuzzleActive, false, false);
        // End:0x624
        if(bCallingForEvent)
        {
            bCallingForEvent = false;
            WaitEnding();
        }
    }
    //return;    
}

function ForceFlashlightOnPlayer()
{
    // End:0xF8
    if((playerReference != none) && currentPlayerController != none)
    {
        PreviousWeapon = AdvWeap_Base(playerReference.Weapon);
        AdvInventoryManager(playerReference.InvManager).SwitchWeapon(1);
        // End:0xF8
        if(playerReference.WeaponLeft != none)
        {
            playerReference.QuickHideCurrentWeapon();
            currentPlayerController.ToggleQuickMenu(1);
        }
    }
    //return;    
}

function ReturnWeaponToLastFoundPlayer()
{
    // End:0x42
    if((playerReference != none) && currentPlayerController != none)
    {
        currentPlayerController.ToggleQuickMenu(5);
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x134
    if(!bSymbolMadeCorrectly)
    {
        // End:0xD2
        if(PlayerDetector != none)
        {
            // End:0xD1
            foreach PlayerDetector.TouchingActors(Class'AdvPlayerPawn', playerDetected)
            {
                playerReference = playerDetected;
                currentPlayerController = AdvPlayerController(playerReference.Controller);
                // End:0xD0
                if(!playerReference.bQuickHidenWeapon)
                {
                    ForceFlashlightOnPlayer();
                }                
            }            
        }
        CheckEndTime += DeltaTime;
        // End:0x131
        if(CheckEndTime > CheckEndTimeThreshold)
        {
            // End:0x131
            if(GlowablePoints[0] != none)
            {
                CheckBarsForBeams();
                CheckEndPuzzle();
                CheckEndTime = 0.0000000;
            }
        }        
    }
    else
    {
        // End:0x192
        if(!GlowablePoints[GlowablePointsLength - 1].bEndingAnimationActive)
        {
            // End:0x188
            if(bCallingForEvent)
            {
                bCallingForEvent = false;
                WaitEnding();
            }
            CheckBarsForBeams();
        }
        // End:0x20F
        if(PlayerDetector != none)
        {
            // End:0x20E
            foreach PlayerDetector.TouchingActors(Class'AdvPlayerPawn', playerDetected)
            {
                playerReference = playerDetected;
                // End:0x20D
                if(playerReference.bQuickHidenWeapon)
                {
                    ReturnWeaponToLastFoundPlayer();
                }                
            }            
        }
    }
    //return;    
}

function WaitEnding()
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_Activated FireEvent;
    local array<int> ActivateIndices;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0x119
    if(GameSeq != none)
    {
        // End:0x55
        if(bSymbolMadeCorrectly)
        {
            ActivateIndices[0] = 0;            
        }
        else
        {
            ActivateIndices[0] = 1;
        }
        GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_Activated', true, ExecutionEvents);
        // End:0x118
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_Activated(ExecutionEvent);
            // End:0x117
            if(FireEvent.Originator == self)
            {
                FireEvent.CheckActivate(self, none, false, ActivateIndices);
            }            
        }        
    }
    //return;    
}

defaultproperties
{
    LightTimeout=5.0000000
    LightPowerThreshold=6.0000000
    LightGainer=4.0000000
    LightWaster=4.0000000
    EndingGlowSpeeder=12.0000000
    LightThresholdInnerDividor=2.0000000
    LightThresholdOuterDividor=10.0000000
    DelayerThreshold=0.2000000
    DelayForMinis=0.3000000
    // Reference: StaticMeshComponent'Default__AdvFlashlightNumeralPuzzle_Base.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvFlashlightNumeralPuzzle_Base.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvFlashlightNumeralPuzzle_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    bHardAttach=true
    CollisionComponent=StaticMeshComponent0
    SupportedEvents=/* Array type was not detected. */
}