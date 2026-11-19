class TurokFELoadingScreenMultiplayerExit extends TurokFELoadingScreen
    native;

var @NULL mLoadingMapTex;
var @NULL mLoadingBgTex;
var @NULL mLoadingMatFlipbook;
var @NULL mTexFlipbook;
var @NULL mLoadingFont;
var float mLoadingTextScale;
var string mLoadingText;

// Export UTurokFELoadingScreenMultiplayerExit::execInit(FFrame&, void* const)
native function Init(@NULL ViewportClient);

defaultproperties
{
    mLoadingBgTex=Texture2D'TurokFELoading.MPLoadingBG_HD'
    mLoadingMatFlipbook=Material'TurokFELoading.LoadingIndicator'
    mTexFlipbook=TextureFlipBook'TurokFELoading.LoadingIndicatorFlipbook'
    mLoadingFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mLoadingTextScale=0.2690000
}