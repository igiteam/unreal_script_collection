interface Interface_AkEventHandler
	native;

cpptext
{
	virtual UBOOL HandleEvent(
		class UAkEvent * in_pEvent, 
		AActor * in_pActor, 
		FName in_nameBone, 
		AkPlayingID& out_iPlayingID,
		AkUInt32 in_uFlags = 0,						///< Bitmask: see \ref AkCallbackType
		AkCallbackFunc in_pfnCallback = NULL,		///< Callback function
		void * in_pCookie = NULL,					///< Callback cookie that will be sent to the callback function along with additional information.
		bool in_bStopWhenOwnerDestroyed = false
		) = 0;
}