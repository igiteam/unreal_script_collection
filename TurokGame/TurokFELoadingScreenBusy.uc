class TurokFELoadingScreenBusy extends TurokFELoadingScreen
    native;

var @NULL mLoadingTexBGGlow;
var @NULL mTexBGGlowInfo;
var @NULL mLoadingMatFlipbook;
var @NULL mMatFlipbookInfo;
var @NULL mLoadingTexFlipbook;
var @NULL mLoadingFont;
var float mLoadingTextScale;
var string mLoadingText;
var bool mbDrawBGGlow;

// Export UTurokFELoadingScreenBusy::execInit(FFrame&, void* const)
native function Init(@NULL ViewportClient);

defaultproperties
{
    mLoadingTexBGGlow=Texture2D'TurokFELoading.Loading_BGGlowForCenterScreen'
    mTexBGGlowInfo=(xPrcnt=0.8750000,yPrcnt=0.8750000,U=128.0000000,V=128.0000000)
    mLoadingMatFlipbook=Material'TurokFELoading.LoadingIndicator'
    mMatFlipbookInfo=(xPrcnt=0.8750000,yPrcnt=0.8750000,U=32.0000000,V=32.0000000)
    mLoadingTexFlipbook=TextureFlipBook'TurokFELoading.LoadingIndicatorFlipbook'
    mLoadingFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mLoadingTextScale=0.2690000
}