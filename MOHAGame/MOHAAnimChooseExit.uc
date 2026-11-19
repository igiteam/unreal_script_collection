class MOHAAnimChooseExit extends MOHAAnimPlayByBase
    native
    hidecategories(Object,Object,Object,Object,AnimNodeBlendList);

enum CHOOSEEXITNODE_IDX
{
    CHOOSEEXITNODE_NOLOCO,          // 0
    CHOOSEEXITNODE_LOCO,            // 1
    CHOOSEEXITNODE_VAULT,           // 2
    CHOOSEEXITNODE_MAX              // 3
};

var() float MinLocoDesiredSpeed;

// Export UMOHAAnimChooseExit::execGetExitDistance(FFrame&, void* const)
native function float GetExitDistance();

// Export UMOHAAnimChooseExit::execNodeEnd(FFrame&, void* const)
native function NodeEnd();

function Vector GetVectorToSubgoal(MOHAAIPawn P)
{
    return P.GetSafeSubgoalPosition() - P.ActiveOIR.Location;
    //return ReturnValue;    
}

event int GetChildIndexToPlay()
{
    local MOHAAIPawn Pawn;
    local float exitDist;

    // End:0x23C
    if((SkelComponent != none) && SkelComponent.Owner != none)
    {
        Pawn = MOHAAIPawn(SkelComponent.Owner);
        // End:0x23C
        if((Pawn != none) && Pawn.ActiveOIR != none)
        {
            // End:0x1A3
            if(!Pawn.ActiveOIR.bUseVaultExit || Children[2].Anim == none)
            {
                exitDist = GetExitDistance();
                // End:0x150
                if(((Pawn.DesiredSpeed == 0.0000000) || Pawn.IsArrivedAtNextOIR()) || VSizeSq2D(GetVectorToSubgoal(Pawn)) < (exitDist * exitDist))
                {
                    Pawn.PrintToAILog(("OIR STATE: USING *NO LOCO* EXIT" @ "Subgoal") @ string(Pawn.vFirstGotoSubgoalPos));
                    return 0;                    
                }
                else
                {
                    Pawn.PrintToAILog(("OIR STATE: USING *LOCO* EXIT" @ "Subgoal") @ string(Pawn.vFirstGotoSubgoalPos));
                    return 1;
                }                
            }
            else
            {
                Pawn.PrintToAILog(("OIR STATE: USING *VAULT* EXIT" @ "Subgoal") @ string(Pawn.vFirstGotoSubgoalPos));
                Pawn.TranslateCollisionForVaultOver();
                Pawn.ActiveOIR.bUseVaultExit = false;
                Pawn.ActiveOIR.bVaultExitUsed = true;
                return 2;
            }
        }
    }
    return 0;
    //return ReturnValue;    
}

event PreSetActiveChild(int Index)
{
    local MOHAAIPawn Pawn;
    local OIRData OIRData;
    local int worldYaw;
    local float relativeYawDeg;
    local bool bIsNotLocomoting;

    // End:0x17D
    if(Children[Index].Anim != none)
    {
        // End:0x17A
        if((SkelComponent != none) && SkelComponent.Owner != none)
        {
            Pawn = MOHAAIPawn(SkelComponent.Owner);
            // End:0x17A
            if(Pawn != none)
            {
                bIsNotLocomoting = (Pawn.DesiredSpeed == 0.0000000) || VSizeSq(Pawn.Acceleration) == 0.0000000;
                // End:0x101
                if((Index == 0) && bIsNotLocomoting)
                {
                    OIRData = Pawn.nextOIRActivityPacket.oirOwner.GetOIRData();
                    worldYaw = OIRData.OIRRotation.Yaw;                    
                }
                else
                {
                    worldYaw = Rotator(GetVectorToSubgoal(Pawn)).Yaw;
                }
                relativeYawDeg = (180.0000000 / 32768.0000000) * float(NormalizeRotAxis(worldYaw - Pawn.ActiveOIR.Rotation.Yaw));
                Pawn.ExitAnimBlendAngle = relativeYawDeg;
            }
        }        
    }
    else
    {
        NodeEnd();
    }
    //return;    
}

event OnInit()
{
    StopAnim();
    //return;    
}

defaultproperties
{
    MinLocoDesiredSpeed=0.2000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}