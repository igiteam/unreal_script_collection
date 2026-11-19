class SeqEvent_AtCover extends SequenceEvent
	native;

var CoverInfo m_CoverSlotAt;
//var int m_SlotIdxToBeAt;
//var Object m_NodeToBeAt;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// function CheckIfCorrespondingCoverSlot( Actor inOriginator, Actor inInstigator, CoverInfo CoverSlotAt )
// {
// 	local SeqVar_Object objVar;
// 	local SeqVar_Int intVar;
// 	local TPCoverNode possibleEventNode;
// 	
// 	m_CoverSlotAt = CoverSlotAt;
// 
// 	if (inOriginator != None &&
// 		bEnabled &&
// 		!bPlayerOnly)
// 	{
// 	
// 	
// 		foreach LinkedVariables(class'SeqVar_Object', ObjVar, "Cover Node")
// 		{
// 				
// 			possibleEventNode = TPCoverNode(ObjVar.GetObjectValue());
// 			
// 			//`log(" ChadAI - SeqEvent_AtCover::CheckIfCorrespondingCoverSlot possibleEventNode: " @ possibleEventNode @ " -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 						
// 			if( possibleEventNode != None )
// 			{
// 				if( possibleEventNode == CoverSlotAt.Link )
// 				{
// 					foreach LinkedVariables(class'SeqVar_Int', intVar, "Slot Idx")
// 					{
// 						if( intVar.IntValue == CoverSlotAt.SlotIdx )
// 						{
// 							//`log(" ChadAI - SeqEvent_AtCover::CheckIfCorrespondingCoverSlot Calling CheckActivate with m_NodeToBeAt: " @ possibleEventNode @ " m_SlotIdxToBeAt: " @ intVar.IntValue @ " -&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!-&$#@!");
// 							CheckActivate(inOriginator,inInstigator,false);
// 						}
// 					
// 					}				
// 		
// 				}
// 			}
// 	
// 		}
// 	}
// }


// 	VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Damage Percent Taken",bWriteable=true)
// Taken from SeqEvent_TakeDamageTP
