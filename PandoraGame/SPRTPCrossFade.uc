class SPRTPCrossFade extends SPRenderTargetProxy
    native;

var Texture2D SrcImage;
var Texture2D DestImage;
var float Alpha;
var float delay;
var float LastUpdateTime;

// Export USPRTPCrossFade::execUpdateProxyData(FFrame&, void* const)
native function UpdateProxyData();
