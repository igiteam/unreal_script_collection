class TurokHudScopeRPG extends TurokHudScope
    transient
    native;

enum eHudScopeRPGOverlayTextures
{
    HSRPGOT_BORDER,                 // 0
    HSRPGOT_GRADIENT,               // 1
    HSRPGOT_SCANLINES,              // 2
    HSRPGOT_SEMI_CIRCLE_ORANGE,     // 3
    HSRPGOT_SEMI_CIRCLE_RED,        // 4
    HSRPGOT_INNER_LINE_ORANGE,      // 5
    HSRPGOT_INNER_LINE_RED,         // 6
    HSRPGOT_CIRCLE_NOTCH_ORANGE,    // 7
    HSRPGOT_CIRCLE_NOTCH_RED,       // 8
    HSRPGOT_TRIANGLE_ORANGE,        // 9
    HSRPGOT_TRIANGLE_WHITE,         // 10
    HSRPGOT_RETICLE_SMALL,          // 11
    HSRPGOT_RETICLE_GREY,           // 12
    HSRPGOT_RETICLE_ORANGE,         // 13
    HSRPGOT_RETICLE_RED,            // 14
    HSRPGOT_LOCK_METER_BACKING,     // 15
    HSRPGOT_LOCK_METER_SMALL_TICK,  // 16
    HSRPGOT_LOCK_METER_LARGE_TICK,  // 17
    HSRPGOT_TEXT_X2,                // 18
    HSRPGOT_TEXT_LOCKED,            // 19
    HSRPGOT_ROTATION_LINE_HORIZONTAL,// 20
    HSRPGOT_ROTATION_LINE_VERTICAL, // 21
    HSRPGOT_MAX                     // 22
};

var int Yaw;
var int Pitch;
var float FOV;
var float fLockStatus;
var float fLockOpeningTime;
var bool bLockAnimCircleComplete;
var bool bRotateUp;
var bool bWasOpen;
var bool mTrianglesOn;
var float fLockBlinkTime;
var float fTriangleRotation;
var float fOpenTime;
var int mPrevYaw;
var int mPrevPitch;
var(Sound) @NULL mServoSndCue;
var(Sound) @NULL mLockedOnSndCue;
var(Sound) @NULL mLockedPctSndCue;
var int mMinClickThresh;
var float fLockBeepTime;
var float fLastBeepTime;
var @NULL BeepCurve;

function SetYawPitch(int in_yaw, int in_pitch, float in_fov)
{
    Yaw = in_yaw;
    Pitch = in_pitch;
    FOV = in_fov;
    // End:0x95
    if((Abs(float(Yaw - mPrevYaw)) >= float(mMinClickThresh)) || Abs(float(Pitch - mPrevPitch)) >= float(mMinClickThresh))
    {
        mHud.mSoundController.TryPlayLocalSound(mServoSndCue);
        mPrevYaw = Yaw;
        mPrevPitch = Pitch;
    }
    //return;    
}

function SetLockStatus(float Status)
{
    // End:0x3E
    if((Status > fLockStatus) && Status >= 1.0000000)
    {
        bLockAnimCircleComplete = false;
        fLockOpeningTime = 0.0000000;
        fLockBlinkTime = 0.0000000;
    }
    fLockStatus = Status;
    //return;    
}

function StartOpen()
{
    fOpenTime = 0.0000000;
    //return;    
}

// Export UTurokHudScopeRPG::execDrawNative(FFrame&, void* const)
native function DrawNative(int Zoom);

// Export UTurokHudScopeRPG::execDrawScopeOverlay(FFrame&, void* const)
native function DrawScopeOverlay(optional float offset_x, optional float offset_y, optional float open_scale);

// Export UTurokHudScopeRPG::execDrawRotationLines(FFrame&, void* const)
native function DrawRotationLines(optional float offset_x, optional float offset_y, optional float open_scale);

// Export UTurokHudScopeRPG::execDrawCircle(FFrame&, void* const)
native function DrawCircle(optional float offset_x, optional float offset_y, optional float open_scale);

// Export UTurokHudScopeRPG::execDrawTextInfo(FFrame&, void* const)
native function DrawTextInfo(optional float offset_x, optional float offset_y, optional float open_scale);

// Export UTurokHudScopeRPG::execDrawLockMeter(FFrame&, void* const)
native function DrawLockMeter(optional float offset_x, optional float offset_y, optional float open_scale);

