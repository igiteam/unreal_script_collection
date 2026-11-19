class SPRTPColorShift extends SPRenderTargetProxy
    native;

var Texture2D ShiftImage;
var Color StartColor;
var array<Color> DestColor;
var Color CurColor;
var int CurIndex;
var float Per;
var float delay;
var float LastUpdateTime;

// Export USPRTPColorShift::execUpdateProxyData(FFrame&, void* const)
native function UpdateProxyData();
