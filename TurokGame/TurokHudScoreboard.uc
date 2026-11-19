class TurokHudScoreboard extends TurokHudElement
    transient
    native;

const MAX_FLAG_ICONS = 12;

enum eScoreboardFlagState
{
    SBFS_EMPTY,                     // 0
    SBFS_POSSESSED,                 // 1
    SBFS_CAPTURED,                  // 2
    SBFS_MAX                        // 3
};

struct native ScoreboardFlagInfo
{
    var int flag_state;
    var int Team;
    var float iconAlpha;
    var float animTime;
    var int animIndex;
    var bool PlayAnim;

    structdefaultproperties
    {
        flag_state=0
        Team=0
        iconAlpha=0.0000000
        animTime=0.0000000
        animIndex=0
        PlayAnim=false
    }
};

var @NULL FlagInfos[12];
var @NULL mScoreboardTex;
var @NULL mFlagOnTex;
var @NULL mFlagOffTex;
var @NULL mScoreFont;
var @NULL mRedTeamColor;
var @NULL mBlueTeamColor;
var int mCapturedFade;
var int mBgAlpha;
var int mRedTeamScore;
var int mBlueTeamScore;
var int NumFlagsInGame;
var int NumIcons;
var float IconSpacing;
var bool bIsCTF;
var bool mDrawClock;
var bool mDrawTeams;
var bool mDrawTeamScores;
var bool mDrawChiclets;
var int mGamePlayModeId;
var @NULL Position;
var int mBgLeftWidth;
var int mBgMiddleWidth;
var int mBgHeight;
var int mBgGap;
var int mClockWidth;
var int mClockGap;
var int mSmallGap;
var int mTeamIconWidth;
var int mTeamIconHeight;
var int mFlagIconWidth;
var int mFlagIconHeight;
var @NULL mFlagIconUV;
var int mChicletWidth;
var int mChicletHeight;
var int mChicHighlightLeftWidth;
var int mChicHighlightMiddleWidth;
var int mChicHighlightHeight;
var int mChicletGap;
var int mScoreWidth;
var int mTextYOffset;
var int mChicletYOffset;
var int mChicHighlightYOffset;
var int mTeamIconYOffset;
var @NULL mBgLeftUVStart;
var @NULL mBgMiddleUVStart;
var @NULL mTeamIcon0UVStart;
var @NULL mTeamIcon1UVStart;
var @NULL mChicletOnUVStart;
var @NULL mChicletOffUVStart;
var @NULL mChicHighlightLeftUVStart;
var @NULL mChicHighlightMiddleUVStart;
var int mBlinkAnim1NumSteps;
var int mBlinkAnim2NumSteps;
var float mBlinkAnimOffToOn[6];
var float mBlinkAnimOnToOffPlusFade[7];

// Export UTurokHudScoreboard::execDrawNative(FFrame&, void* const)
native simulated function DrawNative();

// Export UTurokHudScoreboard::execSetNumFlags(FFrame&, void* const)
native simulated function SetNumFlags(int Num);

// Export UTurokHudScoreboard::execSetFlagPossessed(FFrame&, void* const)
native final simulated function SetFlagPossessed(int Team);

// Export UTurokHudScoreboard::execSetFlagLost(FFrame&, void* const)
native final simulated function SetFlagLost(int Team);

// Export UTurokHudScoreboard::execSetFlagCaptured(FFrame&, void* const)
native final simulated function SetFlagCaptured(int Team);

// Export UTurokHudScoreboard::execSetNumFlagsEmpty(FFrame&, void* const)
native final simulated function SetNumFlagsEmpty(int Team, int Num);

// Export UTurokHudScoreboard::execSetNumFlagsPossessed(FFrame&, void* const)
native final simulated function SetNumFlagsPossessed(int Team, int Num);

// Export UTurokHudScoreboard::execSetNumFlagsCaptured(FFrame&, void* const)
native final simulated function SetNumFlagsCaptured(int Team, int Num);

// Export UTurokHudScoreboard::execSetAllFlagsEmpty(FFrame&, void* const)
native final simulated function SetAllFlagsEmpty(int Team);

// Export UTurokHudScoreboard::execSetAllFlagsPossessed(FFrame&, void* const)
native final simulated function SetAllFlagsPossessed(int Team);

// Export UTurokHudScoreboard::execSetAllFlagsCaptured(FFrame&, void* const)
native final simulated function SetAllFlagsCaptured(int Team);

// Export UTurokHudScoreboard::execResetTeamScoreboard(FFrame&, void* const)
native final simulated function ResetTeamScoreboard(int Team);

// Export UTurokHudScoreboard::execResetScoreboard(FFrame&, void* const)
native final simulated function ResetScoreboard();

