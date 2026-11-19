class TurokHudWinLossText extends TurokHudElement
    transient
    native;

struct native LineInfo
{
    var int Leading;
    var float Scale;
    var @NULL CachedPosition;
    var string String;

    structdefaultproperties
    {
        Leading=0
        Scale=0.0000000
        CachedPosition=(X=0.0000000,Y=0.0000000)
        String=""
    }
};

var private string mWinningPlayerFormatString;
var private string mWinningTeamFormatString;
var private @NULL mWolfPackLogo;
var private @NULL mWhiskeyLogo;
var private @NULL mLogoPosition;
var private @NULL mTextFont;
var private byte mWinningReason;
var private bool bTeamGame;
var private int mWinningTeamIndex;
var private string mWinningPlayer;
var private @NULL mLineInfo[3];
var private int mWinningReasonHashes[4];
var private int mTeamTitleNames[2];
var private @NULL mTeamTextColor[2];
var private @NULL mTextColor;
var private @NULL mBackgroundGradient;

// Export UTurokHudWinLossText::execSet(FFrame&, void* const)
native function Set(byte WinningReason, bool GameOver, byte WinningTeam, string winningPlayer, int gameTypeHash);

// Export UTurokHudWinLossText::execInit(FFrame&, void* const)
native function Init(@NULL hudRef);

// Export UTurokHudWinLossText::execInitialize(FFrame&, void* const)
native function Initialize();

// Export UTurokHudWinLossText::execDraw(FFrame&, void* const)
native function Draw();

// Export UTurokHudWinLossText::execTeardown(FFrame&, void* const)
native function Teardown();

// Export UTurokHudWinLossText::execRestoreColorCube(FFrame&, void* const)
native function RestoreColorCube();

defaultproperties
{
    mWolfPackLogo=Texture2D'TurokHudMultiplayer.EndOfMatch_WolfPack'
    mWhiskeyLogo=Texture2D'TurokHudMultiplayer.EndOfMatch_WhiskeyCo'
    mTextFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mLineInfo[0]=(Leading=5,Scale=0.9700000,CachedPosition=(X=0.0000000,Y=0.0000000),String="")
    mLineInfo[1]=(Leading=5,Scale=0.5400000,CachedPosition=(X=0.0000000,Y=0.0000000),String="")
    mLineInfo[2]=(Leading=0,Scale=0.3900000,CachedPosition=(X=0.0000000,Y=0.0000000),String="")
    mWinningReasonHashes[0]=661658297
    mWinningReasonHashes[1]=661658297
    mWinningReasonHashes[2]=1188153761
    mWinningReasonHashes[3]=-164235727
    mTeamTitleNames[0]=-1849682564
    mTeamTitleNames[1]=1533485293
    mTeamTextColor[0]=(R=255,G=163,B=0,A=255)
    mTeamTextColor[1]=(R=92,G=181,B=246,A=255)
    mTextColor=(R=198,G=242,B=243,A=255)
    mBackgroundGradient=Texture2D'TurokFEStats.Stats_BGgradient_Large'
}