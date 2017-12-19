classdef traci
    % traci class for sending/receiving TraCI message from/to SUMO, etc.
    
    properties
        connection
        update_speed
        update_x
        update_y
        step_packet = [ 0
                        0
                        0
                        10
                        6
                        hex2dec('02')  %0x02 is the command for simulation step
                        0
                        0
                        0
                        0
                        ]
    end
    
    methods
        function obj = traci(p, ipAddr, role)
          obj.connection = tcpip(ipAddr, p, 'NetworkRole', role);
        end
        
        function send_vti_update(obj, name, x, y, speed)
            nameVect = double(name); 
            update_packet = [ 0;
                          0;
                          0;
                          37;
                          33;
                          hex2dec('02');  %0x02 is the command for vti_vehicle_update
                          fliplr(typecast(uint32(length(nameVect)),'uint8'))';
%                           0;
%                           0;
%                           0;
%                           length(nameVect);                     %4
                          nameVect';                            %4
                          fliplr(typecast(double(x),'uint8'))'; %8
                          fliplr(typecast(double(y),'uint8'))'; %8
                          fliplr(typecast(double(speed),'uint8'))'; %8
                        ]
            fwrite(obj.connection, update_packet);
        end
    end
    
end

