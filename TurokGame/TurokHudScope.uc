class TurokHudScope extends TurokHudElement
    transient
    native;

const NUM_SQUIBBLE_LINES = 5;

struct native SquibbleTextInfo
{
    var float fAnimLength;
    var float fAnimTime;
    var float fAnimVal;
    var float XPos;
    var float YPos;
    var int TexNum;
    var bool bHasHighlightBox;
    var @NULL AnimSpline;

    structdefaultproperties
    {
        fAnimLength=0.0000000
        fAnimTime=0.0000000
        fAnimVal=0.0000000
        XPos=0.0000000
        YPos=0.0000000
        TexNum=0
        bHasHighlightBox=false
        AnimSpline=(Points=none,InterpMethod=0)
    }
};

struct native ScopeTextureUVs
{
    var float U;
    var float V;

    structdefaultproperties
    {
        U=0.0000000
        V=0.0000000
    }
};

var array OverlayPieces;
var array ZoomText;
var @NULL CrossHairBGHoriz;
var @NULL CrossHairBGVert;
var @NULL EnemyDot;
var @NULL CrossHairLineHoriz;
var @NULL CrossHairLineVert;
var @NULL ZoomLineHoriz;
var @NULL ZoomLineVert;
var @NULL CircleOuterTarget;
var @NULL CircleInnerTarget;
var @NULL TargetDot;
var @NULL FriendlyReticle;
var array OverlayPiecesUV;
var array ZoomTextUV;
var @NULL CrossHairBGHorizUV;
var @NULL CrossHairBGVertUV;
var @NULL EnemyDotUV;
var @NULL CrossHairLineHorizUV;
var @NULL CrossHairLineVertUV;
var @NULL ZoomLineHorizUV;
var @NULL ZoomLineVertUV;
var @NULL CircleOuterTargetUV;
var @NULL CircleInnerTargetUV;
var @NULL TargetDotUV;
var @NULL FriendlyReticleUV;
var @NULL mZoomColour;
var int PrevZoom;
var protected @NULL AnimSpline;
var protected float fAnimTime;
var protected float fZoomVal;
var protected @NULL SquibbleAnims[5];
var protected int CurSquibbleAnim;
var protected @NULL SquibbleLines[5];
var protected @NULL SquibbleLinesUV[5];
var protected int SkipCount;
var protected int WaitCount;
var @NULL mSquibbleSndCue;
var @NULL mOnTargetSndCue;
var bool mbCanPlayOnTargetSound;

// Export UTurokHudScope::execDrawNative(FFrame&, void* const)
native function DrawNative(int Zoom);

// Export UTurokHudScope::execDrawScopeBG(FFrame&, void* const)
native function DrawScopeBG();

// Export UTurokHudScope::execDrawZoom(FFrame&, void* const)
native function DrawZoom(int Zoom);

// Export UTurokHudScope::execSetupAnimSpline(FFrame&, void* const)
native function SetupAnimSpline(float start_val, float end_val);

// Export UTurokHudScope::execDrawFriendly(FFrame&, void* const)
native function DrawFriendly();

// Export UTurokHudScope::execSetupSquibbleAnim(FFrame&, void* const)
native function SetupSquibbleAnim(int Index);

// Export UTurokHudScope::execDrawSquibbleAnim(FFrame&, void* const)
native function DrawSquibbleAnim(int Index, optional float X, optional float Y, optional int R, optional int G, optional int B, optional int A);

// Export UTurokHudScope::execDrawSquibbleAnims(FFrame&, void* const)
native function DrawSquibbleAnims(optional float X, optional float Y, optional int R, optional int G, optional int B, optional int A);

function InitBase(@NULL myHUD)
{
    Init(myHUD);
    //return;    
}

