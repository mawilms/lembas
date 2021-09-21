-- shellcmd.lua
-- written by Habna


local ShellCommandName = {};
local ShellCommandDes = {};

max = 27; --Number of shell command in both mode
for i = 1, max do ShellCommandName[i]= ( L["SCb" .. i] .. L["SCa" .. i] ); ShellCommandDes[i]= ( L["SC" .. i] ); end

if Widget then
	--maxsc = 0; --Number of shell command in widget mode
	--for i = 1, maxsc do ShellCommandName[max+i]= ( L["WidSCb" .. i] .. L["WidSCa" .. i] ); ShellCommandDes[max+i]= ( L["WidSC" .. i] ); end
else
	maxsc = 6;  --Number of shell command in window mode
	for i = 1, maxsc do ShellCommandName[max+i]= ( L["WinSCb" .. i] .. L["WinSCa" .. i] ); ShellCommandDes[max+i]= ( L["WinSC" .. i] ); end
end

function frmShellCmd()
	frmSC = true;
	wShellCmd = Turbine.UI.Lotro.Window()
	--wShellCmd = Turbine.UI.Lotro.GoldWindow()
	
	if HBLocale == "en" then wShellCmd:SetSize( 460, 50 ); end
	if HBLocale == "fr" then wShellCmd:SetSize( 615, 50 ); end
	if HBLocale == "de" then wShellCmd:SetSize( 610, 50 ); end

	-- **v Set backcolor, position, size and text of the window v**
	--wShellCmd:SetSize( 525, 50 );
	wShellCmd:SetText( L["SCWTitle"] );
	wShellCmd:SetVisible( true );
	wShellCmd:SetWantsKeyEvents( true );
	--wShellCmd:SetZOrder( 2 );
	wShellCmd:Activate();
	-- **^

	wShellCmd.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			wShellCmd:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then  -- **v Hide if F12 key is press or reposition UI v**
			wShellCmd:SetVisible( not wShellCmd:IsVisible() );
		end
	end

	wShellCmd.Closing = function( sender, args )
		wShellCmd:SetWantsKeyEvents( false );
		frmSC = nil;
		wShellCmd = nil;
		option_help:SetEnabled( true );
	end

	--**v Shell command v**
	local PosY = 40;

	for i = 1, #ShellCommandName do
		local lblShell = Turbine.UI.Label();
		lblShell:SetParent( wShellCmd );
		--lblShell:SetFont ( 12 );
		lblShell:SetText( ShellCommandName[i] );
		lblShell:SetPosition( 25, PosY );
		lblShell:SetSize( string.len(lblShell:GetText()) * 7.5, 18 );
		lblShell:SetForeColor( Color["green"] );
		lblShell:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );

		local lblShellDes = Turbine.UI.Label();
		lblShellDes:SetParent( wShellCmd );
		--lblShellDes:SetFont ( 12 );
		lblShellDes:SetText( ShellCommandDes[i] );
		lblShellDes:SetPosition( lblShell:GetLeft() + lblShell:GetWidth() + 5, PosY );
		lblShellDes:SetSize( string.len(lblShellDes:GetText()) * 7.5, 18 );
		lblShellDes:SetForeColor( Color["white"] );
		lblShellDes:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );

		PosY = PosY + 15;
		wShellCmd:SetHeight( PosY );
	end
	wShellCmd:SetHeight( PosY + 20 );

	local winWidth, winHeight = wShellCmd:GetSize();
	local left, top = ( screenWidth / 2 ) - ( winWidth / 2 ) , ( screenHeight / 2 ) - ( winHeight /2 )
    wShellCmd:SetPosition( left, top );
	--**^
end