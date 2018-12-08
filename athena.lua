-- project Athena --

--[[ For refernce I still have a ways to go but for now I'm pasting from documentation 
TODO 
[+] Entity ESP [+]
[+] Color Changer [+]
[+] Tidy up code [+]
]]--
_G.counter = 0
local t = {}
t.esp = {}
t.esp.enabled = false
t.esp.team = false
t.esp.enemy = false
t.esp.admin = false
t.esp.name = false
t.esp.box = false
t.esp.weapon = false
t.esp.health = false
t.esp.skeleton = false
t.esp.entity = false
t.esp.gskeleton = false
t.esp.xyz = false
t.esp.entities = {"money_printer", "spawned_money", "spawned_shipment"}

--[[for k,v in pairs(t.esp) do
	print(k,v)
end]]--
local function Copy1(tt, lt)
	local copy = {}
	if lt then
		if type(tt) == "table" then
			for k,v in next, tt do
				copy[k] = Copy1(k, v)
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
			copy[k] = Copy1(k, v)
		end
	end
	return copy
end
local menunames = {"Enabled","Team Only","Enemy Only", "Admins", "Names", "Box", "Weapon","Health","Skeleton","Entity", "Glowing Skeleton"}
local menuitems = {"Enabled","Team","Enemy", "Admin", "Name", "Box", "Weapon","Health","Skeleton","Entity", "gskeleton"}
local menutable = {"enabled","team","enemy", "admin", "name", "box", "weapon","health","skeleton","entity","gskeleton"}
local me = LocalPlayer()
local mpos = me:GetPos()
local counter = 0 
local surface = Copy1(surface);
local vgui = Copy1(vgui);
local input = Copy1(input);
local gui = Copy1(gui);
local math = Copy1(math);
local file = Copy1(file);
local util = Copy1(util);
local FindMetaTable = FindMetaTable;
local em = FindMetaTable"Entity";
local pm = FindMetaTable"Player";
local vm = FindMetaTable"Vector";
local render = Copy1(render);



if(!IsValid(me)) then me = LocalPlayer() return end
	LocalPlayer():ConCommand("cl_interp 0; cl_interp_ratio 0; cl_cmdrate 200; cl_updaterate 200; rate 51200");
	GAMEMODE["RenderScreenspaceEffects"] = ChamsDud;
local function btn_paint(but)
		function but.OnCursorEntered()
			but.hover = true
			but:SetTextColor(BgColor)
		end
		function but.OnCursorExited()
			but.hover = false
			but:SetTextColor(ForColor)
		end
		function but.Paint()
			but:SetTextColor(ForColor)
			draw.RoundedBox(0, 0, 0, but:GetWide(), but:GetTall(), Color(255,255,255,150)) -- Arrows
			draw.RoundedBox(0, 1, 1, but:GetWide() - 2, but:GetTall() - 2, Color(102,0,255,150)) -- Arrow box Background
			if but.hover then
				but:SetTextColor(Color(102,00,255,150))
				draw.RoundedBox(0, 0, 0, but:GetWide(), but:GetTall(), Color(0,0,0,255))
			end
		end
	end
	
	local function view_paint(view)
		function view.Paint()
			draw.RoundedBox(0, 0, 0, view:GetWide(), view:GetTall(), Color(102,0,255,75)) -- Entity Column Background Color 
		end
	end	

