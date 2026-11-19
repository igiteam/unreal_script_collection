class MessagePawnArrested extends Engine.Message
	editinlinenew;

var Name Arrester;
var Name Arrestee;

// construct
overloaded function construct(Name inArrester, Name inArrestee)
{
    Arrester = inArrester;
    Arrestee = inArrestee;
}

// editorDisplay
static function string editorDisplay(Name triggeredBy, Message filter)
{
	return "A Pawn is Arrested";
}





// Decompiled with UE Explorer.
defaultproperties
{
    specificTo=Class'SwatPawn'
}