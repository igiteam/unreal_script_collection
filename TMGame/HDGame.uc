//-----------------------------------------------------------
// HD???????????????????
//-----------------------------------------------------------
class HDGame extends TMGame;

//
// Set gameplay speed.
//
//function SetGameSpeed( float T )
//{
//	local float TimeDilation;
//
//	TimeDilation = bConsoleServer ? 0.95 : 1.05;  //default is 1.0
//	GameSpeed = FMax(T, 0.1);
//	WorldInfo.TimeDilation = TimeDilation * GameSpeed;
//
//	SetTimer(WorldInfo.TimeDilation, true);   //GameLoop is in function Timer()
//}

/** return a value based on how much this pawn needs help */
function int GetHandicapNeed(Pawn Other)
{
	return 0;
}

//Script Notify Kismet
//???????????Event????Actor::TriggerGlobalEventClass
final simulated function bool ActiveKismetEvent(name EventName, optional Actor InInstigator)
{
	local array<SequenceObject> EventsToActivate;
	local Sequence GameSeq;
	local SeqEvent_RemoteEvent CurEvent;
	local bool bResult;
	local int i;

	GameSeq = WorldInfo.GetGameSequence();
	if(GameSeq != None)
	{
		GameSeq.FindSeqObjectsByClass(class'SeqEvent_RemoteEvent', true, EventsToActivate);
		for(i = 0; i < EventsToActivate.length; i++)
		{
			CurEvent = SeqEvent_RemoteEvent(EventsToActivate[i]);
			if(CurEvent.EventName == EventName)
			{
				bResult = CurEvent.CheckActivate(WorldInfo, InInstigator);
				break; //?????!
			}
		}
	}

	return bResult;
}

//Kismet Notify Script
function MessageFromKismet(const out name Type, const out string Value);


