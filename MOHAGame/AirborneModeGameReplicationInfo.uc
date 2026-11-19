class AirborneModeGameReplicationInfo extends MOHAGameReplicationInfo
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

const MAX_REPLICATED_ITP_ACTORS = 8;

var repnotify MultiplayerCinematicActor.EMultiplayerITPActivity CinActorState[64];
var repnotify MultiplayerCinematicActor.EMultiplayerJumpMasterITPActivity CinActorJumpMasterState[8];
var array<MultiplayerCinematicActor> CinActorArray;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        CinActorJumpMasterState, CinActorState;
}

simulated function PostBeginPlay()
{
    local MultiplayerCinematicActor MCA;

    super.PostBeginPlay();
    // End:0x26
    foreach DynamicActors(Class'MultiplayerCinematicActor', MCA)
    {
        AddCinActor(MCA);        
    }    
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    local int I, J;
    local bool bDirty;

    // End:0x121
    if(VarName == 'CinActorState')
    {
        I = 8;
        // End:0x37
        if(I > CinActorArray.Length)
        {
            I = CinActorArray.Length;
        }
        I = I - 1;
        J0x45:

        // End:0x11C [Loop If]
        if(I >= 0)
        {
            bDirty = false;
            J = 0;
            J0x5F:

            // End:0xE7 [Loop If]
            if(J < 8)
            {
                // End:0xDD
                if(int(CinActorArray[I].MeshActivities[J]) != int(CinActorState[(I * 8) + J]))
                {
                    bDirty = true;
                    CinActorArray[I].MeshActivities[J] = CinActorState[(I * 8) + J];
                }
                J++;
                // [Loop Continue]
                goto J0x5F;
            }
            // End:0x112
            if(bDirty)
            {
                CinActorArray[I].ReplicatedEvent('MeshActivities');
            }
            I--;
            // [Loop Continue]
            goto J0x45;
        }
        return;        
    }
    else
    {
        // End:0x1EA
        if(VarName == 'CinActorJumpMasterState')
        {
            I = 8;
            // End:0x158
            if(I > CinActorArray.Length)
            {
                I = CinActorArray.Length;
            }
            I = I - 1;
            J0x166:

            // End:0x1E5 [Loop If]
            if(I >= 0)
            {
                // End:0x1DB
                if(int(CinActorArray[I].JumpMasterActivity) != int(CinActorJumpMasterState[I]))
                {
                    CinActorArray[I].JumpMasterActivity = CinActorJumpMasterState[I];
                    CinActorArray[I].ReplicatedEvent('JumpMasterActivities');
                }
                I--;
                // [Loop Continue]
                goto J0x166;
            }
            return;            
        }
        else
        {
            super.ReplicatedEvent(VarName);
        }
    }
    //return;    
}

simulated function AddCinActor(MultiplayerCinematicActor MCA)
{
    local int I, J;

    I = 0;
    J0x07:

    // End:0x5C [Loop If]
    if(I < CinActorArray.Length)
    {
        // End:0x2E
        if(CinActorArray[I] == MCA)
        {
            return;
        }
        // End:0x52
        if(CinActorArray[I] == none)
        {
            CinActorArray.Remove(I, 1);
            I--;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    I = CinActorArray.Length;
    CinActorArray[I] = MCA;
    J = 0;
    J0x80:

    // End:0xC1 [Loop If]
    if(J < 8)
    {
        CinActorState[(I * 8) + J] = MCA.MeshActivities[J];
        ++J;
        // [Loop Continue]
        goto J0x80;
    }
    CinActorJumpMasterState[I] = MCA.JumpMasterActivity;
    MCA.m_iGRIIndex = I;
    SortCinActorArray();
    return;
    //return;    
}

simulated function RemoveCinActor(MultiplayerCinematicActor MCA)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4A [Loop If]
    if(I < CinActorArray.Length)
    {
        // End:0x40
        if(CinActorArray[I] == MCA)
        {
            CinActorArray.Remove(I, 1);
            SortCinActorArray();
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export UAirborneModeGameReplicationInfo::execSortCinActorArray(FFrame&, void* const)
native final function SortCinActorArray();

function UpdateCinActor(MultiplayerCinematicActor MCA)
{
    local int J;

    // End:0x9F
    if((MCA.m_iGRIIndex >= 0) && MCA.m_iGRIIndex < 8)
    {
        J = 0;
        J0x32:

        // End:0x7C [Loop If]
        if(J < 8)
        {
            CinActorState[(MCA.m_iGRIIndex * 8) + J] = MCA.MeshActivities[J];
            ++J;
            // [Loop Continue]
            goto J0x32;
        }
        CinActorJumpMasterState[MCA.m_iGRIIndex] = MCA.JumpMasterActivity;
    }
    //return;    
}
