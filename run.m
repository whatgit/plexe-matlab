%Define a role, either 'server' or 'client'
%If you are connecting to SUMO, choose 'client'
%If you are waiting for a connection, e.g. from Veins, choose 'server'
role = 'client';   

%Initilize traci connection
t = traci(8813, '0.0.0.0', role);

%connect
fopen(t.connection)

while 1
   %send a message for stepping a simulation
   fwrite(t.connection,t.step_packet)
end

