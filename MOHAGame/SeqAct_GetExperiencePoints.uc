class SeqAct_GetExperiencePoints extends SequenceAction
    hidecategories(Object);

var() MOHAIncludeClass.EWeaponType SelectedWeaponType;
var MOHAPlayerController Player;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}

function Activated()
{
    local MOHAPlayerController localPlayerController;
    local editinline MOHAWeaponExperienceComponent LocalWeaponExperienceComponent;

    // End:0x42
    foreach GetWorldInfo().DynamicActors(Class'MOHAPlayerController', localPlayerController)
    {
        // End:0x41
        if(NetConnection(localPlayerController.Player) == none)
        {
            Player = localPlayerController;
            // End:0x42
            break;
        }        
    }    
    LocalWeaponExperienceComponent = Player.playerStats.GetWeaponExpComponentByType(SelectedWeaponType);
    SeqVar_Float(VariableLinks[0].LinkedVariables[0]).FloatValue = GetScaledExperienceValue(LocalWeaponExperienceComponent);
    //return;    
}

function float GetScaledExperienceValue(MOHAWeaponExperienceComponent InWeaponExperienceComponent)
{
    local float ScaleFactor, DivisionLength, retval;

    // End:0x11
    if(InWeaponExperienceComponent == none)
    {
        return 0.0000000;
    }
    // End:0x34
    if(InWeaponExperienceComponent.MaxExperienceLevel == 4)
    {
        DivisionLength = 25.0000000;        
    }
    else
    {
        // End:0x54
        if(InWeaponExperienceComponent.MaxExperienceLevel == 3)
        {
            DivisionLength = 33.3000000;
        }
    }
    // End:0xA9
    if(InWeaponExperienceComponent.ExperienceLevel == 0)
    {
        ScaleFactor = DivisionLength / InWeaponExperienceComponent.ExperienceLevelPoints[0];
        retval = InWeaponExperienceComponent.ExperiencePoints * ScaleFactor;
        return retval;        
    }
    else
    {
        // End:0x129
        if(InWeaponExperienceComponent.ExperienceLevel == 1)
        {
            ScaleFactor = DivisionLength / (InWeaponExperienceComponent.ExperienceLevelPoints[1] - InWeaponExperienceComponent.ExperienceLevelPoints[0]);
            retval = DivisionLength + ((InWeaponExperienceComponent.ExperiencePoints - InWeaponExperienceComponent.ExperienceLevelPoints[0]) * ScaleFactor);
            return retval;            
        }
        else
        {
            // End:0x1B2
            if(InWeaponExperienceComponent.ExperienceLevel == 2)
            {
                ScaleFactor = DivisionLength / (InWeaponExperienceComponent.ExperienceLevelPoints[2] - InWeaponExperienceComponent.ExperienceLevelPoints[1]);
                retval = (2.0000000 * DivisionLength) + ((InWeaponExperienceComponent.ExperiencePoints - InWeaponExperienceComponent.ExperienceLevelPoints[1]) * ScaleFactor);
                return retval;                
            }
            else
            {
                // End:0x258
                if(InWeaponExperienceComponent.ExperienceLevel == 3)
                {
                    // End:0x1E2
                    if(InWeaponExperienceComponent.MaxExperienceLevel == 3)
                    {
                        return 100.0000000;
                    }
                    ScaleFactor = DivisionLength / (InWeaponExperienceComponent.ExperienceLevelPoints[3] - InWeaponExperienceComponent.ExperienceLevelPoints[2]);
                    retval = (3.0000000 * DivisionLength) + ((InWeaponExperienceComponent.ExperiencePoints - InWeaponExperienceComponent.ExperienceLevelPoints[2]) * ScaleFactor);
                    return retval;                    
                }
                else
                {
                    // End:0x276
                    if(InWeaponExperienceComponent.ExperienceLevel == 4)
                    {
                        return 100.0000000;                        
                    }
                    else
                    {
                        return 0.0000000;
                    }
                }
            }
        }
    }
    //return ReturnValue;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Out_ExperiencePoints",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="GetExperiencePoints"
    ObjCategory="UI"
}