// Export UTurokHudScopeRPG::execDrawReticle(FFrame&, void* const)
native function DrawReticle(optional float offset_x, optional float offset_y, optional float open_scale);

// Export UTurokHudScopeRPG::execDrawLockMeterIcons(FFrame&, void* const)
native function DrawLockMeterIcons(int icon_num, int R, int G, int B, float Opacity, optional float offset_x, optional float offset_y);

function Init(@NULL myHUD)
{
    InitBase(myHUD);
    OverlayPieces[0] = Texture2D'TurokHud.Reticles.RPG.OuterBorder';
    OverlayPieces[1] = Texture2D'TurokHud.Reticles.RPG.OuterShadow';
    OverlayPieces[2] = Texture2D'TurokHud.Reticles.RPG.LineScreenBG';
    OverlayPieces[3] = Texture2D'TurokHud.Reticles.RPG.OrangeCircle';
    OverlayPieces[4] = Texture2D'TurokHud.Reticles.RPG.RedCircle';
    OverlayPieces[5] = Texture2D'TurokHud.Reticles.RPG.OrangeCircleInner';
    OverlayPieces[6] = Texture2D'TurokHud.Reticles.RPG.RedCircleInner';
    OverlayPieces[7] = Texture2D'TurokHud.Reticles.RPG.CircleNotchOrange';
    OverlayPieces[8] = Texture2D'TurokHud.Reticles.RPG.CircleNotchRed';
    OverlayPieces[9] = Texture2D'TurokHud.Reticles.RPG.TriangleOrange';
    OverlayPieces[10] = Texture2D'TurokHud.Reticles.RPG.WhiteTriangle';
    OverlayPieces[11] = Texture2D'TurokHud.Reticles.RPG.SmallHexagon';
    OverlayPieces[12] = Texture2D'TurokHud.Reticles.RPG.CrosshairOff';
    OverlayPieces[13] = Texture2D'TurokHud.Reticles.RPG.CrosshairOn';
    OverlayPieces[14] = Texture2D'TurokHud.Reticles.RPG.CrosshairFire';
    OverlayPieces[15] = Texture2D'TurokHud.Reticles.RPG.Timer';
    OverlayPieces[16] = Texture2D'TurokHud.Reticles.RPG.TimerNotchSmall';
    OverlayPieces[17] = Texture2D'TurokHud.Reticles.RPG.TimerNotchBig';
    OverlayPieces[18] = Texture2D'TurokHud.Reticles.RPG.X2Graphic';
    OverlayPieces[19] = Texture2D'TurokHud.Reticles.RPG.LockedText';
    OverlayPieces[20] = Texture2D'TurokHud.Reticles.RPG.HorizonalLine';
    OverlayPieces[21] = Texture2D'TurokHud.Reticles.RPG.VerticalLine';
    SquibbleLines[0] = Texture2D'TurokHud.Reticles.RPG.SniperScope_Squibble_1';
    SquibbleLines[1] = Texture2D'TurokHud.Reticles.RPG.SniperScope_Squibble_2';
    SquibbleLines[2] = Texture2D'TurokHud.Reticles.RPG.SniperScope_Squibble_3';
    SquibbleLines[3] = Texture2D'TurokHud.Reticles.RPG.SniperScope_Squibble_4';
    SquibbleLines[4] = Texture2D'TurokHud.Reticles.RPG.SniperScope_Squibble_5';
    CurSquibbleAnim = 0;
    SetupSquibbleAnim(CurSquibbleAnim);
    //return;    
}

function Draw()
{
    local @NULL locPawnOwner, view_rotation;
    local float cur_fov;

    locPawnOwner = TurokPawnHuman(mHud.mPawnOwner);
    cur_fov = TurokPlayerController(locPawnOwner.Controller).FOVAngle;
    view_rotation = locPawnOwner.GetBaseAimRotation();
    SetYawPitch(view_rotation.Yaw, view_rotation.Pitch, cur_fov);
    DrawNative(0);
    //return;    
}

defaultproperties
{
    bRotateUp=true
    mServoSndCue=SoundCue'SndWeapRpg.RPGServoSndCue'
    mLockedOnSndCue=SoundCue'SndWeapRpg.RPGTargetLockBSndCue'
    mLockedPctSndCue=SoundCue'SndWeapRpg.RPGTargetLockDSndCue'
    mMinClickThresh=100
    BeepCurve=(Points=/* Array type was not detected. */,InterpMethod=0)
}