class MessageAICharacterComplied extends Engine.Message
	editinlinenew;

var Name AI;

// construct
overloaded function construct(Name inAI)
{
    AI = inAI;
}

// editorDisplay
static function string editorDisplay(Name triggeredBy, Message filter)
{
	return "An AICharacter (Enemy or Hostage) Complies.";
}






// Decompiled with UE Explorer.
defaultproperties
{
    specificTo=Class'SwatAICharacter'
}