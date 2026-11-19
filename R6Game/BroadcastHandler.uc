class BroadcastHandler extends Info
    config(Game)
    notplaceable
    hidecategories(lighting,Movement,Collision);

var int SentText;
var config bool bMuteSpectators;

function UpdateSentText()
{
    SentText = 0;
    return;
}

function bool AllowsBroadcast(Actor broadcaster, int InLen)
{
    // End:0x3F
    if((bMuteSpectators && PlayerController(broadcaster) != none) && PlayerController(broadcaster).PlayerReplicationInfo.bOnlySpectator)
    {
        return false;
    }
    SentText += InLen;
    return (WorldInfo.Pauser != none) || SentText < 260;
    return;
}

function BroadcastText(PlayerReplicationInfo SenderPRI, PlayerController Receiver, coerce string Msg, optional name Type)
{
    Receiver.TeamMessage(SenderPRI, Msg, Type);
    return;
}

function BroadcastLocalized(Actor Sender, PlayerController Receiver, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    Receiver.ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    return;
}

function Broadcast(Actor Sender, coerce string Msg, optional name Type)
{
    local PlayerController P;
    local PlayerReplicationInfo PRI;
    local bool bCanBroadcast, bSenderIsDead;

    // End:0x1B
    if(!AllowsBroadcast(Sender, Len(Msg)))
    {
        return;
    }
    // End:0x65
    if(Pawn(Sender) != none)
    {
        PRI = Pawn(Sender).PlayerReplicationInfo;
        bSenderIsDead = !Pawn(Sender).IsAlive();        
    }
    else
    {
        // End:0xD1
        if(Controller(Sender) != none)
        {
            PRI = Controller(Sender).PlayerReplicationInfo;
            bSenderIsDead = ((Controller(Sender).Pawn != none) ? !Controller(Sender).Pawn.IsAlive() : true);
        }
    }
    // End:0x17E
    foreach WorldInfo.AllControllers(Class'PlayerController', P)
    {
        bCanBroadcast = true;
        // End:0x159
        if(((Type == 'Say') && bSenderIsDead) && P != Sender)
        {
            bCanBroadcast = ((P.Pawn != none) ? !P.Pawn.IsAlive() : true);
        }
        // End:0x17D
        if(bCanBroadcast)
        {
            BroadcastText(PRI, P, Msg, Type);
        }        
    }    
    return;
}

function BroadcastTeam(Controller Sender, coerce string Msg, optional name Type)
{
    local PlayerController P;
    local bool bCanBroadcast, bSenderIsDead;

    // End:0x1B
    if(!AllowsBroadcast(Sender, Len(Msg)))
    {
        return;
    }
    bSenderIsDead = ((Sender.Pawn != none) ? !Sender.Pawn.IsAlive() : true);
    // End:0x155
    foreach WorldInfo.AllControllers(Class'PlayerController', P)
    {
        bCanBroadcast = true;
        // End:0xDC
        if(((Type == 'Say') && bSenderIsDead) && P != Sender)
        {
            bCanBroadcast = ((P.Pawn != none) ? !P.Pawn.IsAlive() : true);
        }
        // End:0x154
        if((bCanBroadcast && P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == Sender.PlayerReplicationInfo.Team)
        {
            BroadcastText(Sender.PlayerReplicationInfo, P, Msg, Type);
        }        
    }    
    return;
}

event AllowBroadcastLocalized(Actor Sender, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerController P;

    // End:0x4B
    foreach WorldInfo.AllControllers(Class'PlayerController', P)
    {
        BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);        
    }    
    return;
}

defaultproperties
{
    TickGroup=1
}