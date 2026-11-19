class Procedures extends Core.Object
    config(Leadership);
    //not perObjectConfig

var private config array< class<Procedure> > ProcedureClass;

//dkaplan: made public to allow SwatGameInfo to update the GameReplicationInfo
var array<Procedure> Procedures;

var private transient SwatGameInfo Game;

Overloaded function Construct()
{
    local Procedure CurrentProcedure;
    local int i;

    for (i=0; i<ProcedureClass.length; ++i)
    {
        AssertWithDescription(ProcedureClass[i] != None,
            "[tcohen] ProcedureClass index "$i
            $" in the "$class.name
            $" configuration file is not a valid Procedure class.");

        CurrentProcedure = new(None, string(ProcedureClass[i].name), 0) ProcedureClass[i]();

        assert(CurrentProcedure != None);
        assert(CurrentProcedure.IsA(ProcedureClass[i].name));  //TMC test Karl's bugfix for constructors from dynamic types

        Procedures[Procedures.length] = CurrentProcedure;
    }
}

final function Init(SwatGameInfo GameInfo)
{
    local int i;

    assert(GameInfo != None);
    Game = GameInfo;

    for (i=0; i<Procedures.length; ++i)
    {
        Procedures[i].Init(Game);
    }
}

function bool ProceduresMaxed()
{
    local int i;
    
    for( i = 0; i < Procedures.Length; i++ )
    {
        if( !Procedures[i].IsMaxed() )
            return false;
    }
    
    return true;
}

// Decompiled with UE Explorer.
defaultproperties
{
    ProcedureClass[0]=Class'SwatProcedures.Procedure_CompleteMission'
    ProcedureClass[1]=Class'SwatProcedures.Procedure_ArrestUnIncapacitatedSuspects'
    ProcedureClass[2]=Class'SwatProcedures.Procedure_ArrestIncapacitatedSuspects'
    ProcedureClass[3]=Class'SwatProcedures.Procedure_KillSuspects'
    ProcedureClass[4]=Class'SwatProcedures.Procedure_NoSuspectsNeutralized'
    ProcedureClass[5]=Class'SwatProcedures.Procedure_NoCiviliansInjured'
    ProcedureClass[6]=Class'SwatProcedures.Procedure_NoOfficersDown'
    ProcedureClass[7]=Class'SwatProcedures.Procedure_PlayerUninjured'
    ProcedureClass[8]=Class'SwatProcedures.Procedure_ReportCharactersToTOC'
    ProcedureClass[9]=Class'SwatProcedures.Procedure_SecureAllWeapons'
    ProcedureClass[10]=Class'SwatProcedures.Procedure_EvacuateDownedOfficers'
    ProcedureClass[11]=Class'SwatProcedures.Procedure_NoHostageIncapacitated'
    ProcedureClass[12]=Class'SwatProcedures.Procedure_NoHostageKilled'
    ProcedureClass[13]=Class'SwatProcedures.Procedure_NoOfficerIncapacitated'
    ProcedureClass[14]=Class'SwatProcedures.Procedure_NoOfficerInjured'
    ProcedureClass[15]=Class'SwatProcedures.Procedure_NoUnauthorizedUseOfDeadlyForce'
    ProcedureClass[16]=Class'SwatProcedures.Procedure_NoUnauthorizedUseOfForce'
}