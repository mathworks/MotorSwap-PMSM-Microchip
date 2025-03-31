% Initialization script for Microchip XXXX kit based motor control
% examples.

% Copyright 2024 The MathWorks, Inc.

%% Simulation Parameters

%% Set PWM Switching frequency
PWM_frequency 	= 16e3;             %Hz     // converter s/w freq
T_pwm           = 1/PWM_frequency;  %s      // PWM switching time period

%% Set Sample Times
Ts_simulink     = T_pwm/2;          %sec    // simulation time step for model simulation
Ts_inverter     = T_pwm/2;          %sec    // simulation time step for average value inverter
Ts_serialIn     = 50e-3;
Ts_serialOut    = 5e-3;

%% Set data type for controller & code-gen
dataType = 'single';    

%% Target 
target.model                = 'Microchip_XXXX';	    % 		// Manufacturer Model Number
target.CPU_frequency        = 200e6;    			%Hz     // Clock frequency
target.PWM_frequency        = PWM_frequency;   		%Hz     // PWM frequency
target.PWM_Counter_Period   = round(target.CPU_frequency/target.PWM_frequency/2);
target.PWM_Counter_Period   = target.PWM_Counter_Period+mod(target.PWM_Counter_Period,2); % // Count value needs to be even
target.ADC_Vref             = 3;			        %V		// ADC voltage reference for LAUNCHXL-F28379D
target.ADC_MaxCount         = 4095;			        %		// Max count for 12 bit ADC
target.BaudRate             = 921659;               %Hz     // Set baud rate for serial communication
target.comport              = '<Select a port...>';
target.frameSize            = 20;
target.comport = 'COM3';                            % Uncomment and update the appropriate serial port

%% Inverter parameters

inverter.model         = 'MCLV-48V-300W';           % 		// Manufacturer Model Number
inverter.V_dc          = 24;       					%V      // DC Link Voltage of the Inverter
inverter.AMPPerCount   = -22/(2^11);                % phase current equivalent to one ADC count
% Update above parameter such that current entering motor is sensed as
% positive. 
inverter.VoltPerCount  = 75.9/(2^12);               % Voltage sensed per ADC count
inverter.EnableLogic   = 1;    					    % 1: Active high enable
                                                    % 0: Active Low enable

% Below are optional parameter, enter zero if the value is not known or not
% relevant
inverter.Rds_on        = 1e-3;     				    %Ohms   // Rds ON for BoostXL-DRV8305
inverter.Rshunt        = 0.01;    				    %Ohms   // Rshunt for BoostXL-DRV8305
inverter.ISenseMax     = abs(inverter.AMPPerCount * 2048);
inverter.R_board       = inverter.Rds_on + inverter.Rshunt/3;  %Ohms

% Enable automatic calibration of ADC offset for current measurement
inverter.ADCOffsetCalibEnable = 1;                  % Enable: 1, Disable:0

% If automatic ADC offset calibration is disabled, enter offset values below
inverter.CtSensAOffset = 2^15-1;                    % ADC Offset for phase current A
inverter.CtSensBOffset = 2^15-1;                    % ADC Offset for phase current B