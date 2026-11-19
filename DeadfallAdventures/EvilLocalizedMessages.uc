class EvilLocalizedMessages extends Info
    hidecategories(Navigation,Movement,Collision);

struct native MessageInfo
{
    var const localized string Id;
    var const localized string Message;
    var const localized string Sound;

    structdefaultproperties
    {
        Id=""
        Message=""
        Sound=""
    }
};

var array<MessageInfo> Messages;

function string FindMessage(string Id)
{
    local int I;

    I = Messages.Find('Id', Id);    
    // End:0x66
    if(I != -1)
    {
        return Messages[I].Message;        
    }
    else
    {
        return "";
    }
    //return ReturnValue;    
}

function MessageInfo FindMessageInfo(string Id)
{
    local int I;
    local MessageInfo MSI;

    I = Messages.Find('Id', Id);    
    // End:0x59
    if(I != -1)
    {
        MSI = Messages[I];
    }
    return MSI;
    //return ReturnValue;    
}
