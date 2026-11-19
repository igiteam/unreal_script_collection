class WeaponScopeComponent extends ActorComponent
    config(Weapon);

const MAX_WEAPON_TYPE_SP = 25;
const MAX_SP_MISSIONS = 7;
const MAX_SP_MEDALS = 6;
const MAX_HUD_NOTIFICATIONS = 8;
const NUM_MP_MAPS = 6;
const NUM_MP_AWARDS = 19;
const NUM_WEAPON_CLASSES = 7;
const MAX_RIVALS = 8;
const NUM_WEAPON_EXP_LEVELS = 3;
const NUM_MP_MEDALS = 15;
const NUM_MP_WEAPON_UPGRADES = 4;
const MAX_MISSION_SKILL_DROPS = 5;
const MAX_UPGRADEABLE_WEAPONS_SP = 16;
const NUM_XBLACH_UPGRADED_WEAPONS = 5;
const NUM_KILL_TIMES_TO_TRACK = 5;
const NUM_CONSECUTIVE_HEADSHOT_XBLACH = 10;
const MAX_DIFFICULTIES = 3;
const MAX_HUD_RENDERMODES = 4;
const MAX_SP_CHEAT_FLAGS = 7;
const WIDESCREEN_ASPECT_RATIO = 1.7777f;
const WIDESCREEN_INVERSE_ASPECT_RATIO = 0.5625f;
const MAX_HEALTH_DROPPED_PICKUPS = 1;
const MAX_HEALTH_DROPPED_PICKUPS_MP = 10;

enum EZoomState
{
    ZS_NONE,                        // 0
    ZS_ZOOMIN,                      // 1
    ZS_ZOOMOUT,                     // 2
    ZS_HALFZOOM,                    // 3
    ZS_FULLZOOM,                    // 4
    ZS_MAX                          // 5
};

var() config ScopeTuning ScopeParams;
var() Texture2D ScopeTexture;
var() bool bShowViewmodel;
var() bool bBlurDisabled;
var bool bEnabled;
var float fCurrentFOV;
var WeaponScopeComponent.EZoomState ZoomState;
var float fCurrentFocalLength;
var float fCurrentFocalRadius;
var float fFocalNoiseScalar;
var EALASmallArms Weap;
var float fScopeInOutPercent;
var transient bool bDrawTrueTriggerMeter;
var transient bool bForceTickSound;
var transient float timeAdjustingZoom;
var transient float lastTickSoundFOV;
var SoundCue zoomTickSound;
var float zoomSliderPositionThetaStart;
var float zoomSliderPositionThetaRange;
var float zoomSliderRotationThetaStart;
var float zoomSliderRotationThetaRange;
var float zoomSliderRadius;

simulated function Init(EALASmallArms MyWeap)
{
    ResetFOV();
    Weap = MyWeap;
    //return;    
}

simulated function BeginSniperZoom()
{
    local WeaponAttachment WeapAttachment;
    local MOHAPlayerPawn PlayerPawn;
    local MOHAPlayerController PlayerController;
    local MOHAHUD myHUD;

    // End:0x0B
    if(bEnabled)
    {
        return;
    }
    WeapAttachment = Weap.GetWeaponAttachment();
    // End:0x4C
    if(SniperRifleAttachment(WeapAttachment) != none)
    {
        SniperRifleAttachment(WeapAttachment).BeginSniperZoom();
    }
    PlayerPawn = MOHAPlayerPawn(Weap.Instigator);
    // End:0x84
    if(!bShowViewmodel)
    {
        Weap.RenderWeaponAndArms(false);
    }
    bEnabled = true;
    fCurrentFocalLength = 0.0000000;
    fCurrentFocalRadius = 0.0000000;
    PlayerController = MOHAPlayerController(PlayerPawn.Controller);
    myHUD = MOHAHUD(PlayerController.myHUD);
    // End:0xF4
    if(ScopeTexture != none)
    {
        myHUD.SetRenderMode(1);
    }
    // End:0x135
    if(!Class'MOHAUtilities'.static.IsEditorActive() && ScopeTexture != none)
    {
        PlayerController.PostProcessComponent.EnableScopeEffect();
    }
    // End:0x197
    if((Weap.TrueTriggerComponent != none) && Weap.bTrueTriggerEnabled)
    {
        myHUD.hud_trueTriggerMeter.EnableElement(true);
        myHUD.hud_weaponZoomSlider.EnableElement(true);
    }
    PlayerPawn.bCanJump = false;
    //return;    
}

