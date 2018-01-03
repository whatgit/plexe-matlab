classdef traci_constants
    %this class contains constants defined by TraCI and some additions
    properties
        %% Commands
        cmd_step_simulation = hex2dec('02')
        
        cmd_subscribe_vehicle = hex2dec('D4')
        cmd_subscribe_vehicle_resp = hex2dec('E4')
        
        %% Variables
        
        var_speed = hex2dec('40')
        var_2d_position = hex2dec('42')
        var_lane_position = hex2dec('56')
        var_road_id = hex2dec('50')
        
        %% Data types
        data_2DPos = hex2dec('01')
        data_double = hex2dec('0B')
        data_string = hex2dec('0C')
        
        %% Other commands used with VTI
        cmd_vti_vehicle_update = hex2dec('02')
    end
    methods
        function obj = traci_constants
        end
    end
end