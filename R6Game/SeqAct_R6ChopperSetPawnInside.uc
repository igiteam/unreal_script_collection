class SeqAct_R6ChopperSetPawnInside extends SequenceAction
    native
    hidecategories(Object);

var() R6EngineEnums.EChopperPawns m_ePawnInFourthSeat;
var() R6EngineEnums.EChopperPawns m_ePawnInPilotSeat;
var() R6EngineEnums.EChopperPawns m_ePawnInCoPilotSeat;
var() R6CharacterTemplate m_CharaterTemplateInFourthSeat;
var() R6CharacterTemplate m_CharaterTemplateInPilotSeat;
var() R6CharacterTemplate m_CharaterTemplateInCoPilotSeat;

defaultproperties
{
    m_ePawnInFourthSeat=2
    m_ePawnInPilotSeat=3
    bCallHandler=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Helicopter",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Set Extra Pawns Inside"
    ObjCategory="Helicopter"
}