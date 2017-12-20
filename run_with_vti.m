%MATLAB script for running with vsim12
%Define a role, either 'server' or 'client'
%If you are connecting to SUMO, choose 'client'
%If you are waiting for a connection, e.g. from Veins, choose 'server'
role = 'client';   
vti_ip_address = '194.47.15.19';
%Initilize traci connection
t = traci(8888, vti_ip_address, role);

%connect
fopen(t.connection)

while 1
   if t.connection.BytesAvailable ~= 0
       t.received_packet = fread(t.connection, t.connection.BytesAvailable);
       command = t.extract_command();
       if command == hex2dec('C4')
           %create/update vehicle(s) that is displayed on VTI's driving simulator
           %arguments: name, x, y, speed
           %note: at the moment 'y' position 244 is used as a lane separation point
           %(if you just put different names, it will create a new vehicle)
           t.send_vti_update('test',5,20,5);
       end
       if command == hex2dec('10')
           [driver_speed, driver_acceleration] = t.extract_vti_value();
           %Call your function here for re-calculation with updates about human driver's state
       end
   end   
end

