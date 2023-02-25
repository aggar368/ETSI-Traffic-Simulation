tic;

sim_t_slots = 1e7;   % number of time slots to simulate

% statistics of traffic
mu_Npc = 5;   % mean number of packet calls
mu_Dpc = 412;   % mean reading time(inter-packet-call time) (sec)
mu_Nd = 25;   % mean number of packets in a packet call
mu_Dd = 0.5;   % mean inter-packet arrival time in a packet call (sec)
mu_Ds = 500;   % mean inter-session time (sec)
% packet size: Pareto distribution with cut-off
Pareto_alpha = 1.1;
Pareto_k = 81.5;   % (bytes)
m = 66666;   % maximum allowed packet size(bytes)

t_to_byte = 1e3;   % how packet size relates to receiving time (bytes/time slot)

jobs = zeros(1, 3);   % [(number of remaining packet calls), (number of remaining packets), (remaining bytes of current packet)]
idle_timer = 0;   % (inter-session time)/(reading time)/(inter-packet time)

history = zeros(1, sim_t_slots);   % BS status of each time slot

% sec to ms
mu_Dpc = mu_Dpc * 1000;
mu_Dd = mu_Dd * 1000;
mu_Ds = mu_Ds * 1000;

time = 1;
while 1
    if time == 1   % initialization: schedule a session
        jobs(1) = geornd(1/mu_Npc);
        jobs(2) = geornd(1/mu_Nd);   % first packet call
        jobs(3) = GetPacketSize(Pareto_alpha, Pareto_k, m);   % first packet of first packet call
    end

    if idle_timer > 0
        history(time) = 0;   % idle
        idle_timer = idle_timer - 1;
    else   % idle timer = 0
        if jobs(3) > 0
            history(time) = 1;   % is receiving data
            jobs(3) = jobs(3) - t_to_byte;   % bytes received in current time slot
        else   % packet-receiving finished
            if jobs(2) > 0
                jobs(2) = jobs(2) - 1;   % one packet finished
                idle_timer = geornd(1/mu_Dd);   % generate inter-packet time

                % generate next packet size
                jobs(3) = GetPacketSize(Pareto_alpha, Pareto_k, m);
    
                history(time) = 0;   % idle
                idle_timer = idle_timer - 1;
            else   % current packet call finished
                if jobs(1) > 0
                    jobs(1) = jobs(1) - 1;   % one packet call finished
                    idle_timer = geornd(1/mu_Dpc);   % generate reading time

                    % generate next packet call
                    jobs(2) = geornd(1/mu_Nd);
                    % generate next packet size
                    jobs(3) = GetPacketSize(Pareto_alpha, Pareto_k, m);
    
                    history(time) = 0;   % idle
                    idle_timer = idle_timer - 1;
                else   % current session finished
                    idle_timer = geornd(1/mu_Ds);   % generate inter-session time
    
                    % generate schedule for next session
                    jobs(1) = geornd(1/mu_Npc);
                    jobs(2) = geornd(1/mu_Nd);   % first packet call
                    jobs(3) = GetPacketSize(Pareto_alpha, Pareto_k, m);   % first packet of first packet call
    
                    history(time) = 0;   % idle
                    idle_timer = idle_timer - 1;
                end
            end
        end
    end

    if time >= sim_t_slots
        break;
    else
        time = time + 1;
    end
end

toc;


% traffic visualization
X = 1:sim_t_slots;
plot(X, history)

