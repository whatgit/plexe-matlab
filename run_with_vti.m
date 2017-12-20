%MATLAB script for running with vsim12
%Define a role, either 'server' or 'client'
%If you are connecting to SUMO, choose 'client'
%If you are waiting for a connection, e.g. from Veins, choose 'server'
role = 'client';   

%Initilize traci connection
t = traci(8888, '194.47.15.19', role);

%connect
fopen(t.connection)

while 1
   if t.connection.BytesAvailable ~= 0
       t.received_packet = fread(t.connection, t.connection.BytesAvailable);
       command = t.extract_command();
       if command == hex2dec('C4')
           t.send_vti_update('test',5,20,5);
       end
   end   
end

