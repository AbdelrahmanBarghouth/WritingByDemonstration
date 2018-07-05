function change_letter(a,b, Imsg, letter, cam, probePositionPub)
old_letter = get(letter,'string');
new_letter = char(old_letter + 1);
set(letter, 'string', new_letter)
x_pos = (old_letter - 97)*0.15;
y_pos = floor((old_letter - 97)/7)*0.15;

uicontrol('style','edit',...
    'units', 'normalized',...
    'string', 'try',...
    'position', [x_pos y_pos 0.05 0.05]);
trial1 = uicontrol('style','edit',...
    'units', 'normalized',...
    'string', '',...
    'position', [x_pos+0.05 y_pos 0.02 0.05]);

uicontrol('style','edit',...
    'units', 'normalized',...
    'string', 'human',...
    'position', [x_pos y_pos+0.22 0.07 0.05]);
trial2 = uicontrol('style','edit',...
    'units', 'normalized',...
    'string', '',...
    'position', [x_pos+0.07 y_pos+0.22 0.02 0.05]);
set(trial1, 'string', old_letter);
set(trial2, 'string', old_letter);
human = axes('position',[x_pos y_pos+0.23 0.14 0.24]);
try1 = axes('position',[x_pos y_pos+0.01 0.14 0.24]);
edge_image = readImage(Imsg.LatestMessage);
axes(human)
imshow(edge_image)
x_y_position = rosmessage('std_msgs/Float32MultiArray');
x_y_position.Data = [0,0];
send(probePositionPub, x_y_position);
booleanImage = rosmessage('sensor_msgs/Image');
booleanImage.Encoding = 'rgb8';
booleanImage.Width  = Imsg.LatestMessage.Width;
booleanImage.Height = Imsg.LatestMessage.Height;
for rep = 1:10
    for i = 1:240
        for j=1:320
            if edge_image(i,j) >0
                x_servo = 3-(j/320)*3;
                y_servo = 3.6-(i/240)*3.6;
                x_y_position.Data=[x_servo,y_servo];
                abdo = ["position", x_y_position.Data(1), x_y_position.Data(2)];
                disp(abdo)
                send(probePositionPub, x_y_position);
                pause(0.1)
            end
        end
    end
end
x_y_position.Data=[0,0];
send(probePositionPub, x_y_position);
try_image = edge(rgb2gray(readImage(cam.LatestMessage)));
try_image = try_image(50:end,:);
try_image(190:240,:) = 0;
try_image(1:50,:) = 0;
try_image(:,1:50) = 0;
try_image(:,270:320) = 0;
axes(try1)
imshow(try_image)
end