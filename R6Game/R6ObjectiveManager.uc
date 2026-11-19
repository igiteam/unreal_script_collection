class R6ObjectiveManager extends Object
    native;

var array<R6Objective> m_aObjectives;
var bool m_bMissionFailed;
var bool m_bDrawDebug;
var R6GameInfo m_gameInfo;
var array<R6Objective> sm_arrObjectives;

// Export UR6ObjectiveManager::execUpdate(FFrame&, void* const)
native function Update(float fDeltaTime);

// Export UR6ObjectiveManager::execCheckMissionFailure(FFrame&, void* const)
native function CheckMissionFailure(R6Objective pObjectiveFailed);

// Export UR6ObjectiveManager::execSetMissionFailed(FFrame&, void* const)
native function SetMissionFailed();

// Export UR6ObjectiveManager::execIsMissionFailed(FFrame&, void* const)
native function bool IsMissionFailed();

// Export UR6ObjectiveManager::execGetObjective(FFrame&, void* const)
native function R6Objective GetObjective(int iIndex);

function AddObjective(R6Objective newObjective)
{
    newObjective.EnableSelf();
    return;
}

// Export UR6ObjectiveManager::execRegisterObjective(FFrame&, void* const)
native final function RegisterObjective(R6Objective pObjective);

// Export UR6ObjectiveManager::execUnRegisterObjective(FFrame&, void* const)
native final function UnRegisterObjective(R6Objective pObjective);

function PawnDied(R6Pawn deadPawn, Controller Killer)
{
    local int I;
    local R6Objective currentObjective;

    I = 0;
    J0x07:

    // End:0x65 [Loop If]
    if(I < m_aObjectives.Length)
    {
        currentObjective = m_aObjectives[I];
        // End:0x5B
        if(int(currentObjective.m_eStatus) == int(1))
        {
            currentObjective.PawnDied(deadPawn, Killer);
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function ZoneEntered(R6ExtractionZone PZone, R6Pawn pPawn)
{
    local int I;
    local R6ObjectiveBasic currentObjective;

    I = 0;
    J0x07:

    // End:0x6A [Loop If]
    if(I < m_aObjectives.Length)
    {
        currentObjective = R6ObjectiveBasic(m_aObjectives[I]);
        // End:0x60
        if(int(currentObjective.m_eStatus) == int(1))
        {
            currentObjective.ZoneEntered(PZone, pPawn);
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function ZoneExited(R6ExtractionZone PZone, R6Pawn pPawn)
{
    local int I;
    local R6ObjectiveBasic currentObjective;

    I = 0;
    J0x07:

    // End:0x6A [Loop If]
    if(I < m_aObjectives.Length)
    {
        currentObjective = R6ObjectiveBasic(m_aObjectives[I]);
        // End:0x60
        if(int(currentObjective.m_eStatus) == int(1))
        {
            currentObjective.ZoneExited(PZone, pPawn);
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function DrawHUD(HUD H)
{
    local int I, iOffsetY, iOffsetX;
    local string szObjectiveDescription;

    // End:0x267
    if(m_bDrawDebug)
    {
        iOffsetX = int(H.SizeX * 0.5000000);
        iOffsetY = int(H.SizeY * 0.5000000);
        H.Canvas.SetPos(float(iOffsetX), float(iOffsetY));
        H.Canvas.DrawColor = H.WhiteColor;
        // End:0x230
        if(m_aObjectives.Length > 0)
        {
            H.Canvas.__NFUN_465__("Active mission objectives: ");
            iOffsetY += 15;
            I = 0;
            J0xDE:

            // End:0x22D [Loop If]
            if(I < m_aObjectives.Length)
            {
                // End:0x223
                if(!m_aObjectives[I].m_bHiddenInManager)
                {
                    H.Canvas.SetPos(float(iOffsetX), float(iOffsetY));
                    // End:0x176
                    if(int(m_aObjectives[I].m_eStatus) == int(2))
                    {
                        H.Canvas.DrawColor = H.GreenColor;                        
                    }
                    else
                    {
                        // End:0x1BE
                        if(int(m_aObjectives[I].m_eStatus) == int(3))
                        {
                            H.Canvas.DrawColor = H.RedColor;                            
                        }
                        else
                        {
                            H.Canvas.DrawColor = H.WhiteColor;
                        }
                    }
                    m_aObjectives[I].GetDescription(szObjectiveDescription);
                    H.Canvas.__NFUN_465__(szObjectiveDescription);
                    iOffsetY += 15;
                }
                I++;
                // [Loop Continue]
                goto J0xDE;
            }            
        }
        else
        {
            H.Canvas.__NFUN_465__("There are no mission objectives");
        }
    }
    return;
}

event Save()
{
    sm_arrObjectives = m_aObjectives;
    return;
}

event Reset()
{
    m_aObjectives.Remove(0, m_aObjectives.Length);
    m_aObjectives = sm_arrObjectives;
    m_bMissionFailed = false;
    return;
}

defaultproperties
{
    m_bDrawDebug=true
}