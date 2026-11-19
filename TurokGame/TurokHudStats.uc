class TurokHudStats extends TurokHudElement
    transient
    native;

const M_TrueSkillRank = 1771942426;
const M_PlayerName = -1212432799;
const M_Kills = 52250070;
const M_Deaths = 576138387;
const M_StatScreenHeader_Score = 1140952803;
const M_Flags = -541244099;
const M_CTFActs = 321679768;
const M_CTFPoints = -1725928246;
const M_WGActs = -547692405;
const M_WGPoints = 343579128;
const M_ViewGamerCard = -2048945104;

enum eHudStatColumns
{
    HSC_RANK,                       // 0
    HSC_LEVEL,                      // 1
    HSC_VOICE,                      // 2
    HSC_NAME,                       // 3
    HSC_TOTAL_KILLS,                // 4
    HSC_DEATHS,                     // 5
    HSC_MAX                         // 6
};

enum eColumn4
{
    COL4_SCORE,                     // 0
    COL4_CTF_POINTS,                // 1
    COL4_WG_POINTS,                 // 2
    COL4_MAX                        // 3
};

struct native HeaderColumn
{
    var int mStringHash;
    var array mCachedStrings;
    var float mPositionX;
    var float mPositionY;
    var byte mAlignment;

    structdefaultproperties
    {
        mStringHash=0
        mCachedStrings=none
        mPositionX=0.0000000
        mPositionY=0.0000000
        mAlignment=0
    }
};

struct native ColumnInformation
{
    var byte mAlignment;
    var int mPositionX;

    structdefaultproperties
    {
        mAlignment=1
        mPositionX=0
    }
};

struct native FontInformation
{
    var @NULL mFont;
    var float mScale;
    var float mHeight;
    var @NULL mColor;

    structdefaultproperties
    {
        mFont=none
        mScale=0.0000000
        mHeight=0.0000000
        mColor=(R=0,G=0,B=0,A=0)
    }
};

struct native TextureDimensionsHelper
{
    var @NULL Outer;
    var @NULL inner;
    var @NULL Offset;

    structdefaultproperties
    {
        Outer=(X=0.0000000,Y=0.0000000)
        inner=(X=0.0000000,Y=0.0000000)
        Offset=(X=0.0000000,Y=0.0000000)
    }
};

var @NULL mRankInformation;
var array mHeaderColumns;
var array mColumnInformation;
var private int mNumHeaderRows;
var float mLastRefreshed;
var protected float mRefreshTimer;
var private @NULL mController;
var private bool mScoreBasedGame;
var bool mbIsACTFGame;
var bool mbIsTeamGame;
var bool bAllowPlayerDismissal;
var @NULL mBlackTopBar;
var @NULL mBackGrid;
var @NULL mTeamBoxes[2];
var @NULL mSpeakingTexture;
var @NULL mMuteTexture;
var @NULL mBGGradient;
var byte mColumn4;
var @NULL mTeamAndPlayerStatistics;
var @NULL mMiscHeaderFont;
var @NULL mHeaderFont;
var @NULL mDataFont;
var @NULL mLocalPlayerFontColor;
var @NULL mLocalPlayerFontColorDead;
var @NULL mNonLocalPlayerFontColor;
var @NULL mNonLocalPlayerFontColorDead;
var @NULL mTeamFontColor;
var string mPlayerWonString;
var string mTeamWonString;
var string mScoreToWinString;
var string mRespawnInString;
var string mGameName;
var string mACTFHeaderInfo;
var string mACTFHeaderInfoTied;
var @NULL TopBarDimensions;
var @NULL RowArtDimensions;
var @NULL BGArtDimensions;
var @NULL TeamBoxDimension;
var @NULL SpeakingArtDimension;
var @NULL TeamInfoBGDimension;
var float IndividualRowHeight;
var float HeaderRegionHeight;
var float BodyRegionHeight;
var int GameNameHash;
var int mCurHighlightIndex;
var @NULL mHighlightBarCentre;
var @NULL mHighlightBarLeft;
var @NULL mHighlightBarRight;
var @NULL mHighlightBarCentreDimensions;
var @NULL mHighlightBarLeftDimensions;
var @NULL mHighlightBarRightDimensions;
var string mViewGamercardString;
var @NULL mRBButton;
var @NULL mRBButtonSD;
var @NULL mRBButtonDimensions;
var @NULL mRBButtonSDDimensions;
var string mWolfpackName;
var string mWhiskeyName;
var string mTeamString;
var string mPlayerString;
var string mScoreString;
var string mGameNameString;
var string mRespawnText;
var string mSeriesStatsString;
var string mTempHeaderString;
var string mTempColDataString;
var string mTempFooterString;

