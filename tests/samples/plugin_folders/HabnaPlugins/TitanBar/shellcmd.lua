-- shellcmd.lua
-- written by Habna


local max = 26; -- Number of shell commands

local ShellCommandName = {};
local ShellCommandDes = {};

for i = 1, max do ShellCommandName[i]= ( L["SCb" .. i] .. L["SCa" .. i] ); ShellCommandDes[i]= ( L["SCWC" .. i] ); end

function frmShellCmd()
	TB["win"].MouseLeave();
	frmSC = true;
	opt_shellcmd:SetEnabled( false );

	wShellCmd = Turbine.UI.Lotro.Window()
	--wShellCmd = Turbine.UI.Lotro.GoldWindow()
	
	-- **v Set backcolor, position, size and text of the window v**
	if TBLocale == "en" then wShellCmd:SetSize( 460, 50 ); end
	if TBLocale == "fr" then wShellCmd:SetSize( 565, 50 ); end
	if TBLocale == "de" then wShellCmd:SetSize( 645, 50 ); end

	wShellCmd:SetText( L["SCWTitle"] );
	wShellCmd:SetWantsKeyEvents( true );
	wShellCmd:SetPosition( SCWLeft, SCWTop );
	wShellCmd:SetVisible( true );
	--wShellCmd:SetZOrder( 2 );
	wShellCmd:Activate();
	-- **^

	wShellCmd.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			wShellCmd:Close();
		elseif ( args.Action == 268435635 ) then -- **v Hide wShellCmd if F12 key is press v**
			wShellCmd:SetVisible( not wShellCmd:IsVisible() );
		end
	end

	wShellCmd.MouseUp = function( sender, args )
		settings.Shell.L = string.format("%.0f", wShellCmd:GetLeft());
		settings.Shell.T = string.format("%.0f", wShellCmd:GetTop());
		SCWLeft, SCWTop = wShellCmd:GetPosition();
		SaveSettings( false );
	end

	wShellCmd.Closing = function( sender, args ) -- Function for the Upper right X icon
		wShellCmd:SetWantsKeyEvents( false );
		wShellCmd = nil;
		frmSC = nil;
		opt_shellcmd:SetEnabled( true );
	end
	
	--**v Shell command v**
	local PosY = 40;
	local ShowSC = true;
	local Max = #ShellCommandName --Number of shell command

	for i = 1, Max do
		if PlayerAlign == 2 then
			if i == 5 or i == 6 or i == 9 or i == 10 or i == 14 or i == 15 or i == 16 or i == 17 or i == 20 or i == 21 or i == 24 then -- Shell command to ignore if in monster play
				ShowSC = false;
			end
		end

		if ShowSC then
			local lblShell = Turbine.UI.Label();
			lblShell:SetParent( wShellCmd );
			lblShell:SetText( ShellCommandName[i] );
			lblShell:SetPosition( 25, PosY );
			lblShell:SetSize( lblShell:GetTextLength() * 7.5, 18 );
			lblShell:SetForeColor( Color["green"] );
			lblShell:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			--lblShell:SetBackColor( Color["red"] ); -- debug purpose

			local lblShellDes = Turbine.UI.Label();
			lblShellDes:SetParent( wShellCmd );
			lblShellDes:SetText( ShellCommandDes[i] );
			lblShellDes:SetPosition( lblShell:GetLeft() + lblShell:GetWidth() + 5, PosY );
			lblShellDes:SetSize( lblShellDes:GetTextLength() * 7.5, 18 );
			lblShellDes:SetForeColor( Color["white"] );
			lblShellDes:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			--lblShellDes:SetBackColor( Color["blue"] ); -- debug purpose

			PosY = PosY + 15;
			wShellCmd:SetHeight( PosY );
		end
		ShowSC = true;
	end
	wShellCmd:SetHeight( PosY + 20 );
	--**^
end