class SPDAction_RandomBranch extends SPDAction
    native
    editinlinenew
    collapsecategories;

/** STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(SPDAction) export editinline array<export editinline SPDGenericActionList> OtherActionLists;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local int NumberOfActionsListsAvailable, SelectedList;
    local array<int> NonEmptyListIndices;
    local int I;

    NumberOfActionsListsAvailable = OtherActionLists.Length;
    I = 0;
    J0x13:

    // End:0x5E [Loop If]
    if(I < NumberOfActionsListsAvailable)
    {
        // End:0x54
        if(OtherActionLists[I].HasActions())
        {
            NonEmptyListIndices.Insert(0, 1);
            NonEmptyListIndices[0] = I;
        }
        ++I;
        // [Loop Continue]
        goto J0x13;
    }
    // End:0x6D
    if(NonEmptyListIndices.Length == 0)
    {
        return 1;
    }
    SelectedList = 1;
    SelectedList = Rand(NonEmptyListIndices.Length + 1);
    // End:0xD6
    if(SelectedList != 0)
    {
        SelectedList -= 1;
        SelectedList = NonEmptyListIndices[SelectedList];
        Manager.AddActionListWithDamageInfo(OtherActionLists[SelectedList], Actor, DamageInfo);
        return 2;
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    Action="Can randomly either just carry on to next action, or switch to one the embedded actions lists"
}