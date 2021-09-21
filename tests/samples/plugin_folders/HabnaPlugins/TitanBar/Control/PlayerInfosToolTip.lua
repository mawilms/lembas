-- functions.lua
-- Written By Habna


--XP needed to reach next level
--Ex.: at lvl 1 u need 100 XP to reach lvl 2, at lvl 2 u need 275 XP to reach lvl 3 and so on.
--Source: http://lotro-wiki.com/index.php/Character#Character_Levels_and_Experience_Points
-- XP from lvl 75 to 85 from player Geko, thanks!
PlayerLevel = {
	[1]="100", [2]="275", [3]="550", [4]="950", [5]="1,543", [6]="2,395", [7]="3,575", [8]="5,150", [9]="7,188", [10]="9,798",
	[11]="13,090", [12]="17,175", [13]="22,163", [14]="28,163", [15]="35,328", [16]="43,810", [17]="53,763", [18]="65,338", [19]="78,688",
	[20]="94,008", [21]="111,493", [22]="131,338", [23]="153,738", [24]="178,888", [25]="207,025", [26]="238,388", [27]="273,213", [28]="311,738",
	[29]="354,200", [30]="400,880", [31]="452,058", [32]="508,013", [33]="569,025", [34]="635,375", [35]="707,385", [36]="785,378", [37]="869,675",
	[38]="960,600", [39]="1,058,475", [40]="1,163,665", [41]="1,276,535", [42]="1,397,450", [43]="1,526,775", [44]="1,664,875", [45]="1,812,158",
	[46]="1,969,030", [47]="2,135,900", [48]="2,313,175", [49]="2,501,263", [50]="2,700,613", [51]="2,911,675", [52]="3,134,900", [53]="3,370,738",
	[54]="3,619,638", [55]="3,882,093", [56]="4,158,595", [57]="4,449,638", [58]="4,755,713", [59]="5,077,313", [60]="5,415,226", [61]="5,770,277",
	[62]="6,143,336", [63]="6,535,316", [64]="6,947,176", [65]="7,379,926", [66]="7,834,624", [67]="8,312,383", [68]="8,814,374", [69]="9,341,823",
	[70]="9,896,024", [71]="10,478,333", [72]="11,090,176", [73]="11,733,051", [74]="12,408,532", [75]="13,117,787", [76]="13,862,504", [77]="14,644,456",
	[78]="15,465,505", [79]="16,327,606", [80]="17,232,812", [81]="18,183,278", [82]="19,181,267", [83]="20,229,155", [84]="21,329,437", [85]="0" };

