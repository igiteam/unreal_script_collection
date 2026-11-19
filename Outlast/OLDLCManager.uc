class OLDLCManager extends DownloadableContentManager
	config(Game)
	native;

var bool bDLCInstalled;
var config bool bFakeDLCInstalledCooked;
var config bool bFakeDLCInstalledLoose;

native function bool FindAndInstallDLC();

cpptext
{
public:
	UBOOL IsDLCInstalled();
	UBOOL IsOrbisDLCOwned();

private:
	UBOOL FindAndInstallDLCPS4();
	UBOOL FindAndInstallDLCDingo();
	UBOOL FindAndInstallDLCPC();

	UBOOL InstallDLCIn(const FString& dlcPath);

	UBOOL MountOrbisDLC(FString& mountPoint);
	UBOOL MountDingoDLC(FString& mountPoint);
}

defaultproperties
{
}