function menu()
    _G.counter = 1
	local posH = 5
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
	
	local Tabs = vgui.Create( "DPropertySheet", Frame )
	Tabs:Dock( FILL )
	
	local ESP = vgui.Create( "DPanel" )
	ESP.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 102,0,255, 150 ) )
    end
	
	local Misc = vgui.Create( "DPanel" )
	Misc.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 102,0,255, 150 ) )
    end
	local EntityFinder = vgui.Create( "DPanel" )
	EntityFinder.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 102,0,255, 150 ) )
    end
	
	for k, v in pairs(menuitems) do
		local change = menutable[k]
		local Easp = 'ESP'	
		local conName = Easp..v
		local conname = string.lower(v)
		local conNAME = string.upper(v)
		local conByte = string.len(conName)
		local conName = vgui.Create( "DCheckBoxLabel", ESP )
		conName:SetText(menunames[k])
		conName:SetPos(5,posH)
		conName:SetChecked(t.esp[''..menutable[k]])
		conName:SizeToContents()
		function conName:OnChange( change )
			if change then
				t.esp[''..menutable[k]] = true
			else
				t.esp[''..menutable[k]] = false
			end
		end
		posH = posH +20
	end
	
	local backpanel = vgui.Create("DFrame", EntityFinder)
	backpanel:SetTitle("Entity list")
	backpanel:Center()
	backpanel:SetDraggable( false )
	backpanel:SetSize( ScrW() * 0.50, ScrH() * 0.50 )
	backpanel:ShowCloseButton( false )
	function backpanel.Paint()
		draw.RoundedBox(2, 0, 0, backpanel:GetWide(), backpanel:GetTall(), Color(255,255,255,255))
		draw.RoundedBox(2, 1, 1, backpanel:GetWide() - 2, backpanel:GetTall() - 2, Color(102,0,255,150)) -- Border
		draw.RoundedBox(0, 0, 0, backpanel:GetWide(), 22, Color(102,0,255,150)) -- Outer Border 
	end

	local view1 = vgui.Create("DListView", backpanel)
	view1:SetPos(5,30)
	view1:SetSize(backpanel:GetWide()/2 - 30, backpanel:GetTall()-35)
	local view = view1:AddColumn("Not on ESP")
	view1:SetMultiSelect( false )

	view_paint(view1)

	local entities = {}
	for k,v in pairs(ents.GetAll()) do
		local class = v:GetClass()
		if !table.HasValue(entities,class) then
			table.insert(entities,class)
			view1:AddLine(class)
		end
	end

	for k,v in pairs(view1:GetLines()) do
		function v.Paint()
			local val = v:GetValue()
			draw.RoundedBox(0, 1, 1, v:GetWide() - 2, v:GetTall() - 2, Color(102,0,255,0)) -- Not on ESP Column Color
			v.Columns[1]:SetTextColor(Color(0,0,0,255))

			if v:IsSelected() then
				draw.RoundedBox(0, 1, 1, v:GetWide() - 2, v:GetTall() - 2, Color(255,255,255,255))
				v.Columns[1]:SetTextColor(Color(255,0,0,255))
			end

		end
	end

	function view.Header.Paint()
		draw.RoundedBox(0, 0, 0, view.Header:GetWide(), view.Header:GetTall(), Color(102,0,255,150))
		view.Header:SetTextColor(Color(0,0,0,255))
	end

	local view2 = vgui.Create("DListView", backpanel)
	view2:SetPos(backpanel:GetWide() - view1:GetWide() - 5,30)
	view2:SetSize(backpanel:GetWide()/2 - 30, backpanel:GetTall()-35)
	view2:SetMultiSelect( false )
	local view = view2:AddColumn("On ESP")
	for k,v in pairs(t.esp.entities) do
		view2:AddLine(v)
	end

	view_paint(view2)

	for k,v in pairs(view2:GetLines()) do
		function v.Paint()
			local val = v:GetValue()
			draw.RoundedBox(0, 1, 1, v:GetWide() - 2, v:GetTall() - 2, Color(255,255,255,0)) -- Column background
			v.Columns[1]:SetTextColor(Color(0,0,0,255))

			if v:IsSelected() then
				draw.RoundedBox(0, 1, 1, v:GetWide() - 2, v:GetTall() - 2, Color(255,255,255,255))
				v.Columns[1]:SetTextColor(Color(255,0,0,255))
			end

		end
	end

	local function refresh()

		if IsValid(view2) then
			view2:Clear()
			for k,v in pairs(t.esp.entities) do
				view2:AddLine(v)
			end
		end

		entities = {}

		if IsValid(view1) then
			view1:Clear()

			for k,v in pairs(ents.GetAll()) do
				local class = v:GetClass()
			
				if !table.HasValue(entities,class) then
					table.insert(entities,class)
					view1:AddLine(class)
				end
			
			end

		end


	


	end

	function view.Header.Paint()
		draw.RoundedBox(0, 0, 0, view.Header:GetWide(), view.Header:GetTall(), Color(102,0,255,150)) -- On ESP header Color
		view.Header:SetTextColor(Color(0,0,0,255))
	end

	local but = vgui.Create("DButton", backpanel)
	but:SetPos(view1:GetWide() + 10, backpanel:GetTall()/2 - 10)
	but:SetSize(40,20)
	but:SetText("->")
	btn_paint(but)
	function but.DoClick()
		local class = view1:GetSelected()[1].Columns[1]:GetValue() -- Something tells me I'm overcomplicating it ^.^
		print(class)

		if !table.HasValue(t.esp.entities, class) then
			table.insert(t.esp.entities,class)
		else
			draw.SimpleText('')
		end

		refresh()
		end

	local but = vgui.Create("DButton", backpanel)
	but:SetPos(view1:GetWide() + 10, backpanel:GetTall()/2 + 15)
	but:SetSize(40,20)
	but:SetText("<-")
	btn_paint(but)
	function but.DoClick()
		local class = view2:GetSelected()[1].Columns[1]:GetValue()

		if table.HasValue(t.esp.entities, class) then
			table.RemoveByValue(t.esp.entities,class)
		end

		refresh()

	end

	Tabs:AddSheet( "ESP", ESP, "icon16/user.png")
	Tabs:AddSheet( "Misc", Misc, "icon16/user.png")
	Tabs:AddSheet( "Entity Finder", EntityFinder, "icon16/user.png")
	
	Frame.OnClose = function()
        _G.counter = 0
    end
end

