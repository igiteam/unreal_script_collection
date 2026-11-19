class SPMultiKillMessage extends SPLocalMessage;

var const localized string KillString[5];

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.KillString[Min(Switch - 1, 4)];
    //return ReturnValue;    
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x21
    if(P.GamePlayEndedState())
    {
        ScriptTrace();
    }
    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    //return;    
}

defaultproperties
{
    KillString[0]="?Muerte doble!"
    KillString[1]="?Muerte m?ltiple!"
    KillString[2]="??Megamuerte!!"
    KillString[3]="??ULTRAMUERTE!!"
    KillString[4]="???MUERTE MONSTRUOSA!!!"
    bIsUnique=true
    Lifetime=3.0000000
    DrawColor=(R=255,G=0,B=0,A=255)
    FontSize=3
}