// Export UTurokHudStats::execInit(FFrame&, void* const)
native function Init(@NULL hudRef);

// Export UTurokHudStats::execReset(FFrame&, void* const)
native function Reset();

// Export UTurokHudStats::execDraw(FFrame&, void* const)
native function Draw();

event InitUC()
{
    mbIsACTFGame = false;
    // End:0x2E
    if(TurokDMHud(mHud) != none)
    {
        GameNameHash = 1440734140;
        mColumn4 = 0;        
    }
    else
    {
        // End:0x54
        if(TurokTeamDMHud(mHud) != none)
        {
            GameNameHash = 729593930;
            mColumn4 = 0;            
        }
        else
        {
            // End:0x7A
            if(TurokCoopGameHud(mHud) != none)
            {
                GameNameHash = 1864484446;
                mColumn4 = 0;                
            }
            else
            {
                // End:0xA8
                if(TurokAssaultCTFHud(mHud) != none)
                {
                    mbIsACTFGame = true;
                    GameNameHash = 427336396;
                    mColumn4 = 1;                    
                }
                else
                {
                    // End:0xCE
                    if(TurokCTFHud(mHud) != none)
                    {
                        GameNameHash = 1326968103;
                        mColumn4 = 1;                        
                    }
                    else
                    {
                        // End:0xF4
                        if(TurokWarGameHud(mHud) != none)
                        {
                            mColumn4 = 2;
                            GameNameHash = 389650655;                            
                        }
                        else
                        {
                            GameNameHash = 1440734140;
                        }
                    }
                }
            }
        }
    }
    switch(mColumn4)
    {
        // End:0x126
        case 0:
            mHeaderColumns[4].mStringHash = 1140952803;
            // End:0x169
            break;
        // End:0x146
        case 1:
            mHeaderColumns[4].mStringHash = -1725928246;
            // End:0x169
            break;
        // End:0x166
        case 2:
            mHeaderColumns[4].mStringHash = 343579128;
            // End:0x169
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

event bool PlayerIsDead(@NULL PlayerController)
{
    return PlayerController.IsDead();
    //return ReturnValue;    
}

// Export UTurokHudStats::execResetHighlightIndex(FFrame&, void* const)
native function ResetHighlightIndex();

// Export UTurokHudStats::execScrollUp(FFrame&, void* const)
native function ScrollUp();

// Export UTurokHudStats::execScrollDown(FFrame&, void* const)
native function ScrollDown();

// Export UTurokHudStats::execShowGamercard(FFrame&, void* const)
native function ShowGamercard();

defaultproperties
{
    mHeaderColumns=/* Array type was not detected. */
    mColumnInformation=/* Array type was not detected. */
    mRefreshTimer=2.0000000
    mScoreBasedGame=true
    bAllowPlayerDismissal=true
    mBlackTopBar=Texture2D'TurokHudStats.GoldTopbartga'
    mBackGrid=Texture2D'TurokHudStats.StatsInGame_BGstripes'
    mTeamBoxes[0]=Texture2D'TurokHudStats.RedTeamBoxes'
    mTeamBoxes[1]=Texture2D'TurokHudStats.BlueTeamBoxes'
    mSpeakingTexture=Texture2D'TurokFEMultiplayer.SpeechBubble'
    mMuteTexture=Texture2D'TurokFEMultiplayer.NoSpeechBubble'
    mBGGradient=Texture2D'TurokHudStats.Stats_BGgradient_Small'
    mMiscHeaderFont=(mFont=TurokFont'TurokFontsNew.TurokTransferEGauge',mScale=0.2390000,mHeight=19.0000000,mColor=(R=217,G=186,B=136,A=255))
    mHeaderFont=(mFont=TurokFont'TurokFontsNew.TurokTransferEGauge',mScale=0.2390000,mHeight=15.0000000,mColor=(R=87,G=75,B=55,A=255))
    mDataFont=(mFont=TurokFont'TurokFontsNew.TurokConduitTCBold',mScale=0.9500000,mHeight=30.0000000,mColor=(R=217,G=186,B=136,A=255))
    mLocalPlayerFontColor=(R=255,G=166,B=0,A=230)
    mLocalPlayerFontColorDead=(R=148,G=96,B=0,A=230)
    mNonLocalPlayerFontColor=(R=216,G=186,B=137,A=230)
    mNonLocalPlayerFontColorDead=(R=87,G=75,B=55,A=230)
    mTeamFontColor=(R=217,G=185,B=136,A=255)
    TopBarDimensions=(Outer=(X=680.0000000,Y=3.0000000),inner=(X=1024.0000000,Y=3.0000000),Offset=(X=0.0000000,Y=4.0000000))
    RowArtDimensions=(Outer=(X=640.0000000,Y=54.0000000),inner=(X=512.0000000,Y=54.0000000),Offset=(X=0.0000000,Y=0.0000000))
    BGArtDimensions=(Outer=(X=1024.0000000,Y=720.0000000),inner=(X=1024.0000000,Y=1.0000000),Offset=(X=0.0000000,Y=0.0000000))
    TeamBoxDimension=(Outer=(X=32.0000000,Y=32.0000000),inner=(X=32.0000000,Y=32.0000000),Offset=(X=0.0000000,Y=0.0000000))
    SpeakingArtDimension=(Outer=(X=32.0000000,Y=32.0000000),inner=(X=32.0000000,Y=32.0000000),Offset=(X=0.0000000,Y=0.0000000))
    TeamInfoBGDimension=(Outer=(X=1024.0000000,Y=54.0000000),inner=(X=512.0000000,Y=1.0000000),Offset=(X=0.0000000,Y=0.0000000))
    mHighlightBarCentre=Texture2D'TurokFEStats.Kills.RedHilightBar'
    mHighlightBarLeft=Texture2D'TurokFEStats.Kills.RedHilightBar_Left'
    mHighlightBarRight=Texture2D'TurokFEStats.Kills.RedHilightBar_Right'
    mHighlightBarCentreDimensions=(Outer=(X=576.0000000,Y=33.0000000),inner=(X=32.0000000,Y=32.0000000),Offset=(X=0.0000000,Y=0.0000000))
    mHighlightBarLeftDimensions=(Outer=(X=32.0000000,Y=33.0000000),inner=(X=32.0000000,Y=32.0000000),Offset=(X=0.0000000,Y=0.0000000))
    mHighlightBarRightDimensions=(Outer=(X=32.0000000,Y=33.0000000),inner=(X=32.0000000,Y=32.0000000),Offset=(X=0.0000000,Y=0.0000000))
    mRBButton=Texture2D'TurokFEHelpBar.Help_360_RB_HD'
    mRBButtonSD=Texture2D'TurokFEHelpBar_SD.Help_360_RB'
    mRBButtonDimensions=(Outer=(X=32.0000000,Y=32.0000000),inner=(X=32.0000000,Y=32.0000000),Offset=(X=0.0000000,Y=0.0000000))
    mRBButtonSDDimensions=(Outer=(X=46.0000000,Y=36.0000000),inner=(X=46.0000000,Y=36.0000000),Offset=(X=9.0000000,Y=14.0000000))
}