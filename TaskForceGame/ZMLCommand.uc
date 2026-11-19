////
//ZMLCommand - Handles processing for a ZML command
////

class ZMLCommand extends object
	native
	abstract;

var const string CommandString;

/*
Accepts - Tests the command to see if it's for us
	returns true if we accept the command, false otherwise
*/
event bool Accepts(string command)
{
	if (Left(command, Len(CommandString)) ~= CommandString)
	{
		return true;
	}

	return false;
}

/*
Width - Returns the width of what will be rendered. Used for setting up the justification.
	string command - the command to test
*/
event float GetWidth(string command, ZMLRender ZMLDevice);

/*
GetArg - Strips off the CommandString and the equals and returns the arg
*/
function string GetArg(string command)
{
	return Mid(command, Len(CommandString)+1);
}

/*
Render - Renders the command
	string command - the command to test
	returns true is the command is processed, false otherwise
*/
event bool Render(string command, Canvas c, ZMLRender ZMLDevice)
{
	if (Accepts(command))
	{
		//send the args off to DoRender
		//+1 to strip off '='
		DoRender(Mid(command, Len(CommandString)+1), c, ZMLDevice);
		return true;
	}

	return false;
/*	//see if the command begins with my CommandString
	if (Left(command, Len(CommandString)) ~= CommandString)
	{
		//send the args off to DoRender
		//+1 to strip off '='
		DoRender(Mid(command, Len(CommandString)+1), c, ZMLDevice);
		return true;
	}

	return false;*/
}

/*
DoRender - Applys the command. Should not be called outside of the class
	string arg - the arguments to the command
*/
function DoRender(string arg, Canvas c, ZMLRender ZMLDevice);
