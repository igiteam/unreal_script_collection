class AccessControl extends Info
    native
    config(Game)
    notplaceable
    hidecategories(lighting,Movement,Collision);

var globalconfig array<config string> IPPolicies;
var array<string> XUIDBanned;
var const localized string IPBanned;
var const localized string WrongPassword;
var const localized string NeedPassword;
var const localized string SessionBanned;
var const localized string KickedMsg;
var const localized string DefaultKickReason;
var const localized string IdleKickReason;
var class<Admin> AdminClass;
var private string AdminPassword;
var private string GamePassword;
var const localized string ACDisplayText[3];
var const localized string ACDescText[3];
var bool bDontAddDefaultAdmin;

// Export UAccessControl::execSetGamePassword(FFrame&, void* const)
native function SetGamePassword(string P);

// Export UAccessControl::execRequiresPassword(FFrame&, void* const)
native function bool RequiresPassword();

function bool IsAdmin(PlayerController P)
{
    return P.PlayerReplicationInfo.bAdmin;
    return;
}

function bool SetAdminPassword(string P)
{
    AdminPassword = P;
    return true;
    return;
}

function Kick(string S)
{
    local Controller C;

    // End:0xDB
    foreach WorldInfo.AllControllers(Class'Controller', C)
    {
        // End:0xDA
        if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.PlayerName ~= S)
        {
            // End:0x7C
            if(PlayerController(C) != none)
            {
                KickPlayer(PlayerController(C), DefaultKickReason);                
            }
            else
            {
                // End:0xD7
                if(C.PlayerReplicationInfo.bBot)
                {
                    // End:0xC0
                    if(C.Pawn != none)
                    {
                        C.Pawn.Destroy();
                    }
                    // End:0xD7
                    if(C != none)
                    {
                        C.Destroy();
                    }
                }
            }
            // End:0xDB
            break;
        }        
    }    
    return;
}

