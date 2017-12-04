classdef traci
    % traci class for sending/receiving TraCI message from/to SUMO, etc.
    
    properties
        connection
        step_packet = [ 0;
                        0;
                        0;
                        10;
                        6;
                        hex2dec('02');  %0x02 is the command for simulation step
                        0;
                        0;
                        0;
                        0;
                        ]
    end
    
    methods
        function obj = traci(p, ipAddr, role)
          obj.connection = tcpip(ipAddr, p, 'NetworkRole', role);
        end
        
        function copy_packet = createSetSpeed(speed, lane, intention)
            %Data format
            size = 0;
            cmd_size = 0;
            CMD_SET_VEHICLE_VAR = hex2dec('C4');
            VAR_SPEED = hex2dec('40');
            TYPE_DOUBLE = hex2dec('0B');

            copy_packet = [0;
                           0;
                           0;
                           25;
                           21;
                           hex2dec('C4');
                           hex2dec('40');
                           0;
                           hex2dec('0B');
                           hex2dec('40');
                           0;
                           0;
                           0;
                           0;
                           0;
                           0;
                           speed;
                           0;
                           0;
                           0;
                           lane;
                           0;
                           0;
                           0;
                           intention]
        end
    end
    
end

