classdef traci
    % traci class for sending/receiving TraCI message from/to SUMO, etc.
    
    properties
        connection
        received_packet
        step_packet = [ fliplr(typecast(uint32(10),'uint8'))';
                        fliplr(typecast(uint8(6),'uint8'))';
                        hex2dec('02')  %0x02 is the command for simulation step in SUMO
                        fliplr(typecast(uint32(0),'uint8'))';
                        ]
    end
    
    methods
        function obj = traci(p, ipAddr, role)
          obj.connection = tcpip(ipAddr, p, 'NetworkRole', role);
        end
        
        function send_vti_update(obj, name, x, y, speed)
            nameVect = double(name); 
            update_packet = [ fliplr(typecast(uint32(length(nameVect)+33),'uint8'))';
                              fliplr(typecast(uint8(length(nameVect)+29),'uint8'))';
                              hex2dec('02');  %0x02 is the command for vehicle_update in VTI
                              fliplr(typecast(uint32(length(nameVect)),'uint8'))';
                              nameVect';                            
                              fliplr(typecast(double(x),'uint8'))'; 
                              fliplr(typecast(double(y),'uint8'))'; 
                              fliplr(typecast(double(speed),'uint8'))'; 
                            ];
            fwrite(obj.connection, update_packet);
        end
        
        function command = extract_command(obj)
            command = obj.received_packet(6);
        end
    end
    
end