simulated function ToggleTrueTriggerMeter()
{
    bDrawTrueTriggerMeter = !bDrawTrueTriggerMeter;
    //return;    
}

simulated function EndSniperZoom()
{
    local MOHAPlayerPawn PlayerPawn;
    local MOHAPlayerController PlayerController;
    local WeaponAttachment WeapAttachment;
    local MOHAHUD myHUD;

    WeapAttachment = Weap.GetWeaponAttachment();
    // End:0x41
    if(SniperRifleAttachment(WeapAttachment) != none)
    {
        SniperRifleAttachment(WeapAttachment).EndSniperZoom();
    }
    PlayerPawn = MOHAPlayerPawn(Weap.Instigator);
    Weap.RenderWeaponAndArms(true);
    ZoomState = 0;
    bEnabled = false;
    PlayerController = MOHAPlayerController(PlayerPawn.Controller);
    myHUD = MOHAHUD(PlayerController.myHUD);
    myHUD.SetRenderMode(0);
    // End:0x106
    if(!Class'MOHAUtilities'.static.IsEditorActive() && ScopeTexture != none)
    {
        PlayerController.PostProcessComponent.DisableScopeEffect();
    }
    myHUD.hud_trueTriggerMeter.EnableElement(false);
    myHUD.hud_weaponZoomSlider.EnableElement(false);
    PlayerPawn.bCanJump = true;
    //return;    
}

simulated function float GetFOV()
{
    return fCurrentFOV;
    //return ReturnValue;    
}

simulated function ResetFOV()
{
    fCurrentFOV = ScopeParams.MaxFOV;
    //return;    
}

simulated function PCZoomDone()
{
    ZoomState = 0;
    //return;    
}

simulated function PCZoomIn()
{
    // End:0x5C
    if(int(Weap.GetIronsightsState()) == int(3))
    {
        Owner.ClearTimer('PCZoomDone');
        Owner.SetTimer(0.1500000, false, 'PCZoomDone');
        ZoomState = 1;
    }
    //return;    
}

simulated function PCZoomOut()
{
    // End:0x5C
    if(int(Weap.GetIronsightsState()) == int(3))
    {
        Owner.ClearTimer('PCZoomDone');
        Owner.SetTimer(0.1500000, false, 'PCZoomDone');
        ZoomState = 2;
    }
    //return;    
}

simulated function ZoomInDown()
{
    // End:0x26
    if(int(Weap.GetIronsightsState()) == int(3))
    {
        ZoomState = 1;
    }
    //return;    
}

simulated function ZoomInRelease()
{
    // End:0x26
    if(int(Weap.GetIronsightsState()) == int(3))
    {
        ZoomState = 0;
    }
    //return;    
}

simulated function ZoomOutDown()
{
    // End:0x26
    if(int(Weap.GetIronsightsState()) == int(3))
    {
        ZoomState = 2;
    }
    //return;    
}

simulated function ZoomOutRelease()
{
    // End:0x26
    if(int(Weap.GetIronsightsState()) == int(3))
    {
        ZoomState = 0;
    }
    //return;    
}

simulated function DiscreteZoomPress()
{
    // End:0xC4
    if(int(Weap.GetIronsightsState()) == int(3))
    {
        // End:0x4E
        if(int(ZoomState) == int(3))
        {
            ZoomState = 4;
            fCurrentFOV = ScopeParams.MinFOV;            
        }
        else
        {
            // End:0x7E
            if(int(ZoomState) == int(4))
            {
                ZoomState = 0;
                fCurrentFOV = ScopeParams.MaxFOV;                
            }
            else
            {
                ZoomState = 3;
                fCurrentFOV = ScopeParams.MinFOV + ((ScopeParams.MaxFOV - ScopeParams.MinFOV) / 2.0000000);
            }
        }
    }
    //return;    
}

