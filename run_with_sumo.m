%MATLAB script for running with sumo-gui
%Define a role, either 'server' or 'client'
%If you are connecting to SUMO, choose 'client'
%If you are waiting for a connection, e.g. from Veins, choose 'server'
role = 'client';   

%Initilize traci connection
t = traci(8813, '0.0.0.0', role);

%connect
fopen(t.connection);
fwrite(t.connection,t.step_packet)

while 1
   if t.connection.BytesAvailable ~= 0
       t.received_packet = fread(t.connection, t.connection.BytesAvailable);
       command = t.extract_command();
       
       t.subscribeToVehicleVariable('carOne')
       fwrite(t.connection,t.step_packet)
   end
end
