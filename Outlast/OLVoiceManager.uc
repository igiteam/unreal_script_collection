class OLVoiceManager extends Object
	native
	inherits(FTickableObject)
	config(Game)
	implements(Interface_AkEventHandler);

var config array<name> VOPackages;

struct native VOLine
{
	var AkEvent Line;
	var name	BoneName;
	var float TimeFired;
	var float EndOfLineBuffer;
	var int PlayingID;
	var bool bSkipForPaused;

	var int CallbackFlags;
	var native pointer CallbackFunction{void};
	var native pointer CallbackCookie{void};
};

struct native LineQueue
{
	var Actor Talker;
	var init native array<VOLine> Lines;
	var bool IsPlaying;
	var bool IsWaiting;
	var bool CancelWait;

	structcpptext
	{
		FLineQueue()
		{
			appMemzero(this, sizeof(FLineQueue));
		}
		FLineQueue(EEventParm)
		{
			appMemzero(this, sizeof(FLineQueue));
		}
	}
};

var array<LineQueue> LineQueues;

struct native QueueTimer
{
	var Actor QueueActor;
	var float TimeRemaining;
};

var array<QueueTimer> Timers;

struct native EndOfEventInfo
{
	var Actor QueueActor;
	var int PlayingID;
};

var array<EndOfEventInfo> EventCallbacksToProcess;

struct native MarkerInfo
{
	var Actor QueueActor;
	var string MarkerText;
};

var array<MarkerInfo> MarkerCallbacksToProcess;

var native pointer CriticalSection{FCriticalSection};

cpptext
{
	// Interface_AkEventHandler
	virtual UBOOL HandleEvent(
		class UAkEvent * in_pEvent, 
		AActor * in_pActor, 
		FName in_nameBone,
		AkPlayingID& out_iPlayingID, 
		AkUInt32 in_uFlags = 0,						///< Bitmask: see \ref AkCallbackType
		AkCallbackFunc in_pfnCallback = NULL,		///< Callback function
		void * in_pCookie = NULL,					///< Callback cookie that will be sent to the callback function along with additional information.
		bool in_bStopWhenOwnerDestroyed = false
		);

	void Init();
	void Deinit();

	virtual void Tick(FLOAT DeltaTime);
	
	virtual UBOOL IsTickable() const 
	{
		return !HasAnyFlags( RF_Unreachable | RF_AsyncLoading ); 
	}

	void AddEndOfEventCallbackToProcess(class AActor* anActor, INT PlayingID);
	void AddMarkerCallbackToProcess(class AActor* anActor, FString MarkerText);

	void PlayVOLine(
		AActor* aPawn,
		UAkEvent* LineToPlay,
		FName BoneName,
		AkPlayingID& out_iPlayingID,
		AkUInt32 in_uFlags = 0,						///< Bitmask: see \ref AkCallbackType
		AkCallbackFunc in_pfnCallback = NULL,		///< Callback function
		void * in_pCookie = NULL					///< Callback cookie that will be sent to the callback function along with additional information.
		);

	void ClearVOQueue(AActor* anActor, UBOOL bForce = FALSE);

	void ClearAllVOQueues();

	FLineQueue* GetQueueFromActor(class AActor* QueueActor);

protected:
	void HandleEventCallback(struct FEndOfEventInfo CallbackInfo);
	void HandleMarkerCallback(struct FMarkerInfo CallbackInfo);
	AkPlayingID PlayNextLine(class AActor* QueueActor);

	void AddQueueTimer(class AActor* QueueActor, FLOAT Time);
	void StopQueueTimer(class AActor* QueueActor);

	void RemoveQueue(INT QueueIndex);

	void HandleCallbacks();
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local array<float> ColumnPos;
	local Color DrawColor;
	local int i, j;
	local LineQueue CurrentQueue;
	local VOLine CurrentLine;

	DrawColor = MakeColor(255,86,26);

	ColumnPos[0] = 8;
	ColumnPos[1] = ColumnPos[0] + 400;
	ColumnPos[2] = ColumnPos[1] + 120;
	ColumnPos[3] = ColumnPos[2] + 200;
	ColumnPos[4] = ColumnPos[3] + 300;

	HUD.Canvas.SetDrawColorStruct(DrawColor);

	out_YPos += out_YL; // Add Buffer From Top.
	HUD.Canvas.SetPos(8,out_YPos);

	HUD.Canvas.DrawText("Voice Manager", true, 1.5, 1.5);
	out_YPos += out_YL*1.5;

	HUD.Canvas.SetPos(ColumnPos[0],out_YPos);
	HUD.Canvas.DrawText("Queue Name");
	HUD.Canvas.SetPos(ColumnPos[1],out_YPos);
	HUD.Canvas.DrawText("IsPlaying (PlayingID)");
	HUD.Canvas.SetPos(ColumnPos[2],out_YPos);
	HUD.Canvas.DrawText("IsWaiting (Timer)");
	HUD.Canvas.SetPos(ColumnPos[3],out_YPos);
	HUD.Canvas.DrawText("Event Name");
	HUD.Canvas.SetPos(ColumnPos[4],out_YPos);
	HUD.Canvas.DrawText("Buffer Length");

	out_YPos += out_YL;
	HUD.Canvas.Draw2DLine(6, out_YPos, ColumnPos[4]+100, out_YPos, DrawColor);
	out_YPos += 4;

	for (i = 0; i < LineQueues.length; i++)
	{
		CurrentQueue = LineQueues[i];

		HUD.Canvas.SetPos(ColumnPos[0],out_YPos);
		HUD.Canvas.DrawText(CurrentQueue.Talker.GetDebugName());
		HUD.Canvas.SetPos(ColumnPos[1],out_YPos);
		HUD.Canvas.DrawText((CurrentQueue.IsPlaying ? "True (" $ CurrentQueue.Lines[0].PlayingID $ ")" : "False"));

		HUD.Canvas.SetPos(ColumnPos[2],out_YPos);
		if (CurrentQueue.IsWaiting)
		{
			for (j = 0; j < Timers.length; j++)
			{
				if (Timers[j].QueueActor == CurrentQueue.Talker)
				{
					HUD.Canvas.DrawText("True (" $ Timers[j].TimeRemaining $ ")");
				}
			}
		}
		else
		{
			HUD.Canvas.DrawText("False");
		}

		if (CurrentQueue.Lines.length == 0)
		{
			out_YPos += out_YL;
		}
		else
		{
			for (j = 0; j < CurrentQueue.Lines.length; j++)
			{
				CurrentLine = CurrentQueue.Lines[j];

				HUD.Canvas.SetPos(ColumnPos[3],out_YPos);
				HUD.Canvas.DrawText(CurrentLine.Line.Name);
				HUD.Canvas.SetPos(ColumnPos[4],out_YPos);
				HUD.Canvas.DrawText(CurrentLine.EndOfLineBuffer);

				out_YPos += out_YL;
			}
		}
	}
}

defaultproperties
{
}