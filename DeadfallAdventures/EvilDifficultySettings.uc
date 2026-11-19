class EvilDifficultySettings extends Object
    abstract
    config(Game);

var config float AmmoDifficultyModifier;
var config bool bConstantDamage;
var config int ConstantDamageAmount;
var config float MonstersDamageModifier;
var config float SurvivalScoreModifier;
var const EvilTypesNative.EDifficultyLevel DifficultyLevel;
var const localized string DifficultyName;

static function class<EvilDifficultySettings> GetClassByID(EvilTypesNative.EDifficultyLevel Id)
{
    switch(Id)
    {
        // End:0x22
        case 0:
            return Class'EvilDifficultySettings_Low';
        // End:0x31
        case 1:
            return Class'EvilDifficultySettings_Normal';
        // End:0x40
        case 2:
            return Class'EvilDifficultySettings_High';
        // End:0x4F
        case 3:
            return Class'EvilDifficultySettings_VeryHigh';
        // End:0xFFFF
        default:
            return Class'EvilDifficultySettings_Normal';
            break;
    }
    //return ReturnValue;    
}

static function ApplyDifficultySettings(Controller C)
{
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

static function ModifySurvivalScore(out int outScore)
{
    outScore *= default.SurvivalScoreModifier;
    //return;    
}

defaultproperties
{
    AmmoDifficultyModifier=1.0000000
    MonstersDamageModifier=1.0000000
    SurvivalScoreModifier=1.0000000
    DifficultyName="None"
}