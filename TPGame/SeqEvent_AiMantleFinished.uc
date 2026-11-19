class SeqEvent_AiMantleFinished extends SequenceEvent;

var CoverInfo m_CoverSlotAt;
//var int m_SlotIdxToBeAt;
//var Object m_NodeToBeAt;
var () bool FireAtFirstTouchOfTheGround;

function CheckIfCorrespondingCoverSlotForFirstTouchOnGroundEvent( Actor inOriginator, Actor inInstigator, CoverInfo CoverSlotAt )
{
	local SeqVar_Object objVar;
	local SeqVar_Int intVar;
	local TPCoverNode possibleEventNode;
	
	m_CoverSlotAt = CoverSlotAt;

	if (inOriginator != None &&
		bEnabled &&
		!bPlayerOnly)
	{
		//`log(" ChadAI - SeqEvent_AiMantleFinished::CheckIfCorrespondingCoverSlotForFirstTouchOnGroundEvent CoverSlotAt: " @ CoverSlotAt.Link @ " slot: " @ CoverSlotAt.SlotIdx @ " -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");

		if( FireAtFirstTouchOfTheGround )
		{
			foreach LinkedVariables(class'SeqVar_Object', ObjVar, "Cover Node")
			{
					
				possibleEventNode = TPCoverNode(ObjVar.GetObjectValue());
										
				if( possibleEventNode != None )
				{
					if( possibleEventNode == CoverSlotAt.Link )
					{
						foreach LinkedVariables(class'SeqVar_Int', intVar, "Slot Idx")
						{
							if( intVar.IntValue == CoverSlotAt.SlotIdx )
							{
								//`log(" ChadAI - SeqEvent_AiMantleFinished::CheckIfCorrespondingCoverSlotForFirstTouchOnGroundEvent Calling CheckActivate with m_NodeToBeAt: " @ possibleEventNode @ " m_SlotIdxToBeAt: " @ intVar.IntValue @ " -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
								CheckActivate(inOriginator,inInstigator,false);
							}
						
						}				
			
					}
				}
			}
		} // if( FireAtFirstTouchOfTheGround )
		else
		{
			//`log(" ChadAI - SeqEvent_AiMantleFinished::CheckIfCorrespondingCoverSlotForFirstTouchOnGroundEvent  not first hitCoverSlotAt: " @ CoverSlotAt.Link @ " slot: " @ CoverSlotAt.SlotIdx @ " -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");

		}
	}
}

function CheckIfCorrespondingCoverSlot( Actor inOriginator, Actor inInstigator, CoverInfo CoverSlotAt )
{
	local SeqVar_Object objVar;
	local SeqVar_Int intVar;
	local TPCoverNode possibleEventNode;
	
	m_CoverSlotAt = CoverSlotAt;

	if (inOriginator != None &&
		bEnabled &&
		!bPlayerOnly)
	{

								

		//`log(" ChadAI - SeqEvent_AiMantleFinished::CheckIfCorrespondingCoverSlot CoverSlotAt: " @ CoverSlotAt.Link @ " slot: " @ CoverSlotAt.SlotIdx @ " -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");

		foreach LinkedVariables(class'SeqVar_Object', ObjVar, "Cover Node")
		{
				
			possibleEventNode = TPCoverNode(ObjVar.GetObjectValue());
									
			if( possibleEventNode != None )
			{
				if( possibleEventNode == CoverSlotAt.Link )
				{
					foreach LinkedVariables(class'SeqVar_Int', intVar, "Slot Idx")
					{
						if( intVar.IntValue == CoverSlotAt.SlotIdx )
						{
							//`log(" ChadAI - SeqEvent_AiMantleFinished::CheckIfCorrespondingCoverSlot Calling CheckActivate with m_NodeToBeAt: " @ possibleEventNode @ " m_SlotIdxToBeAt: " @ intVar.IntValue @ " -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
							CheckActivate(inOriginator,inInstigator,false);
						}
					
					}				
		
				}
			}
	
		}
	}
}

