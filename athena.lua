
-- project Athena --

--[[ For refernce I still have a ways to go but for now I'm pasting from documentation 

TODO 
[+] Entity Scanner [+]
[+] Skeleton ESP [+]
[+] Color Changer [+]
]]--

--[[
local t = {}
t.esp = {}
t.esp.enabled = false
t.esp.teamonly = false
t.esp.enemyonly = false
t.esp.showxyz = false
t.esp.twodbox = false
t.esp.name = false
t.esp.health = false
t.esp.weapon = false
t.esp.skeleton = false
for k,v in pairs(t.esp) do
	print(k)
	print(v)
end
]]--
_G.counter = 0
_G.espe = 0
_G.espen = 0
_G.espent = 0
_G.espa = 0
_G.espb = 0
_G.espt = 0
_G.esph = 0
_G.esps = 0
_G.espna = 0
_G.espw = 0
local me = LocalPlayer()
local mpos = me:GetPos()
local counter = 0 
local type = type;
local next = next;
local function Copy(tt, lt)
	local copy = {}
	if lt then
		if type(tt) == "table" then
			for k,v in next, tt do
				copy[k] = Copy(k, v)
			end
		else
			copy = lt
		end
		return copy
	end
	if type(tt) != "table" then
		copy = tt
	else
		for k,v in next, tt do
			copy[k] = Copy(k, v)
		end
	end
	return copy
end
local surface = Copy(surface);
local vgui = Copy(vgui);
local input = Copy(input);
local Color = Color;
local ScrW, ScrH = ScrW, ScrH;
local gui = Copy(gui);
local math = Copy(math);
local file = Copy(file);
local util = Copy(util);
local Sens = GetConVar("sensitivity");
local Sensitivity = Sens:GetFloat();
local G = table.Copy( _G )
--local _R = G.debug.getregistry()
--local hookGetTableCopy = G.table.Copy( hook.GetTable() )
local Run = Run or {}
local FindMetaTable = FindMetaTable;
local em = FindMetaTable"Entity";
local pm = FindMetaTable"Player";
local cm = FindMetaTable"CUserCmd";
local wm = FindMetaTable"Weapon";
local am = FindMetaTable"Angle";
local vm = FindMetaTable"Vector";
local Vector = Vector;
local player = Copy(player);
local Angle = Angle;
local me = LocalPlayer();
local render = Copy(render);
local cma = Copy(cam);
local Material = Material;
local CreateMaterial = CreateMaterial;

if(!IsValid(me)) then me = LocalPlayer() return end
	LocalPlayer():ConCommand("cl_interp 0; cl_interp_ratio 0; cl_cmdrate 200; cl_updaterate 200; rate 51200");
	GAMEMODE["RenderScreenspaceEffects"] = ChamsDud;
	