simulated function ActiveRenderOverlays(HUD H)
{
    local float zoomPercent, X, Y;
    local MOHAHUD myHUD;
    local float zoomSliderTheta, AspectRatio, fAspectRatioAdjustment;

    // End:0x0D
    if(!bEnabled)
    {
        return;
    }
    myHUD = MOHAHUD(H);
    // End:0x2A
    if(myHUD == none)
    {
        return;
    }
    AspectRatio = myHUD.Canvas.ClipX / myHUD.Canvas.ClipY;
    // End:0x15D
    if(ScopeTexture != none)
    {
        H.Canvas.SetDrawColor(byte(255), byte(255), byte(255));
        H.Canvas.SetPos(0.0000000, 0.0000000);
        fAspectRatioAdjustment = float(ScopeTexture.SizeX) * (1.0000000 - (AspectRatio * 0.5625000));
        H.Canvas.__NFUN_466__(ScopeTexture, H.Canvas.ClipX, H.Canvas.ClipY, fAspectRatioAdjustment / 2.0000000, 0.0000000, float(ScopeTexture.SizeX) - fAspectRatioAdjustment, float(ScopeTexture.SizeY));
    }
    zoomPercent = ((ScopeParams.MaxFOV > ScopeParams.MinFOV) ? 1.0000000 - FPctByRange(fCurrentFOV, ScopeParams.MinFOV, ScopeParams.MaxFOV) : 1.0000000);
    zoomSliderTheta = (zoomSliderPositionThetaStart * 3.1415930) + ((zoomPercent * 3.1415930) * zoomSliderPositionThetaRange);
    zoomSliderRadius = (default.zoomSliderRadius * 1.7777000) / AspectRatio;
    X = 0.5000000 + (zoomSliderRadius * Cos(zoomSliderTheta));
    Y = 0.5000000 - ((zoomSliderRadius * Sin(zoomSliderTheta)) * AspectRatio);
    myHUD.hud_weaponZoomSlider.Rotation = ((3.1415930 * zoomSliderRotationThetaStart) - ((3.1415930 * zoomSliderRotationThetaRange) * zoomPercent)) / 0.0000959;
    myHUD.hud_weaponZoomSlider.SetPosition(X, Y);
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local float adjustedZoomRate;
    local MOHAPlayerPawn Player;

    // End:0x0D
    if(!bEnabled)
    {
        return;
    }
    UpdateFocalBlur(DeltaTime);
    adjustedZoomRate = ScopeParams.FOVChangeRate;
    // End:0x4C
    if(timeAdjustingZoom < 0.1000000)
    {
        adjustedZoomRate *= 0.2500000;
    }
    switch(ZoomState)
    {
        // End:0x14B
        case 1:
            timeAdjustingZoom += DeltaTime;
            fCurrentFOV -= (DeltaTime * adjustedZoomRate);
            // End:0xA8
            if(fCurrentFOV < ScopeParams.MinFOV)
            {
                fCurrentFOV = ScopeParams.MinFOV;                
            }
            else
            {
                fCurrentFocalLength *= (float(1) - (DeltaTime * ScopeParams.fZoomFocalDegredationScalar));
                fFocalNoiseScalar = 0.0000000;
                // End:0x148
                if((ScopeTexture != none) && bForceTickSound || Abs(lastTickSoundFOV - fCurrentFOV) > float(2))
                {
                    Player = MOHAPlayerPawn(Weap.Instigator);
                    Player.PlaySound(zoomTickSound, true, false, true);
                    bForceTickSound = false;
                    lastTickSoundFOV = fCurrentFOV;
                }
            }
            // End:0x261
            break;
        // End:0x243
        case 2:
            timeAdjustingZoom += DeltaTime;
            fCurrentFOV += (DeltaTime * adjustedZoomRate);
            // End:0x1A0
            if(fCurrentFOV > ScopeParams.MaxFOV)
            {
                fCurrentFOV = ScopeParams.MaxFOV;                
            }
            else
            {
                fCurrentFocalLength *= (float(1) - (DeltaTime * ScopeParams.fZoomFocalDegredationScalar));
                fFocalNoiseScalar = 0.0000000;
                // End:0x240
                if((ScopeTexture != none) && bForceTickSound || Abs(lastTickSoundFOV - fCurrentFOV) > float(2))
                {
                    Player = MOHAPlayerPawn(Weap.Instigator);
                    Player.PlaySound(zoomTickSound, true, false, true);
                    bForceTickSound = false;
                    lastTickSoundFOV = fCurrentFOV;
                }
            }
            // End:0x261
            break;
        // End:0x248
        case 0:
        // End:0xFFFF
        default:
            bForceTickSound = true;
            timeAdjustingZoom = 0.0000000;
            // End:0x261
            break;
            break;
    }
    fScopeInOutPercent = ((ScopeParams.MaxFOV != ScopeParams.MinFOV) ? (fCurrentFOV - ScopeParams.MinFOV) / (ScopeParams.MaxFOV - ScopeParams.MinFOV) : 1.0000000);
    //return;    
}