function KickBan(string S)
{
    local PlayerController P;
    local string IP;

    // End:0xCB
    foreach DynamicActors(Class'PlayerController', P)
    {
        // End:0xCA
        if(((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.PlayerName ~= S) && NetConnection(P.Player) != none)
        {
            IP = P.GetPlayerNetworkAddress();
            // End:0xBB
            if(CheckIPPolicy(IP))
            {
                IP = Left(IP, InStr(IP, ":"));
                IPPolicies[IPPolicies.Length] = "DENY," $ IP;
                SaveConfig();
            }
            P.Destroy();            
            return;
        }        
    }    
    return;
}

function BanPlayer(int iPlayerID)
{
    local PlayerController P;
    local string IP;

    // End:0xD7
    foreach WorldInfo.AllControllers(Class'PlayerController', P)
    {
        // End:0xD6
        if(((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.PlayerID == iPlayerID) && NetConnection(P.Player) != none)
        {
            IP = P.GetPlayerNetworkAddress();
            // End:0xC7
            if(CheckIPPolicy(IP))
            {
                IP = Left(IP, InStr(IP, ":"));
                IPPolicies[IPPolicies.Length] = "DENY," $ IP;
                SaveConfig();
            }
            P.Destroy();            
            return;
        }        
    }    
    return;
}

function BanPlayerXBOX(string sPlayerXUID)
{
    local PlayerController P;

    // End:0xB7
    foreach WorldInfo.AllControllers(Class'PlayerController', P)
    {
        // End:0xB6
        if(((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.m_xuid == sPlayerXUID) && NetConnection(P.Player) != none)
        {
            // End:0xA7
            if(!IsXUIDBanned(sPlayerXUID))
            {
                XUIDBanned[XUIDBanned.Length] = sPlayerXUID;
                GetGameManager().SaveAccessControlBannedXUIDs(XUIDBanned);
            }
            P.Destroy();            
            return;
        }        
    }    
    return;
}

function bool IsXUIDBanned(string sXUID)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(I < XUIDBanned.Length)
    {
        // End:0x2E
        if(XUIDBanned[I] == sXUID)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

function bool KickPlayer(PlayerController C, string KickReason)
{
    // End:0x7B
    if(((C != none) && !IsAdmin(C)) && NetConnection(C.Player) != none)
    {
        // End:0x62
        if(C.Pawn != none)
        {
            C.Pawn.Destroy();
        }
        // End:0x79
        if(C != none)
        {
            C.Destroy();
        }
        return true;
    }
    return false;
    return;
}

function bool AdminLogin(PlayerController P, string Password)
{
    // End:0x0E
    if(AdminPassword == "")
    {
        return false;
    }
    // End:0x7D
    if(Password == AdminPassword)
    {
        WorldInfo.Game.Broadcast(P, P.PlayerReplicationInfo.PlayerName $ "logged in as a server administrator.");
        return true;
    }
    return false;
    return;
}

event PreLogin(string Options, string Address, out string OutError, out string FailCode, bool bSpectator)
{
    local string InPassword;
    local int iNumClients;
    local bool bSpecialGuest;

    OutError = "";
    InPassword = WorldInfo.Game.ParseOption(Options, "JPW");
    iNumClients = WorldInfo.Game.GetIntOption(Options, "NumClients", 1);
    bSpecialGuest = WorldInfo.Game.ParseOption(Options, "SpecialGuest") ~= "1";
    // End:0x10B
    if((int(WorldInfo.NetMode) != int(NM_Standalone)) && WorldInfo.Game.AtCapacity(bSpectator, iNumClients, bSpecialGuest))
    {
        OutError = WorldInfo.Game.GameMessageClass.default.MaxedOutMessage;        
    }
    else
    {
        // End:0x191
        if(((GamePassword != "") && Caps(InPassword) != Caps(GamePassword)) && (AdminPassword == "") || Caps(InPassword) != Caps(AdminPassword))
        {
            // End:0x177
            if(InPassword == "")
            {
                OutError = NeedPassword;
                FailCode = "NEEDPW";                
            }
            else
            {
                OutError = WrongPassword;
                FailCode = "WRONGPW";
            }
        }
    }
    // End:0x1AD
    if(!CheckIPPolicy(Address))
    {
        OutError = IPBanned;
    }
    return;
}

event PreLoginXBOX(string Options, string sXUID, out string OutError, out string FailCode, bool bSpectator)
{
    local string InPassword;
    local int iNumClients;
    local bool bSpecialGuest;

    OutError = "";
    InPassword = WorldInfo.Game.ParseOption(Options, "JPW");
    iNumClients = WorldInfo.Game.GetIntOption(Options, "NumClients", 1);
    bSpecialGuest = WorldInfo.Game.ParseOption(Options, "SpecialGuest") ~= "1";
    // End:0x10B
    if((int(WorldInfo.NetMode) != int(NM_Standalone)) && WorldInfo.Game.AtCapacity(bSpectator, iNumClients, bSpecialGuest))
    {
        OutError = WorldInfo.Game.GameMessageClass.default.MaxedOutMessage;        
    }
    else
    {
        // End:0x174
        if(((GamePassword != "") && Caps(InPassword) != Caps(GamePassword)) && (AdminPassword == "") || Caps(InPassword) != Caps(AdminPassword))
        {
            // End:0x169
            if(InPassword == "")
            {
                OutError = NeedPassword;                
            }
            else
            {
                OutError = WrongPassword;
            }
        }
    }
    // End:0x18E
    if(IsXUIDBanned(sXUID))
    {
        OutError = IPBanned;
    }
    return;
}

function bool CheckIPPolicy(string Address)
{
    local int I, J;
    local string Policy, Mask;
    local bool bAcceptAddress, bAcceptPolicy;

    J = InStr(Address, ":");
    // End:0x31
    if(J != -1)
    {
        Address = Left(Address, J);
    }
    bAcceptAddress = true;
    I = 0;
    J0x40:

    // End:0x159 [Loop If]
    if(I < IPPolicies.Length)
    {
        J = InStr(IPPolicies[I], ",");
        // End:0x78
        if(J == -1)
        {
            // [Explicit Continue]
            goto J0x14F;
        }
        Policy = Left(IPPolicies[I], J);
        Mask = Mid(IPPolicies[I], J + 1);
        // End:0xC9
        if(Policy ~= "ACCEPT")
        {
            bAcceptPolicy = true;            
        }
        else
        {
            // End:0xE4
            if(Policy ~= "DENY")
            {
                bAcceptPolicy = false;                
            }
            else
            {
                // [Explicit Continue]
                goto J0x14F;
            }
        }
        J = InStr(Mask, "*");
        // End:0x133
        if(J != -1)
        {
            // End:0x130
            if(Left(Mask, J) == Left(Address, J))
            {
                bAcceptAddress = bAcceptPolicy;
            }
            // [Explicit Continue]
            goto J0x14F;
        }
        // End:0x14F
        if(Mask == Address)
        {
            bAcceptAddress = bAcceptPolicy;
        }
        J0x14F:

        I++;
        // [Loop Continue]
        goto J0x40;
    }
    return bAcceptAddress;
    return;
}

defaultproperties
{
    IPBanned="Your IP address has been banned on this server."
    WrongPassword="The password you entered is incorrect."
    NeedPassword="You need to enter a password to join this game."
    SessionBanned="Your IP address has been banned from the current game session."
    KickedMsg="You have been forcibly removed from the game."
    DefaultKickReason="None specified"
    IdleKickReason="Kicked for idling."
    AdminClass=Class'Admin'
    ACDisplayText[0]="Game Password"
    ACDisplayText[1]="Access Policies"
    ACDisplayText[2]="Admin Password"
    ACDescText[0]="If this password is set, players will have to enter it to join this server."
    ACDescText[1]="Specifies IP addresses or address ranges which have been banned."
    ACDescText[2]="Password required to login with administrator privileges on this server."
}