class TurokFELoadingScreenStoryMode extends TurokFELoadingScreen
    native;

var @NULL mLoadingTexBlack;
var @NULL mLoadingMatT;
var @NULL mLoadingMatFlipbook;
var @NULL mTexFlipbook;
var @NULL mMatTInfo;
var @NULL mMatFlipbookInfo;
var @NULL mLoadingFont;
var float mLoadingTextScale;
var string mLoadingText;
var float mTipTextScale;
var string mTipText;
var string mTipText2;
var bool mUse2ndLine;
var int mTipSelected;
var float fTipLength;
var float fTipTime;

// Export UTurokFELoadingScreenStoryMode::execInit(FFrame&, void* const)
native function Init(@NULL ViewportClient);

defaultproperties
{
    mLoadingTexBlack=Texture2D'EngineResources.Black'
    mLoadingMatT=Material'TurokFELoading.TurokLoadingMat'
    mLoadingMatFlipbook=Material'TurokFELoading.LoadingIndicator'
    mTexFlipbook=TextureFlipBook'TurokFELoading.LoadingIndicatorFlipbook'
    mMatTInfo=(xPrcnt=0.5000000,yPrcnt=0.2375000,U=1024.0000000,V=256.0000000)
    mMatFlipbookInfo=(xPrcnt=0.9200000,yPrcnt=0.9200000,U=32.0000000,V=32.0000000)
    mLoadingFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mLoadingTextScale=0.2690000
    mTipTextScale=0.3130000
    fTipLength=5.0000000
}