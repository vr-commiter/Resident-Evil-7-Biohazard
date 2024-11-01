
local heartBeatTime = 0
local wallTime = 0
local doorTime = 0
local isTwoHandMelee = false

local function dummyPrefix()
end



function OutputMessage(context)
	local file = io.open("TrueGear.log", "a")			
	file:write(os.date("%Y-%m-%d %H:%M:%S") .. "	[TrueGear]:{".. context .."}\n")
	io.close(file)
end
function ConsoleLog(context)
	local file = io.open("TrueGearLog.log", "a")			
	file:write(os.date("%Y-%m-%d %H:%M:%S") .. "	[TrueGear]:{".. context .."}\n")
	io.close(file)
end

local function dummyPostfix(retval)
    return retval
end

function RegisterHooks()
    
    local file = io.open("TrueGear.log", "w")
    local file1 = io.open("TrueGearLog.log", "w")
	if file then
	    file:close()
	else
	    ConsoleLog("无法打开文件")
	end

    sdk.hook(sdk.find_type_definition("app.WeaponGun"):get_method("shoot"), WeaponGunShoot, dummyPostfix)
    sdk.hook(sdk.find_type_definition("app.PlayerDamageController"):get_method("doDamage"), PlayerDamage, dummyPostfix)
    sdk.hook(sdk.find_type_definition("app.PlayerDamageController"):get_method("doDie"), PlayerDeath, dummyPostfix)
    sdk.hook(sdk.find_type_definition("app.PlayerDamageController"):get_method("doUpdate"), HeartBeat, dummyPostfix)
    sdk.hook(sdk.find_type_definition("app.PlayerMelee"):get_method("getAttackDirection"), MeleeHand, dummyPostfix)
    sdk.hook(sdk.find_type_definition("app.PlayerMelee"):get_method("clearHitWallMaterialID"), Melee, dummyPostfix)
    sdk.hook(sdk.find_type_definition("app.PlayerWeaponChange"):get_method("useItem"), Healing, dummyPostfix)
    sdk.hook(sdk.find_type_definition("app.ItemManager"):get_method("setItemGotFlag"), setItemGotFlag, dummyPostfix)    
    sdk.hook(sdk.find_type_definition("app.PlayerHandTouch"):get_method("_updateDoorAttach"), _updateDoorAttach, dummyPostfix)
    sdk.hook(sdk.find_type_definition("app.PlayerHandTouch"):get_method("_updateWallAttach"), _updateWallAttach, dummyPostfix)

    local vibrationmanager_t = sdk.find_type_definition("app.VibrationManager")
    local method = vibrationmanager_t:get_method("requestAdd(app.VibrationParam, System.Single)")
    if method == nil then
        method = vibrationmanager_t:get_method("requestAdd(app.VibrationParam, System.Single, System.Boolean)")
    end
    sdk.hook(method, Shake, dummyPostfix)
    
    OutputMessage("HeartBeat")
    
end




function _updateWallAttach()
    if os.clock() - wallTime > 0.100 then 
        -- ConsoleLog("---------------------------------------------")
        -- ConsoleLog("_updateWallAttach")
        OutputMessage("LeftHandPickupItem")
        -- ConsoleLog(tostring(os.clock()))
        wallTime = os.clock() 
    end 
end

function _updateDoorAttach()
    if os.clock() - doorTime > 0.100 then 
        -- ConsoleLog("---------------------------------------------")
        -- ConsoleLog("_updateDoorAttach")
        OutputMessage("LeftHandPickupItem")
        doorTime = os.clock() 
    end
    -- ConsoleLog(tostring(reframework:get_build_time()))
end

function setItemGotFlag()
    -- ConsoleLog("---------------------------------------------")
	-- ConsoleLog("BackSlotInputItem")
    OutputMessage("BackSlotInputItem")
end

function WeaponGunShoot(args)
    ConsoleLog("---------------------------------------------")
	ConsoleLog("RightHandShoot")
    OutputMessage("RightHandPistolShoot")
	if re8vr.was_gripping_weapon then
		ConsoleLog("LeftHandShoot")
        OutputMessage("LeftHandPistolShoot")
	end
    local weapon = sdk.to_managed_object(args[2])
    ConsoleLog(sdk.to_managed_object(weapon):get_field("WeaponGunParameter"))
end

function PlayerDamage()
    -- ConsoleLog("---------------------------------------------")
	-- ConsoleLog("PoisonDamage")
    OutputMessage("PoisonDamage")
end

function PlayerDeath()
    -- ConsoleLog("---------------------------------------------")
	-- ConsoleLog("PlayerDeath")
    OutputMessage("PlayerDeath")
end

function HeartBeat(args)
	local damageController = sdk.to_managed_object(args[2])
	if damageController:get_isDying() then
		if (os.clock() - heartBeatTime) > 1  then
            -- ConsoleLog("---------------------------------------------")
	        -- ConsoleLog("HeartBeat")
            OutputMessage("HeartBeat")
            heartBeatTime = os.clock()
        end
	end
end

function MeleeHand(args)
    local melee = sdk.to_managed_object(args[2])
    isTwoHandMelee = melee:get_field("PlayerStatus"):get_isBothHandsAnim()
end

function Melee(args)
    local melee = sdk.to_managed_object(args[2])
    -- ConsoleLog("---------------------------------------------")
	-- ConsoleLog("RightHandMeleeHit")
    OutputMessage("RightHandMeleeHit")
    if isTwoHandMelee then
        -- ConsoleLog("LeftHandMeleeHit")
        OutputMessage("LeftHandMeleeHit")
    end
    
end

function Healing(args)
    local item = sdk.to_managed_object(args[3])
	local itemData = item:get_ItemData()
    ConsoleLog("---------------------------------------------")
    ConsoleLog("UseItem")
    ConsoleLog(string.lower(itemData:get_field("ItemDataID")))
	if string.find(string.lower(itemData:get_field("ItemDataID")), "remedy") then		
	    -- ConsoleLog("Healing")
        OutputMessage("Healing")
	end
end

function Shake()
    if re8vr.is_in_cutscene then
	    -- ConsoleLog("---------------------------------------------")
	    -- ConsoleLog("Shake")
        OutputMessage("Shake")
	end
end

RegisterHooks()

-- ConsoleLog("---------------------------------------------")
-- ConsoleLog("TrueGear Mod Is Loaded")