function menu()
    _G.counter = 1
    -- Menu --
    local Frame = vgui.Create( "DFrame")
    Frame:SetParent( DermaPanel )
    Frame:SetPos( 5, 30 )
    Frame:SetSize( ScrW() * 0.50, ScrH() * 0.50 )
    Frame:SetTitle( "Athena" )
    Frame:SetVisible( true )
    Frame:SetDraggable( true )
    Frame:Center()
    Frame:ShowCloseButton( true )
    Frame:MakePopup()
    Frame.Paint = function( self, w, h ) 
        draw.RoundedBox( 0, 0, 0, w, h, Color( 102,0,255, 150 ) )
    end
	
	local ESPTab = vgui.Create( "DPropertySheet", Frame )
	ESPTab:Dock( FILL )
	local ESP = vgui.Create( "DPanel" )
	ESP.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 102,0,255, 150 ) )
    end
	
	local ESPEnabled = vgui.Create( "DCheckBoxLabel", ESP )
	ESPEnabled:SetText("Enabled")
	ESPEnabled:SetChecked(_G.espe)
	ESPEnabled:SetPos(5,7)
	ESPEnabled:SizeToContents()
	function ESPEnabled:OnChange( ESPE )
		if ESPE then
			_G.espe = 1
		else
			_G.espe = 0
		end
	end
	
	local ESPTeam = vgui.Create( "DCheckBoxLabel", ESP )
	ESPTeam:SetText("Team Only")
	ESPTeam:SetChecked(_G.espt)
	ESPTeam:SetPos(5,27)
	ESPTeam:SizeToContents()
	function ESPTeam:OnChange( ESPT )
		if ESPT then
			_G.espt = 1
		else
			_G.espt = 0
		end
	end
	
	local ESPEnemy = vgui.Create( "DCheckBoxLabel", ESP )
	ESPEnemy:SetText("Enemy Only")
	ESPEnemy:SetChecked(_G.espen)
	ESPEnemy:SetPos(5,47)
	ESPEnemy:SizeToContents()
    function ESPEnemy:OnChange( ESPEN )
		if ESPEN then
			_G.espen = 1
		else
			_G.espen = 0
		end
	end
	
	local ESPAdmin = vgui.Create( "DCheckBoxLabel", ESP )
	ESPAdmin:SetText("Admins")
	ESPAdmin:SetPos(5,67)
	ESPAdmin:SetChecked(_G.espa)
	ESPAdmin:SizeToContents()
	--ESPAdmin:Size
	function ESPAdmin:OnChange( ESPA )
		if ESPA then
			_G.espa = 1
		else
			_G.espa = 0
		end
	end
	
	local ESPName = vgui.Create( "DCheckBoxLabel", ESP )
	ESPName:SetText("Names")
	ESPName:SetPos(5,87)
	ESPName:SetChecked(_G.espna)
	ESPName:SizeToContents()
	function ESPName:OnChange( ESPNA )
		if ESPNA then
			_G.espna = 1
		else
			_G.espna = 0
		end
	end
	local ESPHealth = vgui.Create( "DCheckBoxLabel", ESP )
	ESPHealth:SetText("Health")
	ESPHealth:SetPos(5,147)
	ESPHealth:SetChecked(_G.esph)
	ESPHealth:SizeToContents()
	function ESPHealth:OnChange( ESPH )
		if ESPH then
			_G.esph = 1
		else
			_G.esph = 0
		end
	end
	
	local ESPBox = vgui.Create( "DCheckBoxLabel", ESP )
	ESPBox:SetText("2D Boxes")
	ESPBox:SetPos(5,107)
	ESPBox:SetChecked(_G.espb)
	ESPBox:SizeToContents()
	function ESPBox:OnChange( ESPB )
		if ESPB then
			_G.espb = 1
		else
			_G.espb = 0
		end
	end
	
	local ESPWeapon = vgui.Create( "DCheckBoxLabel", ESP )
	ESPWeapon:SetText("Weapons")
	ESPWeapon:SetPos(5,127)
	ESPWeapon:SetChecked(_G.espb)
	ESPWeapon:SizeToContents()
	function ESPWeapon:OnChange( ESPW )
		if ESPW then
			_G.espw = 1
		else
			_G.espw = 0
		end
	end
	
	ESPTab:AddSheet( "ESP", ESP, "icon16/user.png")
	Frame.OnClose = function()
        _G.counter = 0
    end
