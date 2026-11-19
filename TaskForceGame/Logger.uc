//Gated logging class
//Derive a class from this, set Enabled in your default props, and log through that.
//Usage: If you've derived a logger called 'MenuLogger', the line:
//class'MenuLogger'.static.Print("Some text to log");
//will only log if you've got Enabled set to true in MenuLogger.uc
//Ask Jay if you've got any questions

class Logger extends Object;

var const private bool GlobalEnabled;
var const bool Enabled;
var const string Prefix;

static function Print(string s)
{
	if (default.Enabled && default.GlobalEnabled)
	{
		if (default.Prefix!="")
		{
			log(default.Prefix$":"@s);
		}
		else
		{
			log(s);
		}
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    GlobalEnabled=true
}