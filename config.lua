Config = {}

-- System is always enabled (no toggle)
Config.Enabled = true

-- What to remove (all enabled by default)
Config.Remove = {
    ambientPeds = true,        -- Civilian NPCs
    policePeds = true,         -- Police officers
    scenarioPeds = true,       -- Scenario NPCs
    parkedVehicles = true,     -- Parked cars
    randomVehicles = true,     -- Traffic vehicles
    policeVehicles = true,     -- Police cars
    gangPeds = true,           -- Gang members
    animalPeds = true          -- Animals
}

-- Aggressiveness settings
Config.AggressiveMode = {
    enabled = true,            -- More aggressive removal
    removalDistance = 250.0,   -- How far to remove NPCs (in units)
    checkInterval = 500,       -- How often to check (milliseconds)
    instantRemoval = true      -- Remove immediately when spotted
}

-- Specific NPC model blacklist
Config.BlacklistedModels = {
    -- Police Models
    "s_m_y_cop_01", "s_f_y_cop_01", "s_m_y_hwaycop_01", "s_m_y_sheriff_01", 
    "s_f_y_sheriff_01", "s_m_y_ranger_01", "s_f_y_ranger_01", "s_m_y_swat_01",
    
    -- Army Models
    "s_m_y_armymech_01", "s_m_y_blackops_01", "s_m_y_blackops_02", "s_m_y_blackops_03",
    
    -- Gang Models
    "g_m_y_ballaeast_01", "g_m_y_ballaorig_01", "g_m_y_famca_01", "g_m_y_famdnf_01",
    "g_m_y_famfor_01", "g_m_y_korean_01", "g_m_y_korean_02", "g_m_y_lost_01",
    "g_m_y_lost_02", "g_m_y_lost_03", "g_m_y_mexgang_01", "g_m_y_mexgoon_01",
    "g_m_y_pologoon_01", "g_m_y_salvaboss_01", "g_m_y_salvagoon_01",
    
    -- Animal Models
    "a_c_boar", "a_c_chickenhawk", "a_c_coyote", "a_c_deer", "a_c_mtlion"
}

-- Debug information in console
Config.Debug = false