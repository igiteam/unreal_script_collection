class EvilComboManager extends Object within EvilPlayerController
    classgroup(Combos);

enum EComboEventResult
{
    CER_Miss,                       // 0
    CER_Hit,                        // 1
    CER_Finished,                   // 2
    CER_MAX                         // 3
};

struct ComboState
{
    var EvilComboDef Def;
    var int Step;
    var float Time;
    var EvilPawn FirstOther;

    structdefaultproperties
    {
        Def=none
        Step=0
        Time=0.0000000
        FirstOther=none
    }
};

struct ComboActionState
{
    var EvilComboDef Def;
    var EvilPawn FirstOther;
    var EvilTypes.EBodyParts BodyPart;
    var Vector Location;
    var int ActionIndex;
    var float Time;

    structdefaultproperties
    {
        Def=none
        FirstOther=none
        BodyPart=EBodyParts.BP_Head
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ActionIndex=0
        Time=0.0000000
    }
};

var array<ComboState> States;
var array<ComboActionState> ActionStates;
var array<SequenceObject> AllComboEvents;

private final function bool ServerHandleEvent(name Type, EvilPawn Other, optional Vector Loc, optional class<DamageType> dmgType, optional EvilTypes.EBodyParts BodyPart, optional bool directHit)
{
    local EvilComboDef CD;
    local int I, J, stepBackup;
    local ComboState S;
    local ComboActionState A;
    local SequenceObject SO;
    local SeqEvent_ComboAction ComboEvt;
    local Sequence GameSeq;
    local EvilComboManager.EComboEventResult CER;
    local bool Retval;
    local EvilTypes.ECombatActionType CAT;

    PruneOldStates();
    // End:0x99
    if(((Other != none) && EvilAIController(Other.Controller) != none) && EvilAIController(Other.Controller).IsFriendly(Outer))
    {
        return false;
    }
    Retval = false;
    // End:0x168
    if(((Outer.WorldInfo == none) || Outer.WorldInfo.Game == none) || EvilGame(Outer.WorldInfo.Game).ComboSetArchetype == none)
    {
        return Retval;
    }
    // End:0xD70
    foreach EvilGame(Outer.WorldInfo.Game).ComboSetArchetype.Combos(CD)
    {
        // End:0x1FE
        if(States.Length < 1)
        {
            I = -1;            
        }
        else
        {
            // End:0x2F9
            if(CD.bOnlyOneTarget && Other != none)
            {
                I = 0;
                J0x23C:

                // End:0x2CF [Loop If]
                if(I < States.Length)
                {
                    // End:0x2C1
                    if((States[I].Def == CD) && States[I].FirstOther == Other)
                    {
                        // [Explicit Break]
                        goto J0x2CF;
                    }
                    ++I;
                    // [Loop Continue]
                    goto J0x23C;
                }
                J0x2CF:

                // End:0x2F6
                if(I >= States.Length)
                {
                    I = -1;
                }                
            }
            else
            {
                I = States.Find('Def', CD);
            }
        }
        // End:0x351
        if(I >= 0)
        {
            S = States[I];            
        }
        else
        {
            S.Def = CD;
            S.Step = 0;
            S.Time = Outer.WorldInfo.TimeSeconds;
            S.FirstOther = none;
        }
        stepBackup = S.Step;
        CER = CD.HandleEvent(S, Type, ((Outer.Pawn.IsA('Vehicle')) ? EvilPawn(Vehicle(Outer.Pawn).Driver) : Outer.MyEvilPawn), Other, Loc, dmgType, BodyPart, directHit);
        // End:0xD08
        if(int(CER) > int(0))
        {
            Retval = true;
            // End:0x80B
            if(int(CER) == int(2))
            {
                Outer.ClientShowComboNotification(CD);
                A.Def = CD;
                A.FirstOther = S.FirstOther;
                A.BodyPart = BodyPart;
                A.Location = Loc;
                A.ActionIndex = 0;
                A.Time = Outer.WorldInfo.TimeSeconds;
                ActionStates.AddItem(A);
                // End:0x733
                if(Outer.MyEvilPawn != none)
                {
                    Outer.MyEvilPawn.AddComboBonus(CD.PlasmaBonus);                    
                }
                else
                {
                    // End:0x7E4
                    if(Outer.Pawn.IsA('Vehicle'))
                    {
                        EvilPawn(Vehicle(Outer.Pawn).Driver).AddComboBonus(CD.PlasmaBonus);
                    }
                }
                // End:0x808
                if(I >= 0)
                {
                    States.Remove(I, 1);
                }                
            }
            else
            {
                J = S.Step;
                J0x831:

                // End:0x975 [Loop If]
                if(S.Def.Events[J].IsA('EvilComboEvent_CombatAction'))
                {
                    // End:0x974
                    foreach EvilComboEvent_CombatAction(S.Def.Events[J]).CombatActionTypes(CAT)
                    {
                        Outer.NotifyPossibleInputHijack(CAT, Other, 150.0000000, S.Def.Events[stepBackup].TimeOut);                        
                    }                    
                }
                ++J;
                // End:0x831
                if(!((J >= S.Def.Events.Length) || !S.Def.Events[J].bOrNextOne))
                    goto J0x831;
            }
            // End:0xAA7
            if(AllComboEvents.Length < 1)
            {
                GameSeq = Outer.WorldInfo.GetGameSequence();
                // End:0xAA7
                if(GameSeq != none)
                {
                    GameSeq.FindSeqObjectsByClass(Class'SeqEvent_ComboAction', true, AllComboEvents);
                }
            }
            // End:0xD07
            foreach AllComboEvents(SO)
            {
                ComboEvt = SeqEvent_ComboAction(SO);
                // End:0xD06
                if(((ComboEvt != none) && ComboEvt.ComboDef == CD) && ((int(CER) == int(2)) && ComboEvt.StepName == 'None') || (ComboEvt.StepName == CD.Events[stepBackup].StepName) && CD.Events[stepBackup].StepName != 'None')
                {
                    ComboEvt.Target = S.FirstOther;
                    ComboEvt.Location = Loc;
                    ComboEvt.HitBodyPart = string(BodyPart);
                    ComboEvt.DamageType = dmgType;
                    ComboEvt.CheckActivate(S.FirstOther, Outer);
                }                
            }            
        }
        // End:0xD37
        if(I >= 0)
        {
            States[I] = S;            
        }
        else
        {
            // End:0xD6F
            if(S.Step > 0)
            {
                States.AddItem(S);
            }
        }        
    }    
    return Retval;
    //return ReturnValue;    
}

simulated function bool HandleEvent(name Type, EvilPawn Other, optional Vector Loc, optional class<DamageType> dmgType, optional EvilTypes.EBodyParts BodyPart, optional bool directHit)
{
    return ServerHandleEvent(Type, Other, Loc, dmgType, BodyPart, directHit);
    //return ReturnValue;    
}

function PruneOldStates()
{
    local int I;

    I = States.Length - 1;
    J0x17:

    // End:0x126 [Loop If]
    if(I >= 0)
    {
        // End:0x118
        if((Outer.WorldInfo.TimeSeconds - States[I].Time) > States[I].Def.Events[Max(0, States[I].Step - 1)].TimeOut)
        {
            States.Remove(I, 1);
        }
        --I;
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}
