% Initialization script for motor swap of PMSM

% Copyright 2024 The MathWorks, Inc.

%% Sample times used in control algorithm
Ts          	= T_pwm;            %sec    // Sample time for control system
Ts_motor        = T_pwm/2;          %Sec    // Simulation time step for pmsm
Ts_speed        = 10*Ts;            %Sec    // Sample time for speed controller

% Motor parameters Microchip Long Hurst
pmsm.p          = 5;
pmsm.I_rated    = 4*sqrt(2);
pmsm.N_rated    = 2000;
pmsm.calibSpeed = 60;
pmsm.QEPSlits   = 250;              %           // QEP Encoder Slits
pmsm.QEPIndexPresent = true;        %           // Sensor has index pulse

% Below parameters are needed for simulation.
% Enter zero if not known
pmsm.Rs       = 0.35;               %Ohm        // Stator Resistor
pmsm.Ld       = 2e-4;               %H          // D-axis inductance value
pmsm.Lq       = 2e-4;               %H          // Q-axis inductance value
pmsm.J        = 2.427e-6;           %Kg-m2      // Inertia in SI units
pmsm.B        = 7.5e-6;             %Kg-m2/s    // Friction Co-efficient
pmsm.Ke       = 8.3;                %Bemf Const	// Vpk_LL/krpm
pmsm.Kt       = 0.274;              %Nm/A       // Torque constant
pmsm.PositionOffset = 0 * pi;       % Position offset in radian;
pmsm.OLtoCLSpeed = 0.3;

%% Derived parameters
pmsm.FluxPM   = (pmsm.Ke)/(sqrt(3)*2*pi*1000*pmsm.p/60); %PM flux computed from Ke
pmsm.T_rated  = mcbPMSMRatedTorque(pmsm);   %Get T_rated from I_rated

%%
one_sec_tick = uint16(1/Ts_speed);   % one sec delay
two_sec_tick = uint16(2/Ts_speed);   % two sec delay
RAMP_STEP_SIZE = 0.0001;