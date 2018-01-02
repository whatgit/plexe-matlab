classdef traci
    % traci class for sending/receiving TraCI message from/to SUMO, etc.
    
    properties
        connection
        received_packet
        step_packet = [ fliplr(typecast(uint32(10),'uint8'))';
                        fliplr(typecast(uint8(6),'uint8'))';
                        hex2dec('02')  %0x02 is the command for simulation step in SUMO
                        fliplr(typecast(int32(0),'uint8'))';
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
        
         function [position, speed, acceleration] = extract_vti_value(obj)
            speed_array = obj.received_packet(8:15)';
            acceleration_array = obj.received_packet(17:24)';
            position_array = obj.received_packet(26:33)';
            speed = typecast(uint8(fliplr(speed_array)),'double');
            acceleration = typecast(uint8(fliplr(acceleration_array)),'double');
            position = typecast(uint8(fliplr(position_array)),'double');
         end
         
        function subscribeToVehicleVariable(obj, name)
            nameVect = int8(name);
            subscribe_packet = [ hex2dec('D4'); %0xD4 is the command for subscribing to vehicle
                              fliplr(typecast(uint32(0),'uint8'))';                 %begin time
                              fliplr(typecast(uint32(hex2dec('7FFFFFF')),'uint8'))';    %end time
                              fliplr(typecast(uint32(length(nameVect)),'uint8'))';  %object id (length)
                              nameVect';                                            %object id           
                              fliplr(typecast(uint8(3),'uint8'))';                  %variable number
                              hex2dec('42');    %position 
                              hex2dec('50');    %road_id
                              hex2dec('40');    %speed
                            ];
             subscribe_packet = [fliplr(typecast(uint8(length(subscribe_packet)+1),'uint8'))'; subscribe_packet];
             subscribe_packet = [fliplr(typecast(uint32(length(subscribe_packet)+4),'uint8'))'; subscribe_packet];
             fwrite(obj.connection, subscribe_packet);
        end
    end
    
end