simulated function UpdateFocalBlur(float DeltaTime)
{
    local Vector vStart, vEnd;
    local float fTargetLength, fDelta;

    // End:0x0B
    if(bBlurDisabled)
    {
        return;
    }
    // End:0x56
    if((MOHAPlayerPawn(Inventory(Owner).Instigator) != none) && MOHAPlayerPawn(Inventory(Owner).Instigator).IsUpgradeSequenceActive())
    {
        return;
    }
    vStart = Weap.Instigator.GetWeaponStartTraceLocation();
    vEnd = vStart + (Vector(Weap.GetAdjustedAim(vStart)) * Weap.GetTraceRange());
    fTargetLength = GetFocalDistance(vStart, vEnd);
    // End:0x106
    if(fFocalNoiseScalar < float(1))
    {
        fFocalNoiseScalar += (DeltaTime * float(2));
        // End:0x106
        if(fFocalNoiseScalar > float(1))
        {
            fFocalNoiseScalar = 1.0000000;
        }
    }
    // End:0x15C
    if(fCurrentFocalLength != fTargetLength)
    {
        fDelta = fTargetLength - fCurrentFocalLength;
        fDelta *= FClamp(DeltaTime * ScopeParams.fFocalLengthRateOfChange, 0.0000000, 1.0000000);
        fCurrentFocalLength += fDelta;
    }
    // End:0x1D9
    if(fCurrentFocalRadius != ScopeParams.fFocalRadiusTarget)
    {
        // End:0x1B5
        if(fCurrentFocalRadius < ScopeParams.fFocalRadiusTarget)
        {
            fCurrentFocalRadius += ((DeltaTime * ScopeParams.fFocalRadiusRateOfChange) * fFocalNoiseScalar);            
        }
        else
        {
            fCurrentFocalRadius -= ((DeltaTime * ScopeParams.fFocalRadiusRateOfChange) * fFocalNoiseScalar);
        }
    }
    Owner.WorldInfo.GameModified_DOF_FocusDistance = fCurrentFocalLength;
    Owner.WorldInfo.GameModified_DOF_FocusInnerRadius = fCurrentFocalRadius;
    Owner.WorldInfo.GameModified_DOF_MaxNearBlurAmount = 0.9900000;
    Owner.WorldInfo.GameModified_DOF_MaxFarBlurAmount = 0.9900000;
    //return;    
}

simulated function float GetFocalDistance(Vector vStart, Vector vEnd)
{
    local Actor HitActor;
    local Vector vHit, vHitNormal;

    HitActor = Weap.Trace(vHit, vHitNormal, vEnd, vStart, true);
    // End:0x3E
    if(HitActor == none)
    {
        return fCurrentFocalLength;        
    }
    else
    {
        // End:0xA5
        if(HitActor.IsA('Trigger') || HitActor.IsA('TriggerVolume'))
        {
            HitActor.bProjTarget = false;
            return GetFocalDistance(vHit, vEnd);
            HitActor.bProjTarget = true;
        }
    }
    return VSize(vHit - vStart);
    //return ReturnValue;    
}

simulated function float GetScopeInOutPercent()
{
    return fScopeInOutPercent;
    //return ReturnValue;    
}

defaultproperties
{
    ScopeParams=(MinFOV=10.0000000,MaxFOV=40.0000000,FOVChangeRate=50.0000000,fFocalLengthRateOfChange=3.0000000,fFocalRadiusRateOfChange=1000.0000000,fFocalRadiusTarget=3500.0000000,fZoomFocalDegredationScalar=0.0000000)
    ScopeTexture=Texture2D'GCm_Wpn_SniperScopeOverlay.US_SniperReticle_HUD'
    zoomTickSound=SoundCue'Aud_GCm_FakeWAV.TrueTrigger.Scope_Twist_LP'
    zoomSliderPositionThetaStart=0.5400000
    zoomSliderPositionThetaRange=0.4250000
    zoomSliderRotationThetaStart=0.4250000
    zoomSliderRotationThetaRange=0.4250000
    zoomSliderRadius=0.2680000
}