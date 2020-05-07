%MATLAB script for running with vsim12
%Define a role, either 'server' or 'client'
%If you are connecting to SUMO, choose 'client'
%If you are waiting for a connection, e.g. from Veins, choose 'server'
simulation_time = 100;
simulation_step = 0.1;

%This array is for storing CACC vehicle's speed
%row 1 name
%row 2 x
%row 3 y
%row 4 speed
array_cacc_out = zeros(4,simulation_time/simulation_step);

%This array is for storing HMI's inputs
%row 1 driver_position 
%row 2 driver_speed
%row 3 driver_acceleration
array_hmi_in = zeros(3,simulation_time/simulation_step);

written_at = 0;
role = 'client';   
vti_ip_address = '194.47.15.19';
%Initilize traci connection
t_vti = traci(8888, vti_ip_address, role);
t_matlab = traci(8855, '0.0.0.0', 'server');
%connect
fopen(t_vti.connection)
fopen(t_matlab.connection)
old_pack = [];
time_instance = 1;
while t_matlab.connection.BytesAvailable == 0
    %this wait until we got one message from MATLAB, the MATLAB code has start
end
start = clock
while 1
   if t_vti.connection.BytesAvailable ~= 0  %this should come every 0.1 second
       t_vti.received_packet = fread(t_vti.connection, t_vti.connection.BytesAvailable);
       command = t_vti.extract_command();
       if command == hex2dec('C4')
           %create/update vehicle(s) that is displayed on VTI's driving simulator
           %arguments: name, x, y, speed
           %note: at the moment 'y' position 244 is used as a lane separation point
           %(if you just put different names, it will create a new vehicle)
           t_vti.send_vti_update(array_cacc_out(1,time_instance), array_cacc_out(2,time_instance), array_cacc_out(3,time_instance), array_cacc_out(4,time_instance));
           fwrite(t_matlab.connection,t.step_packet)
       end
       if command == hex2dec('10')
           [array_hmi_in(1,time_instance), array_hmi_in(2,time_instance), array_hmi_in(3,time_instance)] = t_vti.extract_vti_value();
           fwrite(t_matlab.connection,t_vti.received_packet);
       end
       %So, if MATLAB got something new, it will be updated at line 61,
       %Otherwise, just send old data..... 
       if ~isempty(old_pack)
           fwrite(t_vti.connection,old_pack)
       end
       
       time_instance = time_instance + 1;
   end
    if t_matlab.connection.BytesAvailable ~= 0   
       t_matlab.received_packet = fread(t_matlab.connection, t_matlab.connection.BytesAvailable);
       old_pack = t_matlab.received_packet;    
   end
end



