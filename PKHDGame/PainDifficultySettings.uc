class PainDifficultySettings extends Object
    abstract
    config(Game);

var config float AmmoDifficultyModifier;
var config bool bConstantDamage;
var config bool bRestoreMaxHealthInCheckpoint;
var config int ConstantDamageAmount;
var config float MonstersDamageModifier;
var const PKTypes.EDifficultyLevel DifficultyLevel;
var const localized string DifficultyName;

static function class<PainDifficultySettings> GetClassByID(PKTypes.EDifficultyLevel Id)
{
    switch(Id)
    {
        // End:0x22
        case 0:
            return Class'PainDifficultySettings_Daydream';
        // End:0x31
        case 1:
            return Class'PainDifficultySettings_Insomnia';
        // End:0x40
        case 2:
            return Class'PainDifficultySettings_Nightmare';
        // End:0x4F
        case 3:
            return Class'PainDifficultySettings_Trauma';
        // End:0xFFFF
        default:
            return Class'PainDifficultySettings_Insomnia';
            break;
    }
    //return ReturnValue;    
}

static function ApplyDifficultySettings(Controller C)
{
    //return;    
}

static function RestoreHealthInCheckpoint(PKPlayerPawn P)
{
    // End:0x68
    if(default.bRestoreMaxHealthInCheckpoint)
    {
        P.HealDamageLimit(P.HealthMax, P.HealthMax);
    }
    //return;    
}

static function ModifyDamage(out int outDamage)
{
    // End:0x23
    if(default.bConstantDamage)
    {
        outDamage = default.ConstantDamageAmount;        
    }
    else
    {
        outDamage = int(float(outDamage) * default.MonstersDamageModifier);
    }
    //return;    
}

static final function class<PainDifficultySettings> GetServerPlayerDifficultyLevel(WorldInfo WI)
{
    local PKPlayerController PC;
    local PainPRI PCPRI;

    // End:0xB9
    foreach WI.AllControllers(Class'PKPlayerController', PC)
    {
        PCPRI = PainPRI(PC.PlayerReplicationInfo);
        // End:0xB8
        if((PCPRI != none) && PCPRI.IsLocalPlayerPRI())
        {            
            return PCPRI.Difficulty;
        }        
    }    
    return Class'PainDifficultySettings_Insomnia';
    //return ReturnValue;    
}

defaultproperties
{
    DifficultyName="None"
}