function ShowPIWindow()
	if PlayerAlign == 1 then th = 285; tw = 540; else th = 75; tw = 375; end --th: temp height / tw: temp width

	-- ( offsetX, offsetY, width, height, bubble side )
	local x, y, w, h = -5, -15, tw, th;
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
	
	if w + mouseX > screenWidth then x = w - 10; end

	if not TBTop then y = h; end
	
	_G.ToolTipWin = Turbine.UI.Window();
	_G.ToolTipWin:SetZOrder( 1 );
	--_G.ToolTipWin.xOffset = x;
	--_G.ToolTipWin.yOffset = y;
	_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
	_G.ToolTipWin:SetSize( w, h );
	_G.ToolTipWin:SetVisible( true );

	--**v Control of all player infos v**
	local APICtr = Turbine.UI.Control();
	APICtr:SetParent( _G.ToolTipWin );
	APICtr:SetZOrder( 1 );
	APICtr:SetSize( w, h );
	APICtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	--APICtr:SetBackColor( Color["red"] ); -- Debug purpose
	--**^

	local MoraleCtr = Turbine.UI.Control();
	MoraleCtr:SetParent( APICtr );
	MoraleCtr:SetSize( 180, 26 );
	MoraleCtr:SetPosition( 15, 12 );

	local MoraleIcon = Turbine.UI.Control();
	MoraleIcon:SetParent(MoraleCtr);
	MoraleIcon:SetBlendMode(5);
	MoraleIcon:SetSize(24,26);
	MoraleIcon:SetPosition(1,1);
	MoraleIcon:SetBackground(0x410dcfce);

	local MoraleLabel = Turbine.UI.Label();
	MoraleLabel:SetParent(MoraleCtr);
	MoraleLabel:SetSize(65,26);
	MoraleLabel:SetPosition(25,0);
	MoraleLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	MoraleLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	MoraleLabel:SetForeColor( Color["nicegreen"] );
	MoraleLabel:SetText( L["Morale"] );
	
	MoraleValue = Turbine.UI.Label();
	MoraleValue:SetParent(MoraleCtr);
	MoraleValue:SetSize(95,26);
	MoraleValue:SetPosition(90,0);
	MoraleValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	MoraleValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	MoraleValue:SetForeColor( Color["white"] );
	
	local PowerCtr = Turbine.UI.Control();
	PowerCtr:SetParent( APICtr );
	PowerCtr:SetSize(180,26);
	PowerCtr:SetPosition(MoraleCtr:GetLeft() + MoraleCtr:GetWidth() + 5, MoraleCtr:GetTop());

	local PowerIcon = Turbine.UI.Control();
	PowerIcon:SetParent(PowerCtr);
	PowerIcon:SetBlendMode(5);
	PowerIcon:SetSize(24,26);
	PowerIcon:SetPosition(1,1);
	PowerIcon:SetBackground(0x410dcfcf);

	local PowerLabel = Turbine.UI.Label();
	PowerLabel:SetParent(PowerCtr);
	PowerLabel:SetSize(65,26);
	PowerLabel:SetPosition(25,0);
	PowerLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	PowerLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	PowerLabel:SetForeColor( Color["niceblue"] );
	PowerLabel:SetText( L["Power"] );

	PowerValue = Turbine.UI.Label();
	PowerValue:SetParent(PowerCtr);
	PowerValue:SetSize(95,26);
	PowerValue:SetPosition(90,0);
	PowerValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	PowerValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	PowerValue:SetForeColor( Color["white"] );
	
	if PlayerAlign == 1 then
		local ArmorCtr = Turbine.UI.Control();
		ArmorCtr:SetParent( APICtr );
		--ArmorCtr:SetBlendMode(5);
		ArmorCtr:SetSize(135,26);
		ArmorCtr:SetPosition(PowerCtr:GetLeft() + PowerCtr:GetWidth() + 5, MoraleCtr:GetTop());

		local ArmorIcon = Turbine.UI.Control();
		ArmorIcon:SetParent(ArmorCtr);
		ArmorIcon:SetBlendMode(5);
		ArmorIcon:SetSize(24,26);
		ArmorIcon:SetPosition(1,1);
		ArmorIcon:SetBackground(0x410dcfd0);

		local ArmorLabel = Turbine.UI.Label();
		ArmorLabel:SetParent(ArmorCtr);
		ArmorLabel:SetSize(65,26);
		ArmorLabel:SetPosition(25,0);
		ArmorLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		ArmorLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		ArmorLabel:SetForeColor( Color["brown"] );
		ArmorLabel:SetText( L["Armour"] );

		ArmorValue = Turbine.UI.Label();
		ArmorValue:SetParent(ArmorCtr);
		ArmorValue:SetSize(50,26);
		ArmorValue:SetPosition(90,0);
		ArmorValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		ArmorValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		ArmorValue:SetForeColor( Color["white"] );
		
		local StatsLen, StatsLbl, StatsVal = 125, 85, 40; --Statistics size, label size, value size
		local StatsHeading = Turbine.UI.Label();
		StatsHeading:SetParent( APICtr );
		StatsHeading:SetSize(StatsLen,18);
		StatsHeading:SetPosition(MoraleCtr:GetLeft(), MoraleCtr:GetTop()+30);
		StatsHeading:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		StatsHeading:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
		StatsHeading:SetForeColor( Color["white"] );
		StatsHeading:SetText( L["Stats"] );

		local StatsSeparator = Turbine.UI.Control();
		StatsSeparator:SetParent( APICtr );
		StatsSeparator:SetSize(StatsLen+1,1);
		StatsSeparator:SetPosition(StatsHeading:GetLeft(),StatsHeading:GetTop()+18);
		StatsSeparator:SetBackColor( Color["trueblue"] );

		local MightLabel = Turbine.UI.Label();
		MightLabel:SetParent( APICtr );
		MightLabel:SetSize(StatsLbl,15);
		MightLabel:SetPosition(StatsHeading:GetLeft(),StatsHeading:GetTop()+20);
		MightLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		MightLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		MightLabel:SetForeColor( Color["nicegold"] );
		MightLabel:SetText( L["Might"] );

		MightValue = Turbine.UI.Label();
		MightValue:SetParent( APICtr );
		MightValue:SetSize(StatsVal,15);
		MightValue:SetPosition(MightLabel:GetLeft()+StatsLbl,MightLabel:GetTop());
		MightValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		MightValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		MightValue:SetForeColor( Color["white"] );
		
		local AgilityLabel = Turbine.UI.Label();
		AgilityLabel:SetParent( APICtr );
		AgilityLabel:SetSize(StatsLbl,15);
		AgilityLabel:SetPosition(MightLabel:GetLeft(),MightLabel:GetTop()+15);
		AgilityLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		AgilityLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		AgilityLabel:SetForeColor( Color["nicegold"] );
		AgilityLabel:SetText( L["Agility"] );

		AgilityValue = Turbine.UI.Label();
		AgilityValue:SetParent( APICtr );
		AgilityValue:SetSize(StatsVal,15);
		AgilityValue:SetPosition(AgilityLabel:GetLeft()+StatsLbl,AgilityLabel:GetTop());
		AgilityValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		AgilityValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		AgilityValue:SetForeColor( Color["white"] );
		
		local VitalityLabel = Turbine.UI.Label();
		VitalityLabel:SetParent( APICtr );
		VitalityLabel:SetSize(StatsLbl,15);
		VitalityLabel:SetPosition(AgilityLabel:GetLeft(),AgilityLabel:GetTop()+15);
		VitalityLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		VitalityLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		VitalityLabel:SetForeColor( Color["nicegold"] );
		VitalityLabel:SetText( L["Vitality"] );

		VitalityValue=Turbine.UI.Label();
		VitalityValue:SetParent( APICtr );
		VitalityValue:SetSize(StatsVal,15);
		VitalityValue:SetPosition(VitalityLabel:GetLeft()+StatsLbl,VitalityLabel:GetTop());
		VitalityValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		VitalityValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		VitalityValue:SetForeColor( Color["white"] );
		
		local WillLabel = Turbine.UI.Label();
		WillLabel:SetParent( APICtr );
		WillLabel:SetSize(StatsLbl,15);
		WillLabel:SetPosition(VitalityLabel:GetLeft(),VitalityLabel:GetTop()+15);
		WillLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		WillLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		WillLabel:SetForeColor( Color["nicegold"] );
		WillLabel:SetText( L["Will"] );

		WillValue = Turbine.UI.Label();
		WillValue:SetParent( APICtr );
		WillValue:SetSize(StatsVal,15);
		WillValue:SetPosition(WillLabel:GetLeft()+StatsLbl,WillLabel:GetTop());
		WillValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		WillValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		WillValue:SetForeColor( Color["white"] );
		
		local FateLabel =  Turbine.UI.Label();
		FateLabel:SetParent( APICtr );
		FateLabel:SetSize(StatsLbl,15);
		FateLabel:SetPosition(WillLabel:GetLeft(),WillLabel:GetTop()+15);
		FateLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		FateLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		FateLabel:SetForeColor( Color["nicegold"] );
		FateLabel:SetText( L["Fate"] );

		FateValue = Turbine.UI.Label();
		FateValue:SetParent( APICtr );
		FateValue:SetSize(StatsVal,15);
		FateValue:SetPosition(FateLabel:GetLeft()+StatsLbl,FateLabel:GetTop());
		FateValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		FateValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		FateValue:SetForeColor( Color["white"] );
			
		local FinesseLabel = Turbine.UI.Label();
		FinesseLabel:SetParent( APICtr );
		FinesseLabel:SetSize(StatsLbl,15);
		FinesseLabel:SetPosition(FateLabel:GetLeft(),FateLabel:GetTop()+20);
		FinesseLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		FinesseLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		FinesseLabel:SetForeColor( Color["nicegold"] );
		FinesseLabel:SetText( L["Finesse"] );

		FinesseValue = Turbine.UI.Label();
		FinesseValue:SetParent( APICtr );
		FinesseValue:SetSize(StatsVal,15);
		FinesseValue:SetPosition(FinesseLabel:GetLeft()+StatsLbl,FinesseLabel:GetTop());
		FinesseValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		FinesseValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		FinesseValue:SetForeColor( Color["white"] );

		local MitLen, MitLbl, MitVal = 150, 70, 80; --Mitigation size, label size, value size
		local MitigationsHeading = Turbine.UI.Label();
		MitigationsHeading:SetParent(APICtr);
		MitigationsHeading:SetSize(MitLen,18);
		MitigationsHeading:SetPosition(StatsHeading:GetLeft()+StatsHeading:GetWidth()+40, PowerCtr:GetTop()+30);
		MitigationsHeading:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		MitigationsHeading:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
		MitigationsHeading:SetForeColor(Color["white"]);
		MitigationsHeading:SetText(L["Mitigations"]);

		local MitigationsSeparator = Turbine.UI.Control();
		MitigationsSeparator:SetParent(APICtr);
		MitigationsSeparator:SetSize(MitLen+1,1);
		MitigationsSeparator:SetPosition(MitigationsHeading:GetLeft(),MitigationsHeading:GetTop()+18);
		MitigationsSeparator:SetBackColor(Color["trueblue"]);

		local CommonLabel = Turbine.UI.Label();
		CommonLabel:SetParent(APICtr);
		CommonLabel:SetSize(MitLbl,15);
		CommonLabel:SetPosition(MitigationsHeading:GetLeft(),MitigationsHeading:GetTop()+20);
		CommonLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		CommonLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		CommonLabel:SetForeColor(Color["nicegold"]);
		CommonLabel:SetText(L["Common"]);

		CommonValue = Turbine.UI.Label();
		CommonValue:SetParent(APICtr);
		CommonValue:SetSize(MitVal,15);
		CommonValue:SetPosition(CommonLabel:GetLeft()+MitLbl,CommonLabel:GetTop());
		CommonValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		CommonValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		CommonValue:SetForeColor(Color["white"]);
		
		local FireLabel = Turbine.UI.Label();
		FireLabel:SetParent(APICtr);
		FireLabel:SetSize(MitLbl,15);
		FireLabel:SetPosition(CommonLabel:GetLeft(),CommonLabel:GetTop()+15);
		FireLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		FireLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		FireLabel:SetForeColor(Color["nicegold"]);
		FireLabel:SetText(L["Fire"]);

		FireValue = Turbine.UI.Label();
		FireValue:SetParent(APICtr);
		FireValue:SetSize(MitVal,15);
		FireValue:SetPosition(FireLabel:GetLeft()+MitLbl,FireLabel:GetTop());
		FireValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		FireValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		FireValue:SetForeColor(Color["white"]);
		
		local FrostLabel = Turbine.UI.Label();
		FrostLabel:SetParent(APICtr);
		FrostLabel:SetSize(MitLbl,15);
		FrostLabel:SetPosition(FireLabel:GetLeft(),FireLabel:GetTop()+15);
		FrostLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		FrostLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		FrostLabel:SetForeColor(Color["nicegold"]);
		FrostLabel:SetText(L["Frost"]);

		FrostValue = Turbine.UI.Label();
		FrostValue:SetParent(APICtr);
		FrostValue:SetSize(MitVal,15);
		FrostValue:SetPosition(FrostLabel:GetLeft()+MitLbl,FrostLabel:GetTop());
		FrostValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		FrostValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		FrostValue:SetForeColor(Color["white"]);
		
		local ShadowLabel = Turbine.UI.Label();
		ShadowLabel:SetParent(APICtr);
		ShadowLabel:SetSize(MitLbl,15);
		ShadowLabel:SetPosition(FrostLabel:GetLeft(),FrostLabel:GetTop()+15);
		ShadowLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		ShadowLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		ShadowLabel:SetForeColor(Color["nicegold"]);
		ShadowLabel:SetText(L["Shadow"]);

		ShadowValue = Turbine.UI.Label();
		ShadowValue:SetParent(APICtr);
		ShadowValue:SetSize(MitVal,15);
		ShadowValue:SetPosition(ShadowLabel:GetLeft()+MitLbl,ShadowLabel:GetTop());
		ShadowValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		ShadowValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		ShadowValue:SetForeColor(Color["white"]);
		
		local LightningLabel = Turbine.UI.Label();
		LightningLabel:SetParent(APICtr);
		LightningLabel:SetSize(MitLbl,15);
		LightningLabel:SetPosition(ShadowLabel:GetLeft(),ShadowLabel:GetTop()+15);
		LightningLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		LightningLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		LightningLabel:SetForeColor(Color["nicegold"]);
		LightningLabel:SetText(L["Lightning"]);

		LightningValue = Turbine.UI.Label();
		LightningValue:SetParent(APICtr);
		LightningValue:SetSize(MitVal,15);
		LightningValue:SetPosition(LightningLabel:GetLeft()+MitLbl,LightningLabel:GetTop());
		LightningValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		LightningValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		LightningValue:SetForeColor(Color["white"]);
		
		local AcidLabel = Turbine.UI.Label();
		AcidLabel:SetParent(APICtr);
		AcidLabel:SetSize(MitLbl,15);
		AcidLabel:SetPosition(LightningLabel:GetLeft(),LightningLabel:GetTop()+15);
		AcidLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		AcidLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		AcidLabel:SetForeColor(Color["nicegold"]);
		AcidLabel:SetText(L["Acid"]);

		AcidValue = Turbine.UI.Label();
		AcidValue:SetParent(APICtr);
		AcidValue:SetSize(MitVal,15);
		AcidValue:SetPosition(AcidLabel:GetLeft()+MitLbl,AcidLabel:GetTop());
		AcidValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		AcidValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		AcidValue:SetForeColor(Color["white"]);
		
		local PhysicalLabel = Turbine.UI.Label();
		PhysicalLabel:SetParent(APICtr);
		PhysicalLabel:SetSize(MitLbl,15);
		PhysicalLabel:SetPosition(AcidLabel:GetLeft(),AcidLabel:GetTop()+15);
		PhysicalLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		PhysicalLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		PhysicalLabel:SetForeColor(Color["nicegold"]);
		PhysicalLabel:SetText(L["Physical"]);

		PhysicalValue = Turbine.UI.Label();
		PhysicalValue:SetParent(APICtr);
		PhysicalValue:SetSize(MitVal,15);
		PhysicalValue:SetPosition(PhysicalLabel:GetLeft()+MitLbl,PhysicalLabel:GetTop());
		PhysicalValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		PhysicalValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		PhysicalValue:SetForeColor(Color["white"]);
		
		local TacticalLabel = Turbine.UI.Label();
		TacticalLabel:SetParent(APICtr);
		TacticalLabel:SetSize(70,15);
		TacticalLabel:SetPosition(PhysicalLabel:GetLeft(),PhysicalLabel:GetTop()+15);
		TacticalLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		TacticalLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		TacticalLabel:SetForeColor(Color["nicegold"]);
		TacticalLabel:SetText(L["Tactical"]);

		TacticalValue = Turbine.UI.Label();
		TacticalValue:SetParent(APICtr);
		TacticalValue:SetSize(80,15);
		TacticalValue:SetPosition(TacticalLabel:GetLeft()+69,TacticalLabel:GetTop());
		TacticalValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		TacticalValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		TacticalValue:SetForeColor(Color["white"]);
		
		local HealLen, HealLbl, HealVal = 150, 70, 80; --Healing size, label size, value size
		local HealingHeading = Turbine.UI.Label();
		HealingHeading:SetParent(APICtr);
		HealingHeading:SetSize(HealLen,18);
		HealingHeading:SetPosition(MitigationsHeading:GetLeft()+MitigationsHeading:GetWidth()+40,ArmorCtr:GetTop()+30);
		HealingHeading:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		HealingHeading:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
		HealingHeading:SetForeColor( Color["white"] );
		HealingHeading:SetText( L["Healing"] );

		local HealingSeparator = Turbine.UI.Control();
		HealingSeparator:SetParent(APICtr);
		HealingSeparator:SetSize(HealLen+1,1);
		HealingSeparator:SetPosition(HealingHeading:GetLeft(),HealingHeading:GetTop()+18);
		HealingSeparator:SetBackColor( Color["trueblue"] );

		local OutgoingLabel = Turbine.UI.Label();
		OutgoingLabel:SetParent(APICtr);
		OutgoingLabel:SetSize(HealLbl,15);
		OutgoingLabel:SetPosition(HealingHeading:GetLeft(),HealingHeading:GetTop()+20);
		OutgoingLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		OutgoingLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		OutgoingLabel:SetForeColor( Color["nicegold"] );
		OutgoingLabel:SetText( L["Outgoing"] );

		OutgoingValue=Turbine.UI.Label();
		OutgoingValue:SetParent(APICtr);
		OutgoingValue:SetSize(HealVal,15);
		OutgoingValue:SetPosition(OutgoingLabel:GetLeft()+HealLbl,OutgoingLabel:GetTop());
		OutgoingValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		OutgoingValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		OutgoingValue:SetForeColor( Color["white"] );
		
		local IncomingLabel=Turbine.UI.Label();
		IncomingLabel:SetParent(APICtr);
		IncomingLabel:SetSize(HealLbl,15);
		IncomingLabel:SetPosition(OutgoingLabel:GetLeft(),OutgoingLabel:GetTop()+15);
		IncomingLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		IncomingLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		IncomingLabel:SetForeColor( Color["nicegold"] );
		IncomingLabel:SetText( L["Incoming"] );

		IncomingValue=Turbine.UI.Label();
		IncomingValue:SetParent(APICtr);
		IncomingValue:SetSize(HealVal,15);
		IncomingValue:SetPosition(IncomingLabel:GetLeft()+HealLbl,IncomingLabel:GetTop());
		IncomingValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		IncomingValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		IncomingValue:SetForeColor( Color["white"] );
		
		local AvoidLen, AvoidLbl, AvoidVal = 150, 70, 80; --Avoidances size, label size, value size
		local AvoidancesHeading=Turbine.UI.Label();
		AvoidancesHeading:SetParent(APICtr);
		AvoidancesHeading:SetSize(AvoidLen,18);
		AvoidancesHeading:SetPosition(IncomingLabel:GetLeft(),IncomingLabel:GetTop()+20);
		AvoidancesHeading:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		AvoidancesHeading:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
		AvoidancesHeading:SetForeColor(Color["white"]);
		AvoidancesHeading:SetText(L["Avoidances"]);

		local AvoidancesSeparator=Turbine.UI.Control();
		AvoidancesSeparator:SetParent(APICtr);
		AvoidancesSeparator:SetSize(AvoidLen+1,1);
		AvoidancesSeparator:SetPosition(AvoidancesHeading:GetLeft(),AvoidancesHeading:GetTop()+18);
		AvoidancesSeparator:SetBackColor(Color["trueblue"]);

		local BlockLabel=Turbine.UI.Label();
		BlockLabel:SetParent(APICtr);
		BlockLabel:SetSize(AvoidLbl,15);
		BlockLabel:SetPosition(AvoidancesHeading:GetLeft(),AvoidancesHeading:GetTop()+20);
		BlockLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		BlockLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		BlockLabel:SetForeColor(Color["nicegold"]);
		BlockLabel:SetText(L["Block"]);

		BlockValue=Turbine.UI.Label();
		BlockValue:SetParent(APICtr);
		BlockValue:SetSize(AvoidVal,15);
		BlockValue:SetPosition(BlockLabel:GetLeft()+AvoidLbl,BlockLabel:GetTop());
		BlockValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		BlockValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		BlockValue:SetForeColor(Color["white"]);
		
		local ParryLabel=Turbine.UI.Label();
		ParryLabel:SetParent(APICtr);
		ParryLabel:SetSize(AvoidLbl,15);
		ParryLabel:SetPosition(BlockLabel:GetLeft(),BlockLabel:GetTop()+15);
		ParryLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		ParryLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		ParryLabel:SetForeColor(Color["nicegold"]);
		ParryLabel:SetText(L["Parry"]);

		ParryValue=Turbine.UI.Label();
		ParryValue:SetParent(APICtr);
		ParryValue:SetSize(AvoidVal,15);
		ParryValue:SetPosition(ParryLabel:GetLeft()+AvoidLbl,ParryLabel:GetTop());
		ParryValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		ParryValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		ParryValue:SetForeColor(Color["white"]);
		
		local EvadeLabel=Turbine.UI.Label();
		EvadeLabel:SetParent(APICtr);
		EvadeLabel:SetSize(AvoidLbl,15);
		EvadeLabel:SetPosition(ParryLabel:GetLeft(),ParryLabel:GetTop()+15);
		EvadeLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		EvadeLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		EvadeLabel:SetForeColor(Color["nicegold"]);
		EvadeLabel:SetText(L["Evade"]);

		EvadeValue=Turbine.UI.Label();
		EvadeValue:SetParent(APICtr);
		EvadeValue:SetSize(AvoidVal,15);
		EvadeValue:SetPosition(EvadeLabel:GetLeft()+AvoidLbl,EvadeLabel:GetTop());
		EvadeValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		EvadeValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		EvadeValue:SetForeColor(Color["white"]);
		
		local ResistLen, ResistLbl, ResistVal = 150, 70, 80; --Resistances size, label size, value size
		local ResistancesHeading = Turbine.UI.Label();
		ResistancesHeading:SetParent(APICtr);
		ResistancesHeading:SetSize(ResistLen,18);
		ResistancesHeading:SetPosition(EvadeLabel:GetLeft(), EvadeValue:GetTop()+20);
		ResistancesHeading:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		ResistancesHeading:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
		ResistancesHeading:SetForeColor(Color["white"]);
		ResistancesHeading:SetText(L["Resistances"]);

		local ResistancesSeparator = Turbine.UI.Control();
		ResistancesSeparator:SetParent(APICtr);
		ResistancesSeparator:SetSize(ResistLen+1,1);
		ResistancesSeparator:SetPosition(ResistancesHeading:GetLeft(),ResistancesHeading:GetTop()+18);
		ResistancesSeparator:SetBackColor(Color["trueblue"]);

		local BaseLabel = Turbine.UI.Label();
		BaseLabel:SetParent(APICtr);
		BaseLabel:SetSize(ResistLbl,15);
		BaseLabel:SetPosition(ResistancesHeading:GetLeft(),ResistancesHeading:GetTop()+20);
		BaseLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		BaseLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		BaseLabel:SetForeColor(Color["nicegold"]);
		BaseLabel:SetText(L["Base"]);

		BaseValue = Turbine.UI.Label();
		BaseValue:SetParent(APICtr);
		BaseValue:SetSize(ResistVal,15);
		BaseValue:SetPosition(BaseLabel:GetLeft()+ResistLbl,BaseLabel:GetTop());
		BaseValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		BaseValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		BaseValue:SetForeColor(Color["white"]);
		
		local Header, OtherLbl = 90, 100; --Header size, label size
		local MeleeHeading = Turbine.UI.Label();
		MeleeHeading:SetParent(APICtr);
		MeleeHeading:SetSize(Header,18);
		MeleeHeading:SetPosition(FinesseValue:GetLeft()+20,BaseLabel:GetTop()+20);
		MeleeHeading:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		MeleeHeading:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
		MeleeHeading:SetForeColor(Color["white"]);
		MeleeHeading:SetText(L["Physical"]);

		local MeleeSeparator = Turbine.UI.Control();
		MeleeSeparator:SetParent(APICtr);
		MeleeSeparator:SetSize(Header,1);
		MeleeSeparator:SetPosition(MeleeHeading:GetLeft(),MeleeHeading:GetTop()+18);
		MeleeSeparator:SetBackColor(Color["trueblue"]);

		local TacticalHeading = Turbine.UI.Label();
		TacticalHeading:SetParent(APICtr);
		TacticalHeading:SetSize(Header,18);
		TacticalHeading:SetPosition(MeleeHeading:GetLeft()+MeleeHeading:GetWidth()+5,MeleeHeading:GetTop());
		TacticalHeading:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		TacticalHeading:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
		TacticalHeading:SetForeColor(Color["white"]);
		TacticalHeading:SetText(L["Tactical"]);

		local TacticalSeparator = Turbine.UI.Control();
		TacticalSeparator:SetParent(APICtr);
		TacticalSeparator:SetSize(TacticalHeading:GetWidth(),1);
		TacticalSeparator:SetPosition(TacticalHeading:GetLeft(),MeleeSeparator:GetTop());
		TacticalSeparator:SetBackColor(Color["trueblue"]);

		local CriticalAvoidLabel = Turbine.UI.Label();
		CriticalAvoidLabel:SetParent(APICtr);
		CriticalAvoidLabel:SetSize(OtherLbl,15);
		CriticalAvoidLabel:SetPosition(MoraleCtr:GetLeft(),MeleeHeading:GetTop()+20);
		CriticalAvoidLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		CriticalAvoidLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		CriticalAvoidLabel:SetForeColor(Color["nicegold"]);
		CriticalAvoidLabel:SetText(L["CritAvoid"]);

		CriticalMeleeAvoidValue = Turbine.UI.Label();
		CriticalMeleeAvoidValue:SetParent(APICtr);
		CriticalMeleeAvoidValue:SetSize(Header,15);
		CriticalMeleeAvoidValue:SetPosition(MeleeHeading:GetLeft(),CriticalAvoidLabel:GetTop());
		CriticalMeleeAvoidValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		CriticalMeleeAvoidValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		CriticalMeleeAvoidValue:SetForeColor(Color["white"]);
		
		CriticalTacticalAvoidValue = Turbine.UI.Label();
		CriticalTacticalAvoidValue:SetParent(APICtr);
		CriticalTacticalAvoidValue:SetSize(Header,15);
		CriticalTacticalAvoidValue:SetPosition(TacticalHeading:GetLeft(),CriticalAvoidLabel:GetTop());
		CriticalTacticalAvoidValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		CriticalTacticalAvoidValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		CriticalTacticalAvoidValue:SetForeColor(Color["white"]);
		
		local CritHitChanceLabel = Turbine.UI.Label();
		CritHitChanceLabel:SetParent(APICtr);
		CritHitChanceLabel:SetSize(OtherLbl,15);
		CritHitChanceLabel:SetPosition(CriticalAvoidLabel:GetLeft(),CriticalAvoidLabel:GetTop()+15);
		CritHitChanceLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		CritHitChanceLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		CritHitChanceLabel:SetForeColor(Color["nicegold"]);
		CritHitChanceLabel:SetText(L["CritChance"]);

		CritHitMeleeChanceValue = Turbine.UI.Label();
		CritHitMeleeChanceValue:SetParent(APICtr);
		CritHitMeleeChanceValue:SetSize(Header,15);
		CritHitMeleeChanceValue:SetPosition(CriticalMeleeAvoidValue:GetLeft(),CritHitChanceLabel:GetTop());
		CritHitMeleeChanceValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		CritHitMeleeChanceValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		CritHitMeleeChanceValue:SetForeColor(Color["white"]);
		
		CritHitTacticalChanceValue = Turbine.UI.Label();
		CritHitTacticalChanceValue:SetParent(APICtr);
		CritHitTacticalChanceValue:SetSize(Header,15);
		CritHitTacticalChanceValue:SetPosition(CriticalTacticalAvoidValue:GetLeft(),CritHitChanceLabel:GetTop());
		CritHitTacticalChanceValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		CritHitTacticalChanceValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		CritHitTacticalChanceValue:SetForeColor(Color["white"]);
		
		local DamageLabel = Turbine.UI.Label();
		DamageLabel:SetParent(APICtr);
		DamageLabel:SetSize(OtherLbl,15);
		DamageLabel:SetPosition(CritHitChanceLabel:GetLeft(),CritHitChanceLabel:GetTop()+15);
		DamageLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		DamageLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		DamageLabel:SetForeColor(Color["nicegold"]);
		DamageLabel:SetText(L["Mastery"]);

		DamageMeleeValue = Turbine.UI.Label();
		DamageMeleeValue:SetParent(APICtr);
		DamageMeleeValue:SetSize(Header,15);
		DamageMeleeValue:SetPosition(CritHitMeleeChanceValue:GetLeft(),DamageLabel:GetTop());
		DamageMeleeValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		DamageMeleeValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		DamageMeleeValue:SetForeColor(Color["white"]);
		
		DamageTacticalValue = Turbine.UI.Label();
		DamageTacticalValue:SetParent(APICtr);
		DamageTacticalValue:SetSize(Header,15);
		DamageTacticalValue:SetPosition(CritHitTacticalChanceValue:GetLeft(),DamageLabel:GetTop());
		DamageTacticalValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		DamageTacticalValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		DamageTacticalValue:SetForeColor(Color["white"]);
		
		local PlayLbl, PlayVal = 50, 100; --Player size, label size, value size
		local PlayerLevelLabel = Turbine.UI.Label();
		PlayerLevelLabel:SetParent(APICtr);
		PlayerLevelLabel:SetSize(PlayLbl,15);
		PlayerLevelLabel:SetPosition(BaseLabel:GetLeft(),CriticalMeleeAvoidValue:GetTop()-15);
		PlayerLevelLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		PlayerLevelLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		PlayerLevelLabel:SetForeColor(Color["nicegold"]);
		PlayerLevelLabel:SetText(L["Level"]);

		PlayerLevelValue = Turbine.UI.Label();
		PlayerLevelValue:SetParent(APICtr);
		PlayerLevelValue:SetSize(PlayVal,15);
		PlayerLevelValue:SetPosition(PlayerLevelLabel:GetLeft()+PlayLbl,PlayerLevelLabel:GetTop());
		PlayerLevelValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		PlayerLevelValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		PlayerLevelValue:SetForeColor(Color["white"]);
		
		local PlayerRaceLabel = Turbine.UI.Label();
		PlayerRaceLabel:SetParent(APICtr);
		PlayerRaceLabel:SetSize(PlayLbl,15);
		PlayerRaceLabel:SetPosition(PlayerLevelLabel:GetLeft(),CriticalMeleeAvoidValue:GetTop());
		PlayerRaceLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		PlayerRaceLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		PlayerRaceLabel:SetForeColor(Color["nicegold"]);
		PlayerRaceLabel:SetText(L["Race"]);

		PlayerRacelValue = Turbine.UI.Label();
		PlayerRacelValue:SetParent(APICtr);
		PlayerRacelValue:SetSize(PlayVal,15);
		PlayerRacelValue:SetPosition(PlayerRaceLabel:GetLeft()+PlayLbl,PlayerRaceLabel:GetTop());
		PlayerRacelValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		PlayerRacelValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		PlayerRacelValue:SetForeColor(Color["white"]);
		
		local PlayerClassLabel = Turbine.UI.Label();
		PlayerClassLabel:SetParent(APICtr);
		PlayerClassLabel:SetSize(PlayLbl,15);
		PlayerClassLabel:SetPosition(PlayerRaceLabel:GetLeft(),CritHitChanceLabel:GetTop());
		PlayerClassLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		PlayerClassLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		PlayerClassLabel:SetForeColor(Color["nicegold"]);
		PlayerClassLabel:SetText(L["Class"]);

		PlayerClassValue = Turbine.UI.Label();
		PlayerClassValue:SetParent(APICtr);
		PlayerClassValue:SetSize(PlayVal,15);
		PlayerClassValue:SetPosition(PlayerClassLabel:GetLeft()+PlayLbl,PlayerClassLabel:GetTop());
		PlayerClassValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		PlayerClassValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		PlayerClassValue:SetForeColor(Color["white"]);
		
		PlayerXPLabel = Turbine.UI.Label();
		PlayerXPLabel:SetParent(APICtr);
		PlayerXPLabel:SetSize(PlayLbl,15);
		PlayerXPLabel:SetPosition(PlayerClassLabel:GetLeft(),DamageLabel:GetTop());
		PlayerXPLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		PlayerXPLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		PlayerXPLabel:SetForeColor(Color["nicegold"]);
		PlayerXPLabel:SetText(L["XP"]);

		PlayerXPValue = Turbine.UI.Label();
		PlayerXPValue:SetParent(APICtr);
		PlayerXPValue:SetSize(125,15);
		PlayerXPValue:SetPosition(PlayerXPLabel:GetLeft()+25,PlayerXPLabel:GetTop());
		PlayerXPValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		PlayerXPValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		PlayerXPValue:SetForeColor(Color["white"]);
		
		PlayerXPPerValue = Turbine.UI.Label();
		PlayerXPPerValue:SetParent(APICtr);
		PlayerXPPerValue:SetSize(45,15);
		PlayerXPPerValue:SetPosition(PlayerXPLabel:GetLeft()-50,PlayerXPLabel:GetTop());
		PlayerXPPerValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		PlayerXPPerValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		PlayerXPPerValue:SetForeColor(Color["white"]);
	else
		local WarningLabel = Turbine.UI.Label();
		WarningLabel:SetParent(APICtr);
		WarningLabel:SetPosition(25,MoraleCtr:GetTop()+30);
		WarningLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		WarningLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		WarningLabel:SetForeColor( Color["nicegold"] );
		WarningLabel:SetText( L["NoData"] );
		WarningLabel:SetSize(WarningLabel:GetTextLength()*7.2, 15 ); --Auto size with text lenght
	end

	GetData();

	ApplySkin();
