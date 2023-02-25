function bytes = GetPacketSize(alpha, k, m)

% quantile function of Pareto distribution
bytes = k*(1-rand).^(-1/alpha);   % rand: uniform(0, 1)

% cut-off
if bytes > m
    bytes = m;
end