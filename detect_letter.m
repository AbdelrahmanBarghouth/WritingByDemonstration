function detect_letter(a,b, Imsg, edge_axes, capturedImgPub)
booleanImage = rosmessage('sensor_msgs/Image');
booleanImage.Encoding = 'rgb8';
booleanImage.Width  = Imsg.LatestMessage.Width;
booleanImage.Height = Imsg.LatestMessage.Height;
grayImg = rgb2gray(readImage(Imsg.LatestMessage));
edgeImg = edge(grayImg);
edge_image = edgeImg(80:end,1:250);
edge_image(190:240,:) = 0;
edge_image(1:50,:) = 0;
edge_image(:,1:50) = 0;
edge_image(:,270:320) = 0;
tmpImg = reshape(transpose(edge_image)*255,[Imsg.LatestMessage.Width*Imsg.LatestMessage.Height,1]);
% disp(size(edgeImg))
% disp(size(tmpImg))
% disp(Imsg.LatestMessage.Width*Imsg.LatestMessage.Height)
booleanImage.Data(1:3:Imsg.LatestMessage.Width*Imsg.LatestMessage.Height*3) = tmpImg(:,1);
booleanImage.Data(2:3:Imsg.LatestMessage.Width*Imsg.LatestMessage.Height*3) = tmpImg(:,1);
booleanImage.Data(3:3:Imsg.LatestMessage.Width*Imsg.LatestMessage.Height*3) = tmpImg(:,1);

axes(edge_axes)
imshow(readImage(booleanImage))

send(capturedImgPub, booleanImage)
end