end

function GetData()
	--Stats
	MoraleValue:SetText(round(Player:GetMorale()).."/".. round(Player:GetMaxMorale()));
	PowerValue:SetText(round(Player:GetPower()).."/".. round(Player:GetMaxPower()));
	
	if PlayerAlign == 1 then
		curLvl = Player:GetLevel(); --Current player level
		--curLvl = 76; --debug purpose
		--ExpPTS = "13,117,787"; --debug purpose
		--curLvl = 77; --debug purpose
		--ExpPTS = "13,863,500"; --debug purpose
		--PlayerLevelValue:SetText( curLvl ); --debug purpose

		ArmorValue:SetText(PlayerAtt:GetArmor());
		MightValue:SetText(PlayerAtt:GetMight());
		AgilityValue:SetText(PlayerAtt:GetAgility());
		VitalityValue:SetText(PlayerAtt:GetVitality());
		WillValue:SetText(PlayerAtt:GetWill());
		FateValue:SetText(PlayerAtt:GetFate());
		FinesseValue:SetText(PlayerAtt:GetFinesse());

		--Mitigations
		--% = Rtg / (150 * Level + Rtg)
		Rtg = round(PlayerAtt:GetCommonMitigation());
		str = string.format("%.1f", (Rtg / (150 * curLvl + Rtg))*100); --THIS IS NOT THE RIGHT CALCULATION
		CommonValue:SetText(Rtg .. " (" .. str .. "%)");
		CommonValue:SetForeColor( Color["red"] );

		Rtg = round(PlayerAtt:GetFireMitigation());
		str = string.format("%.1f", (Rtg / (150 * curLvl + Rtg))*100);
		FireValue:SetText(Rtg .. " (" .. str .. "%)");

		Rtg = round(PlayerAtt:GetFrostMitigation());
		str = string.format("%.1f", (Rtg / (150 * curLvl + Rtg))*100);
		FrostValue:SetText(Rtg .. " (" .. str .. "%)");

		Rtg = round(PlayerAtt:GetShadowMitigation());
		str = string.format("%.1f", (Rtg / (150 * curLvl + Rtg))*100);
		ShadowValue:SetText(Rtg .. " (" .. str .. "%)");

		Rtg = round(PlayerAtt:GetLightningMitigation());
		str = string.format("%.1f", (Rtg / (150 * curLvl + Rtg))*100);
		LightningValue:SetText(Rtg .. " (" .. str .. "%)");

		Rtg = round(PlayerAtt:GetAcidMitigation());
		str = string.format("%.1f", (Rtg / (150 * curLvl + Rtg))*100);
		AcidValue:SetText(Rtg .. " (" .. str .. "%)");

		Rtg = round(PlayerAtt:GetPhysicalMitigation());
		str = string.format("%.1f", (Rtg / (150 * curLvl + Rtg))*100); --THIS IS NOT THE RIGHT CALCULATION
		PhysicalValue:SetText(Rtg .. " (" .. str .. "%)");
		PhysicalValue:SetForeColor( Color["red"] );

		Rtg = round(PlayerAtt:GetTacticalMitigation());
		str = string.format("%.1f", (Rtg / (150 * curLvl + Rtg))*100);
		TacticalValue:SetText(Rtg .. " (" .. str .. "%)");

		--Healing
		--% = Rtg / (1190/3 * Level + Rtg)
		Rtg = round(PlayerAtt:GetOutgoingHealing());
		str = string.format("%.1f", (Rtg / (1190/3 * curLvl + Rtg))*100);
		OutgoingValue:SetText(Rtg .. " (" .. str .. "%)");
		
		Rtg = round(PlayerAtt:GetIncomingHealing());
		str = string.format("%.1f", (Rtg / (1190/3 * curLvl + Rtg))*100);
		IncomingValue:SetText(Rtg .. " (" .. str .. "%)");
		IncomingValue:SetForeColor( Color["red"] );

		--Avoidances
		--% = Rtg / (1190/3 * Level + Rtg)
		Rtg = round(PlayerAtt:GetBlock());
		str = string.format("%.1f", (Rtg / (1190/3 * curLvl + Rtg))*100); --THIS IS NOT THE RIGHT CALCULATION
		BlockValue:SetText(Rtg .. " (" .. str .. "%)");
		BlockValue:SetForeColor( Color["red"] );

		Rtg = round(PlayerAtt:GetParry());
		str = string.format("%.1f", (Rtg / (1190/3 * curLvl + Rtg))*100); --THIS IS NOT THE RIGHT CALCULATION
		ParryValue:SetText(Rtg .. " (" .. str .. "%)");
		ParryValue:SetForeColor( Color["red"] );
		
		Rtg = round(PlayerAtt:GetEvade());
		str = string.format("%.1f", (Rtg / (1190/3 * curLvl + Rtg))*100);
		EvadeValue:SetText(Rtg .. " (" .. str .. "%)");

		--Resistances
		--% = Rtg / (1190/3 * Level + Rtg)
		--% = Rtg / (1330 * Level + Rtg) <- Partial calculation
		Rtg = round(PlayerAtt:GetBaseResistance());
		str = string.format("%.1f", (Rtg / (1190/3 * curLvl + Rtg))*100);
		BaseValue:SetText(Rtg .. " (" .. str .. "%)");

		Rtg = round(PlayerAtt:GetMeleeCriticalHitAvoidance());
		str = string.format("%.1f", (Rtg / (1190/3 * curLvl + Rtg))*100);
		CriticalMeleeAvoidValue:SetText(Rtg .. " (" .. str .. "%)");
		CriticalMeleeAvoidValue:SetForeColor( Color["red"] );

		Rtg = round(PlayerAtt:GetTacticalCriticalHitAvoidance());
		str = string.format("%.1f", (Rtg / (1190/3 * curLvl + Rtg))*100);
		CriticalTacticalAvoidValue:SetText(Rtg .. " (" .. str .. "%)");
		CriticalTacticalAvoidValue:SetForeColor( Color["red"] );
		
		Rtg = round(PlayerAtt:GetMeleeCriticalHitChance());
		str = string.format("%.1f", (Rtg / (1190/3 * curLvl + Rtg))*100);
		CritHitMeleeChanceValue:SetText(Rtg .. " (" .. str .. "%)");

		Rtg = round(PlayerAtt:GetTacticalCriticalHitChance());
		str = string.format("%.1f", (Rtg / (1190/3 * curLvl + Rtg))*100);
		CritHitTacticalChanceValue:SetText(Rtg .. " (" .. str .. "%)");

		Rtg = round(PlayerAtt:GetMeleeDamage());
		str = string.format("%.1f", (Rtg / (1190/3 * curLvl + Rtg))*100); --THIS IS NOT THE RIGHT CALCULATION
		DamageMeleeValue:SetText(Rtg .. " (" .. str .. "%)");
		DamageMeleeValue:SetForeColor( Color["red"] );

		Rtg = round(PlayerAtt:GetTacticalDamage());
		str = string.format("%.1f", (Rtg / (1190/3 * curLvl + Rtg))*100); --THIS IS NOT THE RIGHT CALCULATION
		DamageTacticalValue:SetText(Rtg .. " (" .. str .. "%)");
		DamageTacticalValue:SetForeColor( Color["red"] );

		PlayerLevelValue:SetText(Player:GetLevel());
		PlayerRacelValue:SetText(PlayerRaceIs);
		PlayerClassValue:SetText(PlayerClassIs);

		if curLvl >= #PlayerLevel then
			PlayerXPValue:SetText( L["MLvl"] );
		else
			-- Calculate max xp for current level
			maxXP = PlayerLevel[curLvl]; --Max XP at current level
			maxXP = string.gsub(maxXP, ",", ""); --Replace "," in 1,400 to get 1400

			--Max XP at previous level
			if curLvl-1 == 0 then preXP = 0;
			else preXP = PlayerLevel[curLvl-1]; end
			preXP = string.gsub(preXP, ",", ""); --Replace "," in 1,400 to get 1400
			maxXP = maxXP - preXP;

			--Calculate the min xp for current level
			minXP = ExpPTS;
			--minXP = string.gsub(minXP, ",", ""); --Replace "," in 1,400 to get 1400
			minXP = string.gsub(minXP, "%p", ""); --Replace decimal separator Ex.: in 1,400 to get 1400
			minXP = minXP - preXP;
			minXP = string.format("%2d", minXP);

			--Calculate % for current level
			percentage_done = string.format("%.2f", (minXP / maxXP)*100);
			PlayerXPPerValue:SetText( percentage_done .. "%" );

			-- Convert back number with comma
			minXP = comma_value(minXP);
			maxXP = comma_value(maxXP);

			PlayerXPValue:SetText( minXP .. "/" .. maxXP);
		end
	end
end

function comma_value(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end