function Init(@NULL hudRef)
{
    local int I;

    super.Init(hudRef);
    bIsCTF = false;
    // End:0x41
    if(TurokDMHud(mHud) != none)
    {
        SetNumFlags(0);
        mDrawTeams = false;
        mDrawTeamScores = false;        
    }
    else
    {
        // End:0x6F
        if(TurokTeamDMHud(mHud) != none)
        {
            SetNumFlags(0);
            mDrawTeams = true;
            mDrawTeamScores = true;            
        }
        else
        {
            // End:0x9D
            if(TurokAssaultCTFHud(mHud) != none)
            {
                SetNumFlags(0);
                mDrawTeams = true;
                mDrawTeamScores = true;                
            }
            else
            {
                // End:0x183
                if(TurokCTFHud(mHud) != none)
                {
                    bIsCTF = true;
                    SetNumFlags(1);
                    mDrawTeams = true;
                    mDrawTeamScores = true;
                    I = 0;
                    J0xD7:

                    // End:0x180 [Loop If]
                    if(I < 12)
                    {
                        FlagInfos[I].flag_state = 1;
                        FlagInfos[I].Team = 0;
                        FlagInfos[I].PlayAnim = false;
                        FlagInfos[I].animTime = 0.0000000;
                        FlagInfos[I].animIndex = 0;
                        FlagInfos[I].iconAlpha = 1.0000000;
                        I++;
                        // [Loop Continue]
                        goto J0xD7;
                    }                    
                }
                else
                {
                    // End:0x1A6
                    if(TurokWarGameHud(mHud) != none)
                    {
                        mDrawTeams = false;
                        mDrawTeamScores = false;                        
                    }
                    else
                    {
                        // End:0x1D4
                        if(TurokCoopGameHud(mHud) != none)
                        {
                            SetNumFlags(0);
                            mDrawTeams = false;
                            mDrawTeamScores = false;                            
                        }
                        else
                        {
                            SetNumFlags(0);
                            mDrawTeams = false;
                            mDrawTeamScores = false;
                        }
                    }
                }
            }
        }
    }
    I = 1;
    J0x1F6:

    // End:0x22A [Loop If]
    if(I < mBlinkAnim1NumSteps)
    {
        mBlinkAnimOffToOn[I] += mBlinkAnimOffToOn[I - 1];
        I++;
        // [Loop Continue]
        goto J0x1F6;
    }
    I = 1;
    J0x231:

    // End:0x265 [Loop If]
    if(I < mBlinkAnim2NumSteps)
    {
        mBlinkAnimOnToOffPlusFade[I] += mBlinkAnimOnToOffPlusFade[I - 1];
        I++;
        // [Loop Continue]
        goto J0x231;
    }
    //return;    
}

function Reset()
{
    //return;    
}

function Draw()
{
    Position.X = mHud.CenterX;
    Position.Y = ((mHud.SizeY - (mHud.SizeY * mHud.mSafeZoneHalfPcnt)) - float(mBgHeight)) - 2.0000000;
    // End:0xDB
    if(mDrawTeamScores)
    {
        mRedTeamScore = int(mHud.WorldInfo.GRI.Teams[0].Score);
        mBlueTeamScore = int(mHud.WorldInfo.GRI.Teams[1].Score);
    }
    DrawNative();
    //return;    
}

defaultproperties
{
    mScoreboardTex=Texture2D'TurokHudMultiplayer.MiniScoreboard.MiniScoreboard_Pieces_HD'
    mFlagOnTex=Texture2D'TurokHudMultiplayer.MiniScoreboard.FlagIcon_Pos_HD'
    mFlagOffTex=Texture2D'TurokHudMultiplayer.MiniScoreboard.FlagIcon_Neg_HD'
    mScoreFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mRedTeamColor=(R=218,G=125,B=0,A=255)
    mBlueTeamColor=(R=2,G=115,B=195,A=255)
    mCapturedFade=200
    mBgAlpha=153
    mBgLeftWidth=8
    mBgMiddleWidth=8
    mBgHeight=26
    mBgGap=2
    mClockWidth=54
    mClockGap=10
    mSmallGap=10
    mTeamIconWidth=24
    mTeamIconHeight=22
    mFlagIconWidth=15
    mFlagIconHeight=18
    mFlagIconUV=(X=8.0000000,Y=6.0000000)
    mChicletWidth=17
    mChicletHeight=6
    mChicHighlightLeftWidth=6
    mChicHighlightMiddleWidth=8
    mChicHighlightHeight=16
    mChicletGap=5
    mScoreWidth=11
    mTextYOffset=1
    mChicletYOffset=4
    mChicHighlightYOffset=5
    mTeamIconYOffset=2
    mBgLeftUVStart=(X=4.0000000,Y=3.0000000)
    mBgMiddleUVStart=(X=14.0000000,Y=3.0000000)
    mTeamIcon0UVStart=(X=100.0000000,Y=5.0000000)
    mTeamIcon1UVStart=(X=74.0000000,Y=5.0000000)
    mChicletOnUVStart=(X=27.0000000,Y=18.0000000)
    mChicletOffUVStart=(X=27.0000000,Y=9.0000000)
    mChicHighlightLeftUVStart=(X=48.0000000,Y=8.0000000)
    mChicHighlightMiddleUVStart=(X=59.0000000,Y=8.0000000)
    mBlinkAnim1NumSteps=6
    mBlinkAnim2NumSteps=7
    mBlinkAnimOffToOn[0]=0.2500000
    mBlinkAnimOffToOn[1]=0.2500000
    mBlinkAnimOffToOn[2]=0.2500000
    mBlinkAnimOffToOn[3]=0.2500000
    mBlinkAnimOffToOn[4]=0.2500000
    mBlinkAnimOffToOn[5]=0.2500000
    mBlinkAnimOnToOffPlusFade[0]=0.2500000
    mBlinkAnimOnToOffPlusFade[1]=0.2500000
    mBlinkAnimOnToOffPlusFade[2]=0.2500000
    mBlinkAnimOnToOffPlusFade[3]=0.2500000
    mBlinkAnimOnToOffPlusFade[4]=0.2500000
    mBlinkAnimOnToOffPlusFade[5]=0.2500000
    mBlinkAnimOnToOffPlusFade[6]=0.5000000
}