end
function ESP(v)
	local pos = em.GetPos(v);
	local pos, pos2 = vm.ToScreen(pos - Vector(0, 0, 5)), vm.ToScreen( pos + Vector(0, 0, 70 ) );
	local h = pos.y - pos2.y;
	local w = h / 2.2;
	if espb == 1 then        	
		surface.SetDrawColor(255,255,255,255);
		surface.DrawOutlinedRect( pos.x - w / 2, pos.y - h, w, h);
		surface.SetDrawColor(0, 0, 0, 255);
		surface.DrawOutlinedRect( pos.x - w / 2 - 1, pos.y - h - 1, w + 2, h + 2);
		surface.DrawOutlinedRect( pos.x - w / 2 + 1, pos.y - h + 1, w - 2, h - 2);			
	end
	
	if esph == 1 then
		local hp = em.Health(v) * h / 100;
		if(hp > h) then hp = h; end
			local diff = h - hp;
			surface.SetDrawColor(0, 0, 0, 255);
			surface.DrawRect(pos.x - w / 2 - 5, pos.y - h - 1, 3, h + 2);
			surface.SetDrawColor( ( 100 - em.Health(v) ) * 2.55, em.Health(v) * 2.55, 0, 255);
			surface.DrawRect(pos.x - w / 2 - 4, pos.y - h + diff, 1, hp);
		end
		surface.SetFont("BudgetLabel");	
		surface.SetTextColor(255, 255, 255);	
		
		if espna == 1 then
			Name = pm.Name(v);
			local tw, th = surface.GetTextSize(Name);		
			surface.SetTextPos( pos.x - tw / 2, pos.y - h + 2 - th );
			surface.DrawText(Name);		
		end	
		if espw == 1 then	
			local w = pm.GetActiveWeapon(v);
			if(w && em.IsValid(w)) then
				local tw,  th = surface.GetTextSize(em.GetClass(w));
				surface.SetTextPos( pos.x - tw / 2, pos.y - th / 2 + 5 );
				surface.DrawText(em.GetClass(w)); 
			end
		end			
	if esps == 1 then
		local origin = em.GetPos(v);
		for i = 1, em.GetBoneCount(v) do
			local parent = em.GetBoneParent(v, i);
			if(!parent) then continue; end
			local bonepos, parentpos = em.GetBonePosition(v, i), em.GetBonePosition(v, parent);
			if(!bonepos || !parentpos || bonepos == origin) then continue; end
			local bs, ps = vm.ToScreen(bonepos), vm.ToScreen(parentpos);
			surface.SetDrawColor(255, 255, 255);
			surface.DrawLine(bs.x, bs.y, ps.x, ps.y);
		end
	end		
end
function staff()
	function ad(ply)
		local pos = (ply:GetPos() + Vector( 0, 0, 50 )):ToScreen()
		draw.DrawText("Admin","Default",pos.x,pos.y,Color(255,255,255,255),TEXT_ALIGN_CENTER)
	end
	function sad(ply)
		local pos = (ply:GetPos() + Vector( 0, 0, 50 )):ToScreen()
		draw.DrawText("Superadmin","Default",pos.x,pos.y,Color(255,0,0,255),TEXT_ALIGN_CENTER)
	end
	for k,v in pairs(player.GetAll()) do	
		if v:IsSuperAdmin() then
			sad(v)
		elseif v:IsAdmin() then
			ad(v)
		end
	end
end

function xyz()
	local x = mpos.x
	local y = mpos.y
	local z = mpos.z
	draw.DrawText("X:%s\nY:%s\nZ:%s","TargetID",5,7).format(x,y,z)
end

function AC(a)
	if _G.CAC then
		draw.DrawText("Detected Anti-Cheat\n---------------","TargetID",5,a,Color(255,0,0,255))
	end
end

function EntityFinder(v)
	function haloents(v)
		halo.Add() -- use the same method in staff()
	end
	for k,v in pairs(ents.GetAll()) do 
		haloents(v) 
	end
end
		
hook.Add('HUDPaint','painthud', function()
	if espe == 1 then
		for k,v in next, player.GetAll() do
			if(!em.IsValid(v) || em.Health(v) < 1 || v == me || em.IsDormant(v)) then continue; end
				ESP(v);
			end
		if espa == 1 then
			staff()
		end
		if espn == 1 then
			-- draw enemy only
		end	
		if espb == 1 then -- make box esp a requirement to use the settings below
			-- draw box esp
			if espw == 1 then
				-- draw weapon
			end
			if esps == 1 then
				-- draw skeleton
			end
			if esph == 1 then
				-- draw healthbar see pasteware for details
			end
		end	
		if espxyz == 1 then
			xyz()
		end	
		if espent == 1 then
			-- draw esp maybe chams for entities?
		end		
		if espp == 1 then
			-- draw prop esp maybe??
		end
	end
	if MiscAC == 1 then
		if espxyz == 0 then
			AC(60)
		else
			AC(5)
		end
	end	
end)

hook.Add("Think",'ins', function()
    if input.IsKeyDown(KEY_INSERT) then
        if _G.counter < 1 then
            menu()
        end
    end
end)