function Init(@NULL myHUD)
{
    InitBase(myHUD);
    ZoomText[0] = Texture2D'TurokHud.Reticles.Sniper.Text_2x';
    ZoomText[1] = Texture2D'TurokHud.Reticles.Sniper.Text_5x';
    ZoomText[2] = Texture2D'TurokHud.Reticles.Sniper.Text_10x';
    ZoomTextUV[0].U = 64.0000000;
    ZoomTextUV[0].V = 32.0000000;
    ZoomTextUV[1].U = 64.0000000;
    ZoomTextUV[1].V = 32.0000000;
    ZoomTextUV[2].U = 64.0000000;
    ZoomTextUV[2].V = 32.0000000;
    CrossHairBGHoriz = Texture2D'TurokHud.Reticles.Sniper.Crosshair_Horizontal';
    CrossHairBGVert = Texture2D'TurokHud.Reticles.Sniper.Crosshair_Vertical';
    CrossHairBGHorizUV.U = 512.0000000;
    CrossHairBGHorizUV.V = 32.0000000;
    CrossHairBGVertUV.U = 32.0000000;
    CrossHairBGVertUV.V = 512.0000000;
    CrossHairLineHoriz = Texture2D'TurokHud.Reticles.Sniper.TargetingLines_Left';
    CrossHairLineVert = Texture2D'TurokHud.Reticles.Sniper.TargetingLines_Top';
    ZoomLineHoriz = Texture2D'TurokHud.Reticles.Sniper.TargetLineWhite_Horizontal';
    ZoomLineVert = Texture2D'TurokHud.Reticles.Sniper.TargetLineWhite_Vertical';
    CrossHairLineHorizUV.U = 32.0000000;
    CrossHairLineHorizUV.V = 128.0000000;
    CrossHairLineVertUV.U = 128.0000000;
    CrossHairLineVertUV.V = 32.0000000;
    ZoomLineHorizUV.U = 128.0000000;
    ZoomLineHorizUV.V = 8.0000000;
    ZoomLineVertUV.U = 8.0000000;
    ZoomLineVertUV.V = 128.0000000;
    CircleOuterTarget = Texture2D'TurokHud.Reticles.Sniper.CircleOuterScaling';
    CircleInnerTarget = Texture2D'TurokHud.Reticles.Sniper.CircleInnerTarget';
    TargetDot = Texture2D'TurokHud.Reticles.Sniper.Crosshair_Dot';
    FriendlyReticle = Texture2D'TurokHud.Reticles.Sniper.ReticleFriendly';
    CircleOuterTargetUV.U = 128.0000000;
    CircleOuterTargetUV.V = 128.0000000;
    CircleInnerTargetUV.U = 32.0000000;
    CircleInnerTargetUV.V = 32.0000000;
    TargetDotUV.U = 4.0000000;
    TargetDotUV.V = 4.0000000;
    FriendlyReticleUV.U = 32.0000000;
    FriendlyReticleUV.V = 32.0000000;
    EnemyDot = Texture2D'TurokHud.Reticles.Sniper.SquibbleDot_White';
    EnemyDotUV.U = 16.0000000;
    EnemyDotUV.V = 16.0000000;
    SquibbleLines[0] = Texture2D'TurokHud.Reticles.Sniper.SniperScope_Squibble_1';
    SquibbleLines[1] = Texture2D'TurokHud.Reticles.Sniper.SniperScope_Squibble_2';
    SquibbleLines[2] = Texture2D'TurokHud.Reticles.Sniper.SniperScope_Squibble_3';
    SquibbleLines[3] = Texture2D'TurokHud.Reticles.Sniper.SniperScope_Squibble_4';
    SquibbleLines[4] = Texture2D'TurokHud.Reticles.Sniper.SniperScope_Squibble_5';
    SquibbleLinesUV[0].U = 64.0000000;
    SquibbleLinesUV[0].V = 8.0000000;
    SquibbleLinesUV[1].U = 64.0000000;
    SquibbleLinesUV[1].V = 8.0000000;
    SquibbleLinesUV[2].U = 64.0000000;
    SquibbleLinesUV[2].V = 8.0000000;
    SquibbleLinesUV[3].U = 64.0000000;
    SquibbleLinesUV[3].V = 8.0000000;
    SquibbleLinesUV[4].U = 64.0000000;
    SquibbleLinesUV[4].V = 8.0000000;
    CurSquibbleAnim = 0;
    SetupSquibbleAnim(CurSquibbleAnim);
    //return;    
}

function Draw()
{
    local @NULL locPawnOwner, zoomer;

    locPawnOwner = TurokPawnHuman(mHud.mPawnOwner);
    zoomer = TurokPlayerController(locPawnOwner.Controller).mZoomer;
    // End:0x67
    if(locPawnOwner != none)
    {
        // End:0x67
        if((zoomer != none) && zoomer.mCurToggle > 0)
        {
        }
    }
    //return;    
}

defaultproperties
{
    mSquibbleSndCue=SoundCue'SndWeapSniper.SniperReadoutASndCue'
    mOnTargetSndCue=SoundCue'SndWeapSniper.SniperOnTargetSndCue'
    mbCanPlayOnTargetSound=true
}