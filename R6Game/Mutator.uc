class Mutator extends Info
    native
    notplaceable
    hidecategories(lighting,Movement,Collision);

var Mutator NextMutator;
var class<Weapon> DefaultWeapon;
var string DefaultWeaponName;
var() string GroupName;
var() const localized string FriendlyName;
var() const localized string Description;
var bool bUserAdded;

event PreBeginPlay()
{
    // End:0x0F
    if(!MutatorIsAllowed())
    {
        Destroy();
    }
    return;
}

function bool MutatorIsAllowed()
{
    return !WorldInfo.IsDemoBuild() || Class == Class'Mutator';
    return;
}

function Destroyed()
{
    WorldInfo.Game.RemoveMutator(self);
    Destroyed();
    return;
}

function Mutate(string MutateString, PlayerController Sender)
{
    // End:0x25
    if(NextMutator != none)
    {
        NextMutator.Mutate(MutateString, Sender);
    }
    return;
}

function ModifyLogin(out string Portal, out string Options)
{
    // End:0x25
    if(NextMutator != none)
    {
        NextMutator.ModifyLogin(Portal, Options);
    }
    return;
}

function AddMutator(Mutator M)
{
    // End:0x19
    if(NextMutator == none)
    {
        NextMutator = M;        
    }
    else
    {
        NextMutator.AddMutator(M);
    }
    return;
}

function bool AlwaysKeep(Actor other)
{
    // End:0x21
    if(NextMutator != none)
    {
        return NextMutator.AlwaysKeep(other);
    }
    return false;
    return;
}

function bool IsRelevant(Actor other, out byte bSuperRelevant)
{
    local bool bResult;

    bResult = CheckReplacement(other, bSuperRelevant);
    // End:0x4F
    if(bResult && NextMutator != none)
    {
        bResult = NextMutator.IsRelevant(other, bSuperRelevant);
    }
    return bResult;
    return;
}

function bool CheckRelevance(Actor other)
{
    local bool bResult;
    local byte bSuperRelevant;

    // End:0x11
    if(AlwaysKeep(other))
    {
        return true;
    }
    bResult = IsRelevant(other, bSuperRelevant);
    return bResult;
    return;
}

function bool CheckReplacement(Actor other, out byte bSuperRelevant)
{
    return true;
    return;
}

function GetServerDetails(out ServerResponseLine ServerState)
{
    local int I;

    I = ServerState.ServerInfo.Length;
    ServerState.ServerInfo.Length = I + 1;
    ServerState.ServerInfo[I].Key = "Mutator";
    ServerState.ServerInfo[I].Value = GetHumanReadableName();
    return;
}

function GetServerPlayers(out ServerResponseLine ServerState)
{
    return;
}

function string ParseChatPercVar(Controller Who, string Cmd)
{
    // End:0x2B
    if(NextMutator != none)
    {
        Cmd = NextMutator.ParseChatPercVar(Who, Cmd);
    }
    return Cmd;
    return;
}

function NotifyLogout(PlayerController Exiting)
{
    // End:0x20
    if(NextMutator != none)
    {
        NextMutator.NotifyLogout(Exiting);
    }
    return;
}

function NotifyLogin(PlayerController NewPlayer)
{
    // End:0x20
    if(NextMutator != none)
    {
        NextMutator.NotifyLogin(NewPlayer);
    }
    return;
}

function bool CanEnterVehicle(Vehicle V, Pawn P)
{
    // End:0x26
    if(NextMutator != none)
    {
        return NextMutator.CanEnterVehicle(V, P);
    }
    return true;
    return;
}

function DriverEnteredVehicle(Vehicle V, Pawn P)
{
    // End:0x25
    if(NextMutator != none)
    {
        NextMutator.DriverEnteredVehicle(V, P);
    }
    return;
}

function bool CanLeaveVehicle(Vehicle V, Pawn P)
{
    // End:0x26
    if(NextMutator != none)
    {
        return NextMutator.CanLeaveVehicle(V, P);
    }
    return true;
    return;
}

function DriverLeftVehicle(Vehicle V, Pawn P)
{
    // End:0x25
    if(NextMutator != none)
    {
        NextMutator.DriverLeftVehicle(V, P);
    }
    return;
}

function InitMutator(string Options, out string ErrorMessage)
{
    // End:0x25
    if(NextMutator != none)
    {
        NextMutator.InitMutator(Options, ErrorMessage);
    }
    return;
}
