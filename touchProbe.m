%% Initializing Pi
pi=raspi('169.254.0.2','pi','raspberry');

%% Initialise ros on this PC
setenv('ROS_IP','169.254.0.3');
rosinit

%% SSH the pi
pi.openShell

%% Creating Publishers
capturedImgPub = rospublisher('/tp/capturedImg','sensor_msgs/Image');

probePositionPub = rospublisher('/probePosition/x_y','std_msgs/Float32MultiArray');

pwmPubx = rospublisher('/servo_ctrl/s1','std_msgs/Float32');
pwmPuby = rospublisher('/servo_ctrl/s2','std_msgs/Float32');
%% Define Subscribers to the pi topics
rgbSub = rossubscriber('/tp/pi_camera_rgb');
capturedImgSub = rossubscriber('/tp/capturedImg');
positionSub = rossubscriber('/probePosition/x_y');
%% Creating UI
figure(1)

camera_axes = axes('position',[0.01 0.68 0.35 0.3]);

edge_axes = axes('position',[0.52 0.68 0.35 0.3]);

uicontrol('style','edit',...
    'units', 'normalized',...
    'string', 'Please write on this paper letter',...
    'position', [0.33 0.5 0.3 0.05]);

letter = uicontrol('style','edit',...
    'units', 'normalized',...
    'string', 'a',...
    'position', [0.63 0.5 0.03 0.05]);

Detect_letter = uicontrol('style', 'pushbutton',...
    'string', 'Detect Letter',...
    'units', 'normalized',...
    'position', [0.1 0.47 0.2 0.15], ...
    'callback', {@detect_letter, rgbSub, edge_axes, capturedImgPub});

Start_Learn = uicontrol('style', 'pushbutton',...
    'string', 'Start Writing',...
    'units', 'normalized',...
    'position', [0.7 0.47 0.2 0.15], ...
    'callback', {@change_letter, capturedImgSub, letter, rgbSub, probePositionPub});
%% Using Callback Fxns.
rgbSub.NewMessageFcn=@(~,msg)camera_show(msg, camera_axes);
positionSub.NewMessageFcn=@(~,msg)adjustProbePosition(pwmPubx, pwmPuby, msg);