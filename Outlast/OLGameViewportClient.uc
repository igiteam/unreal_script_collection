class OLGameViewportClient extends UDKGameViewportClient
	native;

cpptext
{
	virtual UBOOL InputKey(FViewport* Viewport,INT ControllerId,FName Key,EInputEvent EventType,FLOAT AmountDepressed=1.f,UBOOL bGamepad=FALSE);
}


function DrawTransition(Canvas Canvas)
{
	// this space intentionally left blank.
}
