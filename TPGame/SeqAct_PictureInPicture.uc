class SeqAct_PictureInPicture extends SequenceAction
	dependson(PictureInPicture)
	deprecated;


//***********************************************************************
// Variable Declaration
//***********************************************************************


var() bool bEnablePiP;
var() PiPRenderShape renderShape;
var() float screenWidth;
var() float screenHeight;
var() float timeOut;
var() float transitionTime;

var() Material RenderToTextureMaterial;

//***********************************************************************
// CPP Text
//***********************************************************************


//***********************************************************************
// Default Properties
//***********************************************************************
