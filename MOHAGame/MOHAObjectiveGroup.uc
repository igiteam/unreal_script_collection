class MOHAObjectiveGroup extends MOHAObjective
    native
    placeable
    hidecategories(Navigation);

var(Objective) array<EALAObjective> SubObjectives;

function OnUpdateMissionObjective(SeqAct_UpdateMissionObjective Action)
{
    //return;    
}

function PostBeginPlay()
{
    local int I;

    super(EALAObjective).PostBeginPlay();
    I = 0;
    J0x0D:

    // End:0x3D [Loop If]
    if(I < SubObjectives.Length)
    {
        SubObjectives[I].ParentObjective = self;
        I++;
        // [Loop Continue]
        goto J0x0D;
    }
    //return;    
}

function SubObjectiveAdded()
{
    // End:0x12
    if(int(ObjectiveStatus) != int(0))
    {
        return;
    }
    OnGroupObjectiveAdded();
    //return;    
}

function SubObjectiveChangedStatus(EALAObjective.EObjectiveStatus newStatus)
{
    local bool bSuccess;
    local int I;

    // End:0x12
    if(int(ObjectiveStatus) != int(1))
    {
        return;
    }
    // End:0x2C
    if(int(newStatus) == int(3))
    {
        OnGroupObjectiveFailed();
    }
    // End:0x9F
    if(int(newStatus) == int(2))
    {
        bSuccess = true;
        I = 0;
        J0x4B:

        // End:0x8C [Loop If]
        if(I < SubObjectives.Length)
        {
            // End:0x82
            if(int(SubObjectives[I].ObjectiveStatus) != int(2))
            {
                bSuccess = false;
            }
            I++;
            // [Loop Continue]
            goto J0x4B;
        }
        // End:0x9F
        if(bSuccess)
        {
            OnGroupObjectiveSucceeded();
        }
    }
    //return;    
}

function OnGroupObjectiveAdded()
{
    LogDisplayString = Prompts.LogBookString;
    AddToManager(Prompts.ActivateString, GetNewObjectiveTitle());
    //return;    
}

function OnGroupObjectiveSucceeded()
{
    LogDisplayString = Prompts.LogBookString;
    ChangeStatus(2, Prompts.SuccessString, GetObjectiveSuccessTitle());
    //return;    
}

function OnGroupObjectiveFailed()
{
    ChangeStatus(3, Prompts.FailureString, GetObjectiveFailureTitle());
    //return;    
}

defaultproperties
{
    // Reference: SpriteComponent'Default__MOHAObjectiveGroup.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}