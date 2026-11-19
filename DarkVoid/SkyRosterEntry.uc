class SkyRosterEntry extends Object
    editinlinenew;

var() class<SkyPawn> PawnClass;
var() string PawnClassName;
var() string PlayerName;
var() bool bTaken;

function Init()
{
    // End:0x28
    if(PawnClassName != "")
    {
        PawnClass = class<SkyPawn>(DynamicLoadObject(PawnClassName, Class'Core.Class'));
    }
    //return;    
}