function ESP(v) -- courtesy of pasteware
	local pos = em.GetPos(v);
	local pos, pos2 = vm.ToScreen(pos - Vector(0, 0, 5)), vm.ToScreen( pos + Vector(0, 0, 70 ) );
	local h = pos.y - pos2.y;
	local w = h / 2.2;
	if t.esp.box == true then        	
		surface.SetDrawColor(255,255,255,255);
		surface.DrawOutlinedRect( pos.x - w / 2, pos.y - h, w, h);
		surface.SetDrawColor(0, 0, 0, 255);
		surface.DrawOutlinedRect( pos.x - w / 2 - 1, pos.y - h - 1, w + 2, h + 2);
		surface.DrawOutlinedRect( pos.x - w / 2 + 1, pos.y - h + 1, w - 2, h - 2);			
	end
	
	if t.esp.health == true then
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
		
		if t.esp.name == true then
			Name = pm.Name(v);
			local tw, th = surface.GetTextSize(Name);		
			surface.SetTextPos( pos.x - tw / 2, pos.y - h + 2 - th );
			surface.DrawText(Name);		
		end	
		if t.esp.weapon == true then	
			local w = pm.GetActiveWeapon(v);
			if(w && em.IsValid(w)) then
				local tw,  th = surface.GetTextSize(em.GetClass(w));
				surface.SetTextPos( pos.x - tw / 2, pos.y - th / 2 + 5 );
				surface.DrawText(em.GetClass(w)); 
			end
		end			
	if t.esp.skeleton == true then
		local origin = em.GetPos(v);
		for i = 1, em.GetBoneCount(v) do
			local parent = em.GetBoneParent(v, i);
			if(!parent) then continue; end
			local bonepos, parentpos = em.GetBonePosition(v, i), em.GetBonePosition(v, parent);
			if(!bonepos || !parentpos || bonepos == origin) then continue; end
			local bs, ps = vm.ToScreen(bonepos), vm.ToScreen(parentpos);
			if t.esp.gskeleton == true then
				surface.SetDrawColor(math.random(0,255)%360,math.random(0,255)%360,math.random(0,255)%360, 255);
			else
				surface.SetDrawColor(255, 255, 255);
			end
			surface.DrawLine(bs.x, bs.y, ps.x, ps.y);
		end
	end		
end
function staff()
	function ad(ply)
		local zOffset = 50 // unsure why we offset by 50 
		local x = ply:GetPos().x			//Get the X position of our player
		local y = ply:GetPos().y			//Get the Y position of our player
		local z = ply:GetPos().z			//Get the Z position of our player
		local pos = Vector(x,y,z+zOffset)	//Add our offset onto the Vector
		local pos2d = pos:ToScreen()		//Change the 3D vector to a 2D one
		draw.DrawText("Admin","Default",pos2d.x,pos2d.y,Color(255,255,255,255),TEXT_ALIGN_CENTER)	//Draw the indicator
	end
	function sad(ply)
		local zOffset = 50 // unsure why we offset by 50 
		local x = ply:GetPos().x			//Get the X position of our player
		local y = ply:GetPos().y			//Get the Y position of our player
		local z = ply:GetPos().z			//Get the Z position of our player
		local pos = Vector(x,y,z+zOffset)	//Add our offset onto the Vector
		local pos2d = pos:ToScreen()		//Change the 3D vector to a 2D one
		draw.DrawText("SuperAdmin","Default",pos2d.x,pos2d.y,Color(math.random(0,255)%360,math.random(0,255)%360,math.random(0,255)%360, 255),TEXT_ALIGN_CENTER)	//Draw the indicator
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
		
hook.Add('HUDPaint','painthud', function()
	if t.esp.enabled == true then
		for k,v in next, player.GetAll() do
			if(!em.IsValid(v) || em.Health(v) < 1 || v == me || em.IsDormant(v)) then continue; end
				ESP(v);
			end
		if t.esp.admin == true then
			staff()
		end
		if t.esp.enemy == true then
			-- draw enemy only
		end	
		if t.esp.xyz == true then
			xyz()
		end	
		if t.esp.entity == true then
			for k,v in pairs(ents.GetAll()) do

			if table.HasValue(t.esp.entities, v:GetClass()) and !v:IsDormant() then
				local class = v:GetClass()
				local classize = surface.GetTextSize(class)
				local posy = v:GetPos():ToScreen()

			cam.Start3D()
				cam.IgnoreZ(true)
				render.MaterialOverride(Material("models/debug/debugwhite"))
				render.SuppressEngineLighting( true )

				local col = Color(102,0,255,150)

				render.SetColorModulation( col.r/255, col.g/255, col.b/255 )
					v:DrawModel()
				render.SetColorModulation( 1, 1, 1 )
				
				render.SuppressEngineLighting( false )
				render.MaterialOverride(0)
				cam.IgnoreZ(false)

			cam.End3D()

			pony.drawtext(class, posy.x - classize*0.5,posy.y)

		end

	end
		end		
		if t.esp.prop == true then
			-- draw prop esp maybe??
		end
	end
	if MiscAC == true then
		if t.esp.xyz == false then
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
